
local MoveDoer = class("MoveDoer")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

local MOVE_TYPES       = require("res.data.GameConstant").moveTypes
local EXPORTED_METHODS = {
    "getMoveRange",
    "getMoveType",
}

MoveDoer.DEPENDS = {}

--------------------------------------------------------------------------------
-- The param validators.
--------------------------------------------------------------------------------
local function isMoveRange(param)
    return (param > 0) and (math.ceil(param) == param)
end

local function isMoveType(param)
    for _, validType in ipairs(MOVE_TYPES) do
        if (validType == param) then
            return true
        end
    end

    return false
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function MoveDoer:ctor(param)
    assert(isMoveRange(param.range), "MoveDoer:ctor() the param.range is expected to be an integer.")
    assert(isMoveType(param.type), "MoveDoer:ctor() the param.type is invalid.")
    self.m_Template = param

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function MoveDoer:onBind(target)
    assert(self.m_Target == nil, "MoveDoer:onBind() the MoveDoer has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Target = target

    return self
end

function MoveDoer:onUnbind()
    assert(self.m_Target, "MoveDoer:unbind() the component has not bound a target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function MoveDoer:getMoveRange()
    return self.m_Template.range
end

function MoveDoer:getMoveType()
    return self.m_Template.type
end

return MoveDoer
