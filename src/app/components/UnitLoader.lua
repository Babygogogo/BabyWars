
local UnitLoader = require("src.global.functions.class")("UnitLoader")

local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")
local ComponentManager      = require("src.global.components.ComponentManager")

local EXPORTED_METHODS = {
    "getMaxLoadCount",
    "getCurrentLoadCount",
    "getLoadUnitIdList",
    "hasLoadUnitId",
    "canLoadModelUnit",
    "canDropModelUnit",
    "canLaunchModelUnit",
    "canSupplyLoadedModelUnit",

    "addLoadUnitId",
}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getRemainingUnitIdsOnDrop(currentList, dropDestinations)
    local remainingUnitIds = {}
    for _, unitID in ipairs(currentList) do
        local isUnitIdRemaining = true
        for _, dropDestination in pairs(dropDestinations) do
            if (unitID == dropDestination.unitID) then
                isUnitIdRemaining = false
                break
            end
        end

        if (isUnitIdRemaining) then
            remainingUnitIds[#remainingUnitIds + 1] = unitID
        end
    end

    return remainingUnitIds
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseSupplyUnit(self, event)
    local modelUnitMap = event.modelUnitMap
    if ((self.m_Owner:getPlayerIndex() == event.playerIndex) and
        (self:canSupplyLoadedModelUnit()))                   then
        for _, unitID in pairs(self:getLoadUnitIdList()) do
            local modelUnit = modelUnitMap:getLoadedModelUnitWithUnitId(unitID)
            assert(modelUnit, "UnitLoader-onEvtTurnPhaseSupplyUnit() a unit is loaded in the loader, while is not loaded in ModelUnitMap.")

            modelUnit:setCurrentFuel(modelUnit:getMaxFuel())
            if ((modelUnit.hasPrimaryWeapon) and (modelUnit:hasPrimaryWeapon())) then
                modelUnit:setPrimaryWeaponCurrentAmmo(modelUnit:getPrimaryWeaponMaxAmmo())
            end
        end
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function UnitLoader:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    self.m_LoadedUnitIds = self.m_LoadedUnitIds or {}

    return self
end

function UnitLoader:loadTemplate(template)
    self.m_Template = template

    return self
end

function UnitLoader:loadInstantialData(data)
    self.m_LoadedUnitIds = data.loaded

    return self
end

function UnitLoader:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "UnitLoader:setRootScriptEventDispatcher() the dispatcher has been set.")

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtTurnPhaseSupplyUnit", self)

    return self
end

function UnitLoader:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "UnitLoader:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseSupplyUnit", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function UnitLoader:toSerializableTable()
    if (#self.m_LoadedUnitIds == 0) then
        return nil
    else
        return {
            loaded = self.m_LoadedUnitIds,
        }
    end
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function UnitLoader:onBind(target)
    assert(self.m_Owner == nil, "UnitLoader:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Owner = target

    return self
end

function UnitLoader:onUnbind()
    assert(self.m_Owner ~= nil, "UnitLoader:onUnbind() the component has not bound to a target.")

    ComponentManager.unsetMethods(self.m_Owner, EXPORTED_METHODS)
    self.m_Owner = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function UnitLoader:onEvent(event)
    if (event.name == "EvtTurnPhaseSupplyUnit") then
        onEvtTurnPhaseSupplyUnit(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function UnitLoader:doActionMoveModelUnit(action, loadedModelUnits)
    local destination = action.path[#action.path]
    for _, modelUnit in pairs(loadedModelUnits or {}) do
        modelUnit:setGridIndex(destination, false)
    end

    return self.m_Owner
end

function UnitLoader:doActionLoadModelUnit(action, unitID, loaderModelUnit)
    if (self.m_Owner == loaderModelUnit) then
        self.m_LoadedUnitIds[#self.m_LoadedUnitIds + 1] = unitID
    end

    return self.m_Owner
end

function UnitLoader:doActionDropModelUnit(action, dropActorUnits)
    local dropDestinations = action.dropDestinations
    self.m_LoadedUnitIds   = getRemainingUnitIdsOnDrop(self:getLoadUnitIdList(), action.dropDestinations)

    for _, dropActorUnit in pairs(dropActorUnits) do
        local dropModelUnit = dropActorUnit:getModel()
        for _, dropDestination in pairs(dropDestinations) do
            if (dropModelUnit:getUnitId() == dropDestination.unitID) then
                dropModelUnit:setGridIndex(dropDestination.gridIndex)
            end
        end
    end

    return self.m_Owner
end

function UnitLoader:doActionLaunchModelUnit(action)
    local launchUnitID = action.launchUnitID
    if (launchUnitID) then
        for i, unitID in ipairs(self.m_LoadedUnitIds) do
            if (unitID == launchUnitID) then
                table.remove(self.m_LoadedUnitIds, i)
                break
            end
        end
    end

    return self.m_Owner
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function UnitLoader:getMaxLoadCount()
    -- TODO: take the co skills into account.
    return self.m_Template.maxLoadCount
end

function UnitLoader:getCurrentLoadCount()
    return #self.m_LoadedUnitIds
end

function UnitLoader:getLoadUnitIdList()
    return self.m_LoadedUnitIds
end

function UnitLoader:hasLoadUnitId(unitID)
    for i, loadedUnitID in ipairs(self:getLoadUnitIdList()) do
        if (loadedUnitID == unitID) then
            return true, i
        end
    end

    return false
end

function UnitLoader:canLoadModelUnit(modelUnit)
    return ((self:getCurrentLoadCount() < self:getMaxLoadCount()) and
        (self.m_Owner:getPlayerIndex() == modelUnit:getPlayerIndex()) and
        (GameConstantFunctions.isTypeInCategory(modelUnit:getUnitType(), self.m_Template.targetCategoryType)))
end

function UnitLoader:canDropModelUnit()
    return self.m_Template.canDrop
end

function UnitLoader:canLaunchModelUnit()
    return self.m_Template.canLaunch
end

function UnitLoader:canSupplyLoadedModelUnit()
    return self.m_Template.canSupply
end

function UnitLoader:addLoadUnitId(unitID)
    self.m_LoadedUnitIds[#self.m_LoadedUnitIds + 1] = unitID

    return self.m_Owner
end

return UnitLoader
