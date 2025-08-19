local make_unit_melee_ammo_type = function(damage_value)
data.raw.unit["small-biter"].attack_parameters =  {
	type = "projectile",
	range = 0.5,
	cooldown = 35,
	cooldown_deviation = 0.15,
	ammo_category = "melee",
	ammo_type = make_unit_melee_ammo_type(100),
	sound = sounds.biter_roars(0.35),
	animation = biterattackanimation(small_biter_scale, small_biter_tint1, small_biter_tint2),
	range_mode = "bounding-box-to-bounding-box"
    }
--https://github.com/wube/factorio-data/blob/master/base/prototypes/entity/enemies.lua