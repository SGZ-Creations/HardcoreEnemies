--By @MetroidManiax with Sgamez

---@class LuaSettings 
local SS = settings.startup

local lib = require("Functions.Lib")

local to_adjust = {}
local total_recs = 0

local visited =  {}

local function damage_update(current_path, key, value)
    if SS["AdvancedDebug"].value then log(table.concat(current_path, ".")) end
    if #current_path >= 2 and current_path[#current_path - 1] == "damage" and key == "amount" then
		if SS["Debug"].value then log(table.concat(current_path, ".")) end
		if SS["Debug"].value then log("updating damage to " .. (value * SS["DamageMultiplier"].value)) end
        return value * SS["DamageMultiplier"].value
    end
    if #current_path >= 2 and (current_path[#current_path - 1] == "action_delivery" or type(current_path[#current_path - 1]) == "number") and (key == "projectile" or key == "stream") then
		if SS["Debug"].value then log(table.concat(current_path, ".")) end
        to_adjust[value] = true
    end
    return value
end

local function rec_damage_update()
    total_recs = total_recs + 1
    if total_recs > 10 then
        if SS["AdvancedDebug"].value then log("recursion limit exceeded") end
        return
    end
    if next(to_adjust) then
        for prot_name, _ in pairs(to_adjust) do
            to_adjust[prot_name] = nil
            local prot = data.raw["projectile"][prot_name] or data.raw["stream"][prot_name]
            if prot and not visited[prot_name] then
				visited[prot_name] = true
				if SS["SearchingDebug"].value then log("searching " .. prot_name) end
				if SS["VisitedDebug"].value then log("visited " .. tostring(visited[prot_name])) end
                lib.apply_to_table_with_path(prot, damage_update)
            end
        end
        rec_damage_update()
    end
end

for _, prototypes in pairs({data.raw["unit"], data.raw["spider-unit"], data.raw["turret"]}) do
	for k, p in pairs(prototypes) do
		if string.sub(k, -6) == "-biter" or string.sub(k, -8) == "-spitter"  or string.sub(k, -9) == "-pentapod" or string.sub(k, -10) == "-premature" or string.sub(k, -7) == "-turret" then
			if SS["Debug"].value then log("searching " .. k) end
			lib.apply_to_table_with_path(p, damage_update)
		end
	end
end

rec_damage_update()