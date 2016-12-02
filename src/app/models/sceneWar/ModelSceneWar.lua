
--[[--------------------------------------------------------------------------------
-- ModelSceneWar是战局场景，同时也是游戏中最重要的场景。
--
-- 主要职责和使用场景举例：
--   维护战局中的所有信息
--
-- 其他：
--  - ModelSceneWar功能很多，因此分成多个不同的子actor来共同工作。目前这些子actor包括：
--    - SceneWarHUD
--    - WarField
--    - PlayerManager
--    - TurnManager
--    - WeatherManager
--
--  - model和view的“时间差”
--    在目前的设计中，一旦收到事件，model将即时完成所有相关计算，而view将随后跨帧显示相应效果。
--    考虑服务器传来“某unit A按某路线移动后对unit B发起攻击”的事件的情况。这种情况下，在model中，unit的新的数值将马上完成结算（如hp，弹药量，消灭与否，等级等都会有更新），
--    但在view不可能立刻按model的新状态进行呈现（否则，玩家就会看到unit发生了瞬移，或是突然消失了），而必须跨帧逐步更新。
--    采取model先行结算的方式可以避免很多问题，所以后续开发应该遵守同样的规范。
--]]--------------------------------------------------------------------------------

local ModelSceneWar = require("src.global.functions.class")("ModelSceneWar")

local ActionExecutor        = require("src.app.utilities.ActionExecutor")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local TableFunctions        = require("src.app.utilities.TableFunctions")
local Actor                 = require("src.global.actors.Actor")
local EventDispatcher       = require("src.global.events.EventDispatcher")

local IS_SERVER        = require("src.app.utilities.GameConstantFunctions").isServer()
local AudioManager     = (not IS_SERVER) and (require("src.app.utilities.AudioManager"))     or (nil)
local WebSocketManager = (not IS_SERVER) and (require("src.app.utilities.WebSocketManager")) or (nil)

local IGNORED_KEYS_FOR_EXECUTED_ACTIONS = {"fileName", "actionID"}
local getLocalizedText                  = LocalizationFunctions.getLocalizedText

--------------------------------------------------------------------------------
-- The private callback function on web socket events.
--------------------------------------------------------------------------------
local function onWebSocketOpen(self, param)
    print("ModelSceneWar-onWebSocketOpen()")
    self:getModelMessageIndicator():showMessage(getLocalizedText(30))

    local modelTurnManager = self:getModelTurnManager()
    if ((modelTurnManager:getTurnPhase() == "requestToBegin")                                         and
        (modelTurnManager:getPlayerIndex() == self:getModelPlayerManager():getPlayerIndexLoggedIn())) then
        modelTurnManager:runTurn()
    else
        WebSocketManager.sendAction({
            actionName = "GetSceneWarActionId",
            fileName   = self:getFileName(),
        })
    end
end

local function onWebSocketMessage(self, param)
    print("ModelSceneWar-onWebSocketMessage():\n" .. param.message)
    self:executeAction(param.action)
end

local function onWebSocketClose(self, param)
    print("ModelSceneWar-onWebSocketClose()")
    self:getModelMessageIndicator():showMessage(getLocalizedText(31))
end

local function onWebSocketError(self, param)
    print("ModelSceneWar-onWebSocketError()")
    self:getModelMessageIndicator():showMessage(getLocalizedText(32, param.error))
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initScriptEventDispatcher(self)
    local dispatcher = EventDispatcher:create()

    self.m_ScriptEventDispatcher = dispatcher
end

local function initActorConfirmBox(self)
    local actor = Actor.createWithModelAndViewName("common.ModelConfirmBox", nil, "common.ViewConfirmBox")
    actor:getModel():setEnabled(false)

    self.m_ActorConfirmBox = actor
end

local function initActorMessageIndicator(self)
    local actor = Actor.createWithModelAndViewName("common.ModelMessageIndicator", nil, "common.ViewMessageIndicator")

    self.m_ActorMessageIndicator = actor
end

local function initActorPlayerManager(self, playersData)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelPlayerManager", playersData)

    self.m_ActorPlayerManager = actor
end

local function initActorWeatherManager(self, weatherData)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelWeatherManager", weatherData)

    self.m_ActorWeatherManager = actor
end

local function initActorWarField(self, warFieldData)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelWarField", warFieldData, "sceneWar.ViewWarField")

    self.m_ActorWarField = actor
