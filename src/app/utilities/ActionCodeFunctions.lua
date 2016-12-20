
local ActionCodeFunctions = {}

local TableFunctions = require("src.app.utilities.TableFunctions")

local s_ActionCodes = {
    NetworkHeartbeat      = 1,
    Register              = 2,
    Login                 = 3,
    Logout                = 4,
    Message               = 5,
    GetSkillConfiguration = 6,
    SetSkillConfiguration = 7,
    NewWar                = 8,
}
local s_ActionNames

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ActionCodeFunctions.getActionCode(actionName)
    local code = s_ActionCodes[actionName]
    assert(code, "ActionCodeFunctions.getActionCode() invalid actionName: " .. (actionName or nil))

    return code
end

function ActionCodeFunctions.getActionName(actionCode)
    if (not s_ActionNames) then
        s_ActionNames = {}
        for name, code in pairs(s_ActionCodes) do
            s_ActionNames[code] = name
        end
    end

    return s_ActionNames[actionCode]
end

function ActionCodeFunctions.getFullList()
    return TableFunctions.clone(s_ActionCodes)
end

return ActionCodeFunctions
