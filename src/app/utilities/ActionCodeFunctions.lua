
local ActionCodeFunctions = {}

local TableFunctions = require("src.app.utilities.TableFunctions")

local s_ActionCodes = {
    ActionDownloadReplayData           = 1,
    ActionGetJoinableWarConfigurations = 2,
    ActionGetOngoingWarConfigurations  = 3,
    ActionGetPlayerProfile             = 4,
    ActionGetRankingList               = 5,
    ActionGetReplayConfigurations      = 6,
    ActionGetSkillConfiguration        = 7,
    ActionGetWaitingWarConfigurations  = 8,
    ActionJoinWar                      = 9,
    ActionLogin                        = 10,
    ActionLogout                       = 11,
    ActionMessage                      = 12,
    ActionNetworkHeartbeat             = 13,
    ActionNewWar                       = 14,
    ActionRegister                     = 15,
    ActionReloadSceneWar               = 16,
    ActionRunSceneMain                 = 17,
    ActionRunSceneWar                  = 18,
    ActionSetSkillConfiguration        = 19,
    ActionSyncSceneWar                 = 20,

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
    ActionVoteForDraw                  = 118,
    ActionWait                         = 119,
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
