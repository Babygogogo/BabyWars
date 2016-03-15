
local IncomeProvider = class("IncomeProvider")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")

local EXPORTED_METHODS = {
    "getIncomeAmount"
}

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

function IncomeProvider:bind(target)
	ComponentManager.setMethods(target, self, EXPORTED_METHODS)

	self.m_Target = target
end

function IncomeProvider:unbind(target)
    assert(self.m_Target == target , "IncomeProvider:unbind() the component is not bind to the parameter target")
    assert(self.m_Target, "IncomeProvider:unbind() the component is not bind to any target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil
end

--------------------------------------------------------------------------------
-- Exported methods.
--------------------------------------------------------------------------------
function IncomeProvider:getIncomeAmount()
    return self.m_IncomeAmount
end

return IncomeProvider
