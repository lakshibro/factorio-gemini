import type { MessageHandler } from './llm/message-handler'
import type { StdoutMessage } from './parser'
import { Buffer } from 'node:buffer'
import { Format, setGlobalFormat, useLogg } from '@guiiai/logg'
import { backOff } from 'exponential-backoff'
import { connect } from 'it-ws'
import { initEnv, wsClientConfig } from './config'
import { createMessageHandler } from './llm/message-handler'
import { parseChatMessage, parseModErrorMessage, parseOperationCompletedMessage } from './parser'

setGlobalFormat(Format.Pretty)
const logger = useLogg('main').useGlobalConfig()

async function executeCommandFromAgent<T extends StdoutMessage>(message: T, messageHandler: MessageHandler, ws: any) {
  const llmResponse = await backOff(() => messageHandler.handleMessage(message), {
    timeMultiple: 2,
    maxDelay: 10000,
    retry(e, attemptNumber) {
      logger.withFields({ error: e.message, attemptNumber }).error('Failed to handle message, attempt to retry')
      return true
    },
  })

  if (!llmResponse) {
    logger.error('Failed to handle message')
    return
  }

  if (llmResponse.chatMessage) {
    ws.socket.send(JSON.stringify({
      type: 'command',
      command: `/c game.print([[[${llmResponse.chatMessage}]]])`,
    }))
  }

  if (llmResponse.operationCommands.length === 0) {
    return
  }

  logger.withFields({ operationCommands: llmResponse.operationCommands, currentStep: llmResponse.currentStep }).debug('Executing operation commands')

  const command = llmResponse.operationCommands.join(';')
  ws.socket.send(JSON.stringify({
    type: 'command',
    command: `/c ${command}`,
  }))
}

async function main() {
  initEnv()

  const ws = connect(`ws://${wsClientConfig.wsHost}:${wsClientConfig.wsPort}`)
  await ws.connected()

  const gameLogger = useLogg('game').useGlobalConfig()

  const messageHandler = await createMessageHandler()

  for await (const buffer of ws.source) {
    const line = Buffer.from(buffer).toString('utf-8')

    const chatMessage = parseChatMessage(line)
    if (chatMessage) {
      if (chatMessage.isServer) {
        continue
      }

      gameLogger.withContext('chat').log(`${chatMessage.username}: ${chatMessage.message}`)

      await executeCommandFromAgent(chatMessage, messageHandler, ws)
      continue
    }
    
    const modErrorMessage = parseModErrorMessage(line)
    if (modErrorMessage) {
      gameLogger.withContext('mod').error(`${modErrorMessage.error}`)
      
      await executeCommandFromAgent(modErrorMessage, messageHandler, ws)
      continue
    }
    
    const operationCompletedMessage = parseOperationCompletedMessage(line)
    if (operationCompletedMessage) {
      gameLogger.withContext('mod').log(`All operations completed`)
      
      await executeCommandFromAgent(operationCompletedMessage, messageHandler, ws)
      continue
    }
  }
}

main().catch((e: Error) => {
  logger.error(e.message)
  logger.error(e.stack)
})
