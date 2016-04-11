
local DefenseBonusProvider = class("DefenseBonusProvider")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")

local EXPORTED_METHODS = {
    "getDefenseBonusAmount",
    "getNormalizedDefenseBonusAmount",
    "getDefenseBonusTargetCatagory",
    "getDefenseBonusTargetList",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function DefenseBonusProvider:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function DefenseBonusProvider:loadTemplate(template)
    assert(template.amount,         "DefenseBonusProvider:loadTemplate() the param template.amount is invalid.")
    assert(template.targetCatagory, "DefenseBonusProvider:loadTemplate() the param template.targetCatagory is invalid.")
    assert(template.targetList,     "DefenseBonusProvider:loadTemplate() the param template.targetList is invalid.")

    self.m_Template = template

    return self
end

function DefenseBonusProvider:loadInstantialData(data)
    return self
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function DefenseBonusProvider:onBind(target)
    assert(self.m_Target == nil, "DefenseBonusProvider:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Target = target

    return self
end

function DefenseBonusProvider:onUnbind()
    assert(self.m_Target ~= nil, "DefenseBonusProvider:onUnbind() the component has not bound to a target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function DefenseBonusProvider:getDefenseBonusAmount()
    return self.m_Template.amount
end

function DefenseBonusProvider:getNormalizedDefenseBonusAmount()
    return math.floor(self:getDefenseBonusAmount() / 10)
end

function DefenseBonusProvider:getDefenseBonusTargetCatagory()
    return self.m_Template.targetCatagory
end

function DefenseBonusProvider:getDefenseBonusTargetList()
    return self.m_Template.targetList
end

return DefenseBonusProvider
