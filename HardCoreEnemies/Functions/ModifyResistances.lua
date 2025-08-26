-- Rify: 20:33 8.18.2025
--[[
    The ResistanceMultiplier startup setting controls how much resistances are applied to buildings
]]

-- Rify, 22:14 8.18.2025
--[[
    items are stored as their type and if they're a combat building
    true for combat building, false for regular building

    example entry(s)
    {"regular-building", false},
    {"combat-building", true}
]]

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

local UpdateResistanceTable = function(prot_name, entity_name, setting_value)
    -- do nothing if the resistance table doesn't exist
    local resist_tbl = data.raw[prot_name][entity_name].resistances
    if not resist_tbl then return end

    -- loop through the resistances table
    for i, _ in pairs(resist_tbl) do
        -- check if .decrease exists for the resitance table, if it doesn't d̶o̶ n̶o̶t̶h̶i̶n̶g̶ Add value 25 or 100 to resistances. for combat 100 for regular 25 for all damage types See List In bottom of file
        if resist_tbl[i].decrease then
            local old_decrease = resist_tbl[i].decrease -- for logging, TODO: remove me

            -- begin stupid fucking formatter
            data.raw[prot_name][entity_name].resistances[i].decrease = resist_tbl[i].decrease * --Was told this does not work
                settings.startup["ResistanceMultiplier"]
                    .value -- modify the existing decrease value
            -- end stupid fucking formatter

            -- settings.startup["old_decrease"].value then log("\t\t\\Beginning Decrease: " .. tostring(old_decrease)) end                                       -- For debugging TODO: remove me
            -- settings.startup["decrease"].value then log("\t\t\\Ending Decrease: " .. tostring(data.raw[prot_name][entity_name].resistances[i].decrease)) end -- For debugging TODO: remove me

        end
    end
end

local ModifyResistances = function()
    for _, tbl in pairs(building_types) do

        if tbl[2] then -- combat building
            -- TODO: prototype later
        else
            --log(tbl[1])
            for k, _ in pairs(data.raw[tbl[1]]) do
                data.raw[tbl[1]][k].hide_resistances = false
                --log("\\BLOCK START") -- For debugging TODO: remove me
                --log("\t\\" .. k)     -- For debugging TODO: remove me
                UpdateResistanceTable(tbl[1], k)
                --log("\\END BLOCK")   -- For debugging TODO: remove me
            end

        end
    end
end

return ModifyResistances


--[[
the List
{
    "physical", 
    "acid",
    "explosion",
    type = "fire",
    type = "electric",
    type = "impact",
    type = "laser",
    type = "poison",

    if mods["bobenemies"] then
        type = "bob-plasma",
        type = "bob-pierce",
    end
]]