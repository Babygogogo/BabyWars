
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

local ModelSceneWar = requireBW("src.global.functions.class")("ModelSceneWar")

local ActionCodeFunctions    = requireBW("src.app.utilities.ActionCodeFunctions")
local ActionExecutor         = requireBW("src.app.utilities.ActionExecutor")
local LocalizationFunctions  = requireBW("src.app.utilities.LocalizationFunctions")
local SerializationFunctions = requireBW("src.app.utilities.SerializationFunctions")
local TableFunctions         = requireBW("src.app.utilities.TableFunctions")
local Actor                  = requireBW("src.global.actors.Actor")
local EventDispatcher        = requireBW("src.global.events.EventDispatcher")

local IS_SERVER        = requireBW("src.app.utilities.GameConstantFunctions").isServer()
local AudioManager     = (not IS_SERVER) and (requireBW("src.app.utilities.AudioManager"))     or (nil)
local WebSocketManager = (not IS_SERVER) and (requireBW("src.app.utilities.WebSocketManager")) or (nil)

local ipairs, next     = ipairs, next
local getLocalizedText = LocalizationFunctions.getLocalizedText

local IGNORED_KEYS_FOR_EXECUTED_ACTIONS = {"warID", "actionID"}
local TIME_INTERVAL_FOR_ACTIONS         = 1

--------------------------------------------------------------------------------
-- The private callback function on web socket events.
--------------------------------------------------------------------------------
local function onWebSocketOpen(self, param)
    print("ModelSceneWar-onWebSocketOpen()")
    self:getModelMessageIndicator():showMessage(getLocalizedText(30, "ConnectionEstablished"))

    if (not self:isTotalReplay()) then
        local modelTurnManager = self:getModelTurnManager()
        if ((modelTurnManager:isTurnPhaseRequestToBegin())                                                and
            (modelTurnManager:getPlayerIndex() == self:getModelPlayerManager():getPlayerIndexLoggedIn())) then
            modelTurnManager:runTurn()
        else
            WebSocketManager.sendAction({
                actionCode       = ActionCodeFunctions.getActionCode("ActionSyncSceneWar"),
                actionID         = self:getActionId(),
                warID            = self:getWarId(),
            })
        end
    end
end

local function onWebSocketMessage(self, param)
    local actionCode = param.action.actionCode
    print(string.format("ModelSceneWar-onWebSocketMessage() code: %d  name: %s  length: %d",
        actionCode,
        ActionCodeFunctions.getActionName(actionCode),
        string.len(param.message))
    )
    print(SerializationFunctions.toString(param.action))

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
-- The private functions for actions.
--------------------------------------------------------------------------------
local function setActionId(self, actionID)
    assert(math.floor(actionID) == actionID, "ModelSceneWar-setActionId() invalid actionID: " .. (actionID or ""))
    self.m_ActionID = actionID
end

local function cacheAction(self, action)
    local actionID = action.actionID
    assert(not IS_SERVER,                 "ModelSceneWar-cacheAction() this should not happen on the server.")
    assert(not self:isTotalReplay(),      "ModelSceneWar-cacheAction() this should not happen when replaying.")
    assert(actionID > self:getActionId(), "ModelSceneWar-cacheAction() the action to be cached has been executed already.")

    self.m_CachedActions[actionID] = action

    return self
end

local function executeReplayAction(self)
    assert(self:isTotalReplay(), "ModelSceneWar-executeReplayAction() the scene is not in replay mode.")
    assert(not self:isExecutingAction(), "ModelSceneWar-executeReplayAction() another action is being executed.")

    self.m_ExecutedActionsCount = self.m_ExecutedActionsCount or #self.m_ExecutedActions
    local actionID  = self:getActionId() + 1
    local _, action = next(self.m_ExecutedActions[actionID])
    if (not action) then
        self:getModelMessageIndicator():showMessage(getLocalizedText(11, "NoMoreReplayActions"))
    else
        self:getModelWarField():getModelActionPlanner():setStateIdle(true)
        self:getModelMessageIndicator():showMessage(string.format("%s: %d / %d (%s)",
            getLocalizedText(11, "Progress"),
            actionID,
            self.m_ExecutedActionsCount,
            getLocalizedText(12, ActionCodeFunctions.getActionName(action.actionCode))
        ))

        action.actionID = actionID
        setActionId(self, actionID)

        ActionExecutor.execute(action, self)
    end

    return self
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initScriptEventDispatcher(self)
    self.m_ScriptEventDispatcher = EventDispatcher:create()
