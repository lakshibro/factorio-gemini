export interface LLMConfig {
  apiKey: string
  baseURL: string
  model: string
}

export interface FactorioWsConfig {
  wsPort: number
  wsHost: string
}
