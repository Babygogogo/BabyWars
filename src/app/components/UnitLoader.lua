
local UnitLoader = require("src.global.functions.class")("UnitLoader")

local GameConstantFunctions  = require("src.app.utilities.GameConstantFunctions")
local SkillModifierFunctions = require("src.app.utilities.SkillModifierFunctions")
local ComponentManager       = require("src.global.components.ComponentManager")

UnitLoader.EXPORTED_METHODS = {
    "getMaxLoadCount",
    "getCurrentLoadCount",
    "getLoadUnitIdList",
    "hasLoadUnitId",
    "canLoadModelUnit",
    "canDropModelUnit",
    "canLaunchModelUnit",
    "canRepairLoadedModelUnit",
    "canSupplyLoadedModelUnit",
    "getRepairAmountAndCostForLoadedModelUnit",

    "addLoadUnitId",
}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function round(num)
    return math.floor(num + 0.5)
end

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

    assert(#currentList == #dropDestinations + #remainingUnitIds)
    return remainingUnitIds
end

local function isValidTargetTileType(self, tileType)
    local targetTileTypes = self.m_Template.targetTileTypes
    if (not targetTileTypes) then
        return true
    else
        for _, target in pairs(targetTileTypes) do
            if (target == tileType) then
                return true
            end
        end

        return false
    end
end

local function getNormalizedRepairAmount(self)
    local baseAmount  = self.m_Template.repairAmount
    local playerIndex = self.m_Owner:getPlayerIndex()
    if ((not baseAmount) or (playerIndex < 1)) then
        return baseAmount
    else
        local modelPlayer = self.m_ModelPlayerManager:getModelPlayer(self.m_Owner:getPlayerIndex())
        return baseAmount + SkillModifierFunctions.getRepairAmountModifier(modelPlayer:getModelSkillConfiguration())
    end
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseSupplyUnit(self, event)
    if ((self.m_Owner:getPlayerIndex() == event.playerIndex) and
        (not self:canRepairLoadedModelUnit())                and
        (self:canSupplyLoadedModelUnit()))                   then
        local modelUnitMap = event.modelUnitMap
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

function UnitLoader:setModelPlayerManager(model)
    assert(self.m_ModelPlayerManager == nil, "UnitLoader:setModelPlayerManager() the model has been set already.")
    self.m_ModelPlayerManager = model

    return self
end

function UnitLoader:unsetModelPlayerManager(model)
    assert(self.m_ModelPlayerManager, "UnitLoader:unsetModelPlayerManager() the model hasn't been set.")
    self.m_ModelPlayerManager = nil

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
function UnitLoader:doActionLaunchModelUnit(action)
    local launchUnitID = action.launchUnitID
    assert(launchUnitID, "UnitLoader:doActionLaunchModelUnit() action.launchUnitID is invalid.")

    for i, unitID in ipairs(self.m_LoadedUnitIds) do
        if (unitID == launchUnitID) then
            table.remove(self.m_LoadedUnitIds, i)
            return self.m_Owner
        end
    end

    error("UnitLoader:doActionLaunchModelUnit() no loaded unit id matches action.launchUnitID.")
end

function UnitLoader:canJoinModelUnit(modelUnit)
    return (self:getCurrentLoadCount() == 0)   and
        (modelUnit.getCurrentLoadCount)        and
        (modelUnit:getCurrentLoadCount() == 0)
end

function UnitLoader:doActionMoveModelUnit(action, loadedModelUnits)
    local destination = action.path[#action.path]
    for _, modelUnit in pairs(loadedModelUnits or {}) do
        modelUnit:setGridIndex(destination, false)
    end

    return self.m_Owner
end

function UnitLoader:doActionLoadModelUnit(action, unitID)
    self:addLoadUnitId(unitID)

    return self.m_Owner
end

function UnitLoader:doActionDropModelUnit(action)
    self.m_LoadedUnitIds   = getRemainingUnitIdsOnDrop(self:getLoadUnitIdList(), action.dropDestinations)

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

function UnitLoader:canLoadModelUnit(modelUnit, tileType)
    return (isValidTargetTileType(self, tileType))                                                            and
        (self:getCurrentLoadCount() < self:getMaxLoadCount())                                                 and
        (self.m_Owner:getPlayerIndex() == modelUnit:getPlayerIndex())                                         and
        (GameConstantFunctions.isTypeInCategory(modelUnit:getUnitType(), self.m_Template.targetCategoryType))
end

function UnitLoader:canDropModelUnit(tileType)
    return (self.m_Template.canDrop) and (isValidTargetTileType(self, tileType))
end

function UnitLoader:canLaunchModelUnit()
    return self.m_Template.canLaunch
end

function UnitLoader:canRepairLoadedModelUnit()
    return self.m_Template.canRepair
end

function UnitLoader:canSupplyLoadedModelUnit()
    return self.m_Template.canSupply
end

function UnitLoader:getRepairAmountAndCostForLoadedModelUnit(modelUnit)
    assert(self:hasLoadUnitId(modelUnit:getUnitId()),
        "UnitLoader:getRepairAmountAndCostForLoadedModelUnit() the param modelUnit is not loaded by self.")

    local modelPlayer    = self.m_ModelPlayerManager:getModelPlayer(self.m_Owner:getPlayerIndex())
    local costModifier   = SkillModifierFunctions.getRepairCostModifier(modelPlayer:getModelSkillConfiguration())
    local productionCost = round(
        (costModifier >= 0)                                          and
        (modelUnit:getProductionCost() * (100 + costModifier) / 100) or
        (modelUnit:getProductionCost() * 100 / (100 - costModifier))
    )
    local normalizedCurrentHP    = modelUnit:getNormalizedCurrentHP()
    local normalizedRepairAmount = math.min(
        10 - normalizedCurrentHP,
        getNormalizedRepairAmount(self),
        math.floor(modelPlayer:getFund() * 10 / productionCost)
    )

    return (normalizedRepairAmount + normalizedCurrentHP) * 10 - modelUnit:getCurrentHP(),
        round(normalizedRepairAmount * productionCost / 10)
end

function UnitLoader:addLoadUnitId(unitID)
    assert(not self:hasLoadUnitId(unitID), "UnitLoader:addLoadUnitId() the id has been loaded already.")
    assert(self:getCurrentLoadCount() < self:getMaxLoadCount(), "UnitLoader:addLoadUnitId() too many units are loaded.")
    self.m_LoadedUnitIds[#self.m_LoadedUnitIds + 1] = unitID

    return self.m_Owner
end

return UnitLoader
