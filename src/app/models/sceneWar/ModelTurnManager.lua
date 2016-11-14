
--[[--------------------------------------------------------------------------------
-- ModelTurnManager是战局中的回合控制器。
--
-- 主要职责和使用场景举例：
--   维护相关数值（如当前回合数、回合阶段、当前活动玩家序号PlayerIndex等），提供接口给外界访问
--
-- 其他：
--   - 一个回合包括以下阶段（以发生顺序排序，可能还有未列出的）
--     - 初始阶段（TurnPhaseBeginning，通过此event使得begin turn effect（也就是回合初弹出的消息框）出现）
--     - 计算玩家收入（TurnPhaseGetFund）
--     - 消耗unit燃料（TurnPhaseConsumeUnitFuel，符合特定条件的unit会随之毁灭）
--     - 维修unit（TurnPhaseRepairUnit，指的是tile对unit的维修和补给）
--     - 补给unit（TurnPhaseSupplyUnit，指的是unit对unit的补给，目前未实现）
--     - 主要阶段（TurnPhaseMain，即玩家可以进行操作的阶段）
--     - 恢复unit状态（TurnPhaseResetUnitState，即玩家结束回合后，使得移动过的unit恢复为可移动的状态；切换活动玩家，确保当前玩家不能再次操控unit）
--     - 更换weather（TurnPhaseChangeWeather，目前未实现。具体切换与否，由ModelWeatherManager决定）
--]]--------------------------------------------------------------------------------

local ModelTurnManager = require("src.global.functions.class")("ModelTurnManager")

local IS_SERVER             = require("src.app.utilities.GameConstantFunctions").isServer()
local Destroyers            = require("src.app.utilities.Destroyers")
local GridIndexFunctions    = require("src.app.utilities.GridIndexFunctions")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local SingletonGetters      = require("src.app.utilities.SingletonGetters")
local VisibilityFunctions   = require("src.app.utilities.VisibilityFunctions")
local WebSocketManager      = (not IS_SERVER) and (require("src.app.utilities.WebSocketManager")) or (nil)

local getLocalizedText         = LocalizationFunctions.getLocalizedText
local getModelMessageIndicator = SingletonGetters.getModelMessageIndicator
local getModelPlayerManager    = SingletonGetters.getModelPlayerManager
local getModelFogMap           = SingletonGetters.getModelFogMap
local getModelTileMap          = SingletonGetters.getModelTileMap
local getModelUnitMap          = SingletonGetters.getModelUnitMap
local getPlayerIndexLoggedIn   = SingletonGetters.getPlayerIndexLoggedIn
local getSceneWarFileName      = SingletonGetters.getSceneWarFileName
local getScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher
local isUnitVisible            = VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex
local isTileVisible            = VisibilityFunctions.isTileVisibleToPlayerIndex

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getNextTurnAndPlayerIndex(self, playerManager)
    local nextTurnIndex   = self.m_TurnIndex
    local nextPlayerIndex = self.m_PlayerIndex + 1
    local playersCount    = playerManager:getPlayersCount()

    while (true) do
        if (nextPlayerIndex > playersCount) then
            nextPlayerIndex = 1
            nextTurnIndex   = nextTurnIndex + 1
        end

        assert(nextPlayerIndex ~= self.m_PlayerIndex, "ModelTurnManager-getNextTurnAndPlayerIndex() the number of alive players is less than 2.")

        if (playerManager:getModelPlayer(nextPlayerIndex):isAlive()) then
            return nextTurnIndex, nextPlayerIndex
        else
            nextPlayerIndex = nextPlayerIndex + 1
        end
    end
end

local function dispatchEvtSupplyViewUnit(dispatcher, gridIndex)
    dispatcher:dispatchEvent({
        name      = "EvtSupplyViewUnit",
        gridIndex = gridIndex,
    })
end

