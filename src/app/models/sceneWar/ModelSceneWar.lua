
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

local Actor                  = require("global.actors.Actor")
local ActorManager           = require("global.actors.ActorManager")
local TypeChecker            = require("app.utilities.TypeChecker")
local WebSocketManager       = require("app.utilities.WebSocketManager")
local SerializationFunctions = require("app.utilities.SerializationFunctions")

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

--------------------------------------------------------------------------------
-- The functions that do the actions the system requested.
--------------------------------------------------------------------------------
local function doActionLogout(self, event)
    runSceneMain({confirmText = event.message})
end

local function doActionMessage(self, action)
    self:getModelMessageIndicator():showMessage(action.message)
end

local function doActionBeginTurn(self, action)
    self:getModelTurnManager():doActionBeginTurn(action)
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

    local callbackOnEffectDisappear = function()
        runSceneMain({isPlayerLoggedIn = true}, WebSocketManager:getLoggedInAccountAndPassword())
    end
    local lostModelPlayer = modelPlayerManager:getModelPlayer(action.lostPlayerIndex)
    if (lostModelPlayer:getAccount() == WebSocketManager.getLoggedInAccountAndPassword()) then
        self.m_IsWarEnded = true
        self.m_View:showEffectSurrender(callbackOnEffectDisappear)
    else
        self:getModelMessageIndicator():showMessage("Player " .. lostModelPlayer:getNickname() .. " has surrendered!")

        if (modelPlayerManager:getAlivePlayersCount() == 1) then
            self.m_IsWarEnded = true
            self.m_View:showEffectWin(callbackOnEffectDisappear)
        else
            modelTurnManager:runTurn()
        end
    end
end

local function doActionWait(self, action)
    self:getModelWarField():doActionWait(action)
end

local function doActionAttack(self, action)
    self:getModelWarField():doActionAttack(action)
end

local function doActionCapture(self, action)
    self:getModelWarField():doActionCapture(action)
end

local function doActionProduceOnTile(self, action)
    action.playerIndex = self:getModelTurnManager():getPlayerIndex()

    self:getModelPlayerManager():doActionProduceOnTile(action)
    self:getModelWarField():doActionProduceOnTile(action)
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtSystemRequestDoAction(self, event)
    local actionName = event.actionName
    if (actionName == "Logout") then
        return doActionLogout(self, event)
    elseif (actionName == "Message") then
        return doActionMessage(self, event)
    elseif (actionName == "Error") then
        return error("ModelSceneWar-onEvtSystemRequestDoAction() Error: " .. event.error)
    end

    if ((event.fileName ~= self.m_FileName) or (self.m_IsWarEnded)) then
        return
    elseif (actionName == "BeginTurn") then
        return doActionBeginTurn(self, event)
    elseif (actionName == "EndTurn") then
        return doActionEndTurn(self, event)
    elseif (actionName == "Surrender") then
        return doActionSurrender(self, event)
    elseif (actionName == "Wait") then
        return doActionWait(self, event)
    elseif (actionName == "Attack") then
        return doActionAttack(self, event)
    elseif (actionName == "Capture") then
        return doActionCapture(self, event)
    elseif (actionName == "ProduceOnTile") then
        return doActionProduceOnTile(self, event)
    else
        return print("ModelSceneWar-onEvtSystemRequestDoAction() unrecognized action.")
    end
end

local function onEvtPlayerRequestDoAction(self, event)
    local request = event
    request.playerAccount, request.playerPassword = WebSocketManager.getLoggedInAccountAndPassword()
    request.sceneWarFileName = self.m_FileName
    WebSocketManager.sendString(SerializationFunctions.toString(request))
end

--------------------------------------------------------------------------------
-- The private callback function on web socket events.
--------------------------------------------------------------------------------
local function onWebSocketOpen(self, param)
    print("ModelSceneWar-onWebSocketOpen()")
    self:getModelMessageIndicator():showMessage("Connection established.")
end

