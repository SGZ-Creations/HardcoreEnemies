require ("Functions.Shorthands")

local make_unit_melee_ammo_type = function(damage_value)
return
	{
		target_type = "entity",
		action = {
			type = "direct",
			action_delivery ={
				type = "instant",
				target_effects = {
					type = "damage",
					damage = { amount = damage_value , type = "physical"}
				}
			}
		}
	}
end

local BitersDamage = function(damage_value)
    for k, v in pairs(data.raw.unit) do
        if string.find(k, "-biter") == true then
            v.attack_parameters.ammo_type = make_unit_melee_ammo_type(damage_value) * SS["DamageMultiplier"].value
        end
    end
end

return BitersDamage