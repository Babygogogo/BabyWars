
--[[--------------------------------------------------------------------------------
-- ModelPlayerManager是战局上的玩家管理器，负责维护玩家列表及在适当时候更新玩家数据。
--
-- 主要职责
--   同上
--
-- 使用场景举例：
--   - 在回合进入“获得收入”的阶段（即收到EvtTurnPhaseGetFund消息）时，更新相应的player属性。
--   - 在回合进入“维修单位”的阶段（即收到EvtTurnPhaseRepairUnit消息）时，更新相应的unit和player的属性。
--
-- 其他：
--  - 在本类中响应“维修单位”有点不合理，可以移动到别的地方处理
--
--  - 本类目前没有对应的view，因为暂时还不用显示。
--]]--------------------------------------------------------------------------------

local ModelPlayerManager = require("src.global.functions.class")("ModelPlayerManager")

local ModelPlayer      = require("src.app.models.sceneWar.ModelPlayer")
local SingletonGetters = require("src.app.utilities.SingletonGetters")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getRepairableModelUnits(modelUnitMap, modelTileMap, playerIndex)
    local units = {}
    modelUnitMap:forEachModelUnitOnMap(function(modelUnit)
            if (modelUnit:getPlayerIndex() == playerIndex) then
                local modelTile = modelTileMap:getModelTile(modelUnit:getGridIndex())
                if ((modelTile.canRepairTarget) and (modelTile:canRepairTarget(modelUnit))) then
                    units[#units + 1] = modelUnit
                end
            end
        end)
        :forEachModelUnitLoaded(function(modelUnit)
            if (modelUnit:getPlayerIndex() == playerIndex) then
                local loader = modelUnitMap:getModelUnit(modelUnit:getGridIndex())
                if (loader:canRepairLoadedModelUnit()) then
                    units[#units + 1] = modelUnit
                end
            end
        end)

    table.sort(units, function(unit1, unit2)
        local cost1, cost2 = unit1:getProductionCost(), unit2:getProductionCost()
        return (cost1 > cost2)                                             or
            ((cost1 == cost2) and (unit1:getUnitId() < unit2:getUnitId()))
    end)

    return units
end

local function getRepairAmountAndCostForModelUnit(modelUnit, modelUnitMap, modelTileMap)
    local gridIndex = modelUnit:getGridIndex()
    if (modelUnitMap:getLoadedModelUnitWithUnitId(modelUnit:getUnitId())) then
        return modelUnitMap:getModelUnit(gridIndex):getRepairAmountAndCostForLoadedModelUnit(modelUnit)
    else
        return modelTileMap:getModelTile(gridIndex):getRepairAmountAndCost(modelUnit)
    end
end

local function dispatchEvtModelPlayerUpdated(sceneWarFileName, modelPlayer, playerIndex)
    SingletonGetters.getScriptEventDispatcher(sceneWarFileName):dispatchEvent({
        name        = "EvtModelPlayerUpdated",
        modelPlayer = modelPlayer,
        playerIndex = playerIndex,
    })
end

local function dispatchEvtRepairViewUnit(sceneWarFileName, gridIndex)
    SingletonGetters.getScriptEventDispatcher(sceneWarFileName):dispatchEvent({
        name      = "EvtRepairViewUnit",
        gridIndex = gridIndex,
    })
end

local function dispatchEvtSupplyViewUnit(sceneWarFileName, gridIndex)
    SingletonGetters.getScriptEventDispatcher(sceneWarFileName):dispatchEvent({
        name      = "EvtSupplyViewUnit",
        gridIndex = gridIndex,
    })
end

local function dispatchEvtSkillGroupActivated(sceneWarFileName, playerIndex, skillGroupID)
    SingletonGetters.getScriptEventDispatcher(sceneWarFileName):dispatchEvent({
        name         = "EvtSkillGroupActivated",
        playerIndex  = playerIndex,
        skillGroupID = skillGroupID,
    })
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseResetSkillState(self, event)
    local playerIndex = event.playerIndex
    self:getModelPlayer(playerIndex):deactivateSkillGroup()
end

local function onEvtTurnPhaseGetFund(self, event)
    local playerIndex = event.playerIndex
    local modelPlayer = self:getModelPlayer(playerIndex)

    if (modelPlayer:isAlive()) then
        local income = 0
        event.modelTileMap:forEachModelTile(function(modelTile)
            if ((modelTile.getIncomeAmount) and (modelTile:getPlayerIndex() == playerIndex)) then
                income = income + (modelTile:getIncomeAmount() or 0)
            end
        end)

        modelPlayer:setFund(modelPlayer:getFund() + income)
        dispatchEvtModelPlayerUpdated(self.m_SceneWarFileName, modelPlayer, playerIndex)
    end
end

local function onEvtTurnPhaseRepairUnit(self, event)
    local modelUnitMap    = event.modelUnitMap
    local modelTileMap    = event.modelTileMap
    local playerIndex     = event.playerIndex
    local modelPlayer     = self.m_ModelPlayers[playerIndex]

    for _, unit in ipairs(getRepairableModelUnits(modelUnitMap, modelTileMap, playerIndex)) do
        local gridIndex                = unit:getGridIndex()
        local repairAmount, repairCost = getRepairAmountAndCostForModelUnit(unit, modelUnitMap, modelTileMap)
        local shouldSupply             = unit:getCurrentFuel() < unit:getMaxFuel()

        unit:setCurrentHP(unit:getCurrentHP() + repairAmount)
            :setCurrentFuel(unit:getMaxFuel())
        if ((unit.hasPrimaryWeapon)                                                and
            (unit:hasPrimaryWeapon())                                              and
            (unit:getPrimaryWeaponCurrentAmmo() < unit:getPrimaryWeaponMaxAmmo())) then
            shouldSupply = true
            unit:setPrimaryWeaponCurrentAmmo(unit:getPrimaryWeaponMaxAmmo())
        end
        unit:updateView()
        modelPlayer:setFund(modelPlayer:getFund() - repairCost)

        if (repairAmount >= 10) then
            dispatchEvtRepairViewUnit(self.m_SceneWarFileName, gridIndex)
        elseif (shouldSupply) then
            dispatchEvtSupplyViewUnit(self.m_SceneWarFileName, gridIndex)
        end
    end

    dispatchEvtModelPlayerUpdated(self.m_SceneWarFileName, modelPlayer, playerIndex)
end

local function onEvtSceneWarStarted(self, event)
    self:forEachModelPlayer(function(modelPlayer, playerIndex)
        if (modelPlayer:isAlive()) then
            local activatingSkillGroupID = modelPlayer:getModelSkillConfiguration():getActivatingSkillGroupId()
            if (activatingSkillGroupID) then
                dispatchEvtSkillGroupActivated(self.m_SceneWarFileName, playerIndex, activatingSkillGroupID)
            end
        end
    end)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelPlayerManager:ctor(param)
    self.m_ModelPlayers = {}
    for i, player in ipairs(param) do
        self.m_ModelPlayers[i] = ModelPlayer:create(player)
    end

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelPlayerManager:toSerializableTable()
    local t = {}
    self:forEachModelPlayer(function(modelPlayer, playerIndex)
        t[playerIndex] = modelPlayer:toSerializableTable()
    end)

    return t
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelPlayerManager:onStartRunning(sceneWarFileName)
    self.m_SceneWarFileName = sceneWarFileName

    SingletonGetters.getScriptEventDispatcher(sceneWarFileName)
        :addEventListener("EvtTurnPhaseResetSkillState", self)
        :addEventListener("EvtTurnPhaseGetFund",         self)
        :addEventListener("EvtTurnPhaseRepairUnit",      self)
        :addEventListener("EvtSceneWarStarted",          self)

    return self
end

function ModelPlayerManager:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtTurnPhaseResetSkillState") then onEvtTurnPhaseResetSkillState(self, event)
    elseif (eventName == "EvtTurnPhaseGetFund")         then onEvtTurnPhaseGetFund(        self, event)
    elseif (eventName == "EvtTurnPhaseRepairUnit")      then onEvtTurnPhaseRepairUnit(     self, event)
    elseif (eventName == "EvtSceneWarStarted")          then onEvtSceneWarStarted(         self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelPlayerManager:doActionActivateSkillGroup(action, playerIndex)
    local modelPlayer = self:getModelPlayer(playerIndex)
    modelPlayer:doActionActivateSkillGroup(action)
    dispatchEvtModelPlayerUpdated(self.m_SceneWarFileName, modelPlayer, playerIndex)
    dispatchEvtSkillGroupActivated(self.m_SceneWarFileName, playerIndex, action.skillGroupID)

    return self
end

function ModelPlayerManager:doActionAttack(action)
    if (action.lostPlayerIndex) then
        local modelPlayer = self:getModelPlayer(action.lostPlayerIndex)
        assert(modelPlayer:isAlive(), "ModelPlayerManager:doActionAttack() the player that is being defeated is not alive.")
        modelPlayer:setAlive(false)
    end

    return self
end

function ModelPlayerManager:doActionCaptureModelTile(action)
    if (action.lostPlayerIndex) then
        self.m_ModelPlayers[action.lostPlayerIndex]:setAlive(false)
    end

    return self
end

function ModelPlayerManager:doActionProduceModelUnitOnUnit(action, playerIndex)
    local modelPlayer = self:getModelPlayer(playerIndex)
    modelPlayer:setFund(modelPlayer:getFund() - action.cost)
    dispatchEvtModelPlayerUpdated(self.m_SceneWarFileName, modelPlayer, playerIndex)

    return self
end

function ModelPlayerManager:doActionProduceOnTile(action, playerIndex)
    local modelPlayer = self:getModelPlayer(playerIndex)
    modelPlayer:setFund(modelPlayer:getFund() - action.cost)
    dispatchEvtModelPlayerUpdated(self.m_SceneWarFileName, modelPlayer, playerIndex)

    return self
end

function ModelPlayerManager:doActionSurrender(action)
    self.m_ModelPlayers[action.lostPlayerIndex]:setAlive(false)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelPlayerManager:getModelPlayer(playerIndex)
    return self.m_ModelPlayers[playerIndex]
end

function ModelPlayerManager:getPlayersCount()
    return #self.m_ModelPlayers
end

function ModelPlayerManager:getAlivePlayersCount()
    local count = 0
    for _, modelPlayer in ipairs(self.m_ModelPlayers) do
        if (modelPlayer:isAlive()) then
            count = count + 1
        end
    end

    return count
end

function ModelPlayerManager:getModelPlayerWithAccount(account)
    for playerIndex, modelPlayer in ipairs(self.m_ModelPlayers) do
        if (modelPlayer:getAccount() == account) then
            return modelPlayer, playerIndex
        end
    end

    return nil, nil
end

function ModelPlayerManager:forEachModelPlayer(func)
    for playerIndex, modelPlayer in ipairs(self.m_ModelPlayers) do
        func(modelPlayer, playerIndex)
    end

    return self
end

return ModelPlayerManager