local function onWebSocketMessage(self, param)
    print("ModelSceneWar-onWebSocketMessage():\n" .. param.message)

    local action = assert(loadstring("return " .. param.message))()
    -- print(SerializationFunctions.serialize(action))
    onEvtSystemRequestDoAction(self, action)
end

local function onWebSocketClose(self, param)
    print("ModelSceneWar-onWebSocketClose()")
    self:getModelMessageIndicator():showMessage("Connection lost. Now reconnecting...")

    WebSocketManager.close()
        .init()
        .setOwner(self)
end

local function onWebSocketError(self, param)
    print("ModelSceneWar-onWebSocketError()")
    self:getModelMessageIndicator():showMessage("Connection lost with error: " .. param.error)

    WebSocketManager.close()
        .init()
        .setOwner(self)
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initScriptEventDispatcher(self)
    local dispatcher = require("global.events.EventDispatcher"):create()
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

    self.m_ActorWarHud = actor
end

local function initActorTurnManager(self, turnData)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelTurnManager", turnData, "sceneWar.ViewTurnManager")
    actor:getModel():setModelPlayerManager(self:getModelPlayerManager())
        :setModelWarField(self.m_ActorWarField:getModel())
        :setRootScriptEventDispatcher(self.m_ScriptEventDispatcher)
        :setModelMessageIndicator(self:getModelMessageIndicator())

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

    view:setViewWarField(        self.m_ActorWarField:getView())
        :setViewWarHud(          self.m_ActorWarHud:getView())
        :setViewTurnManager(     self.m_ActorTurnManager:getView())
        :setViewMessageIndicator(self.m_ActorMessageIndicator:getView())

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function ModelSceneWar:toStringList(spaces)
    spaces = spaces or ""
    local subSpaces  = spaces .. "    "
    local strList    = {spaces .. "return {\n"}

    local appendList = require("app.utilities.TableFunctions").appendList
    appendList(strList, self:getModelWarField()      :toStringList(subSpaces), ",\n")
    appendList(strList, self:getModelTurnManager()   :toStringList(subSpaces), ",\n")
    appendList(strList, self:getModelPlayerManager() :toStringList(subSpaces), ",\n")
    appendList(strList, self:getModelWeatherManager():toStringList(subSpaces), "\n" .. spaces .. "}")

    return strList
end

function ModelSceneWar:toSerializableTable()
    return {
        fileName = self.m_FileName,
        warField = self.m_ActorWarField:getModel():toSerializableTable(),
        turn     = self.m_ActorTurnManager:getModel():toSerializableTable(),
        players  = self.m_ActorPlayerManager:getModel():toSerializableTable(),
        weather  = self.m_ActorWeatherManager:getModel():toSerializableTable(),
    }
end

--------------------------------------------------------------------------------
-- The callback functions on start/stop running/script/web socket events.
--------------------------------------------------------------------------------
function ModelSceneWar:onStartRunning()
    local playerIndex = self:getModelTurnManager():getPlayerIndex()
    self.m_ScriptEventDispatcher:dispatchEvent({
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

    self:getModelTurnManager():runTurn()

    return self
end

function ModelSceneWar:onStopRunning()
    return self
end

function ModelSceneWar:onEvent(event)
    local eventName = event.name
    if (eventName == "EvtPlayerRequestDoAction") then
        onEvtPlayerRequestDoAction(self, event)
    elseif (eventName == "EvtSystemRequestDoAction") then
        onEvtSystemRequestDoAction(self, event)
    end

    return self
end

function ModelSceneWar:onWebSocketEvent(eventName, param)
    if (eventName == "open") then
        onWebSocketOpen(self, param)
    elseif (eventName == "message") then
        onWebSocketMessage(self, param)
    elseif (eventName == "close") then
        onWebSocketClose(self, param)
    elseif (eventName == "error") then
        onWebSocketError(self, param)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelSceneWar:getScriptEventDispatcher()
    return self.m_ScriptEventDispatcher
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

function ModelSceneWar:getModelMessageIndicator()
    return self.m_ActorMessageIndicator:getModel()
end

return ModelSceneWar
