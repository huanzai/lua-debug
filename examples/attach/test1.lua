
local function _do()
    local a = 1
    local b = 2

    local c = a+b
    c = 9
    return c + 10
end

local function _no()
    local a = 1
    local b = 2 
    return a+b
end

return _do