end

local function initActorWarHud(self)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelWarHUD", nil, "sceneWar.ViewWarHUD")

    self.m_ActorWarHud = actor
end

local function initActorTurnManager(self, turnData)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelTurnManager", turnData, "sceneWar.ViewTurnManager")

    self.m_ActorTurnManager = actor
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelSceneWar:ctor(sceneData)
    self.m_ActionID            = sceneData.actionID
    self.m_ExecutedActions     = sceneData.executedActions
    self.m_FileName            = sceneData.fileName
    self.m_IsWarEnded          = sceneData.isEnded
    self.m_IsFogOfWarByDefault = sceneData.isFogOfWarByDefault
    self.m_IsTotalReplay       = sceneData.isTotalReplay
    self.m_MaxSkillPoints      = sceneData.maxSkillPoints
    self.m_WarPassword         = sceneData.warPassword
    self.m_CachedActions       = {}

    initScriptEventDispatcher(self)
    initActorPlayerManager(   self, sceneData.players)
    initActorWeatherManager(  self, sceneData.weather)
    initActorWarField(        self, sceneData.warField, sceneData.isTotalReplay)
    initActorTurnManager(     self, sceneData.turn)
    if (not IS_SERVER) then
        initActorConfirmBox(      self)
        initActorMessageIndicator(self)
        initActorWarHud(          self)
    end

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelSceneWar:initView()
    assert(self.m_View, "ModelSceneWar:initView() no view is attached to the owner actor of the model.")
    self.m_View:setViewConfirmBox(self.m_ActorConfirmBox      :getView())
        :setViewWarField(         self.m_ActorWarField        :getView())
        :setViewWarHud(           self.m_ActorWarHud          :getView())
        :setViewTurnManager(      self.m_ActorTurnManager     :getView())
        :setViewMessageIndicator( self.m_ActorMessageIndicator:getView())

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelSceneWar:toSerializableTable()
    return {
        fileName            = self.m_FileName,
        warPassword         = self.m_WarPassword,
        isEnded             = self.m_IsWarEnded,
        isFogOfWarByDefault = self.m_IsFogOfWarByDefault,
        actionID            = self.m_ActionID,
        executedActions     = self.m_ExecutedActions,
        maxSkillPoints      = self.m_MaxSkillPoints,
        warField            = self:getModelWarField()      :toSerializableTable(),
        turn                = self:getModelTurnManager()   :toSerializableTable(),
        players             = self:getModelPlayerManager() :toSerializableTable(),
        weather             = self:getModelWeatherManager():toSerializableTable(),
    }
end

function ModelSceneWar:toSerializableTableForPlayerIndex(playerIndex)
    return {
        fileName            = self.m_FileName,
        warPassword         = self.m_WarPassword,
        isEnded             = self.m_IsWarEnded,
        isFogOfWarByDefault = self.m_IsFogOfWarByDefault,
        actionID            = self.m_ActionID,
        maxSkillPoints      = self.m_MaxSkillPoints,
        warField            = self:getModelWarField()      :toSerializableTableForPlayerIndex(playerIndex),
        turn                = self:getModelTurnManager()   :toSerializableTableForPlayerIndex(playerIndex),
        players             = self:getModelPlayerManager() :toSerializableTableForPlayerIndex(playerIndex),
        weather             = self:getModelWeatherManager():toSerializableTableForPlayerIndex(playerIndex),
    }
end

function ModelSceneWar:toSerializableReplayData()
    return {
        fileName            = self.m_FileName,
        isFogOfWarByDefault = self.m_IsFogOfWarByDefault,
        isTotalReplay       = true,
        executedActions     = self.m_ExecutedActions,
        maxSkillPoints      = self.m_MaxSkillPoints,
        warField            = self:getModelWarField()      :toSerializableReplayData(),
        turn                = self:getModelTurnManager()   :toSerializableReplayData(),
        players             = self:getModelPlayerManager() :toSerializableReplayData(),
        weather             = self:getModelWeatherManager():toSerializableReplayData(),
    }
end

