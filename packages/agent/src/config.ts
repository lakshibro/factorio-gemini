import type { FactorioRconAPIClientConfig, FactorioWsConfig, GeminiConfig } from './types.js'
import { env } from 'node:process'
import { useLogg } from '@guiiai/logg'

const logger = useLogg('config').useGlobalConfig()

export const geminiConfig: GeminiConfig = {
  apiKey: '',
}

export const rconClientConfig: FactorioRconAPIClientConfig = {
  host: '',
  port: 0,
}

export const wsClientConfig: FactorioWsConfig = {
  wsHost: '',
  wsPort: 0,
}

export function initEnv() {
  logger.log('Initializing environment variables')

  geminiConfig.apiKey = env.GEMINI_API_KEY || ''

  rconClientConfig.host = env.RCON_API_SERVER_HOST || 'localhost'
  rconClientConfig.port = Number.parseInt(env.RCON_API_SERVER_PORT || '24180')

  wsClientConfig.wsHost = env.FACTORIO_WS_HOST || 'localhost'
  wsClientConfig.wsPort = Number.parseInt(env.FACTORIO_WS_PORT || '8080')

  logger.withFields({ geminiConfig }).log('Environment variables initialized')
}
