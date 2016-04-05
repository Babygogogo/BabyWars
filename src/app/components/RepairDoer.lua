
local RepairDoer = class("RepairDoer")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")

local EXPORTED_METHODS = {
    "getRepairTargetCatagory",
    "getRepairAmount",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function RepairDoer:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function RepairDoer:load(param)
    self.m_Template = param

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function RepairDoer:onBind(target)
    assert(self.m_Target == nil, "RepairDoer:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Target = target

    return self
end

function RepairDoer:onUnbind()
    assert(self.m_Target, "RepairDoer:onUnbind() the component has not bound a target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil

    return self
end

--------------------------------------------------------------------------------
-- Exported methods.
--------------------------------------------------------------------------------
function RepairDoer:getRepairTargetCatagory()
    return self.m_Template.targetCatagory
end

function RepairDoer:getRepairAmount()
    return self.m_Template.amount
end

return RepairDoer