local function supplyModelUnit(modelUnit)
    local hasSupplied = false
    local maxFuel = modelUnit:getMaxFuel()
    if (modelUnit:getCurrentFuel() < maxFuel) then
        modelUnit:setCurrentFuel(maxFuel)
        hasSupplied = true
    end

    if ((modelUnit.hasPrimaryWeapon) and (modelUnit:hasPrimaryWeapon())) then
        local maxAmmo = modelUnit:getPrimaryWeaponMaxAmmo()
        if (modelUnit:getPrimaryWeaponCurrentAmmo() < maxAmmo) then
            modelUnit:setPrimaryWeaponCurrentAmmo(maxAmmo)
            hasSupplied = true
        end
    end

    if (hasSupplied) then
        modelUnit:updateView()
    end

    return hasSupplied
end

local function repairModelUnit(modelUnit, repairAmount)
    modelUnit:setCurrentHP(modelUnit:getCurrentHP() + repairAmount)
    local hasSupplied = supplyModelUnit(modelUnit)

    if (not IS_SERVER) then
        modelUnit:updateView()

        if (repairAmount >= 10) then
            SingletonGetters.getModelGridEffect():showAnimationRepair(modelUnit:getGridIndex())
        elseif (hasSupplied) then
            SingletonGetters.getModelGridEffect():showAnimationSupply(modelUnit:getGridIndex())
        end
    end
end

local function resetVisionOnClient()
    assert(not IS_SERVER, "ModelTurnManager-resetVisionOnClient() this shouldn't be called on the server.")
    local sceneWarFileName = getSceneWarFileName()
    local playerIndex      = getPlayerIndexLoggedIn()

    getModelUnitMap():forEachModelUnitOnMap(function(modelUnit)
        local gridIndex = modelUnit:getGridIndex()
        if (not isUnitVisible(sceneWarFileName, gridIndex, modelUnit:getUnitType(), (modelUnit.isDiving and modelUnit:isDiving()), modelUnit:getPlayerIndex(), playerIndex)) then
            Destroyers.destroyActorUnitOnMap(sceneWarFileName, gridIndex, true)
        end
    end)

    getModelTileMap():forEachModelTile(function(modelTile)
        if (not isTileVisible(sceneWarFileName, modelTile:getGridIndex(), playerIndex)) then
            modelTile:updateAsFogEnabled()
                :updateView()
        end
    end)
end

--------------------------------------------------------------------------------
-- The functions that runs each turn phase.
--------------------------------------------------------------------------------
local function runTurnPhaseBeginning(self)
    local modelPlayer = getModelPlayerManager(self.m_SceneWarFileName):getModelPlayer(self.m_PlayerIndex)
    local callbackOnBeginTurnEffectDisappear = function()
        self.m_TurnPhase = "getFund"
        self:runTurn()
    end

    if (self.m_View) then
        self.m_View:showBeginTurnEffect(self.m_TurnIndex, modelPlayer:getNickname(), callbackOnBeginTurnEffectDisappear)
    else
        callbackOnBeginTurnEffectDisappear()
    end
end

local function runTurnPhaseGetFund(self)
    if (self.m_IncomeForNextTurn) then
        local modelPlayer = getModelPlayerManager(self.m_SceneWarFileName):getModelPlayer(self.m_PlayerIndex)
        modelPlayer:setFund(modelPlayer:getFund() + self.m_IncomeForNextTurn)
        self.m_IncomeForNextTurn = nil
    end

    self.m_TurnPhase = "consumeUnitFuel"
end

