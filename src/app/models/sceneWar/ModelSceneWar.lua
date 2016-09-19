
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
--  - ModelSceneWar要正确处理服务器传来的事件消息。目前，是使用doActionXXX系列函数来处理的。
--    由于ModelSceneWar本身是由许多子actor组成，所以这些系列函数通常只是把服务器事件分发给合适的子actor再行处理。
--
--  - model和view的“时间差”
--    在目前的设计中，一旦收到事件，model将即时完成所有相关计算，而view将随后跨帧显示相应效果。
--    考虑服务器传来“某unit A按某路线移动后对unit B发起攻击”的事件的情况。这种情况下，在model中，unit的新的数值将马上完成结算（如hp，弹药量，消灭与否，等级等都会有更新），
--    但在view不可能立刻按model的新状态进行呈现（否则，玩家就会看到unit发生了瞬移，或是突然消失了），而必须跨帧逐步更新。
--    采取model先行结算的方式可以避免很多问题，所以后续开发应该遵守同样的规范。
--]]--------------------------------------------------------------------------------

local ModelSceneWar = class("ModelSceneWar")

local ActionExecutor         = require("src.app.utilities.ActionExecutor")
local AudioManager           = require("src.app.utilities.AudioManager")
local InstantSkillExecutor   = require("src.app.utilities.InstantSkillExecutor")
local LocalizationFunctions  = require("src.app.utilities.LocalizationFunctions")
local SerializationFunctions = require("src.app.utilities.SerializationFunctions")
local WebSocketManager       = require("src.app.utilities.WebSocketManager")
local Actor                  = require("src.global.actors.Actor")
local ActorManager           = require("src.global.actors.ActorManager")
local EventDispatcher        = require("src.global.events.EventDispatcher")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function runSceneMain(modelSceneMainParam, playerAccount, playerPassword)
    local modelSceneMain = Actor.createModel("sceneMain.ModelSceneMain", modelSceneMainParam)
    local viewSceneMain  = Actor.createView("sceneMain.ViewSceneMain")

    WebSocketManager.setLoggedInAccountAndPassword(playerAccount, playerPassword)
    ActorManager.setAndRunRootActor(Actor.createWithModelAndViewInstance(modelSceneMain, viewSceneMain), "FADE", 1)
end

local function dispatchEvtIsWaitingForServerResponse(self, waiting)
    self:getScriptEventDispatcher():dispatchEvent({
        name    = "EvtIsWaitingForServerResponse",
        waiting = waiting,
    })
end

local function requestReload(self, durationSec)
    self:getModelMessageIndicator():showPersistentMessage(LocalizationFunctions.getLocalizedText(80, "TransferingData"))
    dispatchEvtIsWaitingForServerResponse(self, true)

    local func = function()
        WebSocketManager.sendAction({
            actionName = "GetSceneWarData",
            fileName   = self.m_FileName,
        })
    end

    if ((self.m_View) and (durationSec) and (durationSec > 0)) then
        self.m_View:runAction(cc.Sequence:create(
            cc.DelayTime:create(durationSec),
            cc.CallFunc:create(func)
        ))
    else
        func()
    end
end

local function callbackOnWarEnded()
    runSceneMain({isPlayerLoggedIn = true}, WebSocketManager.getLoggedInAccountAndPassword())
end

--------------------------------------------------------------------------------
-- The functions that do the actions the system requested.
--------------------------------------------------------------------------------
local function doActionBeginTurn(self, action)
    local modelTurnManager = self:getModelTurnManager()
    local lostPlayerIndex  = action.lostPlayerIndex

    if (lostPlayerIndex) then
        local modelWarField      = self:getModelWarField()
        local modelPlayerManager = self:getModelPlayerManager()
        local lostModelPlayer    = modelPlayerManager:getModelPlayer(lostPlayerIndex)

        action.callbackOnEnterTurnPhaseMain = function()
            modelWarField:clearPlayerForce(lostPlayerIndex)
            lostModelPlayer:setAlive(false)

            if (lostModelPlayer:getAccount() == WebSocketManager.getLoggedInAccountAndPassword()) then
                self.m_IsWarEnded = true
                self.m_View:showEffectLose(callbackOnWarEnded)
            else
                self:getModelMessageIndicator():showMessage(LocalizationFunctions.getLocalizedText(76, lostModelPlayer:getNickname()))

                if (modelPlayerManager:getAlivePlayersCount() == 1) then
                    self.m_IsWarEnded = true
                    self.m_View:showEffectWin(callbackOnWarEnded)
                else
                    modelTurnManager:endTurn()
                        :runTurn()
                end
            end
        end
    end

    modelTurnManager:doActionBeginTurn(action)
end

local function doActionEndTurn(self, action)
    self:getModelTurnManager():doActionEndTurn(action)
end

