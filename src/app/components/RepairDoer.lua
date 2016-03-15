
local RepairDoer = class("RepairDoer")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")

local EXPORTED_METHODS = {
    "getRepairTargetCatagory",
    "getRepairAmount",
}

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

function RepairDoer:bind(target)
	ComponentManager.setMethods(target, self, EXPORTED_METHODS)

	self.m_Target = target
end

function RepairDoer:unbind(target)
    assert(self.m_Target == target , "RepairDoer:unbind() the component is not bind to the parameter target")
    assert(self.m_Target, "RepairDoer:unbind() the component is not bind to any target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil
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
