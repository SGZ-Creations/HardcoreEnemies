---@class LuaSettings
local SS = settings.startup



-- Simple line of code that outputs all damage types to the log file (name returns a string)
for name, _ in pairs(data.raw["damage-type"]) do
    if SS["DamageDebug"].value == true then log(name) end
end


-- Method to access all damage types
data.raw["damage-type"]