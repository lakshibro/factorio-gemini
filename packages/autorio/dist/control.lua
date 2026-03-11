--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]

local ____modules = {}
local ____moduleCache = {}
local ____originalRequire = require
local function require(file, ...)
    if ____moduleCache[file] then
        return ____moduleCache[file].value
    end
    if ____modules[file] then
        local module = ____modules[file]
        local value = nil
        if (select("#", ...) > 0) then value = module(...) else value = module(file) end
        ____moduleCache[file] = { value = value }
        return value
    else
        if ____originalRequire then
            return ____originalRequire(file)
        else
            error("module '" .. file .. "' not found")
        end
    end
end
____modules = {
["utils.inventory"] = function(...) 
--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
-- Lua Library inline imports
local function __TS__ArrayMap(self, callbackfn, thisArg)
    local result = {}
    for i = 1, #self do
        result[i] = callbackfn(thisArg, self[i], i - 1, self)
    end
    return result
end
-- End of Lua Library inline imports
local ____exports = {}
function ____exports.get_inventory_items(self, player_id)
    log("[AUTORIO] Getting inventory items for player: " .. tostring(player_id))
    local player = game.connected_players[player_id]
    local main_inventory = player.get_main_inventory()
    if not main_inventory then
        return {}
    end
    return __TS__ArrayMap(
        main_inventory.get_contents(),
        function(____, ____bindingPattern0)
            local count
            local name
            name = ____bindingPattern0.name
            count = ____bindingPattern0.count
            return {name = name, count = count}
        end
    )
end
return ____exports
 end,
["types"] = function(...) 
--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports.TaskStates = TaskStates or ({})
____exports.TaskStates.IDLE = "idle"
____exports.TaskStates.WALKING_TO_ENTITY = "walking_to_entity"
____exports.TaskStates.MINING = "mining"
____exports.TaskStates.PLACING = "placing"
____exports.TaskStates.PLACING_IN_CHEST = "placing_in_chest"
____exports.TaskStates.PICKING_UP = "picking_up"
____exports.TaskStates.CRAFTING = "crafting"
____exports.TaskStates.RESEARCHING = "researching"
____exports.TaskStates.WALKING_DIRECT = "walking_direct"
____exports.TaskStates.MOVING_ITEMS = "moving_items"
____exports.TaskStates.ATTACKING = "attacking"
____exports.TaskStates.WAITING = "waiting"
return ____exports
 end,
["task_manager"] = function(...) 
--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
-- Lua Library inline imports
local function __TS__ArraySetLength(self, length)
    if length < 0 or length ~= length or length == math.huge or math.floor(length) ~= length then
        error(
            "invalid array length: " .. tostring(length),
            0
        )
    end
    for i = length + 1, #self do
        self[i] = nil
    end
    return length
end
-- End of Lua Library inline imports
local ____exports = {}
local ____types = require("types")
local TaskStates = ____types.TaskStates
function ____exports.new_task_manager(self)
    local next_task, player_state, task_queue
    function next_task(self)
        if player_state.task_state ~= TaskStates.IDLE then
            log("[AUTORIO] Task state is not IDLE, wont execute next task")
            return
        end
        local task = table.remove(task_queue, 1)
        if not task then
            player_state.task_state = TaskStates.IDLE
            game.print("[AUTORIO] All operations completed")
            log("[AUTORIO] All operations completed")
            return
        end
        log((("[AUTORIO] Next task: " .. task.type) .. ", task queue length: ") .. tostring(#task_queue))
        player_state.task_state = task.type
        repeat
            local ____switch9 = task.type
            local ____cond9 = ____switch9 == TaskStates.WALKING_TO_ENTITY
            if ____cond9 then
                player_state.parameters_walk_to_entity = task
                break
            end
            ____cond9 = ____cond9 or ____switch9 == TaskStates.WALKING_DIRECT
            if ____cond9 then
                player_state.parameters_walking_direct = task
                break
            end
            ____cond9 = ____cond9 or ____switch9 == TaskStates.MINING
            if ____cond9 then
                player_state.parameters_mine_entity = task
                break
            end
            ____cond9 = ____cond9 or ____switch9 == TaskStates.PLACING
            if ____cond9 then
                player_state.parameters_place_entity = task
                break
            end
            ____cond9 = ____cond9 or ____switch9 == TaskStates.MOVING_ITEMS
            if ____cond9 then
                player_state.parameters_move_items = task
                break
            end
            ____cond9 = ____cond9 or ____switch9 == TaskStates.CRAFTING
            if ____cond9 then
                do
                    local player = game.connected_players[1]
                    if not player then
                        log("[AUTORIO] No player found")
                        return
                    end
                    player.begin_crafting({count = task.count, recipe = task.item_name})
                    player_state.parameters_craft_item = task
                    break
                end
            end
            ____cond9 = ____cond9 or ____switch9 == TaskStates.ATTACKING
            if ____cond9 then
                player_state.parameters_attack_nearest_enemy = task
                break
            end
            ____cond9 = ____cond9 or ____switch9 == TaskStates.RESEARCHING
            if ____cond9 then
                player_state.parameters_research_technology = task
                break
            end
            ____cond9 = ____cond9 or ____switch9 == TaskStates.WAITING
            if ____cond9 then
                player_state.parameters_waiting = task
                break
            end
        until true
    end
    player_state = {task_state = TaskStates.IDLE}
    task_queue = {}
    local function add_task(self, task)
        task_queue[#task_queue + 1] = task
        log((("[AUTORIO] Task added: " .. task.type) .. ", task queue length: ") .. tostring(#task_queue))
        if #task_queue == 1 then
            next_task(nil)
        end
    end
    local function reset_task_state(self)
        player_state.task_state = TaskStates.IDLE
        player_state.parameters_walk_to_entity = nil
        player_state.parameters_walking_direct = nil
        player_state.parameters_mine_entity = nil
        player_state.parameters_place_entity = nil
        player_state.parameters_move_items = nil
        player_state.parameters_craft_item = nil
        player_state.parameters_attack_nearest_enemy = nil
        player_state.parameters_research_technology = nil
        player_state.parameters_waiting = nil
    end
    local function is_task_queue_empty(self)
        return #task_queue == 0
    end
    local function cancel_task(self)
        reset_task_state(nil)
    end
    local function cancel_all_tasks(self)
        reset_task_state(nil)
        __TS__ArraySetLength(task_queue, 0)
    end
    return {
        player_state = player_state,
        add_task = add_task,
        next_task = next_task,
        is_task_queue_empty = is_task_queue_empty,
        reset_task_state = reset_task_state,
        cancel_task = cancel_task,
        cancel_all_tasks = cancel_all_tasks
    }
end
return ____exports
 end,
["tools"] = function(...) 
--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
-- Lua Library inline imports
local function __TS__ArrayMap(self, callbackfn, thisArg)
    local result = {}
    for i = 1, #self do
        result[i] = callbackfn(thisArg, self[i], i - 1, self)
    end
    return result
end
-- End of Lua Library inline imports
local ____exports = {}
local ____inventory = require("utils.inventory")
local get_inventory_items = ____inventory.get_inventory_items
function ____exports.create_tools_remote_interface(self)
    remote.add_interface(
        "autorio_tools",
        {
            get_inventory_items = function(player_id)
                rcon.print(serpent.block(get_inventory_items(nil, player_id)))
                return true
            end,
            get_recipe = function(item_name, player_id)
                local player = game.connected_players[player_id]
                local recipe = player.force.recipes[item_name]
                if not recipe then
                    rcon.print("no such recipe")
                    return false
                end
                if not recipe.enabled then
                    rcon.print("recipe locked")
                    return false
                end
                local ingredients = __TS__ArrayMap(
                    recipe.ingredients,
                    function(____, ingredient)
                        return {name = ingredient.name, count = ingredient.amount}
                    end
                )
                rcon.print(serpent.block(ingredients))
                return true
            end
        }
    )
end
return ____exports
 end,
["utils.math"] = function(...) 
--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
function ____exports.distance(self, a, b)
    return math.sqrt(math.pow(a.x - b.x, 2) + math.pow(a.y - b.y, 2))
end
return ____exports
 end,
["control"] = function(...) 
--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
-- Lua Library inline imports
local function __TS__ArrayForEach(self, callbackFn, thisArg)
    for i = 1, #self do
        callbackFn(thisArg, self[i], i - 1, self)
    end
end

local function __TS__ArrayFilter(self, callbackfn, thisArg)
    local result = {}
    local len = 0
    for i = 1, #self do
        if callbackfn(thisArg, self[i], i - 1, self) then
            len = len + 1
            result[len] = self[i]
        end
    end
    return result
end

local function __TS__ArrayMap(self, callbackfn, thisArg)
    local result = {}
    for i = 1, #self do
        result[i] = callbackfn(thisArg, self[i], i - 1, self)
    end
    return result
end

local function __TS__ArrayIsArray(value)
    return type(value) == "table" and (value[1] ~= nil or next(value) == nil)
end

local function __TS__ArrayFlat(self, depth)
    if depth == nil then
        depth = 1
    end
    local result = {}
    local len = 0
    for i = 1, #self do
        local value = self[i]
        if depth > 0 and __TS__ArrayIsArray(value) then
            local toAdd
            if depth == 1 then
                toAdd = value
            else
                toAdd = __TS__ArrayFlat(value, depth - 1)
            end
            for j = 1, #toAdd do
                local val = toAdd[j]
                len = len + 1
                result[len] = val
            end
        else
            len = len + 1
            result[len] = value
        end
    end
    return result
end
-- End of Lua Library inline imports
local ____exports = {}
local check_can_craft
local ____task_manager = require("task_manager")
local new_task_manager = ____task_manager.new_task_manager
local ____tools = require("tools")
local create_tools_remote_interface = ____tools.create_tools_remote_interface
local ____types = require("types")
local TaskStates = ____types.TaskStates
local ____inventory = require("utils.inventory")
local get_inventory_items = ____inventory.get_inventory_items
local ____math = require("utils.math")
local distance = ____math.distance
function check_can_craft(self, player, item_name, count)
    local recipe = player.force.recipes[item_name]
    if not recipe then
        log("[AUTORIO] No such recipe: " .. item_name)
        return false
    end
    local ingredients = recipe.ingredients
    local player_inventory = player.get_main_inventory()
    if not player_inventory then
        log("[AUTORIO] Cannot access player inventory, ending CRAFTING task")
        return false
    end
    local not_enough_ingredients = {}
    for ____, ingredient in ipairs(ingredients) do
        local item_count = player_inventory.get_item_count(ingredient.name)
        if item_count < ingredient.amount * count then
            not_enough_ingredients[#not_enough_ingredients + 1] = {name = ingredient.name, amount = ingredient.amount * count - item_count}
        end
    end
    if #not_enough_ingredients > 0 then
        log((("[AUTORIO] [ERROR] No enough ingredients to craft " .. item_name) .. ": ") .. serpent.line(not_enough_ingredients))
        return false
    end
    return true
end
create_tools_remote_interface(nil)
local setup_complete = false
local task_manager = new_task_manager(nil)
local function log_player_info(self, player_id)
    local player = game.connected_players[player_id]
    local ____player_name_2 = player.name
    local ____player_position_3 = player.position
    local ____player_force_name_4 = player.force.name
    local ____temp_5 = {}
    local ____temp_6 = {}
    local ____temp_7 = {}
    local ____temp_8 = {surface_name = player.surface.name, daytime = player.surface.daytime, wind_speed = player.surface.wind_speed, wind_orientation = player.surface.wind_orientation}
    local ____opt_0 = player.force.current_research
    local log_data = {
        name = ____player_name_2,
        position = ____player_position_3,
        force = ____player_force_name_4,
        inventory = ____temp_5,
        equipment = ____temp_6,
        nearby_entities = ____temp_7,
        map_info = ____temp_8,
        research = {current_research = ____opt_0 and ____opt_0.name or "None", research_progress = player.force.research_progress},
        technologies = {},
        crafting_queue = {},
        character_stats = {
            health = nil,
            health_max = 0,
            mining_progress = nil,
            mining_target = nil,
            vehicle = "None"
        }
    }
    log_data.inventory = get_inventory_items(nil, player_id)
    local ____opt_9 = player.character
    if ____opt_9 and ____opt_9.grid then
        __TS__ArrayForEach(
            player.character.grid.equipment,
            function(____, ____bindingPattern0)
                local position
                local name
                name = ____bindingPattern0.name
                position = ____bindingPattern0.position
                local ____log_data_equipment_11 = log_data.equipment
                ____log_data_equipment_11[#____log_data_equipment_11 + 1] = {name = name, position = position}
            end
        )
    end
    local nearby_entities = player.surface.find_entities_filtered({position = player.position, radius = 20})
    __TS__ArrayForEach(
        nearby_entities,
        function(____, ____bindingPattern0)
            local position
            local name
            name = ____bindingPattern0.name
            position = ____bindingPattern0.position
            local ____log_data_nearby_entities_12 = log_data.nearby_entities
            ____log_data_nearby_entities_12[#____log_data_nearby_entities_12 + 1] = {name = name, position = position}
        end
    )
    for name, tech in pairs(player.force.technologies) do
        if tech.researched then
            local ____log_data_technologies_13 = log_data.technologies
            ____log_data_technologies_13[#____log_data_technologies_13 + 1] = name
        end
    end
    do
        local i = 1
        while i < player.crafting_queue_size do
            local ____opt_14 = player.crafting_queue
            local item = ____opt_14 and ____opt_14[i + 1]
            if item then
                local ____log_data_crafting_queue_16 = log_data.crafting_queue
                ____log_data_crafting_queue_16[#____log_data_crafting_queue_16 + 1] = {name = item.recipe, count = item.count}
            end
            i = i + 1
        end
    end
    if player.character then
        local ____player_character_health_19 = player.character.health
        local ____player_character_max_health_20 = player.character.max_health
        local ____player_character_mining_progress_21 = player.character.mining_progress
        local ____player_character_mining_target_22 = player.character.mining_target
        local ____opt_17 = player.vehicle
        log_data.character_stats = {
            health = ____player_character_health_19,
            health_max = ____player_character_max_health_20,
            mining_progress = ____player_character_mining_progress_21,
            mining_target = ____player_character_mining_target_22,
            vehicle = ____opt_17 and ____opt_17.name or "None"
        }
    end
    log((("[AUTORIO] Player " .. player.name) .. " info: ") .. serpent.block(log_data))
end
remote.add_interface(
    "autorio_operations",
    {
        walk_to_entity = function(entity_name, search_radius)
            log((("[AUTORIO] New walk_to_entity task: " .. entity_name) .. ", radius: ") .. tostring(search_radius))
            task_manager:add_task({
                type = TaskStates.WALKING_TO_ENTITY,
                entity_name = entity_name,
                search_radius = search_radius,
                path = nil,
                path_drawn = false,
                path_index = 1,
                calculating_path = false,
                target_position = nil
            })
            return true
        end,
        mine_entity = function(entity_name, count)
            if count == nil then
                count = 1
            end
            task_manager:add_task({type = TaskStates.MINING, entity_name = entity_name, count = count})
            log((("[AUTORIO] New mine_entity task: " .. entity_name) .. " x") .. tostring(count))
            return true
        end,
        place_entity = function(entity_name)
            task_manager:add_task({type = TaskStates.PLACING, entity_name = entity_name, position = nil})
            log("[AUTORIO] New place_entity task: " .. entity_name)
            return true
        end,
        move_items = function(item_name, entity_name, max_count, to_entity)
            task_manager:add_task({
                type = TaskStates.MOVING_ITEMS,
                item_name = item_name,
                entity_name = entity_name,
                max_count = max_count or math.huge,
                to_entity = to_entity
            })
            if to_entity then
                log((("[AUTORIO] New move_items task for " .. item_name) .. " from player's inventory to ") .. entity_name)
            else
                log(((("[AUTORIO] New move_items task for " .. item_name) .. " from ") .. entity_name) .. " to player's inventory")
            end
            return {true, "Task started"}
        end,
        wait = function(ticks)
            task_manager:add_task({type = TaskStates.WAITING, remaining_ticks = ticks})
            log(("[AUTORIO] New wait task for " .. tostring(ticks)) .. " ticks")
            return {true, "Task started"}
        end,
        craft_item = function(item_name, count)
            if count == nil then
                count = 1
            end
            local player = game.connected_players[1]
            if not player.force.recipes[item_name] then
                log("[AUTORIO] Cannot start craft_item task: Recipe not available")
                return {false, "Recipe not available"}
            end
            if not player.force.recipes[item_name].enabled then
                log("[AUTORIO] Cannot start craft_item task: Recipe not unlocked")
                return {false, "Recipe not unlocked"}
            end
            if not check_can_craft(nil, player, item_name, count) then
                return {false, "Not enough ingredients"}
            end
            task_manager:add_task({type = TaskStates.CRAFTING, item_name = item_name, count = count, crafted = 0})
            log((("[AUTORIO] New craft_item task: " .. item_name) .. " x") .. tostring(count))
            return {true, "Task started"}
        end,
        attack_nearest_enemy = function(search_radius)
            if search_radius == nil then
                search_radius = 50
            end
            task_manager:add_task({type = TaskStates.ATTACKING, search_radius = search_radius, target = nil})
            log("[AUTORIO] New attack nearest enemy task, search radius: " .. tostring(search_radius))
            return {true, "Task started"}
        end,
        research_technology = function(technology_name)
            local player = game.connected_players[1]
            local force = player.force
            local tech = force.technologies[technology_name]
            if not tech then
                log("[AUTORIO] Cannot start research_technology task: Technology not found")
                return {false, "Technology not found"}
            end
            if tech.researched then
                log("[AUTORIO] Cannot start research_technology task: Technology already researched")
                return {false, "Technology already researched"}
            end
            if not tech.enabled then
                log("[AUTORIO] Cannot start research_technology task: Technology not available for research")
                return {false, "Technology not available for research"}
            end
            local research_added = force.add_research(tech)
            if research_added then
                log("[AUTORIO] New research_technology task: " .. technology_name)
                return {true, "Research started"}
            end
            log("[AUTORIO] Could not start new research.")
            return {true, "Cannot start new research."}
        end,
        cancel_all_tasks = function()
            task_manager:cancel_all_tasks()
            return true
        end,
        log_player_info = function(player_id)
            log_player_info(nil, player_id)
            return true
        end
    }
)
local function get_direction(self, start_position, end_position)
    local angle = math.atan2(end_position.y - start_position.y, start_position.x - end_position.x)
    local octant = (angle + math.pi) / (2 * math.pi) * 8 + 0.5
    if octant < 1 then
        return defines.direction.east
    end
    if octant < 2 then
        return defines.direction.northeast
    end
    if octant < 3 then
        return defines.direction.north
    end
    if octant < 4 then
        return defines.direction.northwest
    end
    if octant < 5 then
        return defines.direction.west
    end
    if octant < 6 then
        return defines.direction.southwest
    end
    if octant < 7 then
        return defines.direction.south
    end
    return defines.direction.southeast
end
local function get_nearest_entity(self, player, entities)
    local min_distance = math.huge
    local nearest_entity = nil
    if #entities == 0 then
        return nil
    end
    for ____, entity in ipairs(entities) do
        local distance = (entity.position.x - player.position.x) ^ 2 + (entity.position.y - player.position.y) ^ 2
        if distance < min_distance then
            min_distance = distance
            nearest_entity = entity
        end
    end
    return nearest_entity
end
local function start_mining(self, player, entity_position)
    player.update_selected_entity(entity_position)
    player.mining_state = {mining = true, position = entity_position}
    log("[AUTORIO] Started mining at position: " .. serpent.line(entity_position))
end
script.on_event(
    defines.events.on_selected_entity_changed,
    function(unused_event)
    end
)
script.on_event(
    defines.events.on_script_path_request_finished,
    function(event)
        if task_manager.player_state.task_state ~= TaskStates.WALKING_TO_ENTITY then
            log("[AUTORIO] Not walking to entity, ignoring path request")
            return
        end
        if not task_manager.player_state.parameters_walk_to_entity then
            log("[AUTORIO] No parameters found when receiving path request")
            return
        end
        if not event.path then
            log("[AUTORIO] Path calculation failed, switching to direct walking")
            task_manager.player_state.task_state = TaskStates.WALKING_DIRECT
            task_manager.player_state.parameters_walking_direct = {type = TaskStates.WALKING_DIRECT, target_position = task_manager.player_state.parameters_walk_to_entity.target_position}
            task_manager.player_state.parameters_walk_to_entity = nil
            return
        end
        task_manager.player_state.parameters_walk_to_entity.path = event.path
        task_manager.player_state.parameters_walk_to_entity.path_drawn = false
        task_manager.player_state.parameters_walk_to_entity.path_index = 1
        task_manager.player_state.parameters_walk_to_entity.calculating_path = false
        log("[AUTORIO] Path calculation completed. Path length: " .. tostring(event.path))
    end
)
script.on_event(
    defines.events.on_player_mined_entity,
    function(unused_event)
        if task_manager.player_state.task_state ~= TaskStates.MINING then
            return
        end
        if not task_manager.player_state.parameters_mine_entity then
            log("[AUTORIO] No parameters found when on_player_mined_entity event")
            return
        end
        if task_manager.player_state.parameters_mine_entity.count <= 0 then
            log("[AUTORIO] Count is 0, switching to IDLE state")
            task_manager:reset_task_state()
            task_manager:next_task()
            return
        end
        task_manager.player_state.parameters_mine_entity.count = task_manager.player_state.parameters_mine_entity.count - 1
    end
)
local function setup(self)
    local surface = game.surfaces[1]
    local enemies = surface.find_entities_filtered({force = "enemy"})
    log(("[AUTORIO] Removing " .. tostring(#enemies)) .. " enemies")
    for ____, enemy in ipairs(enemies) do
        enemy.destroy()
    end
    setup_complete = true
    log("[AUTORIO] Setup complete")
end
local function draw_path(self, player, path)
    do
        local i = 0
        while i < #path - 1 do
            rendering.draw_line({
                color = {r = 0, g = 1, b = 0},
                width = 2,
                from = path[i + 1].position,
                to = path[i + 1 + 1].position,
                surface = player.surface,
                time_to_live = 600,
                draw_on_ground = true
            })
            i = i + 1
        end
    end
end
local function follow_path(self, player, path)
    if #path == 0 then
        return true
    end
    local next_position = path[1].position
    local d = distance(nil, next_position, player.position)
    if d < 0.1 then
        table.remove(path, 1)
        return false
    end
    local direction = get_direction(nil, player.position, next_position)
    player.walking_state = {walking = true, direction = direction}
    return false
end
local function state_walking_to_entity(self, player)
    if not task_manager.player_state.parameters_walk_to_entity then
        log("[AUTORIO] No parameters found when walking to entity")
        return
    end
    if task_manager.player_state.parameters_walk_to_entity.calculating_path then
        log("[AUTORIO] Path calculation in progress, skipping")
        return
    end
    if task_manager.player_state.parameters_walk_to_entity.path then
        if not task_manager.player_state.parameters_walk_to_entity.path_drawn then
            draw_path(nil, player, task_manager.player_state.parameters_walk_to_entity.path)
            task_manager.player_state.parameters_walk_to_entity.path_drawn = true
            log("[AUTORIO] Path drawn on ground")
        end
        if follow_path(nil, player, task_manager.player_state.parameters_walk_to_entity.path) then
            log("[AUTORIO] Task completed, switching to IDLE state")
            rendering.clear()
            task_manager:reset_task_state()
            task_manager:next_task()
        end
        return
    end
    if not prototypes.entity[task_manager.player_state.parameters_walk_to_entity.entity_name] then
        log(("[AUTORIO] [ERROR] Unknown entity name: " .. task_manager.player_state.parameters_walk_to_entity.entity_name) .. ", reverting to IDLE state")
        task_manager:reset_task_state()
        task_manager:next_task()
        return
    end
    local entities = player.surface.find_entities_filtered({position = player.position, radius = task_manager.player_state.parameters_walk_to_entity.search_radius, name = task_manager.player_state.parameters_walk_to_entity.entity_name})
    if not #entities then
        log("[AUTORIO] No entities found, reverting to IDLE state")
        task_manager:reset_task_state()
        task_manager:next_task()
        return
    end
    if #entities == 0 then
        log(((("[AUTORIO] [ERROR] No " .. task_manager.player_state.parameters_walk_to_entity.entity_name) .. " found in ") .. tostring(task_manager.player_state.parameters_walk_to_entity.search_radius)) .. "m radius, reverting to IDLE state")
        task_manager:cancel_all_tasks()
        return
    end
    local nearest_entity = get_nearest_entity(nil, player, entities)
    log("[AUTORIO] Nearest entity position: " .. serpent.line(nearest_entity and nearest_entity.position))
    log("[AUTORIO] Player position: " .. serpent.line(player.position))
    local ____log_28 = log
    local ____serpent_line_27 = serpent.line
    local ____opt_25 = player.character
    ____log_28("[AUTORIO] Player bounding box: " .. ____serpent_line_27(____opt_25 and ____opt_25.bounding_box))
    if nearest_entity and not task_manager.player_state.parameters_walk_to_entity.calculating_path and not task_manager.player_state.parameters_walk_to_entity.path then
        local character = player.character
        if not character then
            log("[AUTORIO] Player character not found, aborting pathfinding")
            return
        end
        local bbox = {{-0.5, -0.5}, {0.5, 0.5}}
        local start = player.surface.find_non_colliding_position(
            "iron-chest",
            character.position,
            10,
            0.5,
            false
        )
        if not start then
            log("[AUTORIO] find_non_colliding_position returned nil! Aborting pathfinding.")
            return
        end
        local collision_mask = {layers = {player = true, train = true, water_tile = true, object = true}, consider_tile_transitions = true}
        player.surface.request_path({
            bounding_box = bbox,
            collision_mask = collision_mask,
            radius = 2,
            start = start,
            goal = nearest_entity.position,
            force = player.force,
            entity_to_ignore = character,
            pathfind_flags = {cache = false, no_break = true, prefer_straight_paths = false, allow_paths_through_own_entities = false}
        })
        task_manager.player_state.parameters_walk_to_entity.calculating_path = true
        task_manager.player_state.parameters_walk_to_entity.target_position = nearest_entity.position
        log("[AUTORIO] Requested path calculation to " .. serpent.line(nearest_entity.position))
    end
end
local function state_mining(self, player)
    if not task_manager.player_state.parameters_mine_entity then
        log("[AUTORIO] No parameters found when mining")
        return
    end
    if player.mining_state.mining then
        return
    end
    if task_manager.player_state.parameters_mine_entity.position then
        start_mining(nil, player, task_manager.player_state.parameters_mine_entity.position)
        return
    end
    if not prototypes.entity[task_manager.player_state.parameters_mine_entity.entity_name] then
        log(("[AUTORIO] [ERROR] Unknown entity name: " .. task_manager.player_state.parameters_mine_entity.entity_name) .. ", reverting to IDLE state")
        task_manager:reset_task_state()
        task_manager:next_task()
        return
    end
    local entities = player.surface.find_entities_filtered({position = player.position, radius = 5, name = task_manager.player_state.parameters_mine_entity.entity_name})
    if #entities == 0 then
        log("[AUTORIO] No entity found to mine, switching to IDLE state")
        task_manager:reset_task_state()
        task_manager:next_task()
        return
    end
    local nearest_entity = get_nearest_entity(nil, player, entities)
    if not nearest_entity then
        log("[AUTORIO] No entity found to mine, switching to IDLE state")
        task_manager:reset_task_state()
        task_manager:next_task()
        return
    end
    start_mining(nil, player, nearest_entity.position)
end
local function state_placing(self, player)
    if not player then
        log("[AUTORIO] Invalid player, ending PLACING task")
        task_manager:reset_task_state()
        task_manager:next_task()
        return {false, "Invalid player"}
    end
    if not task_manager.player_state.parameters_place_entity then
        log("[AUTORIO] No parameters found when placing")
        return
    end
    local surface = player.surface
    local inventory = player.get_main_inventory()
    if not inventory then
        log("[AUTORIO] Cannot access player inventory, ending PLACING task")
        task_manager:reset_task_state()
        task_manager:next_task()
        return {false, "Cannot access player inventory"}
    end
    if not prototypes.entity[task_manager.player_state.parameters_place_entity.entity_name] then
        log(("[AUTORIO] [ERROR] Unknown entity name: " .. task_manager.player_state.parameters_place_entity.entity_name) .. ", reverting to IDLE state")
        task_manager:reset_task_state()
        task_manager:next_task()
        return {false, "Invalid entity name"}
    end
    local entity_prototype = prototypes.entity[task_manager.player_state.parameters_place_entity.entity_name]
    if not entity_prototype or not entity_prototype.items_to_place_this then
        log(("[AUTORIO] [ERROR] Entity " .. task_manager.player_state.parameters_place_entity.entity_name) .. " cannot be placed, ending PLACING task")
        task_manager:reset_task_state()
        task_manager:next_task()
        return {false, "Invalid entity name"}
    end
    local item_name = entity_prototype.items_to_place_this[1]
    if not item_name then
        log("[AUTORIO] Invalid entity name, ending PLACING task")
        task_manager:reset_task_state()
        task_manager:next_task()
        return {false, "Invalid entity name"}
    end
    local item_stack, unused_count = inventory.find_item_stack(task_manager.player_state.parameters_place_entity.entity_name)
    if not item_stack then
        log("[AUTORIO] Entity not found in inventory, ending PLACING task")
        task_manager:reset_task_state()
        task_manager:next_task()
        return {false, "Entity not found in inventory"}
    end
    if not task_manager.player_state.parameters_place_entity.position then
        task_manager.player_state.parameters_place_entity.position = surface.find_non_colliding_position(task_manager.player_state.parameters_place_entity.entity_name, player.position, 1, 1)
        if not task_manager.player_state.parameters_place_entity.position then
            log("[AUTORIO] Could not find a valid position to place the entity, ending PLACING task")
            task_manager:reset_task_state()
            task_manager:next_task()
            return {false, "Could not find a valid position to place the entity"}
        end
    end
    task_manager.player_state.task_state = TaskStates.IDLE
    local create_entity_args = {
        name = task_manager.player_state.parameters_place_entity.entity_name,
        position = task_manager.player_state.parameters_place_entity.position,
        force = player.force,
        raise_built = true,
        player = player
    }
    local entity = surface.create_entity(create_entity_args)
    if entity then
        item_stack.count = item_stack.count - 1
        log("[AUTORIO] Entity placed successfully: " .. task_manager.player_state.parameters_place_entity.entity_name)
        task_manager:reset_task_state()
        task_manager:next_task()
        return {true, "Entity placed successfully", entity}
    end
    log("[AUTORIO] Failed to place entity: " .. task_manager.player_state.parameters_place_entity.entity_name)
    return {false, "Failed to place entity"}
end
local function state_moving_items(self, player)
    local parameters = task_manager.player_state.parameters_move_items
    if not parameters then
        log("[AUTORIO] No parameters found when moving items")
        return
    end
    local nearby_entities = player.surface.find_entities_filtered({position = player.position, radius = 8, name = parameters.entity_name, force = player.force})
    local player_inventory = player.get_main_inventory()
    if not player_inventory then
        log("[AUTORIO] Cannot access player inventory, ending MOVING_ITEMS task")
        task_manager:reset_task_state()
        task_manager:next_task()
        return
    end
    local moved_total = 0
    if parameters.to_entity then
        local item_stack, unused_count = player_inventory.find_item_stack(parameters.item_name)
        if not item_stack then
            log("[AUTORIO] Item not found in player inventory, ending MOVING_ITEMS task")
            task_manager:reset_task_state()
            task_manager:next_task()
            return
        end
        __TS__ArrayForEach(
            __TS__ArrayFlat(__TS__ArrayMap(
                __TS__ArrayFilter(
                    nearby_entities,
                    function(____, it) return it.can_insert({name = parameters.item_name}) end
                ),
                function(____, entity)
                    local max_index = entity.get_max_inventory_index()
                    local inventories = {}
                    do
                        local i = 1
                        while i <= max_index do
                            local inventory = entity.get_inventory(i)
                            if inventory and inventory.can_insert({name = parameters.item_name}) then
                                inventories[#inventories + 1] = inventory
                            end
                            i = i + 1
                        end
                    end
                    return inventories
                end
            )),
            function(____, inventory)
                if moved_total >= parameters.max_count then
                    return
                end
                local to_move = math.min(item_stack.count, parameters.max_count - moved_total)
                if to_move <= 0 then
                    return
                end
                local ____log_32 = log
                local ____parameters_item_name_31 = parameters.item_name
                local ____opt_29 = inventory.entity_owner
                ____log_32((((((("[AUTORIO] Moving " .. tostring(to_move)) .. " ") .. ____parameters_item_name_31) .. " to ") .. tostring(____opt_29 and ____opt_29.name)) .. " inventory index ") .. tostring(inventory.index))
                local moved = inventory.insert({name = parameters.item_name, count = to_move})
                if moved > 0 then
                    player_inventory.remove({name = parameters.item_name, count = moved})
                    moved_total = moved_total + moved
                    local ____log_36 = log
                    local ____parameters_item_name_35 = parameters.item_name
                    local ____opt_33 = inventory.entity_owner
                    ____log_36((((((("[AUTORIO] Moved " .. tostring(moved)) .. " ") .. ____parameters_item_name_35) .. " to ") .. tostring(____opt_33 and ____opt_33.name)) .. " inventory index ") .. tostring(inventory.index))
                end
            end
        )
    else
        __TS__ArrayForEach(
            __TS__ArrayFlat(__TS__ArrayMap(
                nearby_entities,
                function(____, entity)
                    local max_index = entity.get_max_inventory_index()
                    local inventories = {}
                    do
                        local i = 1
                        while i <= max_index do
                            do
                                local inventory = entity.get_inventory(i)
                                if not inventory then
                                    goto __continue116
                                end
                                inventories[#inventories + 1] = inventory
                            end
                            ::__continue116::
                            i = i + 1
                        end
                    end
                    return inventories
                end
            )),
            function(____, inventory)
                if moved_total >= parameters.max_count then
                    return
                end
                if not player_inventory.can_insert({name = parameters.item_name}) then
                    log(("[AUTORIO] Cannot insert " .. parameters.item_name) .. " into player inventory, skipping")
                    return
                end
                local removed = inventory.remove({name = parameters.item_name, count = parameters.max_count - moved_total})
                if removed <= 0 then
                    return
                end
                local inserted = player_inventory.insert({name = parameters.item_name, count = removed})
                if inserted < removed then
                    inventory.insert({name = parameters.item_name, count = removed - inserted})
                    moved_total = moved_total + inserted
                else
                    moved_total = moved_total + removed
                end
                moved_total = moved_total + removed
                local ____log_40 = log
                local ____parameters_item_name_39 = parameters.item_name
                local ____opt_37 = inventory.entity_owner
                ____log_40((((((("[AUTORIO] Moved " .. tostring(removed)) .. " ") .. ____parameters_item_name_39) .. " from ") .. tostring(____opt_37 and ____opt_37.name)) .. " inventory index ") .. tostring(inventory.index))
            end
        )
    end
    if moved_total == 0 then
        log("[AUTORIO] No items moved, ending task")
    else
        log((("[AUTORIO] Moved a total of " .. tostring(moved_total)) .. " ") .. parameters.item_name)
    end
    task_manager:reset_task_state()
    task_manager:next_task()
end
local function state_researching(self, player)
    if not task_manager.player_state.parameters_research_technology then
        log("[AUTORIO] No parameters found when researching")
        return
    end
    local force = player.force
    local tech = force.technologies[task_manager.player_state.parameters_research_technology.technology_name]
    if tech.researched then
        log("[AUTORIO] Research completed: " .. task_manager.player_state.parameters_research_technology.technology_name)
        task_manager:reset_task_state()
        task_manager:next_task()
    elseif force.current_research ~= tech then
        log("[AUTORIO] Research interrupted: " .. task_manager.player_state.parameters_research_technology.technology_name)
        task_manager:reset_task_state()
        task_manager:next_task()
    end
end
local function state_walking_direct(self, player)
    if not task_manager.player_state.parameters_walking_direct then
        log("[AUTORIO] No parameters found when walking directly")
        return
    end
    local target = task_manager.player_state.parameters_walking_direct.target_position
    if target then
        local direction = get_direction(nil, player.position, target)
        player.walking_state = {walking = true, direction = direction}
        if (target.x - player.position.x) ^ 2 + (target.y - player.position.y) ^ 2 < 2 then
            log("[AUTORIO] Reached target, switching to IDLE state")
            task_manager:reset_task_state()
            task_manager:next_task()
        end
    else
        log("[AUTORIO] No target position, switching to IDLE state")
        task_manager:reset_task_state()
        task_manager:next_task()
    end
end
local function state_waiting(self)
    if not task_manager.player_state.parameters_waiting then
        log("[AUTORIO] No parameters found when waiting")
        return
    end
    if task_manager.player_state.parameters_waiting.remaining_ticks <= 0 then
        log("[AUTORIO] Waiting task complete")
        task_manager:reset_task_state()
        task_manager:next_task()
        return
    end
    local ____task_manager_player_state_parameters_waiting_41, ____remaining_ticks_42 = task_manager.player_state.parameters_waiting, "remaining_ticks"
    ____task_manager_player_state_parameters_waiting_41[____remaining_ticks_42] = ____task_manager_player_state_parameters_waiting_41[____remaining_ticks_42] - 1
end
local no_player_found = false
script.on_event(
    defines.events.on_tick,
    function(unused_event)
        if not setup_complete then
            setup(nil)
        end
        local player = game.connected_players[1]
        if player == nil or player.character == nil then
            if not no_player_found then
                log("[AUTORIO] No valid player found")
                no_player_found = true
            end
            return
        end
        if task_manager.player_state.task_state == TaskStates.IDLE then
            return
        end
        if task_manager.player_state.task_state == TaskStates.WALKING_TO_ENTITY then
            state_walking_to_entity(nil, player)
        elseif task_manager.player_state.task_state == TaskStates.MINING then
            state_mining(nil, player)
        elseif task_manager.player_state.task_state == TaskStates.PLACING then
            state_placing(nil, player)
        elseif task_manager.player_state.task_state == TaskStates.MOVING_ITEMS then
            state_moving_items(nil, player)
        elseif task_manager.player_state.task_state == TaskStates.RESEARCHING then
            state_researching(nil, player)
        elseif task_manager.player_state.task_state == TaskStates.WALKING_DIRECT then
            state_walking_direct(nil, player)
        elseif task_manager.player_state.task_state == TaskStates.WAITING then
            state_waiting(nil)
        end
    end
)
script.on_event(
    defines.events.on_player_crafted_item,
    function(event)
        log((("[AUTORIO] Player " .. game.connected_players[event.player_index].name) .. " crafted item: ") .. event.item_stack.name)
        if not task_manager.player_state.parameters_craft_item then
            log("[AUTORIO] No parameters found when item crafted")
            return
        end
        if task_manager.player_state.task_state ~= TaskStates.CRAFTING then
            return
        end
        task_manager.player_state.parameters_craft_item.crafted = task_manager.player_state.parameters_craft_item.crafted + 1
        log((("[AUTORIO] Crafted 1 " .. task_manager.player_state.parameters_craft_item.item_name) .. ", remaining: ") .. tostring(task_manager.player_state.parameters_craft_item.count - task_manager.player_state.parameters_craft_item.crafted))
        if task_manager.player_state.parameters_craft_item.crafted >= task_manager.player_state.parameters_craft_item.count then
            log("[AUTORIO] Crafting task complete")
            task_manager:reset_task_state()
            task_manager:next_task()
        end
    end
)
log("[AUTORIO] Mod loaded 1")
return ____exports
 end,
["utils.hot_reload"] = function(...) 
--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
-- Lua Library inline imports
local function __TS__ArrayForEach(self, callbackFn, thisArg)
    for i = 1, #self do
        callbackFn(thisArg, self[i], i - 1, self)
    end
end
-- End of Lua Library inline imports
local ____exports = {}
function ____exports.create_hot_reloader(self, mod_name, before_reload)
    if not mods_globals then
        mods_globals = {}
    end
    if not mods_globals[mod_name] then
        mods_globals[mod_name] = {
            remote_interfaces = {},
            event_listeners = {},
            add_remote_interface = function(____, name, i)
                local ____mods_globals_mod_name_remote_interfaces_0 = mods_globals[mod_name].remote_interfaces
                ____mods_globals_mod_name_remote_interfaces_0[#____mods_globals_mod_name_remote_interfaces_0 + 1] = name
                remote.add_interface(name, i)
                log("add_remote_interface " .. name)
            end,
            add_event_listener = function(____, event, callback)
                if not mods_globals[mod_name].event_listeners[event] then
                    mods_globals[mod_name].event_listeners[event] = {}
                    script.on_event(
                        event,
                        function()
                            __TS__ArrayForEach(
                                mods_globals[mod_name].event_listeners[event],
                                function(____, callback)
                                    callback(nil)
                                end
                            )
                        end
                    )
                end
                local ____mods_globals_mod_name_event_listeners_event_1 = mods_globals[mod_name].event_listeners[event]
                ____mods_globals_mod_name_event_listeners_event_1[#____mods_globals_mod_name_event_listeners_event_1 + 1] = callback
            end,
            before_reload = function()
                log("before_reload")
                __TS__ArrayForEach(
                    mods_globals[mod_name].remote_interfaces,
                    function(____, name)
                        remote.remove_interface(name)
                    end
                )
                for event in pairs(mods_globals[mod_name].event_listeners) do
                    mods_globals[mod_name].event_listeners[event] = {}
                end
                before_reload(nil)
            end,
            new_code_to_reload = ""
        }
        remote.add_interface(
            mod_name .. "_hot_reload",
            {
                before_reload = function()
                    mods_globals[mod_name]:before_reload()
                end,
                append_code_to_reload = function(code)
                    local ____mods_globals_mod_name_2, ____new_code_to_reload_3 = mods_globals[mod_name], "new_code_to_reload"
                    ____mods_globals_mod_name_2[____new_code_to_reload_3] = ____mods_globals_mod_name_2[____new_code_to_reload_3] .. code .. string.char(10)
                end,
                reload_code = function()
                    local mod, err = load(mods_globals[mod_name].new_code_to_reload, "reload", "bt", _G)
                    if not mod then
                        log("[tstl-plugin-reload-factorio-mod] error reload mod: " .. err)
                        return
                    end
                    local success, run_err = pcall(mod)
                    if not success then
                        log((("[tstl-plugin-reload-factorio-mod] error run mod " .. mod_name) .. ": ") .. run_err)
                        return
                    end
                    game.print("[tstl-plugin-reload-factorio-mod] Mod reloaded: " .. mod_name)
                    log("[tstl-plugin-reload-factorio-mod] Mod reloaded: " .. mod_name)
                    mods_globals[mod_name].new_code_to_reload = ""
                end
            }
        )
    end
    return {add_remote_interface = mods_globals[mod_name].add_remote_interface, add_event_listener = mods_globals[mod_name].add_event_listener}
end
return ____exports
 end,
["hot_reload"] = function(...) 
--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____hot_reload = require("utils.hot_reload")
local create_hot_reloader = ____hot_reload.create_hot_reloader
____exports.hot_reloader = create_hot_reloader(
    nil,
    "autorio",
    function()
        print("before_reload")
    end
)
return ____exports
 end,
}
return require("control", ...)
