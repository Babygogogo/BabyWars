
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
local function getModelTurnManager(self)
    return self.m_ActorTurnManager:getModel()
end

local function getModelPlayerManager(self)
    return self.m_ActorPlayerManager:getModel()
end

local function getModelWeatherManager(self)
    return self.m_ActorWeatherManager:getModel()
end

local function getModelWarField(self)
    return self.m_ActorWarField:getModel()
end

local function getModelMessageIndicator(self)
    return self.m_ActorMessageIndicator:getModel()
end

local function runSceneMain(modelSceneMainParam, playerAccount, playerPassword)
    local modelSceneMain = Actor.createModel("sceneMain.ModelSceneMain", modelSceneMainParam)
    local viewSceneMain  = Actor.createView("sceneMain.ViewSceneMain")

    WebSocketManager.setLoggedInAccountAndPassword(playerAccount, playerPassword)
        .setOwner(modelSceneMain)
    ActorManager.setAndRunRootActor(Actor.createWithModelAndViewInstance(modelSceneMain, viewSceneMain), "FADE", 1)
end

local function dispatchEvtIsWaitingForServerResponse(self, waiting)
    self.m_ScriptEventDispatcher:dispatchEvent({
        name    = "EvtIsWaitingForServerResponse",
        waiting = waiting,
    })
end