local function runTurnPhaseConsumeUnitFuel(self)
    if (self.m_TurnIndex > 1) then
        local sceneWarFileName = self.m_SceneWarFileName
        local playerIndex      = self.m_PlayerIndex
        local modelTileMap     = getModelTileMap(sceneWarFileName)
        local dispatcher       = getScriptEventDispatcher(sceneWarFileName)

        getModelUnitMap(sceneWarFileName):forEachModelUnitOnMap(function(modelUnit)
            if ((modelUnit:getPlayerIndex() == playerIndex) and
                (modelUnit.setCurrentFuel))                 then
                local newFuel = math.max(modelUnit:getCurrentFuel() - modelUnit:getFuelConsumptionPerTurn(), 0)
                modelUnit:setCurrentFuel(newFuel)
                    :updateView()

                if ((newFuel == 0) and (modelUnit:shouldDestroyOnOutOfFuel())) then
                    local gridIndex = modelUnit:getGridIndex()
                    local modelTile = modelTileMap:getModelTile(gridIndex)

                    if ((not modelTile.canRepairTarget) or (not modelTile:canRepairTarget(modelUnit))) then
                        Destroyers.destroyActorUnitOnMap(sceneWarFileName, gridIndex, true)
                        dispatcher:dispatchEvent({
                            name      = "EvtDestroyViewUnit",
                            gridIndex = gridIndex,
                        })
                    end
                end
            end
        end)
    end

    self.m_TurnPhase = "repairUnit"
end

local function runTurnPhaseRepairUnit(self)
    local repairData = self.m_RepairDataForNextTurn
    if (repairData) then
        local sceneWarFileName = self.m_SceneWarFileName
        local modelUnitMap     = getModelUnitMap(sceneWarFileName)
        for unitID, data in pairs(repairData.onMapData) do
            repairModelUnit(modelUnitMap:getModelUnit(data.gridIndex), data.repairAmount)
        end
        for unitID, data in pairs(repairData.loadedData) do
            repairModelUnit(modelUnitMap:getLoadedModelUnitWithUnitId(unitID), data.repairAmount)
        end

        getModelPlayerManager(sceneWarFileName):getModelPlayer(self.m_PlayerIndex):setFund(repairData.remainingFund)
        self.m_RepairDataForNextTurn = nil
    end

    self.m_TurnPhase = "supplyUnit"
end

local function runTurnPhaseSupplyUnit(self)
    local sceneWarFileName = self.m_SceneWarFileName
    local playerIndex      = self.m_PlayerIndex
    local modelUnitMap     = getModelUnitMap(sceneWarFileName)
    local dispatcher       = getScriptEventDispatcher(sceneWarFileName)
    local mapSize          = modelUnitMap:getMapSize()

    local supplyLoadedModelUnits = function(modelUnit)
        if ((modelUnit:getPlayerIndex() == playerIndex) and
            (modelUnit.canSupplyLoadedModelUnit)        and
            (modelUnit:canSupplyLoadedModelUnit())      and
            (not modelUnit:canRepairLoadedModelUnit())) then

            local hasSupplied = false
            for _, unitID in pairs(modelUnit:getLoadUnitIdList()) do
                hasSupplied = supplyModelUnit(modelUnitMap:getLoadedModelUnitWithUnitId(unitID)) or hasSupplied
            end
            if (hasSupplied) then
                dispatchEvtSupplyViewUnit(dispatcher, modelUnit:getGridIndex())
            end
        end
    end

    local supplyAdjacentModelUnits = function(modelUnit)
        if ((modelUnit:getPlayerIndex() == playerIndex) and
            (modelUnit.canSupplyModelUnit))             then
            for _, gridIndex in pairs(GridIndexFunctions.getAdjacentGrids(modelUnit:getGridIndex(), mapSize)) do
                local supplyTarget = modelUnitMap:getModelUnit(gridIndex)
                if ((supplyTarget)                               and
                    (modelUnit:canSupplyModelUnit(supplyTarget)) and
                    (supplyModelUnit(supplyTarget)))             then
                    dispatchEvtSupplyViewUnit(dispatcher, gridIndex)
                end
            end
        end
    end

    modelUnitMap:forEachModelUnitOnMap(supplyAdjacentModelUnits)
        :forEachModelUnitOnMap(        supplyLoadedModelUnits)
        :forEachModelUnitLoaded(       supplyLoadedModelUnits)

    self.m_TurnPhase = "main"
end