local function doActionSurrender(self, action)
    local modelPlayerManager = self:getModelPlayerManager()
    local modelTurnManager   = self:getModelTurnManager()
    modelPlayerManager:doActionSurrender(action)
    modelTurnManager:doActionSurrender(action)
    self:getModelWarField():doActionSurrender(action)

    local lostModelPlayer = modelPlayerManager:getModelPlayer(action.lostPlayerIndex)
    if (lostModelPlayer:getAccount() == WebSocketManager.getLoggedInAccountAndPassword()) then
        self.m_IsWarEnded = true
        self.m_View:showEffectSurrender(callbackOnWarEnded)
    else
        self:getModelMessageIndicator():showMessage(LocalizationFunctions.getLocalizedText(77, lostModelPlayer:getNickname()))

        if (modelPlayerManager:getAlivePlayersCount() == 1) then
            self.m_IsWarEnded = true
            self.m_View:showEffectWin(callbackOnWarEnded)
        else
            modelTurnManager:runTurn()
        end
    end
end

local function doActionActivateSkillGroup(self, action)
    InstantSkillExecutor.doActionActivateSkillGroup(action,
        self:getModelWarField(), self:getModelPlayerManager(), self:getModelTurnManager(), self:getModelWeatherManager(), self:getScriptEventDispatcher())

    local playerIndex = self:getModelTurnManager():getPlayerIndex()
    self:getModelPlayerManager():doActionActivateSkillGroup(action, playerIndex)
end

local function doActionAttack(self, action)
    local modelPlayerManager = self:getModelPlayerManager()
    local modelTurnManager   = self:getModelTurnManager()
    local modelWarField      = self:getModelWarField()
    local lostPlayerIndex    = action.lostPlayerIndex
    local callbackOnAttackAnimationEnded

    if (lostPlayerIndex) then
        local currentPlayerIndex = modelTurnManager:getPlayerIndex()
        local lostModelPlayer    = modelPlayerManager:getModelPlayer(lostPlayerIndex)

        callbackOnAttackAnimationEnded = function()
            modelWarField:clearPlayerForce(lostPlayerIndex)

            if (lostModelPlayer:getAccount() == WebSocketManager.getLoggedInAccountAndPassword()) then
                self.m_IsWarEnded = true
                self.m_View:showEffectLose(callbackOnWarEnded)
            else
                self:getModelMessageIndicator():showMessage(LocalizationFunctions.getLocalizedText(76, lostModelPlayer:getNickname()))

                if (modelPlayerManager:getAlivePlayersCount() == 1) then
                    self.m_IsWarEnded = true
                    self.m_View:showEffectWin(callbackOnWarEnded)
                elseif (lostPlayerIndex == currentPlayerIndex) then
                    modelTurnManager:runTurn()
                end
            end
        end
    end

    modelWarField     :doActionAttack(action, callbackOnAttackAnimationEnded)
    modelPlayerManager:doActionAttack(action)
    modelTurnManager  :doActionAttack(action)
end

local function doActionCaptureModelTile(self, action)
    local modelWarField      = self:getModelWarField()
    local modelPlayerManager = self:getModelPlayerManager()
    local lostPlayerIndex    = action.lostPlayerIndex
    local callbackOnCaptureAnimationEnded

    if (lostPlayerIndex) then
        local lostModelPlayer = modelPlayerManager:getModelPlayer(lostPlayerIndex)

        callbackOnCaptureAnimationEnded = function()
            modelWarField:clearPlayerForce(lostPlayerIndex)

            if (lostModelPlayer:getAccount() == WebSocketManager.getLoggedInAccountAndPassword()) then
                self.m_IsWarEnded = true
                self.m_View:showEffectLose(callbackOnWarEnded)
            else
                self:getModelMessageIndicator():showMessage(LocalizationFunctions.getLocalizedText(76, lostModelPlayer:getNickname()))
                if (modelPlayerManager:getAlivePlayersCount() == 1) then
                    self.m_IsWarEnded = true
                    self.m_View:showEffectWin(callbackOnWarEnded)
                end
            end
        end
    end

    modelWarField     :doActionCaptureModelTile(action, callbackOnCaptureAnimationEnded)
    modelPlayerManager:doActionCaptureModelTile(action)
end

local function doActionLaunchSilo(self, action)
    self:getModelWarField():doActionLaunchSilo(action)
end

local function doActionBuildModelTile(self, action)
    self:getModelWarField():doActionBuildModelTile(action)
end

local function doActionProduceModelUnitOnUnit(self, action)
    self:getModelPlayerManager():doActionProduceModelUnitOnUnit(action, self:getModelTurnManager():getPlayerIndex())
    self:getModelWarField():doActionProduceModelUnitOnUnit(action)
end

local function doActionSupplyModelUnit(self, action)
    self:getModelWarField():doActionSupplyModelUnit(action)
end

local function doActionLoadModelUnit(self, action)
    self:getModelWarField():doActionLoadModelUnit(action)
end

local function doActionDropModelUnit(self, action)
    self:getModelWarField():doActionDropModelUnit(action)
end

local function doActionProduceOnTile(self, action)
    self:getModelPlayerManager():doActionProduceOnTile(action, self:getModelTurnManager():getPlayerIndex())
    self:getModelWarField():doActionProduceOnTile(action)
end

