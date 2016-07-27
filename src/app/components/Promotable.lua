
--[[--------------------------------------------------------------------------------
-- Promotable是ModelUnit可用的组件。只有绑定了本组件，宿主才具有“等级”的属性、以及可升级。
-- 主要职责：
--   维护相关数值（包括当前等级，以及等级所带来的攻防加成），并提供必要接口给外界访问
-- 使用场景举例：
--   宿主初始化时，根据属性来绑定和初始化本组件（大部分ModelUnit需要绑定，但具体由GameConstant决定）
--   单位进行攻击时，会用到本组件提供的攻防加成数值；本组件需根据情况让单位升级
-- 其他：
--   unit默认等级为0，每摧毁一个敌方unit则升一级，最高3级
--   不能进行攻击的单位无法升级，因此无需绑定本组件
--]]--------------------------------------------------------------------------------

local Promotable = require("src.global.functions.class")("Promotable")

local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")

local MAX_PROMOTION   = GameConstantFunctions.getMaxPromotion()
local PROMOTION_BONUS = GameConstantFunctions.getPromotionBonus()

Promotable.EXPORTED_METHODS = {
    "getCurrentPromotion",
    "getPromotionAttackBonus",
    "getPromotionDefenseBonus",

    "setCurrentPromotion",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function Promotable:ctor(param)
    self:loadInstantialData(param.instantialData)

    return self
end

function Promotable:loadTemplate(template)
    return self
end

function Promotable:loadInstantialData(data)
    self:setCurrentPromotion(data.current)

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function Promotable:toSerializableTable()
    local promotion = self:getCurrentPromotion()
    if (promotion == 0) then
        return nil
    else
        return {
            current = promotion,
        }
    end
end

--------------------------------------------------------------------------------
-- The functions for doing the actions.
--------------------------------------------------------------------------------
function Promotable:doActionPromoteModelUnit(action)
    local currentPromotion = self:getCurrentPromotion()
    if (currentPromotion < MAX_PROMOTION) then
        self:setCurrentPromotion(currentPromotion + 1)
    end

    return owner
end

function Promotable:doActionJoinModelUnit(action, modelPlayerManager, target)
    target:setCurrentPromotion(math.max(self:getCurrentPromotion(), target:getCurrentPromotion()))

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function Promotable:getCurrentPromotion()
    return self.m_CurrentPromotion
end

function Promotable:getPromotionAttackBonus()
    if (self.m_CurrentPromotion == 0) then
        return 0
    else
        return PROMOTION_BONUS[self.m_CurrentPromotion].attack
    end
end

function Promotable:getPromotionDefenseBonus()
    if (self.m_CurrentPromotion == 0) then
        return 0
    else
        return PROMOTION_BONUS[self.m_CurrentPromotion].defense
    end
end

function Promotable:setCurrentPromotion(promotion)
    assert((promotion >= 0) and (promotion <= MAX_PROMOTION), "Promotable:setCurrentPromotion() the param promotion is invalid." )
    self.m_CurrentPromotion = promotion

    return self.m_Owner
end

return Promotable
