
local WarFieldManager = {}

local WAR_FIELD_PATH = "res.data.templateWarField."

local string, pairs, ipairs, require = string, pairs, ipairs, require

local s_IsInitialized          = false
local s_WarFieldFileNameList
local s_WarFieldList
local s_WarFieldListDeprecated = {}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function loadWarFieldFileNameList()
    return requireBW(WAR_FIELD_PATH .. "WarFieldList")
end

local function createWarFieldList(warFieldFileNameList)
    local list = {}
    for _, warFieldFileName in ipairs(warFieldFileNameList) do
        list[warFieldFileName] = requireBW(WAR_FIELD_PATH .. warFieldFileName)
    end

    for warFieldFileName, warFieldData in pairs(list) do
        if (WarFieldManager.isRandomWarField(warFieldFileName)) then
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

        s_WarFieldFileNameList = loadWarFieldFileNameList()
        s_WarFieldList         = createWarFieldList(s_WarFieldFileNameList)
    end

    return WarFieldManager
end

function WarFieldManager.isRandomWarField(warFieldFileName)
    return (string.find(warFieldFileName, "Random", 1, true) == 1)
end

function WarFieldManager.getWarFieldData(warFieldFileName)
    assert(s_IsInitialized, "WarFieldManager.getWarFieldData() the manager has not been initialized yet.")
    if (s_WarFieldList[warFieldFileName]) then
        return s_WarFieldList[warFieldFileName]
    else
        if (not s_WarFieldListDeprecated[warFieldFileName]) then
            s_WarFieldListDeprecated[warFieldFileName] = requireBW(WAR_FIELD_PATH .. warFieldFileName)
        end
        return s_WarFieldListDeprecated[warFieldFileName]
    end
end

function WarFieldManager.getWarFieldFileNameList()
    assert(s_IsInitialized, "WarFieldManager.getWarFieldFileNameList() the manager has not been initialized yet.")
    return s_WarFieldFileNameList
end

function WarFieldManager.getWarFieldName(warFieldFileName)
    return WarFieldManager.getWarFieldData(warFieldFileName).warFieldName
end

function WarFieldManager.getWarFieldAuthorName(warFieldFileName)
    return WarFieldManager.getWarFieldData(warFieldFileName).authorName
end

function WarFieldManager.getPlayersCount(warFieldFileName)
    return WarFieldManager.getWarFieldData(warFieldFileName).playersCount
end

function WarFieldManager.getMapSize(warFieldFileName)
    local data = WarFieldManager.getWarFieldData(warFieldFileName)
    return {width = data.width, height = data.height}
end

return WarFieldManager
