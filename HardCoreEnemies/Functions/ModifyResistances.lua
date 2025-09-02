-- Rify, 22:14 8.18.2025

local combat_buildings = {
    ["artillery-turret"] = true,
    ["ammo-turret"] = true,
    ["electric-turret"] = true,
    ["fluid-turret"] = true,
    ["spider-leg"] = true,
    ["car"] = true,
    ["artillery-wagon"] = true,
    ["locomotive"] = true,
    ["spider-vehicle"] = true,
    ["wall"] = true,
    ["gate"] = true
}

-- helper function for ModifyResistances
-- finds a single value from a table and returns true or false if it exists or not
local _find_table_value = function(tbl, val)
    for _, v in pairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

-- local UpdateResistanceTable = function(prot_name, entity_name, setting_value, is_combat_building)
--     local prototype = data.raw[prot_name][entity_name]
--     local resist_tbl = prototype.resistances
--     if not resist_tbl then
--         resist_tbl = {}
--         log("CREATING A NEW RESISTANCE TABLE FOR: [" .. prot_name .. "][" .. entity_name .. "]")
--     end

--     -- add the new resistance types
--     resist_tbl = AddResistances(resist_tbl)

--     -- loop through the resistances table
--     for i, _ in pairs(resist_tbl) do
--         if entity_name == "transport-belt" then
--             log("transport-belt:\t\t\t" .. tostring(resist_tbl[i].percent))
--         end

--         -- add the decrease for a damage type if it doesn't exist
--         if not resist_tbl[i].decrease then
--             if is_combat_building then
--                 resist_tbl[i].decrease = 100
--             else
--                 resist_tbl[i].decrease = 25
--             end
--         end

--         -- increase the decrease value by the proper setting value
--         resist_tbl[i].decrease = resist_tbl[i].decrease * setting_value
--     end

--     -- moved out of the loop
--     prototype.resistances = resist_tbl

--     if entity_name == "transport-belt" then
--         log("transport-belt:\t\t\t" .. prototype.resistances[1].percent)
--     end
-- end

local function UpdateResistanceTable(prototype, setting_value, is_combat_building)
    local resistances = prototype.resistances
    if not resistances then
        resistances = {}
    end

    for _, resistance in pairs(resistances) do
        if not resistance.decrease then
            if is_combat_building then
                resistance.decrease = 100
            else
                resistance.decrease = 25
            end
        end

        resistance.decrease = resistance.decrease * setting_value
    end
end

local function ModifyResistances()
    local setting_name = "ResistanceMultiplier"
    local setting_value = nil
    local is_combat_building = false

    for data_type in pairs(defines.prototypes.entity) do
        if data.raw[data_type] then
            for _, prot in pairs(data.raw[data_type]) do
                if not prot.flags then goto continue end

                prot.hide_resistances = false

                if _find_table_value(prot.flags, "player-creation") then
                    if combat_buildings[data_type] then
                        is_combat_building = true
                        setting_name = "CombatResistanceMultiplier"
                        log(prot.name .. " is a combat building...")
                    end
                    setting_value = settings.startup[setting_name].value

                    if prot.name ~= "underground-belt" then
                        UpdateResistanceTable(prot, setting_value, is_combat_building)
                    end
                end

                ::continue::
            end
        end
    end
end




ModifyResistances()

-- local ModifyResistances = function()
--     -- define variables outside of forloop to save miniscule amounts of memory :P
--     local setting_name = "ResistanceMultiplier" -- assume the buildings are not combat buildings
--     local setting_value = nil                   -- declare this variable here but don't define it
--     local is_combat_building = false

--     -- loop through the entirety of data.raw, only performing resistance changes on entities (hopefully)
--     for prot_cat_name, prot_cat in pairs(data.raw) do
--         for prot_name, prot in pairs(prot_cat) do
--             if not prot.flags then goto continue end -- do nothing if the prot.flags doesn't exist

--             -- make sure we're messing with a player-creation building
--             if _find_table_value(prot.flags, "player-creation") then
--                 if _find_table_value(combat_buildings, prot_cat_name) then -- check if its a combat building
--                     setting_name = "CombatResistanceMultiplier"
--                     is_combat_building = true
--                 end
--                 setting_value = settings.startup[setting_name].value

--                 if prot_name ~= "underground-belt" then -- prevent the underground belt bug
--                     UpdateResistanceTable(prot_cat_name, prot_name, setting_value, is_combat_building)
--                 end
--             end

--             -- reset the variables
--             setting_name = "ResistanceMultiplier"
--             setting_value = nil
--             is_combat_building = false
--             prot.hide_resistances = false

--             ::continue::
--         end
--     end
-- end

-- local combat_buildings = {
--     "artillery-turret",
--     "ammo-turret",
--     "electric-turret",
--     "fluid-turret",
--     "spider-leg",
--     "car",
--     "artillery-wagon",
--     "locomotive",
--     "spider-vehicle",
--     "wall",
--     "gate"
-- }

-- local AddResistances = function(resistances)
--     local truth_table = {}
--     local damage_types = {}

--     for _, v in pairs(data.raw["damage-type"]) do
--         truth_table[v.name] = false
--         table.insert(damage_types, v)
--     end

--     if table_size(resistances) > 0 then
--         -- check for pre-existing resistances and setup the truth table
--         for _, resistance in pairs(resistances) do
--             -- check for a pre-existing resistance
--             for _, t in pairs(damage_types) do
--                 if resistance.type == t then
--                     truth_table[t] = true
--                 end
--             end
--         end
--     end

--     -- add the new resistances that don't already exist in the resistances table
--     for t, v in pairs(truth_table) do
--         if v then -- do nothing if the resistance type already exists in the table
--             goto continue
--         end

--         table.insert(resistances, { type = t })

--         ::continue::
--     end

--     return resistances
-- end





-- -- make it loop through defines.prototypes.entity instead of data.raw to save resources



-- ModifyResistances()
