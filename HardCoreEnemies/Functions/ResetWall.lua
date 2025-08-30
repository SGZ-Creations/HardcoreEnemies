local UpdateResistanceTable = require("Functions.ModifyResistances")

if mods['RampantArsenalFork'] then
    -- reset the resistances for walls
    data.raw.wall["stone-wall"].resistances = {
        {
            type = "physical",
            decrease = 3,
            percent = 20
        },
        {
            type = "impact",
            decrease = 45,
            percent = 60
        },
        {
            type = "explosion",
            decrease = 10,
            percent = 30
        },
        {
            type = "fire",
            percent = 100
        },
        {
            type = "acid",
            percent = 80
        },
        {
            type = "laser",
            percent = 70
        }
    }

    UpdateResistanceTable("wall", "stone-wall", settings.startup["CombatResistanceMultiplier"].value, true)
end
