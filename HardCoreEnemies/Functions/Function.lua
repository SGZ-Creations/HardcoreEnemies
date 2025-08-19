require ("Functions.Shorthands")
--data.raw["unit"].attack_parameters.make_unit_melee_ammo_type(100)

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
        if string.match(k, "-biter") == true then
            data.raw.unit[k].attack_parameters.ammo_type = make_unit_melee_ammo_type(damage_value)
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