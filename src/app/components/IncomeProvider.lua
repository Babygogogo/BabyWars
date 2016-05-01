
local IncomeProvider = class("IncomeProvider")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")

local EXPORTED_METHODS = {
    "getIncomeAmount",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function IncomeProvider:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function IncomeProvider:loadTemplate(template)
    assert(template.amount, "IncomeProvider:loadTemplate() the param template.amount is invalid.")
    self.m_Template = template

    return self
end

function IncomeProvider:loadInstantialData(data)
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
function IncomeProvider:getIncomeAmount(playerIndex)
    if ((not playerIndex) or (self.m_Target:getPlayerIndex() == playerIndex)) then
        return self.m_Template.amount
    else
        return nil
    end
end

return IncomeProvider
