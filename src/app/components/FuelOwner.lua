
local FuelOwner = class("FuelOwner")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

local MOVE_TYPES       = require("res.data.GameConstant").moveTypes
local EXPORTED_METHODS = {
    "getCurrentFuel",
    "setCurrentFuel",
    "getMaxFuel",
    "getFuelConsumptionPerTurn",
    "getDescriptionOnOutOfFuel",
    "shouldDestroyOnOutOfFuel",
}

--------------------------------------------------------------------------------
-- The param validators.
--------------------------------------------------------------------------------
local function isFuelAmount(param)
    return (param >= 0) and (math.ceil(param) == param)
end

local function isShortage(self)
    return self:getCurrentFuel() / self:getMaxFuel() <= 1 / 3
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
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

function FuelOwner:unsetRootScriptEventDispatcher()
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function FuelOwner:onBind(target)
    assert(self.m_Target == nil, "FuelOwner:onBind() the FuelOwner has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Target = target

    return self
end

function FuelOwner:onUnbind()
    assert(self.m_Target, "FuelOwner:unbind() the component has not bound a target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil

    return self
end

--------------------------------------------------------------------------------
-- The functions for doing the actions.
--------------------------------------------------------------------------------
function FuelOwner:doActionWait(action)
    self:setCurrentFuel(self.m_CurrentFuel - action.path.fuelConsumption)

    return self
end

function FuelOwner:doActionAttack(action)
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

function FuelOwner:setCurrentFuel(fuelAmount)
    assert(isFuelAmount(fuelAmount), "FuelOwner:setCurrentFuel() the param fuelAmount is expected to be a non-negative integer.")
    self.m_CurrentFuel = fuelAmount
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name       = "EvtCurrentFuelUpdated",
        amount     = fuelAmount,
        gridIndex  = self.m_Target:getGridIndex(),
        isShortage = isShortage(self)
    })

    return self
end

return FuelOwner