end

local function initActorChatManager(self, chatData)
    if (not self.m_ActorChatManager) then
        self.m_ActorChatManager = Actor.createWithModelAndViewName("sceneWar.ModelChatManager", chatData, "sceneWar.ViewChatManager")
        self.m_ActorChatManager:getModel():setEnabled(false)
    end
end

local function initActorConfirmBox(self)
    if (not self.m_ActorConfirmBox) then
        local actor = Actor.createWithModelAndViewName("common.ModelConfirmBox", nil, "common.ViewConfirmBox")
        actor:getModel():setEnabled(false)

        self.m_ActorConfirmBox = actor
    end
end

local function initActorMessageIndicator(self)
    if (not self.m_ActorMessageIndicator) then
        self.m_ActorMessageIndicator = Actor.createWithModelAndViewName("common.ModelMessageIndicator", nil, "common.ViewMessageIndicator")
    end
end

local function initActorPlayerManager(self, playersData)
    if (not self.m_ActorPlayerManager) then
        self.m_ActorPlayerManager = Actor.createWithModelAndViewName("sceneWar.ModelPlayerManager", playersData)
    else
        self.m_ActorPlayerManager:getModel():ctor(playersData)
    end
end

local function initActorWeatherManager(self, weatherData)
    if (not self.m_ActorWeatherManager) then
        self.m_ActorWeatherManager = Actor.createWithModelAndViewName("sceneWar.ModelWeatherManager", weatherData)
    else
        self.m_ActorWeatherManager:getModel():ctor(weatherData)
    end
end

local function initActorWarField(self, warFieldData, isTotalReplay)
    if (not self.m_ActorWarField) then
        local modelWarField  = Actor.createModel("sceneWar.ModelWarField", warFieldData, isTotalReplay)
        local viewWarField   = (not IS_SERVER) and (Actor.createView("sceneWar.ViewWarField")) or (nil)
        self.m_ActorWarField = Actor.createWithModelAndViewInstance(modelWarField, viewWarField)
    else
        self.m_ActorWarField:getModel():ctor(warFieldData, isTotalReplay)
    end
end

local function initActorWarHud(self, isReplay)
    if (not self.m_ActorWarHud) then
        self.m_ActorWarHud = Actor.createWithModelAndViewName("sceneWar.ModelWarHUD", isReplay, "sceneWar.ViewWarHUD")
    else
        self.m_ActorWarHud:getModel():ctor(isReplay)
    end
end

