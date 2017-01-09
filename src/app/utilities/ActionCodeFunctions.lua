
local ActionCodeFunctions = {}

local TableFunctions = require("src.app.utilities.TableFunctions")

local s_ActionCodes = {
    ActionDownloadReplayData           = 1,
    ActionGetJoinableWarConfigurations = 2,
    ActionGetOngoingWarList            = 3,
    ActionGetPlayerProfile             = 4,
    ActionGetReplayConfigurations      = 5,
    ActionGetSkillConfiguration        = 6,
    ActionJoinWar                      = 7,
    ActionLogin                        = 8,
    ActionLogout                       = 9,
    ActionMessage                      = 10,
    ActionNetworkHeartbeat             = 11,
    ActionNewWar                       = 12,
    ActionRegister                     = 13,
    ActionReloadSceneWar               = 14,
    ActionRunSceneMain                 = 15,
    ActionRunSceneWar                  = 16,
    ActionSetSkillConfiguration        = 17,
    ActionSyncSceneWar                 = 18,

    ActionActivateSkillGroup           = 100,
    ActionAttack                       = 101,
    ActionBeginTurn                    = 102,
    ActionBuildModelTile               = 103,
    ActionCaptureModelTile             = 104,
    ActionDestroyOwnedModelUnit        = 105,
    ActionDive                         = 106,
    ActionDropModelUnit                = 107,
    ActionEndTurn                      = 108,
    ActionJoinModelUnit                = 109,
    ActionLaunchFlare                  = 110,
    ActionLaunchSilo                   = 111,
    ActionLoadModelUnit                = 112,
    ActionProduceModelUnitOnTile       = 113,
    ActionProduceModelUnitOnUnit       = 114,
    ActionSupplyModelUnit              = 115,
    ActionSurface                      = 116,
    ActionSurrender                    = 117,
    ActionWait                         = 118,
    ActionVoteForDraw                  = 119,
}
local s_ActionNames

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ActionCodeFunctions.getActionCode(actionName)
    local code = s_ActionCodes[actionName]
    assert(code, "ActionCodeFunctions.getActionCode() invalid actionName: " .. (actionName or ""))
    return code
end

function ActionCodeFunctions.getActionName(actionCode)
    if (not s_ActionNames) then
        s_ActionNames = {}
        for name, code in pairs(s_ActionCodes) do
            s_ActionNames[code] = name
        end
    end

    local name = s_ActionNames[actionCode]
    assert(name, "ActionCodeFunctions.getActionName() invalid actionCode: " .. (actionCode or ""))
    return name
end

function ActionCodeFunctions.getFullList()
    return TableFunctions.clone(s_ActionCodes)
end

return ActionCodeFunctions
