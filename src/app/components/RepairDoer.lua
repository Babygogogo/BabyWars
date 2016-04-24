
local RepairDoer = class("RepairDoer")

local TypeChecker           = require("app.utilities.TypeChecker")
local ComponentManager      = require("global.components.ComponentManager")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")

local EXPORTED_METHODS = {
    "getRepairTargetCatagory",
    "getRepairTargetList",
    "canRepairTarget",
    "getRepairAmountAndCost",
    "getNormalizedRepairAmount",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function RepairDoer:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function RepairDoer:loadTemplate(template)
    assert(template.targetCatagory, "RepairDoer:loadTemplate() the param template.targetCatagory is invalid.")
    assert(template.targetList,     "RepairDoer:loadTemplate() the param template.targetList is invalid.")
    assert(template.amount,         "RepairDoer:loadTemplate() the param template.amount is invalid.")

    self.m_Template = template

    return self
end

function RepairDoer:loadInstantialData(data)
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

function RepairDoer:getRepairTargetList()
    return self.m_Template.targetList
end

function RepairDoer:canRepairTarget(target)
    local targetTiledID = target:getTiledID()
    if (GameConstantFunctions.getPlayerIndexWithTiledId(targetTiledID) ~= self.m_Target:getPlayerIndex()) then
        return false
    end

    local targetName = GameConstantFunctions.getUnitNameWithTiledId(targetTiledID)
    for _, name in ipairs(self:getRepairTargetList()) do
        if (targetName == name) then
            return true
        end
    end

    return false
end

function RepairDoer:getRepairAmountAndCost(target, modelPlayer)
    local normalizedCurrentHP    = target:getNormalizedCurrentHP()
    local productionCost         = target:getProductionCost()
    local normalizedRepairAmount = math.min(
        10 - normalizedCurrentHP,
        self:getNormalizedRepairAmount(modelPlayer),
        math.floor(modelPlayer:getFund() * 10 / productionCost)
    )

    return (normalizedRepairAmount + normalizedCurrentHP) * 10 - target:getCurrentHP(), normalizedRepairAmount * productionCost / 10
end

function RepairDoer:getNormalizedRepairAmount(modelPlayer)
    if (not modelPlayer) then
        return self.m_Template.amount
    else
        -- TODO: take the abilities of the player into account.
        return self.m_Template.amount
    end
end

return RepairDoer
