local biters_damage = function(damage_value)
    for k, v in pairs(data.raw.unit) do
        if string.find(k, "-biter") == true then
            -- ....
        end
    end
end

local change_damage = function(damage, key, type)
    for k,_ in pairs(data.raw[key]) do
        if string.find(k, "") == true then
            data.raw[key].attack_parameters.ammo_type = apply_modifier(damage, type)
        end
    end
end

return biters_damage
