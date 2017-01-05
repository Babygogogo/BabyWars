
local UnitLoader = require("src.global.functions.class")("UnitLoader")

local GameConstantFunctions  = require("src.app.utilities.GameConstantFunctions")
local SingletonGetters       = require("src.app.utilities.SingletonGetters")
local SkillModifierFunctions = require("src.app.utilities.SkillModifierFunctions")
local TableFunctions         = require("src.app.utilities.TableFunctions")
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
    "removeLoadUnitId",
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
        local modelPlayer = SingletonGetters.getModelPlayerManager(self.m_SceneWarFileName):getModelPlayer(self.m_Owner:getPlayerIndex())
        return baseAmount + SkillModifierFunctions.getRepairAmountModifier(modelPlayer:getModelSkillConfiguration())
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

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function UnitLoader:toSerializableTable()
    if (#self.m_LoadedUnitIds == 0) then
        return nil
    else
        return {
            loaded = TableFunctions.clone(self.m_LoadedUnitIds),
        }
    end
end

--------------------------------------------------------------------------------
-- The public callback function on start running.
--------------------------------------------------------------------------------
function UnitLoader:onStartRunning(modelSceneWar, sceneWarFileName)
    self.m_SceneWarFileName = sceneWarFileName

    return self
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

    local modelPlayer    = SingletonGetters.getModelPlayerManager(self.m_SceneWarFileName):getModelPlayer(self.m_Owner:getPlayerIndex())
    local costModifier   = SkillModifierFunctions.getRepairCostModifier(modelPlayer:getModelSkillConfiguration())
    local productionCost = math.floor(
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

function UnitLoader:removeLoadUnitId(unitID)
    for i, loadedUnitID in ipairs(self.m_LoadedUnitIds) do
        if (loadedUnitID == unitID) then
            table.remove(self.m_LoadedUnitIds, i)
            return self.m_Owner
        end
    end

    error("UnitLoader:removeLoadUnitId() the param unitID is not loaded: " .. (unitID or ""))
end

return UnitLoader