local function requestReload(self, durationSec)
    getModelMessageIndicator(self):showPersistentMessage(LocalizationFunctions.getLocalizedText(80, "TransferingData"))
    dispatchEvtIsWaitingForServerResponse(self, true)

    local func = function()
        self.m_ScriptEventDispatcher:dispatchEvent({
            name       = "EvtPlayerRequestDoAction",
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
local function doActionLogout(self, event)
    runSceneMain({confirmText = event.message})
end

local function doActionMessage(self, action)
    getModelMessageIndicator(self):showMessage(action.message)
    local additionalAction = action.additionalAction
    if     (additionalAction == "RunSceneMain")   then runSceneMain({isPlayerLoggedIn = true}, WebSocketManager.getLoggedInAccountAndPassword())
    elseif (additionalAction == "ReloadSceneWar") then requestReload(self, 3)
    end
end

local function doActionError(self, action)
    error("ModelSceneWar-doActionError(): " .. action.error)
end

local function doActionGetSceneWarData(self, action)
    local actorSceneWar = Actor.createWithModelAndViewName("sceneWar.ModelSceneWar", action.data, "sceneWar.ViewSceneWar")
    WebSocketManager.setOwner(actorSceneWar:getModel())
    ActorManager.setAndRunRootActor(actorSceneWar, "FADE", 1)
end

local function doActionBeginTurn(self, action)
    local modelTurnManager = getModelTurnManager(self)
    local lostPlayerIndex  = action.lostPlayerIndex

    if (lostPlayerIndex) then
        local modelWarField      = getModelWarField(self)
        local modelPlayerManager = getModelPlayerManager(self)
        local lostModelPlayer    = modelPlayerManager:getModelPlayer(lostPlayerIndex)

        action.callbackOnEnterTurnPhaseMain = function()
            modelWarField:clearPlayerForce(lostPlayerIndex)
            lostModelPlayer:setAlive(false)

            if (lostModelPlayer:getAccount() == WebSocketManager.getLoggedInAccountAndPassword()) then
                self.m_IsWarEnded = true
                self.m_View:showEffectLose(callbackOnWarEnded)
            else
                getModelMessageIndicator(self):showMessage(LocalizationFunctions.getLocalizedText(76, lostModelPlayer:getNickname()))

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
    getModelTurnManager(self):doActionEndTurn(action)
end

local function doActionSurrender(self, action)
    local modelPlayerManager = getModelPlayerManager(self)
    local modelTurnManager   = getModelTurnManager(self)
    modelPlayerManager:doActionSurrender(action)
    modelTurnManager:doActionSurrender(action)
    getModelWarField(self):doActionSurrender(action)

    local lostModelPlayer = modelPlayerManager:getModelPlayer(action.lostPlayerIndex)
    if (lostModelPlayer:getAccount() == WebSocketManager.getLoggedInAccountAndPassword()) then
        self.m_IsWarEnded = true
        self.m_View:showEffectSurrender(callbackOnWarEnded)
    else
        getModelMessageIndicator(self):showMessage(LocalizationFunctions.getLocalizedText(77, lostModelPlayer:getNickname()))

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
        getModelWarField(self), getModelPlayerManager(self), getModelTurnManager(self), getModelWeatherManager(self), self.m_ScriptEventDispatcher)

    local playerIndex = getModelTurnManager(self):getPlayerIndex()
    getModelPlayerManager(self):doActionActivateSkillGroup(action, playerIndex)
end

local function doActionWait(self, action)
    getModelWarField(self):doActionWait(action)
end

local function doActionAttack(self, action)
    local modelPlayerManager = getModelPlayerManager(self)
    local modelTurnManager   = getModelTurnManager(self)
    local modelWarField      = getModelWarField(self)
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
                getModelMessageIndicator(self):showMessage(LocalizationFunctions.getLocalizedText(76, lostModelPlayer:getNickname()))

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

local function doActionJoinModelUnit(self, action)
    getModelWarField(self):doActionJoinModelUnit(action)
end

local function doActionCaptureModelTile(self, action)
    local modelWarField      = getModelWarField(self)
    local modelPlayerManager = getModelPlayerManager(self)
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
                getModelMessageIndicator(self):showMessage(LocalizationFunctions.getLocalizedText(76, lostModelPlayer:getNickname()))
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
    getModelWarField(self):doActionLaunchSilo(action)
end

local function doActionBuildModelTile(self, action)
    getModelWarField(self):doActionBuildModelTile(action)
end

local function doActionProduceModelUnitOnUnit(self, action)
    getModelPlayerManager(self):doActionProduceModelUnitOnUnit(action, getModelTurnManager(self):getPlayerIndex())
    getModelWarField(self):doActionProduceModelUnitOnUnit(action)
end

local function doActionSupplyModelUnit(self, action)
    getModelWarField(self):doActionSupplyModelUnit(action)
end

local function doActionLoadModelUnit(self, action)
    getModelWarField(self):doActionLoadModelUnit(action)
end

local function doActionDropModelUnit(self, action)
    getModelWarField(self):doActionDropModelUnit(action)
end

local function doActionProduceOnTile(self, action)
    getModelPlayerManager(self):doActionProduceOnTile(action, getModelTurnManager(self):getPlayerIndex())
    getModelWarField(self):doActionProduceOnTile(action)
end

local function doAction(self, action)
    local actionName = action.actionName
    if     (actionName == "Logout")          then doActionLogout(         self, action)
    elseif (actionName == "Message")         then doActionMessage(        self, action)
    elseif (actionName == "Error")           then doActionError(          self, action)
    elseif (actionName == "GetSceneWarData") then doActionGetSceneWarData(self, action)
    end

    if ((action.fileName ~= self.m_FileName) or (self.m_IsWarEnded)) then
        return
    elseif (action.actionID ~= self.m_ActionID + 1) then
        getModelMessageIndicator(self):showMessage(LocalizationFunctions.getLocalizedText(81, "OutOfSync"))
        requestReload(self, 3)
        return
    end

    self.m_ActionID = action.actionID
    getModelMessageIndicator(self):hidePersistentMessage(LocalizationFunctions.getLocalizedText(80, "TransferingData"))
    dispatchEvtIsWaitingForServerResponse(self, false)

    if     (actionName == "BeginTurn")              then doActionBeginTurn(             self, action)
    elseif (actionName == "EndTurn")                then doActionEndTurn(               self, action)
    elseif (actionName == "Surrender")              then doActionSurrender(             self, action)
    elseif (actionName == "ActivateSkillGroup")     then doActionActivateSkillGroup(    self, action)
    elseif (actionName == "Wait")                   then doActionWait(                  self, action)
    elseif (actionName == "Attack")                 then doActionAttack(                self, action)
    elseif (actionName == "JoinModelUnit")          then doActionJoinModelUnit(         self, action)
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
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtPlayerRequestDoAction(self, event)
    local request  = event
    request.playerAccount,    request.playerPassword = WebSocketManager.getLoggedInAccountAndPassword()
    request.sceneWarFileName, request.actionID       = self.m_FileName, self.m_ActionID + 1

    getModelMessageIndicator(self):showPersistentMessage(LocalizationFunctions.getLocalizedText(80, "TransferingData"))
    dispatchEvtIsWaitingForServerResponse(self, true)
    WebSocketManager.sendString(SerializationFunctions.toString(request))
end

local function onEvtReloadSceneWar(self, event)
    requestReload(self)
end

--------------------------------------------------------------------------------
-- The private callback function on web socket events.
--------------------------------------------------------------------------------
local function onWebSocketOpen(self, param)
    print("ModelSceneWar-onWebSocketOpen()")
    getModelMessageIndicator(self):showMessage(LocalizationFunctions.getLocalizedText(30))
end

local function onWebSocketMessage(self, param)
    print("ModelSceneWar-onWebSocketMessage():\n" .. param.message)

    local action = assert(loadstring("return " .. param.message))()
    -- print(SerializationFunctions.toString(action))
    doAction(self, action)
end

local function onWebSocketClose(self, param)
    print("ModelSceneWar-onWebSocketClose()")
    getModelMessageIndicator(self):showMessage(LocalizationFunctions.getLocalizedText(31))

    WebSocketManager.close()
        .init()
        .setOwner(self)
end

local function onWebSocketError(self, param)
    print("ModelSceneWar-onWebSocketError()")
    getModelMessageIndicator(self):showMessage(LocalizationFunctions.getLocalizedText(32, param.error))

    WebSocketManager.close()
        .init()
        .setOwner(self)
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initScriptEventDispatcher(self)
    local dispatcher = EventDispatcher:create()
    dispatcher:addEventListener("EvtPlayerRequestDoAction", self)
        :addEventListener("EvtReloadSceneWar", self)

    self.m_ScriptEventDispatcher = dispatcher
end

local function initActorMessageIndicator(self)
    local actor = Actor.createWithModelAndViewName("common.ModelMessageIndicator", nil, "common.ViewMessageIndicator")

    self.m_ActorMessageIndicator = actor
end

local function initActorPlayerManager(self, playersData)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelPlayerManager", playersData)
    actor:getModel():setRootScriptEventDispatcher(self.m_ScriptEventDispatcher)

    self.m_ActorPlayerManager = actor
end

local function initActorWeatherManager(self, weatherData)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelWeatherManager", weatherData)

    self.m_ActorWeatherManager = actor
end

local function initActorWarField(self, warFieldData)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelWarField", warFieldData, "sceneWar.ViewWarField")
    actor:getModel():setRootScriptEventDispatcher(self.m_ScriptEventDispatcher)
        :setModelPlayerManager(getModelPlayerManager(self))
        :setModelWeatherManager(getModelWeatherManager(self))

    self.m_ActorWarField = actor
end

local function initActorWarHud(self)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelWarHUD", nil, "sceneWar.ViewWarHUD")
    actor:getModel():setRootScriptEventDispatcher(self.m_ScriptEventDispatcher)
        :setModelWarField(getModelWarField(self))
        :setModelPlayerManager(getModelPlayerManager(self))

    self.m_ActorWarHud = actor
end

local function initActorTurnManager(self, turnData)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelTurnManager", turnData, "sceneWar.ViewTurnManager")
    actor:getModel():setRootScriptEventDispatcher(self.m_ScriptEventDispatcher)
        :setModelPlayerManager(getModelPlayerManager(self))
        :setModelWarField(getModelWarField(self))
        :setModelMessageIndicator(getModelMessageIndicator(self))

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
    self.m_View:setViewWarField( self.m_ActorWarField        :getView())
        :setViewWarHud(          self.m_ActorWarHud          :getView())
        :setViewTurnManager(     self.m_ActorTurnManager     :getView())
        :setViewMessageIndicator(self.m_ActorMessageIndicator:getView())

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on start/stop running/script/web socket events.
--------------------------------------------------------------------------------
function ModelSceneWar:onStartRunning()
    local modelTurnManager = getModelTurnManager(self)
    local playerIndex      = modelTurnManager:getPlayerIndex()
    self.m_ScriptEventDispatcher:dispatchEvent({
            name         = "EvtModelWeatherUpdated",
            modelWeather = getModelWeatherManager(self):getCurrentWeather()
        })
        :dispatchEvent({
            name = "EvtSceneWarStarted",
        })
        :dispatchEvent({
            name        = "EvtPlayerIndexUpdated",
            playerIndex = playerIndex,
            modelPlayer = getModelPlayerManager(self):getModelPlayer(playerIndex),
        })

    modelTurnManager:runTurn()
    AudioManager.playRandomWarMusic()

    return self
end

function ModelSceneWar:onStopRunning()
    return self
end

function ModelSceneWar:onEvent(event)
    local name = event.name
    if     (name == "EvtPlayerRequestDoAction") then onEvtPlayerRequestDoAction(self, event)
    elseif (name == "EvtReloadSceneWar")        then onEvtReloadSceneWar(       self, event)
    end

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

return ModelSceneWar