--------------------------------------------------------------------------------
-- The callback functions on start/stop running and script events.
--------------------------------------------------------------------------------
function ModelSceneWar:onStartRunning()
    local sceneWarFileName = self:getFileName()
    local modelTurnManager = self:getModelTurnManager()
    if (not IS_SERVER) then
        self:getModelWarHud():onStartRunning(sceneWarFileName)
    end
    modelTurnManager            :onStartRunning(sceneWarFileName)
    self:getModelPlayerManager():onStartRunning(sceneWarFileName)
    self:getModelWarField()     :onStartRunning(sceneWarFileName)

    self:getScriptEventDispatcher():dispatchEvent({name = "EvtSceneWarStarted"})

    modelTurnManager:runTurn()
    if (not IS_SERVER) then
        AudioManager.playRandomWarMusic()
    end

    return self
end

function ModelSceneWar:onStopRunning()
    return self
end

function ModelSceneWar:onWebSocketEvent(eventName, param)
    if     (eventName == "open")    then onWebSocketOpen(   self, param)
    elseif (eventName == "message") then onWebSocketMessage(self, param)
    elseif (eventName == "close")   then onWebSocketClose(  self, param)
    elseif (eventName == "error")   then onWebSocketError(  self, param)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelSceneWar:executeAction(action)
    ActionExecutor.execute(action)
    if ((IS_SERVER) and (self.m_ExecutedActions)) then
        self.m_ExecutedActions[self.m_ActionID] = TableFunctions.clone(action, IGNORED_KEYS_FOR_EXECUTED_ACTIONS)
    end

    return self
end

function ModelSceneWar:isExecutingAction()
    return self.m_IsExecutingAction
end

function ModelSceneWar:setExecutingAction(executing)
    self.m_IsExecutingAction = executing
    if ((not executing) and (not self:isEnded())) then
        local actionID = self:getActionId() + 1
        local action   = self.m_CachedActions[actionID]
        if (action) then
            self.m_CachedActions[actionID] = nil
            self:executeAction(action)
        end
    end

    return self
end

function ModelSceneWar:cacheAction(action)
    local actionID = action.actionID
    if (actionID > self:getActionId()) then
        self.m_CachedActions[actionID] = action
    end

    return self
end

function ModelSceneWar:getActionId()
    return self.m_ActionID
end

function ModelSceneWar:setActionId(actionID)
    self.m_ActionID = actionID

    return self
end

function ModelSceneWar:getFileName()
    return self.m_FileName
end

function ModelSceneWar:isEnded()
    return self.m_IsWarEnded
end

function ModelSceneWar:isFogOfWarByDefault()
    return self.m_IsFogOfWarByDefault
end

function ModelSceneWar:setEnded(ended)
    self.m_IsWarEnded = ended

    return self
end

function ModelSceneWar:canReplay()
    return (self:isEnded()) and (self.m_ExecutedActions ~= nil)
end

function ModelSceneWar:isTotalReplay()
    return self.m_IsTotalReplay
end

function ModelSceneWar:getModelConfirmBox()
    return self.m_ActorConfirmBox:getModel()
end

function ModelSceneWar:getModelMessageIndicator()
    return self.m_ActorMessageIndicator:getModel()
end

function ModelSceneWar:getModelTurnManager()
    return self.m_ActorTurnManager:getModel()
end

function ModelSceneWar:getModelPlayerManager()
    return self.m_ActorPlayerManager:getModel()
end

function ModelSceneWar:getModelWeatherManager()
    return self.m_ActorWeatherManager:getModel()
end

function ModelSceneWar:getModelWarField()
    return self.m_ActorWarField:getModel()
end

function ModelSceneWar:getModelWarHud()
    return self.m_ActorWarHud:getModel()
end

function ModelSceneWar:getScriptEventDispatcher()
    return self.m_ScriptEventDispatcher
end

function ModelSceneWar:showEffectSurrender(callback)
    assert(not IS_SERVER, "ModelSceneWar:showEffectSurrender() should not be invoked on the server.")
    self.m_View:showEffectSurrender(callback)

    return self
end

function ModelSceneWar:showEffectWin(callback)
    assert(not IS_SERVER, "ModelSceneWar:showEffectWin() should not be invoked on the server.")
    self.m_View:showEffectWin(callback)

    return self
end

function ModelSceneWar:showEffectLose(callback)
    assert(not IS_SERVER, "ModelSceneWar:showEffectLose() should not be invoked on the server.")
    self.m_View:showEffectLose(callback)

    return self
end

return ModelSceneWar
