
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

local FuelOwner = class("FuelOwner")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

local EXPORTED_METHODS = {
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
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseConsumeUnitFuel(self, event)
    local modelUnit = self.m_Owner
    if ((modelUnit:getPlayerIndex() == event.playerIndex) and (event.turnIndex > 1)) then
        self:setCurrentFuel(math.max(self:getCurrentFuel() - self:getFuelConsumptionPerTurn(), 0))
        modelUnit:updateView()

        if ((self:getCurrentFuel() == 0) and (self:shouldDestroyOnOutOfFuel())) then
            local gridIndex = modelUnit:getGridIndex()
            local tile = event.modelTileMap:getModelTile(gridIndex)

            if ((not tile.getRepairAmount) or (not tile:getRepairAmount(modelUnit))) then
                self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtDestroyModelUnit", gridIndex = gridIndex})
                    :dispatchEvent({name = "EvtDestroyViewUnit", gridIndex = gridIndex})
            end
        end
    end
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

function FuelOwner:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "FuelOwner:setRootScriptEventDispatcher() the dispatcher has been set.")

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtTurnPhaseConsumeUnitFuel", self)

    return self
end

function FuelOwner:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "FuelOwner:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseConsumeUnitFuel", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function FuelOwner:toStringList(spaces)
    local currentFuel = self:getCurrentFuel()
    if (currentFuel ~= self:getMaxFuel()) then
        return {string.format("%sFuelOwner = {current = %d}", spaces or "", currentFuel)}
    else
        return nil
    end
end

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
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function FuelOwner:onBind(target)
    assert(self.m_Owner == nil, "FuelOwner:onBind() the FuelOwner has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Owner = target

    return self
end

function FuelOwner:onUnbind()
    assert(self.m_Owner, "FuelOwner:unbind() the component has not bound a target.")

    ComponentManager.unsetMethods(self.m_Owner, EXPORTED_METHODS)
    self.m_Owner = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function FuelOwner:onEvent(event)
    if (event.name == "EvtTurnPhaseConsumeUnitFuel") then
        onEvtTurnPhaseConsumeUnitFuel(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The functions for doing the actions.
--------------------------------------------------------------------------------
function FuelOwner:doActionMoveModelUnit(action)
    self:setCurrentFuel(self.m_CurrentFuel - action.path.fuelConsumption)

    return self
end

function FuelOwner:doActionAttack(action, isAttacker)
    if (isAttacker) then
        self:setCurrentFuel(self.m_CurrentFuel - action.path.fuelConsumption)
    end

    return self
end

function FuelOwner:doActionCapture(action)
    self:setCurrentFuel(self.m_CurrentFuel - action.path.fuelConsumption)

    return self
end

function FuelOwner:doActionLoadModelUnit(action, focusUnitID)
    if (self.m_Owner:getUnitId() == focusUnitID) then
        self:setCurrentFuel(self.m_CurrentFuel - action.path.fuelConsumption)
    end

    return self
end

function FuelOwner:doActionDropModelUnit(action)
    self:setCurrentFuel(self.m_CurrentFuel - action.path.fuelConsumption)

    return self
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
end

return FuelOwner
