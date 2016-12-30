
local ActionCodeFunctions = {}

local TableFunctions = require("src.app.utilities.TableFunctions")

local s_ActionCodes = {
    ActionGetJoinableWarConfigurations = 1,
    ActionGetOngoingWarList            = 2,
    ActionGetSkillConfiguration        = 3,
    ActionJoinWar                      = 4,
    ActionLogin                        = 5,
    ActionLogout                       = 6,
    ActionMessage                      = 7,
    ActionNetworkHeartbeat             = 8,
    ActionNewWar                       = 9,
    ActionRegister                     = 10,
    ActionReloadSceneWar               = 11,
    ActionRunSceneMain                 = 12,
    ActionRunSceneWar                  = 13,
    ActionSetSkillConfiguration        = 14,
    ActionSyncSceneWar                 = 15,

    ActionBeginTurn                    = 16,
    ActionEndTurn                      = 17,
    ActionSurrender                    = 18,
    ActionWait                         = 19,
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
