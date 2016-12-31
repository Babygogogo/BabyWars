
local ActionCodeFunctions = {}

local TableFunctions = require("src.app.utilities.TableFunctions")

local s_ActionCodes = {
    ActionDownloadReplayData           = 1,
    ActionGetJoinableWarConfigurations = 2,
    ActionGetOngoingWarList            = 3,
    ActionGetReplayConfigurations      = 4,
    ActionGetSkillConfiguration        = 5,
    ActionJoinWar                      = 6,
    ActionLogin                        = 7,
    ActionLogout                       = 8,
    ActionMessage                      = 9,
    ActionNetworkHeartbeat             = 10,
    ActionNewWar                       = 11,
    ActionRegister                     = 12,
    ActionReloadSceneWar               = 13,
    ActionRunSceneMain                 = 14,
    ActionRunSceneWar                  = 15,
    ActionSetSkillConfiguration        = 16,
    ActionSyncSceneWar                 = 17,

    ActionActivateSkillGroup           = 18,
    ActionAttack                       = 19,
    ActionBeginTurn                    = 20,
    ActionEndTurn                      = 21,
    ActionSurrender                    = 22,
    ActionWait                         = 23,
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
