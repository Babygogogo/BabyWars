
local UnitSupplier = require("src.global.functions.class")("UnitSupplier")

local ComponentManager   = require("src.global.components.ComponentManager")
local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")

local EXPORTED_METHODS = {
    "canSupplyModelUnit",
}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function dispatchEvtSupplyViewUnit(self, gridIndex)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name      = "EvtSupplyViewUnit",
        gridIndex = gridIndex,
    })
end

local function canSupplyFuel(modelUnit)
    return (modelUnit.getCurrentFuel)                         and
        (modelUnit:getCurrentFuel() < modelUnit:getMaxFuel())
end

local function canSupplyAmmo(modelUnit)
    return (modelUnit.hasPrimaryWeapon)                                                 and
        (modelUnit:hasPrimaryWeapon())                                                  and
        (modelUnit:getPrimaryWeaponCurrentAmmo() < modelUnit:getPrimaryWeaponMaxAmmo())
end

local function supplyModelUnit(modelUnit)
    if (canSupplyFuel(modelUnit)) then
        modelUnit:setCurrentFuel(modelUnit:getMaxFuel())
    end
    if (canSupplyAmmo(modelUnit)) then
        modelUnit:setPrimaryWeaponCurrentAmmo(modelUnit:getPrimaryWeaponMaxAmmo())
    end
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseSupplyUnit(self, event)
    local modelUnitMap = event.modelUnitMap
    local supplier     = self.m_Owner
    if ((supplier:getPlayerIndex() == event.playerIndex)                       and
        (not modelUnitMap:getLoadedModelUnitWithUnitId(supplier:getUnitId()))) then
        for _, gridIndex in pairs(GridIndexFunctions.getAdjacentGrids(supplier:getGridIndex(), modelUnitMap:getMapSize())) do
            local target = modelUnitMap:getModelUnit(gridIndex)
            if ((target) and (self:canSupplyModelUnit(target))) then
                supplyModelUnit(target)
                dispatchEvtSupplyViewUnit(self, gridIndex)
            end
        end
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function UnitSupplier:ctor(param)
    return self
end

function UnitSupplier:loadTemplate(template)
    return self
end

function UnitSupplier:loadInstantialData(data)
    return self
end

function UnitSupplier:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "UnitSupplier:setRootScriptEventDispatcher() the dispatcher has been set.")

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtTurnPhaseSupplyUnit", self)

    return self
end

function UnitSupplier:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "UnitSupplier:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseSupplyUnit", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function UnitSupplier:onBind(target)
    assert(self.m_Owner == nil, "UnitSupplier:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Owner = target

    return self
end

function UnitSupplier:onUnbind()
    assert(self.m_Owner ~= nil, "UnitSupplier:onUnbind() the component has not bound to a target.")

    ComponentManager.unsetMethods(self.m_Owner, EXPORTED_METHODS)
    self.m_Owner = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function UnitSupplier:onEvent(event)
    if (event.name == "EvtTurnPhaseSupplyUnit") then
        onEvtTurnPhaseSupplyUnit(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The functions for doing actions.
--------------------------------------------------------------------------------
function UnitSupplier:doActionSupplyModelUnit(action, targetModelUnits)
    for _, modelUnit in pairs(targetModelUnits) do
        supplyModelUnit(modelUnit)
    end

    return self.m_Owner
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function UnitSupplier:canSupplyModelUnit(modelUnit)
    return (self.m_Owner:getPlayerIndex() == modelUnit:getPlayerIndex()) and
        ((canSupplyFuel(modelUnit)) or (canSupplyAmmo(modelUnit)))
end

return UnitSupplier