local function initActorTurnManager(self, turnData)
    if (not self.m_ActorTurnManager) then
        self.m_ActorTurnManager = Actor.createWithModelAndViewName("sceneWar.ModelTurnManager", turnData, "sceneWar.ViewTurnManager")
    else
        self.m_ActorTurnManager:getModel():ctor(turnData)
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelSceneWar:ctor(sceneData)
    self.m_CachedActions         = {}
    self.m_AttackModifier        = sceneData.attackModifier        or 0
    self.m_EnergyGainModifier    = sceneData.energyGainModifier    or 100
    self.m_EnterTurnTime         = sceneData.enterTurnTime
    self.m_ExecutedActions       = sceneData.executedActions
    self.m_IncomeModifier        = sceneData.incomeModifier        or 100
    self.m_IntervalUntilBoot     = sceneData.intervalUntilBoot
    self.m_IsWarEnded            = sceneData.isWarEnded
    self.m_IsFogOfWarByDefault   = sceneData.isFogOfWarByDefault
    self.m_IsRandomWarField      = sceneData.isRandomWarField
    self.m_IsRankMatch           = sceneData.isRankMatch
    self.m_IsTotalReplay         = sceneData.isTotalReplay
    self.m_MaxBaseSkillPoints    = sceneData.maxBaseSkillPoints
    self.m_MaxDiffScore          = sceneData.maxDiffScore
    self.m_MoveRangeModifier     = sceneData.moveRangeModifier     or 0
    self.m_RemainingVotesForDraw = sceneData.remainingVotesForDraw
    self.m_StartingFund          = sceneData.startingFund          or 0
    self.m_WarID                 = sceneData.warID
    self.m_WarPassword           = sceneData.warPassword
    setActionId(self, sceneData.actionID)

    initScriptEventDispatcher(self)
    initActorChatManager(     self, sceneData.chatData)
    initActorPlayerManager(   self, sceneData.players)
    initActorWeatherManager(  self, sceneData.weather)
    initActorWarField(        self, sceneData.warField, sceneData.isTotalReplay)
    initActorTurnManager(     self, sceneData.turn)

    if (not IS_SERVER) then
        initActorConfirmBox(      self)
        initActorMessageIndicator(self)
        initActorWarHud(          self, sceneData.isTotalReplay)
    end

    return self
end

function ModelSceneWar:initView()
    assert(self.m_View, "ModelSceneWar:initView() no view is attached to the owner actor of the model.")
    self.m_View:setViewChatManager(self.m_ActorChatManager     :getView())
        :setViewConfirmBox(        self.m_ActorConfirmBox      :getView())
        :setViewWarField(          self.m_ActorWarField        :getView())
        :setViewWarHud(            self.m_ActorWarHud          :getView())
        :setViewTurnManager(       self.m_ActorTurnManager     :getView())
        :setViewMessageIndicator(  self.m_ActorMessageIndicator:getView())

    return self
end

function ModelSceneWar:initWarDataForEachTurn()
    assert((self:isTotalReplay()) and (not self.m_WarDataForEachTurn) and (self:getActionId() == 0))

    self.m_IsFastExecutingActions = true
    self:onStartRunning()

    local modelTurnManager           = self:getModelTurnManager()
    local turnCounter                = 0
    local turnCounterForEachActionID = {[0] = 0}
    local warDataForEachTurn         = {}

    for actionID, wrappedAction in ipairs(self.m_ExecutedActions) do
        if (modelTurnManager:isTurnPhaseRequestToBegin()) then
            turnCounter = turnCounter + 1
            warDataForEachTurn[turnCounter]          = self:toSerializableTable()
            turnCounterForEachActionID[actionID - 1] = turnCounterForEachActionID[actionID - 1] + 1
        end
        turnCounterForEachActionID[actionID] = turnCounter

        local _, action = next(wrappedAction)
        setActionId(self, actionID)
        ActionExecutor.execute(action, self)
    end

    self.m_IsFastExecutingActions     = false
    self.m_TurnCounterForEachActionID = turnCounterForEachActionID
    self.m_WarDataForEachTurn         = warDataForEachTurn
    self.m_WarDataCount               = #warDataForEachTurn
    self:ctor(warDataForEachTurn[1])

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelSceneWar:toSerializableTable()
    return {
        actionID              = self:getActionId(),
        attackModifier        = self.m_AttackModifier,
        energyGainModifier    = self.m_EnergyGainModifier,
        enterTurnTime         = self.m_EnterTurnTime,
        executedActions       = self.m_ExecutedActions,
        incomeModifier        = self.m_IncomeModifier,
        intervalUntilBoot     = self.m_IntervalUntilBoot,
        isFogOfWarByDefault   = self.m_IsFogOfWarByDefault,
        isRandomWarField      = self.m_IsRandomWarField,
        isRankMatch           = self.m_IsRankMatch,
        isTotalReplay         = self.m_IsTotalReplay,
        isWarEnded            = self.m_IsWarEnded,
        maxBaseSkillPoints    = self.m_MaxBaseSkillPoints,
        maxDiffScore          = self.m_MaxDiffScore,
        moveRangeModifier     = self.m_MoveRangeModifier,
        remainingVotesForDraw = self.m_RemainingVotesForDraw,
        startingFund          = self.m_StartingFund,
        warID                 = self.m_WarID,
        warPassword           = self.m_WarPassword,
        chatData              = self:getModelChatManager()   :toSerializableTable(),
        players               = self:getModelPlayerManager() :toSerializableTable(),
        turn                  = self:getModelTurnManager()   :toSerializableTable(),
        warField              = self:getModelWarField()      :toSerializableTable(),
        weather               = self:getModelWeatherManager():toSerializableTable(),
    }
