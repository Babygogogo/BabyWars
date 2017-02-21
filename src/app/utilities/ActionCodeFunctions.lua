
local ActionCodeFunctions = {}

local TableFunctions = requireBW("src.app.utilities.TableFunctions")

local s_ActionCodes = {
    ActionChat                         = 1,
    ActionDownloadReplayData           = 2,
    ActionExitWar                      = 3,
    ActionGetJoinableWarConfigurations = 4,
    ActionGetOngoingWarConfigurations  = 5,
    ActionGetPlayerProfile             = 6,
    ActionGetRankingList               = 7,
    ActionGetReplayConfigurations      = 8,
    ActionGetSkillConfiguration        = 9,
    ActionGetWaitingWarConfigurations  = 10,
    ActionJoinWar                      = 11,
    ActionLogin                        = 12,
    ActionLogout                       = 13,
    ActionMessage                      = 14,
    ActionNetworkHeartbeat             = 15,
    ActionNewWar                       = 16,
    ActionRegister                     = 17,
    ActionReloadSceneWar               = 18,
    ActionRunSceneMain                 = 19,
    ActionRunSceneWar                  = 20,
    ActionSetSkillConfiguration        = 21,
    ActionSyncSceneWar                 = 22,

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
