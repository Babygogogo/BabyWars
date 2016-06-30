
--[[--------------------------------------------------------------------------------
-- RepairDoer是ModelTile可用的组件。只有绑定了本组件，宿主才具有“维修”的属性。
-- 主要职责：
--   维护相关数值并提供必要接口给外界访问
-- 使用场景举例：
--   宿主初始化时，根据属性来绑定和初始化本组件（所有ModelUnit都需要绑定，但具体由GameConstant决定）
--   在维修单位的回合阶段，需要通过本组件获取必要信息（维修量，可维修类型等）
-- 其他：
--   - 目前，“维修”的实际操作是由ModelPlayerManager进行的，本组件提供各种相关getter
--   - 对单位的维修是有次序的。在金钱不够的情况下，优先维修最贵的单位，造价相同的情况下，优先维修首先出现的单位（由ModelUnit.m_UnitID记录）
--   - 维修除了回复hp，也会回复燃料和弹药（不用花钱）
--   - 如果unit的hp为71（此时游戏里显示的hp为8，原因见AttackTaker），那么维修时会补充到100（此时游戏里显示hp为10)。
--     如果unit的hp为70（此时游戏里显示的hp为7），那么维修时会补充到90（此时游戏里显示为9）
--   - 维修量受co技能、金钱影响
--]]--------------------------------------------------------------------------------

local RepairDoer = class("RepairDoer")

local TypeChecker           = require("app.utilities.TypeChecker")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")
local LocalizationFunctions = require("app.utilities.LocalizationFunctions")
local ComponentManager      = require("global.components.ComponentManager")

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
    return self.m_Template.targetCatagory[LocalizationFunctions.getLanguageCode()]
end

function RepairDoer:getRepairTargetList()
    return self.m_Template.targetList
end

function RepairDoer:canRepairTarget(target)
    local targetTiledID = target:getTiledID()
    if (GameConstantFunctions.getPlayerIndexWithTiledId(targetTiledID) ~= self.m_Target:getPlayerIndex()) then
        return false
    end

    local targetName = GameConstantFunctions.getUnitTypeWithTiledId(targetTiledID)
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
