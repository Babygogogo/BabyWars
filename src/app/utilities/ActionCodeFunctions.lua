
local ActionCodeFunctions = {}

local TableFunctions = require("src.app.utilities.TableFunctions")

local s_ActionCode = {
    NetworkHeartbeat = 1,
    Register         = 2,
    Login            = 3,
    Logout           = 4,
}

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ActionCodeFunctions.getActionCode(actionName)
    local code = s_ActionCode[actionName]
    assert(code, "ActionCodeFunctions.getActionCode() invalid actionName: " .. (actionName or nil))

    return code
end

function ActionCodeFunctions.getFullList()
    return TableFunctions.clone(s_ActionCode)
end

return ActionCodeFunctions
