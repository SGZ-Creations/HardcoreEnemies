--By @MetroidManiax

local lib = {}
require "util"
---Recursively applies a function to all non-table values in a table.
---@param root_table table
---@param func function Receives (current_path, key, value) as parameters
function lib.apply_to_table_with_path(root_table, func)
    lib._apply_to_table_with_path(root_table, func, {})
end

---Recursively applies a function to all non-table values in a table.
---@param root_table table
---@param func function Receives (current_path, key, value) as parameters
---@param current_path any[]
function lib._apply_to_table_with_path(root_table, func, current_path)
    for key, value in pairs(root_table) do
        local new_path = {}
        -- Copy current path and add new key
        for i = 1, #current_path do
            new_path[i] = current_path[i]
        end
        new_path[#new_path + 1] = key

        if type(value) == "table" then
            -- Recursively process nested tables
            lib._apply_to_table_with_path(value, func, new_path)
        else
            -- Apply function to non-table values with full path
            root_table[key] = func(new_path, key, value)
        end
    end
end

return lib