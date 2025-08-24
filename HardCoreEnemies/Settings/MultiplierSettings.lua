-- Rify: 20:33 8.18.2025

--[[
    The DamageMultiplier startup setting controls how much damage the biter's will do
    The ResistanceMultiplier startup setting controls how much resistances are applied to buildings
    The CombatResistanceMultiplier startup setting controls how much resistances combat buildings get as opposed to regular buildings
]] --

data.extend({
    {
        type = "double-setting",
        setting_type = "startup",
        name = "DamageMultiplier",
        default_value = 5.0,
        minimum_value = 1.0
    },
    {
        type = "double-setting",
        setting_type = "startup",
        name = "ResistanceMultiplier",
        default_value = 5.0,
        minimum_value = 1.0
    },
    {
        type = "double-setting",
        setting_type = "startup",
        name = "CombatResistanceMultiplier",
        default_value = 2.5,
        minimum_value = 1.0,
    }
})
