-- Rify, 22:14 8.18.2025

--[[
    items are stored as their type and if they're a combat building
    true for combat building, false for regular building

    example entry(s)
    {"regular-building", false},
    {"combat-building", true}
]] --

local combat_buildings = {
    "artillery-turret",
    "ammo-turret",
    "electric-turret",
    "fluid-turret",
    "spider-leg",
    "car",
    "artillery-wagon",
    "locomotive",
    "spider-vehicle",
    "wall",
    "gate"
}

local AddResistances = function(resistances)
    local truth_table = {}
    local damage_types = {}

    for _, v in pairs(data.raw["damage-type"]) do
        truth_table[v.name] = false
        table.insert(damage_types, v)
    end

    if #resistances > 0 then
        -- check for pre-existing resistances and setup the truth table
        for _, resistance in pairs(resistances) do
            -- check for a pre-existing resistance
            for _, t in pairs(damage_types) do
                if resistance.type == t then
                    truth_table[t] = true
                end
            end
        end
    end

    -- add the new resistances that don't already exist in the resistances table
    for t, v in pairs(truth_table) do
        if v then -- do nothing if the resistance type already exists in the table
            goto continue
        end

        table.insert(resistances, { type = t })

        ::continue::
    end

    return resistances
end

local UpdateResistanceTable = function(prot_name, entity_name, setting_value, is_combat_building)
    local prototype = data.raw[prot_name][entity_name]
    local resist_tbl = prototype.resistances or {}

    -- add the new resistance types
    resist_tbl = AddResistances(resist_tbl)

    -- loop through the resistances table
    for i, _ in pairs(resist_tbl) do
        -- add the decrease for a damage type if it doesn't exist
        if not resist_tbl[i].decrease then
            if is_combat_building then
                resist_tbl[i].decrease = 100
            else
                resist_tbl[i].decrease = 25
            end
        end

        -- increase the decrease value by the proper setting value
        resist_tbl[i].decrease = resist_tbl[i].decrease * setting_value

        prototype.resistances = resist_tbl
        data.raw[prot_name][entity_name] = prototype -- update data.raw with the new prototype
    end
end

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

local ModifyResistances = function()
    -- define variables outside of forloop to save miniscule amounts of memory :P
    local setting_name = "ResistanceMultiplier" -- assume the buildings are not combat buildings
    local setting_value = nil                   -- declare this variable here but don't define it
    local is_combat_building = false

    -- loop through the entirety of data.raw, only performing resistance changes on entities (hopefully)
    for prot_cat_name, prot_cat in pairs(data.raw) do
        for prot_name, prot in pairs(prot_cat) do
            if not prot.flags then goto continue end -- do nothing if the prot.flags doesn't exist

            -- if the prototype contains these flags, we should continue
            if _find_table_value(prot.flags, "player-creation") or _find_table_value(prot.flags, "placeable-player") then
                if _find_table_value(combat_buildings, prot_name) then -- check if its a combat building
                    setting_name = "CombatResistanceMultiplier"
                    is_combat_building = true
                end
                setting_value = settings.startup[setting_name].value

                if prot_name ~= "underground-belt" then -- prevent the underground belt bug
                    UpdateResistanceTable(prot_cat_name, prot_name, setting_value, is_combat_building)
                end
            end

            -- reset the variables
            setting_name = "ResistanceMultiplier"
            setting_value = nil
            is_combat_building = false
            prot.hide_resistances = false

            ::continue::
        end
    end
end

ModifyResistances()

return UpdateResistanceTable -- for updating resistances modified by other mods
