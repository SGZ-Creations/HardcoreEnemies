-- Rify, 22:14 8.18.2025

--[[
    items are stored as their type and if they're a combat building
    true for combat building, false for regular building

    example entry(s)
    {"regular-building", false},
    {"combat-building", true}
]] --


local building_types = {
    { "accumulator",               false },
    { "artillery-turret",          true },
    { "beacon",                    false },
    { "boiler",                    false },
    { "arithmetic-combinator",     false },
    { "decider-combinator",        false },
    { "selector-combinator",       false },
    { "constant-combinator",       false },
    { "container",                 false },
    { "logistic-container",        false },
    { "infinity-container",        false },
    { "temporary-container",       false },
    { "assembling-machine",        false },
    { "rocket-silo",               false },
    { "furnace",                   false },
    { "display-panel",             false },
    { "electric-energy-interface", false },
    { "electric-pole",             false },
    { "combat-robot",              false },
    { "construction-robot",        false },
    { "logistic-robot",            false },
    { "gate",                      true },
    { "generator",                 false },
    { "heat-interface",            false },
    { "heat-pipe",                 false },
    { "inserter",                  false },
    { "lab",                       false },
    { "lamp",                      false },
    { "land-mine",                 false },
    { "linked-container",          false },
    { "market",                    false },
    { "mining-drill",              false },
    { "offshore-pump",             false },
    { "pipe",                      false },
    { "infinity-pipe",             false },
    { "pipe-to-ground",            false },
    { "power-switch",              false },
    { "programmable-speaker",      false },
    { "proxy-container",           false },
    { "pump",                      false },
    { "radar",                     false },
    { "curved-rail-a",             false },
    { "curved-rail-b",             false },
    { "half-diagonal-rail",        false },
    { "legacy-curved-rail",        false }, -- TODO: remove when 2.1 comes out
    { "legacy-straight-rail",      false }, -- TODO: remove when 2.1 comes out
    { "straight-rail",             false },
    { "rail-chain-signal",         false },
    { "rail-signal",               false },
    { "reactor",                   false },
    { "roboport",                  false },
    { "solar-panel",               false },
    { "spider-leg",                true },
    { "storage-tank",              false },
    { "train-stop",                false },
    { "lane-splitter",             false },
    { "linked-belt",               false },
    { "splitter",                  false },
    { "transport-belt",            false },
    { "underground-belt",          false },
    { "turret",                    true },
    { "ammo-turret",               true },
    { "electric-turret",           true },
    { "fluid-turret",              true },
    { "valve",                     false },
    { "car",                       true },
    { "artillery-wagon",           true },
    { "cargo-wagon",               false },
    { "infinity-cargo-wagon",      false },
    { "fluid-wagon",               false },
    { "locomotive",                true },
    { "spider-vehicle",            true },
    { "wall",                      false },
    { "fish",                      false },
    { "tree",                      false },
}

local damage_types = {
    "physical",
    "acid",
    "explosion",
    "fire",
    "electric",
    "impact",
    "laser",
    "poison"
}

if mods['bobenemies'] then
    table.insert(damage_types, "bob-plasma")
    table.insert(damage_types, "bob-pierce")
end

if mods['space-age'] then -- add capability with space age shit
    table.insert(building_types, { "space-platform-hub", false })
    table.insert(building_types, { "thruster", false })
    table.insert(building_types, { "rail-support", true })
    table.insert(building_types, { "elevated-straight-rail", false })
    table.insert(building_types, { "elevated-half-diagonal-rail", false })
    table.insert(building_types, { "elevated-curved-rail-b", false })
    table.insert(building_types, { "elevated-curved-rail-a", false })
    table.insert(building_types, { "cargo-pod", false })
    table.insert(building_types, { "cargo-landing-pad", false })
    table.insert(building_types, { "asteroid-collector", false })
    table.insert(building_types, { "agricultural-tower", false })
    table.insert(building_types, { "cargo-bay", false })
    table.insert(building_types, { "capture-robot", false })
    table.insert(building_types, { "plant", false })
end

local AddResistances = function(resistances)
    local truth_table = {
        physical = false,
        acid = false,
        explosion = false,
        fire = false,
        electric = false,
        impact = false,
        laser = false,
        poison = false
    }

    -- TODO: find a better way to introduce mod compatibility with the truth table
    if mods['bobenemies'] then
        truth_table["bob-plasma"] = false
        truth_table["bob-pierce"] = false
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
    -- do nothing if the resistance table doesn't exist
    if not resist_tbl then return end

    -- add the new resistance types
    resist_tbl = AddResistances(resist_tbl)

    -- loop through the resistances table
    for i, _ in pairs(resist_tbl) do
        if resist_tbl[i].decrease then
        else
            if is_combat_building then
                resist_tbl[i].decrease = 100
            else
                resist_tbl[i].decrease = 25
            end
        end

        resist_tbl[i].decrease = resist_tbl[i].decrease * setting_value
        prototype.resistances = resist_tbl
        data.raw[prot_name][entity_name] = prototype
    end
end

local ModifyResistances = function()
    for _, tbl in pairs(building_types) do
        local prototype_name = tbl[1]
        local is_combat_building = tbl[2]
        local setting_name = "ResistanceMultiplier"
        if is_combat_building then
            setting_name = "CombatResistanceMultiplier"
        end
        local setting_value = settings.startup[setting_name].value

        for k, _ in pairs(data.raw[prototype_name]) do
            data.raw[prototype_name][k].hide_resistances = false

            UpdateResistanceTable(prototype_name, k, setting_value, is_combat_building)
        end
    end
end

ModifyResistances()
