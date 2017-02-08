
local AuxiliaryFunctions = {}

local LocalizationFunctions = requireBW("src.app.utilities.LocalizationFunctions")

local math, string, table = math, string, table
local getLocalizedText    = LocalizationFunctions.getLocalizedText

local BYTE_A, BYTE_Z, BYTE_0                    = string.byte("az0", 1, 3)
local SECS_FOR_DAY, SECS_FOR_HOUR, SECS_FOR_MIN = 3600 * 24, 3600, 60

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

function AuxiliaryFunctions.formatTimeInterval(interval)
    interval = math.max(interval, 0)
    if (interval == 0) then
        return string.format("%d%s", interval, getLocalizedText(34, "Second"))
    end

    local days  = math.floor(interval / SECS_FOR_DAY)
    interval    =            interval % SECS_FOR_DAY
    local hours = math.floor(interval / SECS_FOR_HOUR)
    interval    =            interval % SECS_FOR_HOUR
    local mins  = math.floor(interval / SECS_FOR_MIN)
    interval    =            interval % SECS_FOR_MIN

    local strList = {}
    if (days     > 0) then strList[#strList + 1] = string.format("%d%s", days,     getLocalizedText(34, "Day"))    end
    if (hours    > 0) then strList[#strList + 1] = string.format("%d%s", hours,    getLocalizedText(34, "Hour"))   end
    if (mins     > 0) then strList[#strList + 1] = string.format("%d%s", mins,     getLocalizedText(34, "Minute")) end
    if (interval > 0) then strList[#strList + 1] = string.format("%d%s", interval, getLocalizedText(34, "Second")) end

    return table.concat(strList, " ")
end

function AuxiliaryFunctions.round(num)
    return math.floor(num + 0.5)
end

return AuxiliaryFunctions