end

function ModelSceneWar:toSerializableTableForPlayerIndex(playerIndex)
    return {
        actionID              = self:getActionId(),
        attackModifier        = self.m_AttackModifier,
        energyGainModifier    = self.m_EnergyGainModifier,
        enterTurnTime         = self.m_EnterTurnTime,
        executedActions       = nil,
        incomeModifier        = self.m_IncomeModifier,
        intervalUntilBoot     = self.m_IntervalUntilBoot,
        isFogOfWarByDefault   = self.m_IsFogOfWarByDefault,
        isRandomWarField      = self.m_IsRandomWarField,
        isRankMatch           = self.m_IsRankMatch,
        isTotalReplay         = false,
        isWarEnded            = self.m_IsWarEnded,
        maxBaseSkillPoints    = self.m_MaxBaseSkillPoints,
        maxDiffScore          = self.m_MaxDiffScore,
        moveRangeModifier     = self.m_MoveRangeModifier,
        remainingVotesForDraw = self.m_RemainingVotesForDraw,
        startingFund          = self.m_StartingFund,
        warID                 = self.m_WarID,
        warPassword           = self.m_WarPassword,
        chatData              = self:getModelChatManager()   :toSerializableTableForPlayerIndex(playerIndex),
        players               = self:getModelPlayerManager() :toSerializableTableForPlayerIndex(playerIndex),
        turn                  = self:getModelTurnManager()   :toSerializableTableForPlayerIndex(playerIndex),
        warField              = self:getModelWarField()      :toSerializableTableForPlayerIndex(playerIndex),
        weather               = self:getModelWeatherManager():toSerializableTableForPlayerIndex(playerIndex),
    }
end

function ModelSceneWar:toSerializableReplayData()
    return {
        actionID              = 0,
        attackModifier        = self.m_AttackModifier,
        energyGainModifier    = self.m_EnergyGainModifier,
        enterTurnTime         = nil,
        executedActions       = self.m_ExecutedActions,
        incomeModifier        = self.m_IncomeModifier,
        intervalUntilBoot     = self.m_IntervalUntilBoot,
        isFogOfWarByDefault   = self.m_IsFogOfWarByDefault,
        isRandomWarField      = self.m_IsRandomWarField,
        isRankMatch           = self.m_IsRankMatch,
        isTotalReplay         = true,
        isWarEnded            = false,
        maxBaseSkillPoints    = self.m_MaxBaseSkillPoints,
        maxDiffScore          = self.m_MaxDiffScore,
        moveRangeModifier     = self.m_MoveRangeModifier,
        remainingVotesForDraw = nil,
        startingFund          = self.m_StartingFund,
        warID                 = self.m_WarID,
        warPassword           = self.m_WarPassword,
        chatData              = nil,
        players               = self:getModelPlayerManager() :toSerializableReplayData(),
        turn                  = self:getModelTurnManager()   :toSerializableReplayData(),
        warField              = self:getModelWarField()      :toSerializableReplayData(),
        weather               = self:getModelWeatherManager():toSerializableReplayData(),
    }
end

