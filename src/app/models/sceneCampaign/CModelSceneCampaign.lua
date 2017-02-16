
local CModelSceneCampaign = requireBW("src.global.functions.class")("CModelSceneCampaign")

local ActionCodeFunctions    = requireBW("src.app.utilities.ActionCodeFunctions")
local ActionExecutor         = requireBW("src.app.utilities.ActionExecutor")
local AudioManager           = requireBW("src.app.utilities.AudioManager"))
local LocalizationFunctions  = requireBW("src.app.utilities.LocalizationFunctions")
local SerializationFunctions = requireBW("src.app.utilities.SerializationFunctions")
local Actor                  = requireBW("src.global.actors.Actor")
local EventDispatcher        = requireBW("src.global.events.EventDispatcher")

local ipairs, next     = ipairs, next
local getLocalizedText = LocalizationFunctions.getLocalizedText

local TIME_INTERVAL_FOR_ACTIONS = 1

--------------------------------------------------------------------------------
-- The private callback function on web socket events.
--------------------------------------------------------------------------------
local function onWebSocketOpen(self, param)
    print("CModelSceneCampaign-onWebSocketOpen()")
    --self:getModelMessageIndicator():showMessage(getLocalizedText(30, "ConnectionEstablished"))
end

local function onWebSocketMessage(self, param)
end

local function onWebSocketClose(self, param)
    print("CModelSceneCampaign-onWebSocketClose()")
    --self:getModelMessageIndicator():showMessage(getLocalizedText(31))
end

local function onWebSocketError(self, param)
    print("CModelSceneCampaign-onWebSocketError()")
    --self:getModelMessageIndicator():showMessage(getLocalizedText(32, param.error))
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initScriptEventDispatcher(self)
    self.m_ScriptEventDispatcher = EventDispatcher:create()
end

local function initActorConfirmBox(self)
    local actor = Actor.createWithModelAndViewName("common.ModelConfirmBox", nil, "common.ViewConfirmBox")
    actor:getModel():setEnabled(false)

    self.m_ActorConfirmBox = actor
end

local function initActorMessageIndicator(self)
    self.m_ActorMessageIndicator = Actor.createWithModelAndViewName("common.ModelMessageIndicator", nil, "common.ViewMessageIndicator")
end

local function initActorPlayerManager(self, playersData)
    self.m_ActorPlayerManager = Actor.createWithModelAndViewName("sceneWar.ModelPlayerManager", playersData)
end

local function initActorWeatherManager(self, weatherData)
    self.m_ActorWeatherManager = Actor.createWithModelAndViewName("sceneWar.ModelWeatherManager", weatherData)
end

local function initActorWarField(self, warFieldData)
    self.m_ActorWarField = Actor.createWithModelAndViewName("sceneCampaign.ModelWarField", warFieldData, "sceneCampaign.ViewWarField")
end

local function initActorWarHud(self)
    self.m_ActorWarHud = Actor.createWithModelAndViewName("sceneCampaign.ModelWarHUD", nil, "sceneCampaign.ViewWarHUD")
end

local function initActorTurnManager(self, turnData)
    self.m_ActorTurnManager = Actor.createWithModelAndViewName("sceneCampaign.CModelTurnManager", turnData, "sceneWar.ViewTurnManager")
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function CModelSceneCampaign:ctor(sceneData)
    self.m_IncomeModifier      = sceneData.incomeModifier
    self.m_IsWarEnded          = sceneData.isWarEnded
    self.m_IsFogOfWarByDefault = sceneData.isFogOfWarByDefault

    initScriptEventDispatcher(self)
    initActorPlayerManager(   self, sceneData.players)
    initActorWeatherManager(  self, sceneData.weather)
    initActorWarField(        self, sceneData.warField)
    initActorTurnManager(     self, sceneData.turn)
    initActorConfirmBox(      self)
    initActorMessageIndicator(self)
    initActorWarHud(          self)

    return self
end

function CModelSceneCampaign:initView()
    assert(self.m_View, "CModelSceneCampaign:initView() no view is attached to the owner actor of the model.")
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
function CModelSceneCampaign:toSerializableTable()
    return {
        incomeModifier      = self.m_IncomeModifier,
        isFogOfWarByDefault = self.m_IsFogOfWarByDefault,
        isWarEnded          = self.m_IsWarEnded,
        players             = self:getModelPlayerManager() :toSerializableTable(),
        turn                = self:getModelTurnManager()   :toSerializableTable(),
        warField            = self:getModelWarField()      :toSerializableTable(),
        weather             = self:getModelWeatherManager():toSerializableTable(),
    }
end

--------------------------------------------------------------------------------
-- The callback functions on start/stop running and script events.
--------------------------------------------------------------------------------
function CModelSceneCampaign:onStartRunning()
    local modelTurnManager = self:getModelTurnManager()
    modelTurnManager            :onStartRunning(self)
    self:getModelPlayerManager():onStartRunning(self)
    self:getModelWarField()     :onStartRunning(self)
    self:getModelWarHud()       :onStartRunning(self)

    self:getScriptEventDispatcher():dispatchEvent({name = "EvtSceneWarStarted"})

    modelTurnManager:runTurn()
    AudioManager.playRandomWarMusic()

    return self
end

function CModelSceneCampaign:onStopRunning()
    return self
end

function CModelSceneCampaign:onWebSocketEvent(eventName, param)
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
function CModelSceneCampaign:executeAction(action)
    ActionExecutor.execute(action, self)

    return self
end

function CModelSceneCampaign:isExecutingAction()
    return self.m_IsExecutingAction
end

function CModelSceneCampaign:setExecutingAction(executing)
    assert(self.m_IsExecutingAction ~= executing)
    self.m_IsExecutingAction = executing

    return self
end

function CModelSceneCampaign:getIncomeModifier()
    return self.m_IncomeModifier
end

function CModelSceneCampaign:isEnded()
    return self.m_IsWarEnded
end

function CModelSceneCampaign:setEnded(ended)
    self.m_IsWarEnded = ended

    return self
end

function CModelSceneCampaign:isFogOfWarByDefault()
    return self.m_IsFogOfWarByDefault
end

function CModelSceneCampaign:getModelConfirmBox()
    return self.m_ActorConfirmBox:getModel()
end

function CModelSceneCampaign:getModelMessageIndicator()
    return self.m_ActorMessageIndicator:getModel()
end

function CModelSceneCampaign:getModelTurnManager()
    return self.m_ActorTurnManager:getModel()
end

function CModelSceneCampaign:getModelPlayerManager()
    return self.m_ActorPlayerManager:getModel()
end

function CModelSceneCampaign:getModelWeatherManager()
    return self.m_ActorWeatherManager:getModel()
end

function CModelSceneCampaign:getModelWarField()
    return self.m_ActorWarField:getModel()
end

function CModelSceneCampaign:getModelWarHud()
    return self.m_ActorWarHud:getModel()
end

function CModelSceneCampaign:getScriptEventDispatcher()
    return self.m_ScriptEventDispatcher
end

function CModelSceneCampaign:showEffectWin(callback)
    assert(not IS_SERVER, "CModelSceneCampaign:showEffectWin() should not be invoked on the server.")
    self.m_View:showEffectWin(callback)

    return self
end

function CModelSceneCampaign:showEffectLose(callback)
    assert(not IS_SERVER, "CModelSceneCampaign:showEffectLose() should not be invoked on the server.")
    self.m_View:showEffectLose(callback)

    return self
end

return CModelSceneCampaign
