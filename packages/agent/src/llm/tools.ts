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
    fn: async ({ player_index }, sendCommand) => {
      return await sendCommand(`remote.call("autorio_tools", "get_inventory_items", ${player_index})`)
    },
  },
  {
    name: 'get_recipes',
    description: 'Get the list of available recipes for the player\'s force',
    schema: z.object({
      player_index: z.number().default(1),
    }),
    fn: async ({ player_index }, sendCommand) => {
      return await sendCommand(`remote.call("autorio_tools", "get_recipe", "iron-plate", ${player_index})`) // Mod should be updated to return all or specific tech
    },
  },
  {
    name: 'get_nearby_entities',
    description: 'Get a list of entities near the player',
    schema: z.object({
      player_index: z.number().default(1),
      radius: z.number().default(20),
    }),
    fn: async ({ player_index, radius }, sendCommand) => {
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
    fn: async ({ blueprint_string, position, player_index }, sendCommand) => {
      return await sendCommand(`remote.call("autorio_operations", "build_blueprint", "${blueprint_string}", {x=${position.x}, y=${position.y}}, ${player_index})`)
    },
  },
  {
    name: 'spawn_bot',
    description: 'Spawn a character for the bot if it doesn\'t have one',
    schema: z.object({
      player_index: z.number().default(1),
    }),
    fn: async ({ player_index }, sendCommand) => {
      return await sendCommand(`remote.call("autorio_operations", "spawn_bot", ${player_index})`) 
    },
  }
]
