
local IncomeProvider = class("IncomeProvider")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")

local EXPORTED_METHODS = {
    "getIncomeAmount"
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function IncomeProvider:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function IncomeProvider:load(param)
    self.m_IncomeAmount = param.amount
    return self
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function IncomeProvider:onBind(target)
    assert(self.m_Target == nil, "IncomeProvider:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Target = target

    return self
end

function IncomeProvider:onUnbind()
    assert(self.m_Target ~= nil, "IncomeProvider:onUnbind() the component has not bound to a target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function IncomeProvider:getIncomeAmount()
    return self.m_IncomeAmount
end

return IncomeProvider