--------------------------------------------------------------------------------
-- The callback functions on start/stop running and script events.
--------------------------------------------------------------------------------
function ModelSceneWar:onStartRunning(ignoreWarMusic)
    local modelTurnManager = self:getModelTurnManager()
    modelTurnManager            :onStartRunning(self)
    self:getModelPlayerManager():onStartRunning(self)
    self:getModelChatManager()  :onStartRunning(self)
    self:getModelWarField()     :onStartRunning(self)
    if (not IS_SERVER) then
        self:getModelWarHud():onStartRunning(self)
    end

    self:getScriptEventDispatcher():dispatchEvent({name = "EvtSceneWarStarted"})

    if (not self:isTotalReplay()) then
        modelTurnManager:runTurn()
    end
    if ((not IS_SERVER) and (not ignoreWarMusic)) then
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
-- The public functions/accessors.
--------------------------------------------------------------------------------
ModelSceneWar.isModelSceneWar = true

function ModelSceneWar:executeAction(action)
    local warID        = action.warID
    local actionID     = action.actionID
    local selfActionID = self:getActionId()
    if (IS_SERVER) then
        assert(warID == self:getWarId(),  "ModelSceneWar:executeAction() invalid action.warID:" .. (warID or ""))
        assert(actionID == selfActionID + 1, "ModelSceneWar:executeAction() invalid action.actionID:" .. (actionID or ""))
        assert(not self:isExecutingAction(), "ModelSceneWar:executeAction() another action is being executed. This should not happen.")

        setActionId(self, actionID)
        ActionExecutor.execute(action, self)

        if (self.m_ExecutedActions) then
            self.m_ExecutedActions[actionID] = {
                [ActionCodeFunctions.getActionName(action.actionCode)] = TableFunctions.clone(action, IGNORED_KEYS_FOR_EXECUTED_ACTIONS)
            }
        end

    elseif (not warID) then
        ActionExecutor.execute(action, self)

    elseif (warID ~= self:getWarId()) then
        -- The action is not for this war. Do nothing.

    elseif (not actionID) then
        ActionExecutor.execute(action, self)

    elseif ((actionID <= selfActionID) or (self:isEnded())) then
        -- The action has been executed already, or the war is ended for the client. Do nothing.

    elseif ((actionID > selfActionID + 1) or (self:isExecutingAction())) then
        cacheAction(self, action)

    else
        setActionId(self, actionID)
        ActionExecutor.execute(action, self)
    end

    return self
end

function ModelSceneWar:isAutoReplay()
    assert(self:isTotalReplay(), "ModelSceneWar:isAutoReplay() it's not in replay mode.")
    return self.m_IsAutoReplay
end

function ModelSceneWar:setAutoReplay(isAuto)
    assert(self:isTotalReplay(), "ModelSceneWar:setAutoReplay() it's not in replay mode.")
    self.m_IsAutoReplay = isAuto

    if ((isAuto) and (not self:isExecutingAction())) then
        executeReplayAction(self)
    end

    return self
end

function ModelSceneWar:isExecutingAction()
    return self.m_IsExecutingAction
end

function ModelSceneWar:isFastExecutingActions()
    return self.m_IsFastExecutingActions
end

function ModelSceneWar:canFastForwardForReplay()
    assert(self:isTotalReplay(), "ModelSceneWar:canFastForwardForReplay() this may be invoked in replay only.")
    return self.m_TurnCounterForEachActionID[self:getActionId()] < #self.m_WarDataForEachTurn
end

function ModelSceneWar:canFastRewindForReplay()
    assert(self:isTotalReplay(), "ModelSceneWar:canFastRewindForReplay() this may be invoked in replay only.")
    return self:getActionId() > 0
end

function ModelSceneWar:fastForwardForReplay()
    self:getModelWarField():getModelActionPlanner():setStateIdle(true)

    local warDataIndex = self.m_TurnCounterForEachActionID[self:getActionId()] + 1
    self:ctor(self.m_WarDataForEachTurn[warDataIndex])
        :onStartRunning(true)

    self.m_IsExecutingAction = false
    self:getModelMessageIndicator():showMessage(string.format("%s: %d/ %d", getLocalizedText(11, "SwitchTurn"), warDataIndex, self.m_WarDataCount))

    return self
end

