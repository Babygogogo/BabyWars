
--[[--------------------------------------------------------------------------------
-- ModelTurnManager是战局中的回合控制器。
--
-- 主要职责和使用场景举例：
--   维护相关数值（如当前回合数、回合阶段、当前活动玩家序号PlayerIndex等），提供接口给外界访问
--
-- 其他：
--   - 一个回合包括以下阶段（以发生顺序排序，可能还有未列出的）
--     - 初始阶段（EvtTurnPhaseBeginning，通过此event使得begin turn effect（也就是回合初弹出的消息框）出现）
--     - 计算玩家收入（EvtTurnPhaseGetFund）
--     - 消耗unit燃料（EvtTurnPhaseConsumeUnitFuel，符合特定条件的unit会随之毁灭）
--     - 维修unit（EvtTurnPhaseRepairUnit，指的是tile对unit的维修和补给）
--     - 补给unit（EvtTurnPhaseSupplyUnit，指的是unit对unit的补给，目前未实现）
--     - 主要阶段（EvtTurnPhaseMain，即玩家可以进行操作的阶段）
--     - 恢复unit状态（EvtTurnPhaseResetUnitState，即玩家结束回合后，使得移动过的unit恢复为可移动的状态；切换活动玩家，确保当前玩家不能再次操控unit）
--     - 更换weather（EvtTurnPhaseChangeWeather，目前未实现。具体切换与否，由ModelWeatherManager决定）
--]]--------------------------------------------------------------------------------

local ModelTurnManager = class("ModelTurnManager")
local TableFunctions   = require("app.utilities.TableFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getNextTurnAndPlayerIndex(self, playerManager)
    local nextTurnIndex   = self.m_TurnIndex
    local nextPlayerIndex = self.m_PlayerIndex + 1

    while (true) do
        if (nextPlayerIndex > playerManager:getPlayersCount()) then
            nextPlayerIndex = 1
            nextTurnIndex   = nextTurnIndex + 1
        end

        assert(nextPlayerIndex ~= self.m_PlayerIndex, "ModelTurnManager-getNextTurnAndPlayerIndex() the number of alive players is less than 2.")

        if (playerManager:getModelPlayer(nextPlayerIndex):isAlive()) then
            return nextTurnIndex, nextPlayerIndex
        end
    end
end

local function serializeTurnIndexToStringList(self, spaces)
    return {string.format('%sturnIndex = %d', spaces or "", self:getTurnIndex())}
end

local function serializePlayerIndexToStringList(self, spaces)
    return {string.format('%splayerIndex = %d', spaces or "", self:getPlayerIndex())}
end

local function serializeTurnPhaseToStringList(self, spaces)
    return {string.format('%sphase = %q', spaces or "", self:getTurnPhase())}
end

--------------------------------------------------------------------------------
-- The functions that runs each turn phase.
--------------------------------------------------------------------------------
local function runTurnPhaseBeginning(self)
    local modelPlayer = self.m_ModelPlayerManager:getModelPlayer(self.m_PlayerIndex)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name        = "EvtTurnPhaseBeginning",
        modelPlayer = modelPlayer,
        playerIndex = self.m_PlayerIndex,
        turnIndex   = self.m_TurnIndex,
    })

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
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name         = "EvtTurnPhaseGetFund",
        playerIndex  = self.m_PlayerIndex,
        modelTileMap = self.m_ModelWarField:getModelTileMap(),
    })
    self.m_TurnPhase = "consumeUnitFuel"
end

local function runTurnPhaseConsumeUnitFuel(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name         = "EvtTurnPhaseConsumeUnitFuel",
        playerIndex  = self.m_PlayerIndex,
        turnIndex    = self.m_TurnIndex,
        modelTileMap = self.m_ModelWarField:getModelTileMap(),
    })
    self.m_TurnPhase = "repairUnit"
end

local function runTurnPhaseRepairUnit(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name         = "EvtTurnPhaseRepairUnit",
        playerIndex  = self.m_PlayerIndex,
        modelTileMap = self.m_ModelWarField:getModelTileMap(),
        modelUnitMap = self.m_ModelWarField:getModelUnitMap(),
    })
    self.m_TurnPhase = "main"
