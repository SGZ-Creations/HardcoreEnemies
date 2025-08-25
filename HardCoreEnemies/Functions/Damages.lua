--require ("Functions.Shorthands")

--https://github.com/wube/factorio-data/blob/master/space-age/prototypes/entity/enemies.lua#L1025
--[[
local make_unit_melee_ammo_type = function(damage_value)
return
	{
		target_type = "entity",
		action = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					type = "damage",
					damage = { amount = damage_value * SS["DamageMultiplier"].value , type = "physical"}
				}
			}
		}
	}
end

local BitersDamage = function(damage_value)
    for k, _ in pairs(data.raw.unit) do
        if string.find(k, "-biter") then
            data.raw["unit"][k].attack_parameters = make_unit_melee_ammo_type(damage_value)
        end
    end
end


local spitter_behemoth_attack_parameters = function(damage)
	return
	{
		target_type = "entity",
		action = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					type = "damage",
					damage = { amount = damage * SS["DamageMultiplier"].value , type = "acid"}
				}
			}
		}
	}
end

local PentapodDamage = function(damage)
	for k, _ in pairs(data.raw["spider-unit"]) do
		if string.match(k, "-pentapod") == true then
			data.raw["spider-unit"][k].attack_parameters = spitter_behemoth_attack_parameters(damage)
		end
	end
end

return {BitersDamage = BitersDamage, PentapodDamage = PentapodDamage}

]]

local lib = require("Functions.Lib")


local to_adjust = {}
local total_recs = 0


local function damage_update(current_path, key, value)
    -- log(table.concat(current_path, "."))
    if #current_path >= 2 and current_path[#current_path - 1] == "damage" and key == "amount" then
        return value * SS["DamageMultiplier"].value
    end
    if #current_path >= 2 and current_path[#current_path - 1] == "action_delivery" and key == "projectile" then
        to_adjust[value] = true
    end
    return value
end

local function rec_damage_update()
    total_recs = total_recs + 1
    if total_recs > 10 then
        log("recursion limit exceeded")
        return
    end

    if next(to_adjust) then
        for proj, _ in pairs(to_adjust) do
            to_adjust[proj] = nil
            local prot = data.raw["projectile"][proj]
            if prot then
                lib.apply_to_table_with_path(prot, damage_update)
            end
        end

        rec_damage_update()
    end
end

rec_damage_update()