local function runTurnPhaseMain(self)
    local sceneWarFileName = self.m_SceneWarFileName
    local playerIndex      = self.m_PlayerIndex
    getScriptEventDispatcher(sceneWarFileName):dispatchEvent({
            name        = "EvtModelPlayerUpdated",
            modelPlayer = getModelPlayerManager(sceneWarFileName):getModelPlayer(playerIndex),
            playerIndex = playerIndex,
        })
        :dispatchEvent({name = "EvtModelUnitMapUpdated"})
        :dispatchEvent({name = "EvtModelTileMapUpdated"})
end

local function runTurnPhaseResetUnitState(self)
    local playerIndex      = self.m_PlayerIndex
    local sceneWarFileName = self.m_SceneWarFileName
    local func             = function(modelUnit)
        if (modelUnit:getPlayerIndex() == playerIndex) then
            modelUnit:setStateIdle()
                :updateView()
        end
    end

    getModelUnitMap(sceneWarFileName):forEachModelUnitOnMap(func)
        :forEachModelUnitLoaded(func)

    self.m_TurnPhase = "resetVisionForEndingTurnPlayer"
end

local function runTurnPhaseResetVisionForEndingTurnPlayer(self)
    local playerIndex = self:getPlayerIndex()
    if (IS_SERVER) then
        getModelFogMap(self.m_SceneWarFileName):resetMapForPathsForPlayerIndex(playerIndex)
    elseif (playerIndex == getPlayerIndexLoggedIn()) then
        getModelFogMap():resetMapForPathsForPlayerIndex(playerIndex)
        resetVisionOnClient()
    end

    self.m_TurnPhase = "tickTurnAndPlayerIndex"
end

local function runTurnPhaseTickTurnAndPlayerIndex(self)
    local modelPlayerManager = getModelPlayerManager(self.m_SceneWarFileName)
    self.m_TurnIndex, self.m_PlayerIndex = getNextTurnAndPlayerIndex(self, modelPlayerManager)

    getScriptEventDispatcher(self.m_SceneWarFileName):dispatchEvent({
        name        = "EvtPlayerIndexUpdated",
        playerIndex = self.m_PlayerIndex,
        modelPlayer = modelPlayerManager:getModelPlayer(self.m_PlayerIndex),
    })

    -- TODO: Change the vision, weather and so on.
    self.m_TurnPhase = "resetSkillState"
end

local function runTurnPhaseResetSkillState(self)
    local playerIndex = self.m_PlayerIndex
    getModelPlayerManager(self.m_SceneWarFileName):getModelPlayer(playerIndex):deactivateSkillGroup()

    if (not IS_SERVER) then
        local func = function(modelUnit)
            if (modelUnit:getPlayerIndex() == playerIndex) then
                modelUnit:updateView()
            end
        end

        getModelUnitMap(self.m_SceneWarFileName):forEachModelUnitOnMap(func)
            :forEachModelUnitLoaded(func)
    end

    self.m_TurnPhase = "resetVisionForBeginningTurnPlayer"
end

local function runTurnPhaseResetVisionForBeginningTurnPlayer(self)
    local playerIndex = self:getPlayerIndex()
    if (IS_SERVER) then
        getModelFogMap(self.m_SceneWarFileName):resetMapForTilesForPlayerIndex(playerIndex)
            :resetMapForUnitsForPlayerIndex(playerIndex)
    elseif (playerIndex == getPlayerIndexLoggedIn()) then
        getModelFogMap():resetMapForTilesForPlayerIndex(playerIndex)
            :resetMapForUnitsForPlayerIndex(playerIndex)
        resetVisionOnClient()
    end

    self.m_TurnPhase = "requestToBegin"
end

local function runTurnPhaseRequestToBegin(self)
    if ((not IS_SERVER) and (self.m_PlayerIndex == getPlayerIndexLoggedIn())) then
        WebSocketManager.sendAction({
            actionName       = "BeginTurn",
            actionID         = SingletonGetters.getActionId(self.m_SceneWarFileName) + 1,
            sceneWarFileName = self.m_SceneWarFileName,
        })
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelTurnManager:ctor(param)
    self.m_TurnIndex   = param.turnIndex
    self.m_PlayerIndex = param.playerIndex
    self.m_TurnPhase   = param.phase

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelTurnManager:toSerializableTable()
    return {
        turnIndex   = self:getTurnIndex(),
        playerIndex = self:getPlayerIndex(),
        phase       = self:getTurnPhase(),
    }