local function doAction(self, action)
    local actionName = action.actionName
    if ((actionName == "Logout")              or
        (actionName == "Message")             or
        (actionName == "Error")               or
        (actionName == "RunSceneMain")        or
        (actionName == "GetSceneWarData")     or
        (actionName == "ReloadCurrentScene")  or
        (actionName == "JoinModelUnit")       or
        (actionName == "Wait"))               then
        return ActionExecutor.execute(action)
    end

    if ((action.fileName ~= self.m_FileName) or (self.m_IsWarEnded)) then
        return
    elseif (action.actionID ~= self.m_ActionID + 1) then
        self:getModelMessageIndicator():showMessage(LocalizationFunctions.getLocalizedText(81, "OutOfSync"))
        requestReload(self, 3)
        return
    end

    self.m_ActionID = action.actionID
    self:getModelMessageIndicator():hidePersistentMessage(LocalizationFunctions.getLocalizedText(80, "TransferingData"))
    dispatchEvtIsWaitingForServerResponse(self, false)

    if     (actionName == "BeginTurn")              then doActionBeginTurn(             self, action)
    elseif (actionName == "EndTurn")                then doActionEndTurn(               self, action)
    elseif (actionName == "Surrender")              then doActionSurrender(             self, action)
    elseif (actionName == "ActivateSkillGroup")     then doActionActivateSkillGroup(    self, action)
    elseif (actionName == "Attack")                 then doActionAttack(                self, action)
    elseif (actionName == "CaptureModelTile")       then doActionCaptureModelTile(      self, action)
    elseif (actionName == "LaunchSilo")             then doActionLaunchSilo(            self, action)
    elseif (actionName == "BuildModelTile")         then doActionBuildModelTile(        self, action)
    elseif (actionName == "ProduceModelUnitOnUnit") then doActionProduceModelUnitOnUnit(self, action)
    elseif (actionName == "SupplyModelUnit")        then doActionSupplyModelUnit(       self, action)
    elseif (actionName == "LoadModelUnit")          then doActionLoadModelUnit(         self, action)
    elseif (actionName == "DropModelUnit")          then doActionDropModelUnit(         self, action)
    elseif (actionName == "ProduceOnTile")          then doActionProduceOnTile(         self, action)
    else                                                 print("ModelSceneWar-doAction() unrecognized action.")
    end
end

--------------------------------------------------------------------------------
-- The private callback function on web socket events.
--------------------------------------------------------------------------------
local function onWebSocketOpen(self, param)
    print("ModelSceneWar-onWebSocketOpen()")
    self:getModelMessageIndicator():showMessage(LocalizationFunctions.getLocalizedText(30))
end

local function onWebSocketMessage(self, param)
    print("ModelSceneWar-onWebSocketMessage():\n" .. param.message)
    doAction(self, param.action)
end

local function onWebSocketClose(self, param)
    print("ModelSceneWar-onWebSocketClose()")
    self:getModelMessageIndicator():showMessage(LocalizationFunctions.getLocalizedText(31))
end

local function onWebSocketError(self, param)
    print("ModelSceneWar-onWebSocketError()")
    self:getModelMessageIndicator():showMessage(LocalizationFunctions.getLocalizedText(32, param.error))
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
-- The constructor.
--------------------------------------------------------------------------------
function ModelSceneWar:ctor(sceneData)
    self.m_FileName   = sceneData.fileName
    self.m_IsWarEnded = sceneData.isEnded
    self.m_ActionID   = sceneData.actionID

    initScriptEventDispatcher(self)
    initActorConfirmBox(      self)
    initActorMessageIndicator(self)
    initActorPlayerManager(   self, sceneData.players)
    initActorWeatherManager(  self, sceneData.weather)
    initActorWarField(        self, sceneData.warField)
    initActorWarHud(          self)
    initActorTurnManager(     self, sceneData.turn)

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
-- The callback functions on start/stop running/script/web socket events.
--------------------------------------------------------------------------------
function ModelSceneWar:onStartRunning()
    local sceneWarFileName = self:getFileName()
    self.m_ActorWarHud:getModel():onStartRunning(sceneWarFileName)
    self:getModelTurnManager()   :onStartRunning(sceneWarFileName)
    self:getModelPlayerManager() :onStartRunning(sceneWarFileName)
    self:getModelWarField()      :onStartRunning(sceneWarFileName)

    local modelTurnManager = self:getModelTurnManager()
    local playerIndex      = modelTurnManager:getPlayerIndex()
    self:getScriptEventDispatcher():dispatchEvent({
            name         = "EvtModelWeatherUpdated",
            modelWeather = self:getModelWeatherManager():getCurrentWeather()
        })
        :dispatchEvent({
            name = "EvtSceneWarStarted",
        })
        :dispatchEvent({
            name        = "EvtPlayerIndexUpdated",
            playerIndex = playerIndex,
            modelPlayer = self:getModelPlayerManager():getModelPlayer(playerIndex),
        })

    modelTurnManager:runTurn()
    AudioManager.playRandomWarMusic()

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

function ModelSceneWar:getScriptEventDispatcher()
    return self.m_ScriptEventDispatcher
end

return ModelSceneWar
