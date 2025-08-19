-- Rify: 20:33 8.18.2025

--[[
    The DamageMultiplier startup setting controls how much damage the biter's will do
    The ResistanceMultiplier startup setting controls how much resistances are applied to buildings
]] --

data.extend({
    {
        type = "double-setting",
        setting_type = "startup",
        name = "DamageMultiplierSetting",
        default_value = 1.5,
        minimum_value = 1.0
    },
    {
        type = "double-setting",
        setting_type = "startup",
        name = "ResistanceMultiplierSetting",
        default_value = 1.0,
        minimum_value = 1.0
    }
})
