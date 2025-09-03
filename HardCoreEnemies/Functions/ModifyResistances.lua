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

local function AddNewDamageTypes(prototype, is_combat_building)
    local resistances = prototype.resistances or {}
    local truth_table = {} -- if the value is true, the resistance table already has that damage type resistance
    -- grab the damage types from data.raw and assign them truth table values
    for _, v in pairs(data.raw["damage-type"]) do truth_table[v.name] = false end

    -- figure out which damage types already exist within the table
    if table_size(resistances) > 0 then
        for _, v in pairs(resistances) do
            truth_table[v.type] = true
        end
    end

    local decrease_value = is_combat_building == true and 100 or 25
    -- add the new resistance to the resistance table
    for i, v in pairs(truth_table) do
        if v == false then
            table.insert(resistances, { type = i, decrease = decrease_value })
        end
    end

    return resistances
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

                -- update the resistance tables for each item in the game
                if _find_table_value(prot.flags, "player-creation") then
                    is_combat_building = combat_buildings[data_type] or false
                    setting_name = is_combat_building == true and "CombatResistanceMultiplier" or setting_name
                    setting_value = settings.startup[setting_name].value

                    -- add new damage types to be resistant against
                    prot.resistances = AddNewDamageTypes(prot, is_combat_building)

                    if prot.name ~= "underground-belt" then
                        UpdateResistanceTable(prot, setting_value, is_combat_building)
                    end
                end

                -- reset the variables
                setting_name = "ResistanceMultiplier"
                setting_value = nil
                is_combat_building = false

                ::continue::
            end
        end
    end
end

ModifyResistances()
