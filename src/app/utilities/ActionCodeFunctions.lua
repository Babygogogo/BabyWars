
local ActionCodeFunctions = {}

local TableFunctions = require("src.app.utilities.TableFunctions")

local s_ActionCodes = {
    ActionGetJoinableWarConfigurations = 1,
    ActionGetOngoingWarList            = 2,
    ActionGetReplayConfigurations      = 3,
    ActionGetSkillConfiguration        = 4,
    ActionJoinWar                      = 5,
    ActionLogin                        = 6,
    ActionLogout                       = 7,
    ActionMessage                      = 8,
    ActionNetworkHeartbeat             = 9,
    ActionNewWar                       = 10,
    ActionRegister                     = 11,
    ActionReloadSceneWar               = 12,
    ActionRunSceneMain                 = 13,
    ActionRunSceneWar                  = 14,
    ActionSetSkillConfiguration        = 15,
    ActionSyncSceneWar                 = 16,

    ActionBeginTurn                    = 17,
    ActionEndTurn                      = 18,
    ActionSurrender                    = 19,
    ActionWait                         = 20,
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
