--local sounds = require ("prototypes.entity.sounds")
local SS = settings.startup
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

--data.raw.unit["small-biter"].attack_parameters.ammo_type = make_unit_melee_ammo_type() * SS[""]

local BitersDamage = require("")
function (damage_value )
	
end
-- local Spitter 


-- for k, v in pairs(data.raw.unit) do
--     if string.find(k, "-biter") == true then
--         v.attack_parameters.ammo_type = make_unit_melee_ammo_type(damage_value) * SS[""].value
--     end
-- end