end

local function runTurnPhaseMain(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name        = "EvtTurnPhaseMain",
        playerIndex = self.m_PlayerIndex,
        modelPlayer = self.m_ModelPlayerManager:getModelPlayer(self.m_PlayerIndex),
    })
end

local function runTurnPhaseResetUnitState(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name        = "EvtTurnPhaseResetUnitState",
        playerIndex = self.m_PlayerIndex,
        turnIndex   = self.m_TurnIndex
    })
    self.m_TurnPhase = "tickTurnAndPlayerIndex"
end

local function runTurnPhaseTickTurnAndPlayerIndex(self)
    self.m_TurnIndex, self.m_PlayerIndex = getNextTurnAndPlayerIndex(self, self.m_ModelPlayerManager)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name        = "EvtPlayerIndexUpdated",
        playerIndex = self.m_PlayerIndex,
    })

    -- TODO: Change the vision, weather and so on.
    self.m_TurnPhase = "beginning"
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

function ModelTurnManager:setModelPlayerManager(playerManager)
    assert(self.m_ModelPlayerManager == nil, "ModelTurnManager:setModelPlayerManager() the manager has been set.")
    self.m_ModelPlayerManager = playerManager

    return self
end

function ModelTurnManager:setModelWarField(warField)
    assert(self.m_ModelWarField == nil, "ModelTurnManager:setModelWarField() the model has been set.")
    self.m_ModelWarField = warField

    return self
end

function ModelTurnManager:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelTurnManager:setRootScriptEventDispatcher() the dispatcher has been set.")
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

function ModelTurnManager:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelTurnManager:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelTurnManager:toStringList(spaces)
    spaces = spaces or ""
    local subSpaces = spaces .. "    "
    local appendList = TableFunctions.appendList

    local strList = {spaces .. "turn = {\n"}
    appendList(strList, serializeTurnIndexToStringList(  self, subSpaces), ",\n")
    appendList(strList, serializePlayerIndexToStringList(self, subSpaces), ",\n")
    appendList(strList, serializeTurnPhaseToStringList(  self, subSpaces), "\n" .. spaces .. "}")

    return strList
end

function ModelTurnManager:toSerializableTable()
    return {
        turnIndex   = self:getTurnIndex(),
        playerIndex = self:getPlayerIndex(),
        phase       = self:getTurnPhase(),
    }
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelTurnManager:doActionBeginTurn(action)
    assert(self.m_TurnPhase == "beginning", "ModelTurnManager:doActionBeginTurn() the turn phase is expected to be 'beginning'.")

    runTurnPhaseBeginning(self)

    return self
end

function ModelTurnManager:doActionEndTurn(action)
    assert(self.m_TurnPhase == "main", "ModelTurnManager:endTurn() the turn phase is expected to be 'main'.")

    self.m_TurnPhase = "resetUnitState"
    self:runTurn()

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
    if (self.m_TurnPhase == "beginning") then
        self.m_RootScriptEventDispatcher:dispatchEvent({
            name       = "EvtPlayerRequestDoAction",
            actionName = "BeginTurn",
        })
        return self
    end

    if (self.m_TurnPhase == "getFund") then
        runTurnPhaseGetFund(self)
    end

    if (self.m_TurnPhase == "consumeUnitFuel") then
        runTurnPhaseConsumeUnitFuel(self)
    end

    if (self.m_TurnPhase == "repairUnit") then
        runTurnPhaseRepairUnit(self)
    end

    if (self.m_TurnPhase == "main") then
        runTurnPhaseMain(self)
    end

    if (self.m_TurnPhase == "resetUnitState") then
        runTurnPhaseResetUnitState(self)
    end

    if (self.m_TurnPhase == "tickTurnAndPlayerIndex") then
        runTurnPhaseTickTurnAndPlayerIndex(self)
    end

    return self
end

return ModelTurnManager