function ModelSceneWar:fastRewindForReplay()
    self:getModelWarField():getModelActionPlanner():setStateIdle(true)

    local actionID     = self:getActionId()
    local warDataIndex = self.m_TurnCounterForEachActionID[actionID]
    if (warDataIndex > self.m_TurnCounterForEachActionID[actionID - 1]) then
        warDataIndex = warDataIndex - 1
    end

    self.m_IsExecutingAction = false
    self:ctor(self.m_WarDataForEachTurn[warDataIndex])
        :onStartRunning(true)

    self:getModelMessageIndicator():showMessage(string.format("%s: %d/ %d", getLocalizedText(11, "SwitchTurn"), warDataIndex, self.m_WarDataCount))

    return self
end

function ModelSceneWar:setExecutingAction(executing)
    assert(self.m_IsExecutingAction ~= executing)
    self.m_IsExecutingAction = executing

    if ((not executing) and (not self:isEnded())) then
        local actionID = self:getActionId() + 1
        if (not self:isTotalReplay()) then
            local action = self.m_CachedActions[actionID]
            if (action) then
                assert(not IS_SERVER, "ModelSceneWar:setExecutingAction() there should not be any cached actions on the server.")
                self.m_CachedActions[actionID] = nil
                self.m_IsExecutingAction       = true
                self.m_View:runAction(cc.Sequence:create(
                    cc.DelayTime:create(TIME_INTERVAL_FOR_ACTIONS),
                    cc.CallFunc:create(function()
                        self.m_IsExecutingAction = false
                        self:executeAction(action)
                    end)
                ))
            end
        else
            local action = self.m_ExecutedActions[actionID]
            if ((self:isAutoReplay()) and (action)) then
                self.m_IsExecutingAction = true
                self.m_View:runAction(cc.Sequence:create(
                    cc.DelayTime:create(TIME_INTERVAL_FOR_ACTIONS),
                    cc.CallFunc:create(function()
                        self.m_IsExecutingAction = false
                        if (self:isAutoReplay()) then
                            executeReplayAction(self)
                        end
                    end)
                ))
            end
        end
    end

    return self
end

function ModelSceneWar:getActionId()
    return self.m_ActionID
end

function ModelSceneWar:getWarId()
    return self.m_WarID
end

function ModelSceneWar:getAttackModifier()
    return self.m_AttackModifier
end

function ModelSceneWar:getEnergyGainModifier()
    return self.m_EnergyGainModifier
end

function ModelSceneWar:getIncomeModifier()
    return self.m_IncomeModifier
end

function ModelSceneWar:getMoveRangeModifier()
    return self.m_MoveRangeModifier
end

function ModelSceneWar:getStartingFund()
    return self.m_StartingFund
end

function ModelSceneWar:getIntervalUntilBoot()
    return self.m_IntervalUntilBoot
end

function ModelSceneWar:getEnterTurnTime()
    return self.m_EnterTurnTime
end

function ModelSceneWar:setEnterTurnTime(time)
    self.m_EnterTurnTime = time

    return self
end

function ModelSceneWar:isEnded()
    return self.m_IsWarEnded
end

function ModelSceneWar:isFogOfWarByDefault()
    return self.m_IsFogOfWarByDefault
end

function ModelSceneWar:isRankMatch()
    return self.m_IsRankMatch
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

function ModelSceneWar:getRemainingVotesForDraw()
    return self.m_RemainingVotesForDraw
end

function ModelSceneWar:setRemainingVotesForDraw(votesCount)
    self.m_RemainingVotesForDraw = votesCount

    return self
end

function ModelSceneWar:getModelChatManager()
    return self.m_ActorChatManager:getModel()
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

function ModelSceneWar:showEffectEndWithDraw(callback)
    assert(not IS_SERVER, "ModelSceneWar:showEffectEndWithDraw() should not be invoked on the server.")
    self.m_View:showEffectEndWithDraw(callback)

    return self
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

function ModelSceneWar:showEffectReplayEnd(callback)
    assert(not IS_SERVER, "ModelSceneWar:showEffectReplayEnd() should not be invoked on the server.")
    self.m_View:showEffectReplayEnd(callback)

    return self
end

return ModelSceneWar
