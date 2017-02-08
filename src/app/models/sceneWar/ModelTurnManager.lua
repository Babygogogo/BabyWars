
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

local ModelTurnManager = requireBW("src.global.functions.class")("ModelTurnManager")

local IS_SERVER             = requireBW("src.app.utilities.GameConstantFunctions").isServer()
local ActionCodeFunctions   = requireBW("src.app.utilities.ActionCodeFunctions")
local Destroyers            = requireBW("src.app.utilities.Destroyers")
local GridIndexFunctions    = requireBW("src.app.utilities.GridIndexFunctions")
local LocalizationFunctions = requireBW("src.app.utilities.LocalizationFunctions")
local SingletonGetters      = requireBW("src.app.utilities.SingletonGetters")
local SupplyFunctions       = requireBW("src.app.utilities.SupplyFunctions")
local VisibilityFunctions   = requireBW("src.app.utilities.VisibilityFunctions")
local WebSocketManager      = (not IS_SERVER) and (requireBW("src.app.utilities.WebSocketManager")) or (nil)

local destroyActorUnitOnMap    = Destroyers.destroyActorUnitOnMap
local getAdjacentGrids         = GridIndexFunctions.getAdjacentGrids
local getLocalizedText         = LocalizationFunctions.getLocalizedText
local getModelMessageIndicator = SingletonGetters.getModelMessageIndicator
local getModelPlayerManager    = SingletonGetters.getModelPlayerManager
local getModelFogMap           = SingletonGetters.getModelFogMap
local getModelTileMap          = SingletonGetters.getModelTileMap
local getModelUnitMap          = SingletonGetters.getModelUnitMap
local getPlayerIndexLoggedIn   = SingletonGetters.getPlayerIndexLoggedIn
local getScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher
local isUnitVisible            = VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex
local isTileVisible            = VisibilityFunctions.isTileVisibleToPlayerIndex
local isTotalReplay            = SingletonGetters.isTotalReplay
local supplyWithAmmoAndFuel    = SupplyFunctions.supplyWithAmmoAndFuel

local ACTION_CODE_BEGIN_TURN = ActionCodeFunctions.getActionCode("ActionBeginTurn")
local TURN_PHASE_CODES = {
    RequestToBegin                    = 1,
    Beginning                         = 2,
    GetFund                           = 3,
    ConsumeUnitFuel                   = 4,
    RepairUnit                        = 5,
    SupplyUnit                        = 6,
    Main                              = 7,
    ResetUnitState                    = 8,
    ResetVisionForEndingTurnPlayer    = 9,
    TickTurnAndPlayerIndex            = 10,
    ResetSkillState                   = 11,
    ResetVisionForBeginningTurnPlayer = 12,
    ResetVotedForDraw                 = 13,
}
local DEFAULT_TURN_DATA = {
    turnIndex     = 1,
    playerIndex   = 1,
    turnPhaseCode = TURN_PHASE_CODES.RequestToBegin,
}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function isModelUnitDiving(modelUnit)
    return (modelUnit.isDiving) and (modelUnit:isDiving())
end

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

local function repairModelUnit(self, modelUnit, repairAmount)
    modelUnit:setCurrentHP(modelUnit:getCurrentHP() + repairAmount)
    local hasSupplied = supplyWithAmmoAndFuel(modelUnit, true)

    if ((not IS_SERVER) and (not self.m_ModelSceneWar:isFastExecutingActions())) then
        modelUnit:updateView()

        if (repairAmount >= 10) then
            SingletonGetters.getModelGridEffect(self.m_ModelSceneWar):showAnimationRepair(modelUnit:getGridIndex())
        elseif (hasSupplied) then
            SingletonGetters.getModelGridEffect(self.m_ModelSceneWar):showAnimationSupply(modelUnit:getGridIndex())
        end
    end
end

