import { createLogg } from '@guiiai/logg'
import { z } from 'zod'

const logger = createLogg('tools').useGlobalConfig()

export type CommandSender = (command: string) => Promise<any>

export interface ToolFunction {
  name: string
  description: string
  schema: z.Schema
  fn: (args: any, sendCommand: CommandSender) => Promise<any>
}

// Advanced tools for expert play
export const tools: ToolFunction[] = [
  {
    name: 'get_inventory',
    description: 'Get the inventory of a player',
    schema: z.object({
      player_index: z.number().default(1),
    }),
    fn: async ({ player_index = 1 }, sendCommand) => {
      return await sendCommand(`remote.call("autorio_tools", "get_inventory_items", ${player_index})`)
    },
  },
  {
    name: 'get_recipe_ingredients',
    description: 'Get the ingredients required for a specific recipe',
    schema: z.object({
      item_name: z.string(),
      player_index: z.number().default(1),
    }),
    fn: async ({ item_name, player_index = 1 }, sendCommand) => {
      return await sendCommand(`remote.call("autorio_tools", "get_recipe", "${item_name}", ${player_index})`)
    },
  },
  {
    name: 'get_nearby_entities',
    description: 'Get a list of entities near the player',
    schema: z.object({
      player_index: z.number().default(1),
      radius: z.number().default(20),
    }),
    fn: async ({ player_index = 1, radius = 20 }, sendCommand) => {
      return await sendCommand(`remote.call("autorio_operations", "log_player_info", ${player_index}, ${radius})`)
    },
  },
  {
    name: 'build_blueprint',
    description: 'Place a blueprint at a specific position',
    schema: z.object({
      blueprint_string: z.string(),
      position: z.object({
        x: z.number(),
        y: z.number(),
      }),
      player_index: z.number().default(1),
    }),
    fn: async ({ blueprint_string, position, player_index = 1 }, sendCommand) => {
      return await sendCommand(`remote.call("autorio_operations", "build_blueprint", "${blueprint_string}", {x=${position.x}, y=${position.y}}, ${player_index})`)
    },
  },
  {
    name: 'spawn_bot',
    description: 'Spawn a character for the bot if it doesn\'t have one',
    schema: z.object({
      player_index: z.number().default(1),
    }),
    fn: async ({ player_index = 1 }, sendCommand) => {
      return await sendCommand(`remote.call("autorio_operations", "spawn_bot", ${player_index})`) 
    },
  }
]
