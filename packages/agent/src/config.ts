import type { FactorioWsConfig, LLMConfig } from './types.js'
import { env } from 'node:process'
import { useLogg } from '@guiiai/logg'

const logger = useLogg('config').useGlobalConfig()

export const llmConfig: LLMConfig = {
  apiKey: '',
  baseURL: '',
  model: '',
}

export const wsClientConfig: FactorioWsConfig = {
  wsHost: '',
  wsPort: 0,
}

export function initEnv() {
  logger.log('Initializing environment variables')

  llmConfig.apiKey = env.LLM_API_KEY || ''
  llmConfig.baseURL = env.LLM_BASE_URL || 'https://api.groq.com/openai/v1'
  llmConfig.model = env.LLM_MODEL || 'llama-3.3-70b-versatile'

  wsClientConfig.wsHost = env.FACTORIO_WS_HOST || 'localhost'
  wsClientConfig.wsPort = Number.parseInt(env.FACTORIO_WS_PORT || '8080')

  logger.withFields({ llmConfig }).log('Environment variables initialized')
}