local function resetVisionOnClient(self)
    assert(not IS_SERVER, "ModelTurnManager-resetVisionOnClient() this shouldn't be called on the server.")
    local modelSceneWar = self.m_ModelSceneWar
    if (isTotalReplay(modelSceneWar)) then
        getModelFogMap(modelSceneWar):updateView()
    else
        local playerIndex = getPlayerIndexLoggedIn(modelSceneWar)
        getModelUnitMap(modelSceneWar):forEachModelUnitOnMap(function(modelUnit)
            local gridIndex = modelUnit:getGridIndex()
            if (not isUnitVisible(modelSceneWar, gridIndex, modelUnit:getUnitType(), isModelUnitDiving(modelUnit), modelUnit:getPlayerIndex(), playerIndex)) then
                destroyActorUnitOnMap(modelSceneWar, gridIndex, true)
            end
        end)

        getModelTileMap(modelSceneWar):forEachModelTile(function(modelTile)
            if (not isTileVisible(modelSceneWar, modelTile:getGridIndex(), playerIndex)) then
                modelTile:updateAsFogEnabled()
                    :updateView()
            end
        end)
    end
end

--------------------------------------------------------------------------------
-- The functions that runs each turn phase.
--------------------------------------------------------------------------------
local function runTurnPhaseBeginning(self)
    local modelSceneWar = self.m_ModelSceneWar
    local modelPlayer   = getModelPlayerManager(modelSceneWar):getModelPlayer(self.m_PlayerIndex)
    local callbackOnBeginTurnEffectDisappear = function()
        self.m_TurnPhaseCode = TURN_PHASE_CODES.GetFund
        self:runTurn()
    end

    if ((self.m_View) and (not modelSceneWar:isFastExecutingActions())) then
        self.m_View:showBeginTurnEffect(self.m_TurnIndex, modelPlayer:getNickname(), callbackOnBeginTurnEffectDisappear)
    else
        callbackOnBeginTurnEffectDisappear()
    end
end

local function runTurnPhaseGetFund(self)
    if (self.m_IncomeForNextTurn) then
        local modelPlayer = getModelPlayerManager(self.m_ModelSceneWar):getModelPlayer(self.m_PlayerIndex)
        modelPlayer:setFund(modelPlayer:getFund() + self.m_IncomeForNextTurn)
        self.m_IncomeForNextTurn = nil
    end

    self.m_TurnPhaseCode = TURN_PHASE_CODES.ConsumeUnitFuel
end

