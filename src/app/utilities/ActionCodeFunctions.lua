
local ActionCodeFunctions = {}

local TableFunctions = requireBW("src.app.utilities.TableFunctions")

local s_ActionCodes = {
    ActionDownloadReplayData           = 1,
    ActionExitWar                      = 2,
    ActionGetJoinableWarConfigurations = 3,
    ActionGetOngoingWarConfigurations  = 4,
    ActionGetPlayerProfile             = 5,
    ActionGetRankingList               = 6,
    ActionGetReplayConfigurations      = 7,
    ActionGetSkillConfiguration        = 8,
    ActionGetWaitingWarConfigurations  = 9,
    ActionJoinWar                      = 10,
    ActionLogin                        = 11,
    ActionLogout                       = 12,
    ActionMessage                      = 13,
    ActionNetworkHeartbeat             = 14,
    ActionNewWar                       = 15,
    ActionRegister                     = 16,
    ActionReloadSceneWar               = 17,
    ActionRunSceneMain                 = 18,
    ActionRunSceneWar                  = 19,
    ActionSetSkillConfiguration        = 20,
    ActionSyncSceneWar                 = 21,

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
