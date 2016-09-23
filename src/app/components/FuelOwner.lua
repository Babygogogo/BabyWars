
--[[--------------------------------------------------------------------------------
-- FuelOwner是ModelUnit可用的组件。只有绑定了本组件，ModelUnit才具有燃料属性。
-- 主要职责：
--   维护相关数值并提供必要接口给外界访问
-- 使用场景举例：
--   宿主初始化时，根据自身属性来绑定和初始化本组件（所有ModelUnit都需要绑定，但具体由GameConstant决定）
--   收到“回合阶段-消耗燃料”的消息时，计算燃料消耗量，并在必要时（如bomber耗尽燃料）发送消息以摧毁宿主ModelUnit
-- 其他：
--   当前燃料量会影响单位的可移动距离，具体计算目前由ModelActionPlanner进行
--]]--------------------------------------------------------------------------------

local FuelOwner = require("src.global.functions.class")("FuelOwner")

FuelOwner.EXPORTED_METHODS = {
    "getCurrentFuel",
    "getMaxFuel",
    "getFuelConsumptionPerTurn",
    "getDescriptionOnOutOfFuel",
    "shouldDestroyOnOutOfFuel",
    "isFuelInShort",

    "setCurrentFuel",
}

--------------------------------------------------------------------------------
-- The param validators.
--------------------------------------------------------------------------------
local function isFuelAmount(param)
    return (param >= 0) and (math.ceil(param) == param)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function FuelOwner:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function FuelOwner:loadTemplate(template)
    assert(isFuelAmount(template.max),     "FuelOwner:loadTemplate() the template.max is expected to be a non-negative integer.")
    assert(isFuelAmount(template.current), "FuelOwner:loadTemplate() the template.current is expected to be a non-negative integer.")

    self.m_Template = template

    return self
end

function FuelOwner:loadInstantialData(data)
    assert(isFuelAmount(data.current), "FuelOwner:loadInstantialData() the data.current is expected to be a non-negative integer.")

    self.m_CurrentFuel = data.current

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function FuelOwner:toSerializableTable()
    local currentFuel = self:getCurrentFuel()
    if (currentFuel == self:getMaxFuel()) then
        return nil
    else
        return {
            current = currentFuel,
        }
    end
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function FuelOwner:getCurrentFuel()
    return self.m_CurrentFuel
end

function FuelOwner:getMaxFuel()
    return self.m_Template.max
end

function FuelOwner:getFuelConsumptionPerTurn()
    return self.m_Template.consumptionPerTurn
end

function FuelOwner:getDescriptionOnOutOfFuel()
    return self.m_Template.descriptionOnOutOfFuel
end

function FuelOwner:shouldDestroyOnOutOfFuel()
    return self.m_Template.destroyOnOutOfFuel
end

function FuelOwner:isFuelInShort()
    return (self:getCurrentFuel() / self:getMaxFuel()) <= 0.4
end

function FuelOwner:setCurrentFuel(fuelAmount)
    assert(isFuelAmount(fuelAmount), "FuelOwner:setCurrentFuel() the param fuelAmount is expected to be a non-negative integer.")
    self.m_CurrentFuel = fuelAmount

    return self.m_Owner
end

return FuelOwner