local function runTurnPhaseConsumeUnitFuel(self)
    if (self.m_TurnIndex > 1) then
        local modelSceneWar       = self.m_ModelSceneWar
        local playerIndexActing   = self.m_PlayerIndex
        local modelTileMap        = getModelTileMap(modelSceneWar)
        local modelUnitMap        = getModelUnitMap(modelSceneWar)
        local modelFogMap         = getModelFogMap( modelSceneWar)
        local mapSize             = modelTileMap:getMapSize()
        local dispatcher          = getScriptEventDispatcher(modelSceneWar)
        local isReplay            = isTotalReplay(modelSceneWar)
        local playerIndexLoggedIn = ((not IS_SERVER) and (not isReplay)) and (getPlayerIndexLoggedIn(modelSceneWar)) or (nil)
        local shouldUpdateFogMap  = (IS_SERVER) or (isReplay) or (playerIndexActing == playerIndexLoggedIn)

        modelUnitMap:forEachModelUnitOnMap(function(modelUnit)
            if ((modelUnit:getPlayerIndex() == playerIndexActing) and
                (modelUnit.setCurrentFuel))                       then
                local newFuel = math.max(modelUnit:getCurrentFuel() - modelUnit:getFuelConsumptionPerTurn(), 0)
                modelUnit:setCurrentFuel(newFuel)
                    :updateView()

                if ((newFuel == 0) and (modelUnit:shouldDestroyOnOutOfFuel())) then
                    local gridIndex = modelUnit:getGridIndex()
                    local modelTile = modelTileMap:getModelTile(gridIndex)

                    if ((not modelTile.canRepairTarget) or (not modelTile:canRepairTarget(modelUnit))) then
                        if (shouldUpdateFogMap) then
                            modelFogMap:updateMapForPathsWithModelUnitAndPath(modelUnit, {gridIndex})
                        end
                        destroyActorUnitOnMap(modelSceneWar, gridIndex, true)
                        dispatcher:dispatchEvent({
                            name      = "EvtDestroyViewUnit",
                            gridIndex = gridIndex,
                        })

                        if (playerIndexActing == playerIndexLoggedIn) then
                            for _, adjacentGridIndex in pairs(getAdjacentGrids(gridIndex, mapSize)) do
                                local adjacentModelUnit = modelUnitMap:getModelUnit(adjacentGridIndex)
                                if ((adjacentModelUnit)                                                                                                                                                                     and
                                    (not isUnitVisible(modelSceneWar, adjacentGridIndex, adjacentModelUnit:getUnitType(), isModelUnitDiving(adjacentModelUnit), adjacentModelUnit:getPlayerIndex(), playerIndexActing))) then
                                    destroyActorUnitOnMap(modelSceneWar, adjacentGridIndex, true)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end

    self.m_TurnPhaseCode = TURN_PHASE_CODES.RepairUnit
end

local function runTurnPhaseRepairUnit(self)
    local repairData = self.m_RepairDataForNextTurn
    if (repairData) then
        local modelSceneWar = self.m_ModelSceneWar
        local modelUnitMap  = getModelUnitMap(modelSceneWar)

        if (repairData.onMapData) then
            for unitID, data in pairs(repairData.onMapData) do
                repairModelUnit(self, modelUnitMap:getModelUnit(data.gridIndex), data.repairAmount)
            end
        end

        if (repairData.loadedData) then
            for unitID, data in pairs(repairData.loadedData) do
                repairModelUnit(self, modelUnitMap:getLoadedModelUnitWithUnitId(unitID), data.repairAmount)
            end
        end

        getModelPlayerManager(modelSceneWar):getModelPlayer(self.m_PlayerIndex):setFund(repairData.remainingFund)
        self.m_RepairDataForNextTurn = nil
    end

    self.m_TurnPhaseCode = TURN_PHASE_CODES.SupplyUnit
end

local function runTurnPhaseSupplyUnit(self)
    local supplyData = self.m_SupplyDataForNextTurn
    if (supplyData) then
        local modelSceneWar = self.m_ModelSceneWar
        local modelUnitMap  = getModelUnitMap(modelSceneWar)
        local modelGridEffect = ((not IS_SERVER) and (not modelSceneWar:isFastExecutingActions())) and (SingletonGetters.getModelGridEffect(modelSceneWar)) or (nil)

        if (supplyData.onMapData) then
            for unitID, data in pairs(supplyData.onMapData) do
                local gridIndex = data.gridIndex
                supplyWithAmmoAndFuel(modelUnitMap:getModelUnit(gridIndex), true)
                if (modelGridEffect) then
                    modelGridEffect:showAnimationSupply(gridIndex)
                end
            end
        end

        if (supplyData.loadedData) then
            for unitID, data in pairs(supplyData.loadedData) do
                local modelUnit = modelUnitMap:getLoadedModelUnitWithUnitId(unitID)
                supplyWithAmmoAndFuel(modelUnit, true)
                if (modelGridEffect) then
                    modelGridEffect:showAnimationSupply(modelUnit:getGridIndex())
                end
            end
        end

        self.m_SupplyDataForNextTurn = nil
    end

    self.m_TurnPhaseCode = TURN_PHASE_CODES.Main
end

local function runTurnPhaseMain(self)
    local modelSceneWar    = self.m_ModelSceneWar
    local playerIndex      = self.m_PlayerIndex
    getScriptEventDispatcher(modelSceneWar):dispatchEvent({
            name        = "EvtModelPlayerUpdated",
            modelPlayer = getModelPlayerManager(modelSceneWar):getModelPlayer(playerIndex),
            playerIndex = playerIndex,
        })
        :dispatchEvent({name = "EvtModelUnitMapUpdated"})
        :dispatchEvent({name = "EvtModelTileMapUpdated"})
end

local function runTurnPhaseResetUnitState(self)
    local playerIndex      = self.m_PlayerIndex
    local func             = function(modelUnit)
        if (modelUnit:getPlayerIndex() == playerIndex) then
            modelUnit:setStateIdle()
                :updateView()
        end
    end

    getModelUnitMap(self.m_ModelSceneWar):forEachModelUnitOnMap(func)
        :forEachModelUnitLoaded(func)

    self.m_TurnPhaseCode = TURN_PHASE_CODES.ResetVisionForEndingTurnPlayer
end

local function runTurnPhaseResetVisionForEndingTurnPlayer(self)
    local modelSceneWar = self.m_ModelSceneWar
    local playerIndex   = self:getPlayerIndex()
    if (IS_SERVER) then
        getModelFogMap(modelSceneWar):resetMapForPathsForPlayerIndex(playerIndex)
    elseif ((isTotalReplay(modelSceneWar)) or (playerIndex == getPlayerIndexLoggedIn(modelSceneWar))) then
        getModelFogMap(modelSceneWar):resetMapForPathsForPlayerIndex(playerIndex)
        resetVisionOnClient(self)
    end

    self.m_TurnPhaseCode = TURN_PHASE_CODES.TickTurnAndPlayerIndex
end

local function runTurnPhaseTickTurnAndPlayerIndex(self)
    local modelPlayerManager = getModelPlayerManager(self.m_ModelSceneWar)
    self.m_TurnIndex, self.m_PlayerIndex = getNextTurnAndPlayerIndex(self, modelPlayerManager)

    getScriptEventDispatcher(self.m_ModelSceneWar):dispatchEvent({
        name        = "EvtPlayerIndexUpdated",
        playerIndex = self.m_PlayerIndex,
        modelPlayer = modelPlayerManager:getModelPlayer(self.m_PlayerIndex),
    })

    -- TODO: Change the weather.
    self.m_TurnPhaseCode = TURN_PHASE_CODES.ResetSkillState
end

local function runTurnPhaseResetSkillState(self)
    local playerIndex = self.m_PlayerIndex
    getModelPlayerManager(self.m_ModelSceneWar):getModelPlayer(playerIndex):deactivateSkillGroup()

    if (not IS_SERVER) then
        local func = function(modelUnit)
            if (modelUnit:getPlayerIndex() == playerIndex) then
                modelUnit:updateView()
            end
        end

        getModelUnitMap(self.m_ModelSceneWar):forEachModelUnitOnMap(func)
            :forEachModelUnitLoaded(func)
    end

    self.m_TurnPhaseCode = TURN_PHASE_CODES.ResetVisionForBeginningTurnPlayer
end

local function runTurnPhaseResetVisionForBeginningTurnPlayer(self)
    local modelSceneWar = self.m_ModelSceneWar
    local playerIndex   = self:getPlayerIndex()
    if (IS_SERVER) then
        getModelFogMap(modelSceneWar):resetMapForTilesForPlayerIndex(playerIndex)
            :resetMapForUnitsForPlayerIndex(playerIndex)
    elseif ((isTotalReplay(modelSceneWar)) or (playerIndex == getPlayerIndexLoggedIn(modelSceneWar))) then
        getModelFogMap(modelSceneWar):resetMapForTilesForPlayerIndex(playerIndex)
            :resetMapForUnitsForPlayerIndex(playerIndex)
        resetVisionOnClient(self)
    end

    self.m_TurnPhaseCode = TURN_PHASE_CODES.ResetVotedForDraw
end

local function runTurnPhaseResetVotedForDraw(self)
    getModelPlayerManager(self.m_ModelSceneWar):getModelPlayer(self.m_PlayerIndex):setVotedForDraw(false)

    self.m_TurnPhaseCode = TURN_PHASE_CODES.RequestToBegin
end

local function runTurnPhaseRequestToBegin(self)
    local modelSceneWar = self.m_ModelSceneWar
    if ((not IS_SERVER) and (not isTotalReplay(modelSceneWar)) and (self.m_PlayerIndex == getPlayerIndexLoggedIn(modelSceneWar))) then
        WebSocketManager.sendAction({
            actionCode = ACTION_CODE_BEGIN_TURN,
            actionID   = SingletonGetters.getActionId(self.m_ModelSceneWar) + 1,
            warID      = self.m_ModelSceneWar:getWarId(),
        })
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelTurnManager:ctor(param)
    self.m_TurnIndex     = param.turnIndex
    self.m_PlayerIndex   = param.playerIndex
    self.m_TurnPhaseCode = param.turnPhaseCode

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelTurnManager:toSerializableTable()
    return {
        turnIndex     = self:getTurnIndex(),
        playerIndex   = self:getPlayerIndex(),
        turnPhaseCode = self.m_TurnPhaseCode,
    }
end

function ModelTurnManager:toSerializableTableForPlayerIndex(playerIndex)
    return self:toSerializableTable()
end

function ModelTurnManager:toSerializableReplayData()
    return DEFAULT_TURN_DATA
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelTurnManager:onStartRunning(modelSceneWar)
    self.m_ModelSceneWar    = modelSceneWar

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelTurnManager:getTurnIndex()
    return self.m_TurnIndex
end

function ModelTurnManager:getPlayerIndex()
    return self.m_PlayerIndex
end

function ModelTurnManager:isTurnPhaseRequestToBegin()
    return self.m_TurnPhaseCode == TURN_PHASE_CODES.RequestToBegin
end

function ModelTurnManager:isTurnPhaseMain()
    return self.m_TurnPhaseCode == TURN_PHASE_CODES.Main
end

function ModelTurnManager:runTurn()
    if (self.m_TurnPhaseCode == TURN_PHASE_CODES.Beginning)                         then runTurnPhaseBeginning(                        self) end
    if (self.m_TurnPhaseCode == TURN_PHASE_CODES.GetFund)                           then runTurnPhaseGetFund(                          self) end
    if (self.m_TurnPhaseCode == TURN_PHASE_CODES.ConsumeUnitFuel)                   then runTurnPhaseConsumeUnitFuel(                  self) end
    if (self.m_TurnPhaseCode == TURN_PHASE_CODES.RepairUnit)                        then runTurnPhaseRepairUnit(                       self) end
    if (self.m_TurnPhaseCode == TURN_PHASE_CODES.SupplyUnit)                        then runTurnPhaseSupplyUnit(                       self) end
    if (self.m_TurnPhaseCode == TURN_PHASE_CODES.Main)                              then runTurnPhaseMain(                             self) end
    if (self.m_TurnPhaseCode == TURN_PHASE_CODES.ResetUnitState)                    then runTurnPhaseResetUnitState(                   self) end
    if (self.m_TurnPhaseCode == TURN_PHASE_CODES.ResetVisionForEndingTurnPlayer)    then runTurnPhaseResetVisionForEndingTurnPlayer(   self) end
    if (self.m_TurnPhaseCode == TURN_PHASE_CODES.TickTurnAndPlayerIndex)            then runTurnPhaseTickTurnAndPlayerIndex(           self) end
    if (self.m_TurnPhaseCode == TURN_PHASE_CODES.ResetSkillState)                   then runTurnPhaseResetSkillState(                  self) end
    if (self.m_TurnPhaseCode == TURN_PHASE_CODES.ResetVisionForBeginningTurnPlayer) then runTurnPhaseResetVisionForBeginningTurnPlayer(self) end
    if (self.m_TurnPhaseCode == TURN_PHASE_CODES.ResetVotedForDraw)                 then runTurnPhaseResetVotedForDraw(                self) end
    if (self.m_TurnPhaseCode == TURN_PHASE_CODES.RequestToBegin)                    then runTurnPhaseRequestToBegin(                   self) end

    if ((self.m_TurnPhaseCode == TURN_PHASE_CODES.Main) and (self.m_CallbackOnEnterTurnPhaseMainForNextTurn)) then
        self.m_CallbackOnEnterTurnPhaseMainForNextTurn()
        self.m_CallbackOnEnterTurnPhaseMainForNextTurn = nil
    end

    local modelSceneWar = self.m_ModelSceneWar
    if ((not IS_SERVER) and (not isTotalReplay(modelSceneWar))) then
        if (self:getPlayerIndex() == getPlayerIndexLoggedIn(modelSceneWar)) then
            getModelMessageIndicator(modelSceneWar):hidePersistentMessage(getLocalizedText(80, "NotInTurn"))
        else
            getModelMessageIndicator(modelSceneWar):showPersistentMessage(getLocalizedText(80, "NotInTurn"))
        end
    end

    return self
end

function ModelTurnManager:beginTurnPhaseBeginning(income, repairData, supplyData, callbackOnEnterTurnPhaseMain)
    assert(self:isTurnPhaseRequestToBegin(), "ModelTurnManager:beginTurnPhaseBeginning() invalid turn phase code: " .. self.m_TurnPhaseCode)

    self.m_IncomeForNextTurn                       = income
    self.m_RepairDataForNextTurn                   = repairData
    self.m_SupplyDataForNextTurn                   = supplyData
    self.m_CallbackOnEnterTurnPhaseMainForNextTurn = callbackOnEnterTurnPhaseMain

    runTurnPhaseBeginning(self)

    return self
end

function ModelTurnManager:endTurnPhaseMain()
    assert(self:isTurnPhaseMain(), "ModelTurnManager:endTurnPhaseMain() invalid turn phase code: " .. self.m_TurnPhaseCode)
    self.m_TurnPhaseCode = TURN_PHASE_CODES.ResetUnitState
    self:runTurn()

    return self
end

return ModelTurnManager
