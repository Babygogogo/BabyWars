
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

local WebSocketManager       = require("src.app.utilities.WebSocketManager")
local SerializationFunctions = require("src.app.utilities.SerializationFunctions")
local LocalizationFunctions  = require("src.app.utilities.LocalizationFunctions")
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
        .setOwner(modelSceneMain)
    ActorManager.setAndRunRootActor(Actor.createWithModelAndViewInstance(modelSceneMain, viewSceneMain), "FADE", 1)
end

local function callbackOnWarEnded()
    runSceneMain({isPlayerLoggedIn = true}, WebSocketManager:getLoggedInAccountAndPassword())
end

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

--------------------------------------------------------------------------------
-- The functions that do the actions the system requested.
--------------------------------------------------------------------------------
local function doActionLogout(self, event)
    runSceneMain({confirmText = event.message})
end

local function doActionMessage(self, action)
    getModelMessageIndicator(self):showMessage(action.message)
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

local function doActionWait(self, action)
    getModelWarField(self):doActionWait(action)
end

local function doActionAttack(self, action)
    local modelPlayerManager = getModelPlayerManager(self)
    local modelTurnManager   = getModelTurnManager(self)
    local modelWarField      = getModelWarField(self)

    local lostPlayerIndex = action.lostPlayerIndex
    if (lostPlayerIndex) then
        local currentPlayerIndex = modelTurnManager:getPlayerIndex()
        local lostModelPlayer    = modelPlayerManager:getModelPlayer(lostPlayerIndex)

        action.callbackOnAttackAnimationEnded = function()
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

    modelWarField:doActionAttack(action)
    modelPlayerManager:doActionAttack(action)
    modelTurnManager:doActionAttack(action)
end

local function doActionJoinModelUnit(self, action)
    getModelWarField(self):doActionJoinModelUnit(action, getModelPlayerManager(self))
end

local function doActionCapture(self, action)
    local modelWarField      = getModelWarField(self)
    local modelPlayerManager = getModelPlayerManager(self)

    local lostPlayerIndex = action.lostPlayerIndex
    if (lostPlayerIndex) then
        local lostModelPlayer = modelPlayerManager:getModelPlayer(lostPlayerIndex)

        action.callbackOnCaptureAnimationEnded = function()
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

    modelWarField:doActionCapture(action)
    modelPlayerManager:doActionCapture(action)
end

local function doActionBuildModelTile(self, action)
    getModelWarField(self):doActionBuildModelTile(action)
end

local function doActionLaunchSilo(self, action)
    getModelWarField(self):doActionLaunchSilo(action)
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

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtSystemRequestDoAction(self, event)
    local actionName = event.actionName
    if     (actionName == "Logout")  then return doActionLogout( self, event)
    elseif (actionName == "Message") then return doActionMessage(self, event)
    elseif (actionName == "Error")   then return error("ModelSceneWar-onEvtSystemRequestDoAction() Error: " .. event.error)
    end

    if ((event.fileName ~= self.m_FileName) or (self.m_IsWarEnded)) then
        return
    elseif (actionName == "BeginTurn")              then return doActionBeginTurn(             self, event)
    elseif (actionName == "EndTurn")                then return doActionEndTurn(               self, event)
    elseif (actionName == "Surrender")              then return doActionSurrender(             self, event)
    elseif (actionName == "Wait")                   then return doActionWait(                  self, event)
    elseif (actionName == "Attack")                 then return doActionAttack(                self, event)
    elseif (actionName == "JoinModelUnit")          then return doActionJoinModelUnit(         self, event)
    elseif (actionName == "Capture")                then return doActionCapture(               self, event)
    elseif (actionName == "LaunchSilo")             then return doActionLaunchSilo(            self, event)
    elseif (actionName == "BuildModelTile")         then return doActionBuildModelTile(        self, event)
    elseif (actionName == "ProduceModelUnitOnUnit") then return doActionProduceModelUnitOnUnit(self, event)
    elseif (actionName == "SupplyModelUnit")        then return doActionSupplyModelUnit(       self, event)
    elseif (actionName == "LoadModelUnit")          then return doActionLoadModelUnit(         self, event)
    elseif (actionName == "DropModelUnit")          then return doActionDropModelUnit(         self, event)
    elseif (actionName == "ProduceOnTile")          then return doActionProduceOnTile(         self, event)
    else
        return print("ModelSceneWar-onEvtSystemRequestDoAction() unrecognized action.")
    end
end

local function onEvtPlayerRequestDoAction(self, event)
    local request = event
    request.playerAccount, request.playerPassword = WebSocketManager.getLoggedInAccountAndPassword()
    request.sceneWarFileName                      = self.m_FileName

    WebSocketManager.sendString(SerializationFunctions.toString(request))
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
    -- print(SerializationFunctions.serialize(action))
    onEvtSystemRequestDoAction(self, action)
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
        :addEventListener("EvtSystemRequestDoAction", self)

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

local function initActorWarField(self, warFieldData)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelWarField", warFieldData, "sceneWar.ViewWarField")
    actor:getModel():setRootScriptEventDispatcher(self.m_ScriptEventDispatcher)
        :getModelActionPlanner():setModelPlayerManager(self.m_ActorPlayerManager:getModel())

    self.m_ActorWarField = actor
end

local function initActorWarHud(self)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelWarHUD", nil, "sceneWar.ViewWarHUD")
    actor:getModel():setRootScriptEventDispatcher(self.m_ScriptEventDispatcher)
        :setModelWarField(getModelWarField(self))

    self.m_ActorWarHud = actor
end

local function initActorTurnManager(self, turnData)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelTurnManager", turnData, "sceneWar.ViewTurnManager")
    actor:getModel():setModelPlayerManager(getModelPlayerManager(self))
        :setModelWarField(self.m_ActorWarField:getModel())
        :setRootScriptEventDispatcher(self.m_ScriptEventDispatcher)
        :setModelMessageIndicator(getModelMessageIndicator(self))

    self.m_ActorTurnManager = actor
end

local function initActorWeatherManager(self, weatherData)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelWeatherManager", weatherData)

    self.m_ActorWeatherManager = actor
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelSceneWar:ctor(sceneData)
    assert(type(sceneData) == "table", "ModelSceneWar:ctor() the param is invalid.")

    self.m_FileName   = sceneData.fileName
    self.m_IsWarEnded = sceneData.isEnded

    initScriptEventDispatcher(self)
    initActorMessageIndicator(self)
    initActorPlayerManager(   self, sceneData.players)
    initActorWarField(        self, sceneData.warField)
    initActorWarHud(          self)
    initActorTurnManager(     self, sceneData.turn)
    initActorWeatherManager(  self, sceneData.weather)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelSceneWar:initView()
    local view = self.m_View
    assert(view, "ModelSceneWar:initView() no view is attached.")

    view:setViewWarField(        self.m_ActorWarField        :getView())
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

    return self
end

function ModelSceneWar:onStopRunning()
    return self
end

function ModelSceneWar:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtPlayerRequestDoAction") then onEvtPlayerRequestDoAction(self, event)
    elseif (eventName == "EvtSystemRequestDoAction") then onEvtSystemRequestDoAction(self, event)
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
