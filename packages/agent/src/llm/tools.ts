import { createLogg } from '@guiiai/logg'
import { z } from 'zod'

const logger = createLogg('tools').useGlobalConfig()

interface ToolFunction {
  name: string
  description: string
  schema: z.Schema
  fn: (args: any) => Promise<any>
}

// Tools are temporarily disabled — the old RCON API client was removed.
// TODO: Re-enable once tools are wired through the WebSocket connection.
export const tools: ToolFunction[] = []