end

function ModelTurnManager:toSerializableTableForPlayerIndex(playerIndex)
    return self:toSerializableTable()
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelTurnManager:onStartRunning(sceneWarFileName)
    assert(string.len(sceneWarFileName) == 16, "ModelTurnManager:onStartRunning() invalid name: " .. (sceneWarFileName or ""))
    self.m_SceneWarFileName = sceneWarFileName

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelTurnManager:getTurnIndex()
    return self.m_TurnIndex
end

function ModelTurnManager:getTurnPhase()
    return self.m_TurnPhase
end

function ModelTurnManager:getPlayerIndex()
    return self.m_PlayerIndex
end

function ModelTurnManager:runTurn()
    if (self.m_TurnPhase == "beginning")                         then runTurnPhaseBeginning(                        self) end
    if (self.m_TurnPhase == "getFund")                           then runTurnPhaseGetFund(                          self) end
    if (self.m_TurnPhase == "consumeUnitFuel")                   then runTurnPhaseConsumeUnitFuel(                  self) end
    if (self.m_TurnPhase == "repairUnit")                        then runTurnPhaseRepairUnit(                       self) end
    if (self.m_TurnPhase == "supplyUnit")                        then runTurnPhaseSupplyUnit(                       self) end
    if (self.m_TurnPhase == "main")                              then runTurnPhaseMain(                             self) end
    if (self.m_TurnPhase == "resetUnitState")                    then runTurnPhaseResetUnitState(                   self) end
    if (self.m_TurnPhase == "resetVisionForEndingTurnPlayer")    then runTurnPhaseResetVisionForEndingTurnPlayer(   self) end
    if (self.m_TurnPhase == "tickTurnAndPlayerIndex")            then runTurnPhaseTickTurnAndPlayerIndex(           self) end
    if (self.m_TurnPhase == "resetSkillState")                   then runTurnPhaseResetSkillState(                  self) end
    if (self.m_TurnPhase == "resetVisionForBeginningTurnPlayer") then runTurnPhaseResetVisionForBeginningTurnPlayer(self) end
    if (self.m_TurnPhase == "requestToBegin")                    then runTurnPhaseRequestToBegin(                   self) end

    if ((self.m_TurnPhase == "main") and (self.m_CallbackOnEnterTurnPhaseMainForNextTurn)) then
        self.m_CallbackOnEnterTurnPhaseMainForNextTurn()
        self.m_CallbackOnEnterTurnPhaseMainForNextTurn = nil
    end

    if (not IS_SERVER) then
        if (self:getPlayerIndex() == getPlayerIndexLoggedIn()) then
            getModelMessageIndicator():hidePersistentMessage(getLocalizedText(80, "NotInTurn"))
        else
            getModelMessageIndicator():showPersistentMessage(getLocalizedText(80, "NotInTurn"))
        end
    end

    return self
end

function ModelTurnManager:beginTurnPhaseBeginning(income, repairData, callbackOnEnterTurnPhaseMain)
    assert(self.m_TurnPhase == "requestToBegin", "ModelTurnManager:beginTurnPhaseBeginning() invalid turn phase: " .. self.m_TurnPhase)

    self.m_IncomeForNextTurn                       = income
    self.m_RepairDataForNextTurn                   = repairData
    self.m_CallbackOnEnterTurnPhaseMainForNextTurn = callbackOnEnterTurnPhaseMain

    runTurnPhaseBeginning(self)

    return self
end

function ModelTurnManager:endTurnPhaseMain()
    assert(self.m_TurnPhase == "main", "ModelTurnManager:endTurnPhaseMain() invalid turn phase: " .. self.m_TurnPhase)
    self.m_TurnPhase = "resetUnitState"
    self:runTurn()

    return self
end

return ModelTurnManager
