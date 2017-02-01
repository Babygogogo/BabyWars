
local WarFieldManager = {}

local WAR_FIELD_PATH = "res.data.templateWarField."

local string, pairs, ipairs, require = string, pairs, ipairs, require

local s_IsInitialized          = false
local s_WarFieldList
local s_WarFieldListDeprecated = {}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createWarFieldList()
    local list = {}
    for _, warFieldFileName in ipairs(require(WAR_FIELD_PATH .. "WarFieldList")) do
        list[warFieldFileName] = require(WAR_FIELD_PATH .. warFieldFileName)
    end

    for warFieldFileName, warFieldData in pairs(list) do
        if (string.find(warFieldFileName, "Random", 1, true) == 1) then
            local candidateList = warFieldData.list
            assert(#candidateList > 0, "WarFieldManager-createWarFieldList() the candidateList of the random map is invalid: " .. warFieldFileName)

            for _, candidateFileName in ipairs(candidateList) do
                assert(list[candidateFileName], "WarFieldManager-createWarFieldList() a candidate war field is not found: " .. candidateFileName)
            end
        end
    end

    return list
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function WarFieldManager.init()
    if (not s_IsInitialized) then
        s_IsInitialized = true

        s_WarFieldList = createWarFieldList()
    end

    return WarFieldManager
end

function WarFieldManager.getWarFieldData(warFieldFileName)
    assert(s_IsInitialized, "WarFieldManager.getWarFieldData() the manager has not been initialized yet.")
    if (s_WarFieldList[warFieldFileName]) then
        return s_WarFieldList[warFieldFileName]
    else
        if (not s_WarFieldListDeprecated[warFieldFileName]) then
            s_WarFieldListDeprecated[warFieldFileName] = require(WAR_FIELD_PATH .. warFieldFileName)
        end
        return s_WarFieldListDeprecated[warFieldFileName]
    end
end

function WarFieldManager.getWarFieldName(warFieldFileName)
    return s_WarFieldList[warFieldFileName].warFieldName
end

return WarFieldManager
