
local FuelOwner = class("FuelOwner")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

local MOVE_TYPES       = require("res.data.GameConstant").moveTypes
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
-- The util functions.
--------------------------------------------------------------------------------
local function isShortage(self)
    return self:getCurrentFuel() / self:getMaxFuel() <= 1 / 3
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseConsumeUnitFuel(self, event)
    local modelUnit = self.m_Target
    if ((modelUnit:getPlayerIndex() == event.playerIndex) and (event.turnIndex > 1)) then
        self:setCurrentFuel(math.max(self:getCurrentFuel() - self:getFuelConsumptionPerTurn(), 0))
        modelUnit:updateView()
        self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtModelUnitUpdated", modelUnit = modelUnit})

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
    self:unsetRootScriptEventDispatcher()

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtTurnPhaseConsumeUnitFuel", self)

    return self
end

function FuelOwner:unsetRootScriptEventDispatcher()
    if (self.m_RootScriptEventDispatcher) then
        self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseConsumeUnitFuel", self)

        self.m_RootScriptEventDispatcher = nil
    end

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
function FuelOwner:doActionWait(action)
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
