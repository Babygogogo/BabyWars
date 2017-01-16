
local AuxiliaryFunctions = {}

local math, string, table = math, string, table

local BYTE_A, BYTE_Z, BYTE_0 = string.byte("az0", 1, 3)

function AuxiliaryFunctions.getWarIdWithWarName(warName)
    local bytes      = {string.byte(warName, 1, 6)}
    local warID      = 0
    local multiplier = 1
    for i = 6, 1, -1 do
        local b    = bytes[i]
        warID      = warID + multiplier * (((b >= BYTE_A) and (b <= BYTE_Z)) and (b - BYTE_A + 10) or (b - BYTE_0))
        multiplier = multiplier * 36
    end
    return warID
end

function AuxiliaryFunctions.getWarNameWithWarId(warID)
    local charList = {}
    for i = 6, 1, -1 do
        local mod   = warID % 36
        charList[i] = (mod < 10) and ("" .. mod) or (string.char(BYTE_A + mod - 10))
        warID       = math.floor(warID / 36)
    end

    return table.concat(charList)
end

function AuxiliaryFunctions.round(num)
    return math.floor(num + 0.5)
end

return AuxiliaryFunctions
