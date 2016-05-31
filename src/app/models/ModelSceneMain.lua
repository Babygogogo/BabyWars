
--[[--------------------------------------------------------------------------------
-- ModelSceneMain是主场景。刚打开游戏，以及退出战局后所看到的就是这个场景。
--
-- 主要职责和使用场景举例：
--   同上
--
-- 其他：
--  - 目前本类功能很少。预定需要增加的功能包括（在本类中直接实现，或通过添加新的类来实现）：
--    - 创建新战局
--    - 加入已有战局
--    - 配置技能
--    - 显示玩家形象、id、积分、排名、战绩
--]]--------------------------------------------------------------------------------

local ModelSceneMain = class("ModelSceneMain")

local Actor                  = require("global.actors.Actor")
local ActorManager           = require("global.actors.ActorManager")
local GameConstantFunctions  = require("app.utilities.GameConstantFunctions")
local WebSocketManager       = require("app.utilities.WebSocketManager")
local SerializationFunctions = require("app.utilities.SerializationFunctions")

--------------------------------------------------------------------------------
-- The functions for doing actions.
--------------------------------------------------------------------------------
local function doActionLogin(self, action)
    if (action.account ~= WebSocketManager.getLoggedInAccountAndPassword()) then
        WebSocketManager.setLoggedInAccountAndPassword(action.account, action.password)
        self.m_ActorMessageIndicator:getModel():showMessage("Welcome, " .. action.account .. "!")
    end

    self.m_ActorMainMenu:getModel():doActionLogin(action)
end

local function doActionLogout(self, event)
    local modelSceneMain = Actor.createModel("ModelSceneMain", {
        confirmText = event.message
    })
    local viewSceneMain  = Actor.createView("ViewSceneMain")

    WebSocketManager.setLoggedInAccountAndPassword(nil, nil)
        .setOwner(modelSceneMain)
    ActorManager.setAndRunRootActor(Actor.createWithModelAndViewInstance(modelSceneMain, viewSceneMain), "FADE", 1)
end

local function doActionNewWar(self, action)
    self.m_ActorMainMenu:getModel():doActionNewWar(action)
    self.m_ActorMessageIndicator:getModel():showMessage(action.message)
end

local function doActionGetOngoingWarList(self, action)
    self.m_ActorMainMenu:getModel():doActionGetOngoingWarList(action)
end

local function doActionGetSceneWarData(self, action)
    self.m_ActorMainMenu:getModel():doActionGetSceneWarData(action)
end

local function doActionMessage(self, action)
    self.m_ActorMessageIndicator:getModel():showMessage(action.message)
end

--------------------------------------------------------------------------------
-- The private callback function on script events.
--------------------------------------------------------------------------------
local function onEvtSystemRequestDoAction(self, event)
    local actionName = event.actionName
    if (actionName == "Login") then
        doActionLogin(self, event)
    elseif (actionName == "Logout") then
        doActionLogout(self, event)
    elseif (actionName == "NewWar") then
        doActionNewWar(self, event)
    elseif (actionName == "GetOngoingWarList") then
        doActionGetOngoingWarList(self, event)
    elseif (actionName == "GetSceneWarData") then
        doActionGetSceneWarData(self, event)
    elseif (actionName == "Message") then
        doActionMessage(self, event)
    elseif (actionName == "Error") then
        error("ModelSceneMain-onEvtSystemRequestDoAction() Error: " .. event.error)
    else
        print("ModelSceneMain-onEvtSystemRequestDoAction() unrecoginzed action.")
    end
end

local function onEvtPlayerRequestDoAction(self, event)
    local request = event
    request.playerAccount, request.playerPassword = WebSocketManager.getLoggedInAccountAndPassword()
    WebSocketManager.sendString(SerializationFunctions.serialize(request))
end

--------------------------------------------------------------------------------
-- The private callback function on web socket events.
--------------------------------------------------------------------------------
local function onWebSocketOpen(self, param)
    print("ModelSceneMain-onWebSocketOpen()")
    self.m_ActorMessageIndicator:getModel():showMessage("Connection established.")
end

local function onWebSocketMessage(self, param)
    print("ModelSceneMain-onWebSocketMessage():\n" .. param.message)

    local action = assert(loadstring("return " .. param.message))()
    -- print(SerializationFunctions.serialize(action))
    onEvtSystemRequestDoAction(self, action)
end

local function onWebSocketClose(self, param)
    print("ModelSceneMain-onWebSocketClose()")
    self.m_ActorMessageIndicator:getModel():showMessage("Connection lost. Now reconnecting...")

    WebSocketManager.close()
        .init()
        .setOwner(self)
end

local function onWebSocketError(self, param)
    print("ModelSceneMain-onWebSocketError() " .. param.error)
    self.m_ActorMessageIndicator:getModel():showMessage("Connection lost with error: " .. param.error)

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

local function initActorConfirmBox(self, confirmText)
    local actor = Actor.createWithModelAndViewName("common.ModelConfirmBox", nil, "common.ViewConfirmBox")
    if (not confirmText) then
        actor:getModel():setEnabled(false)
    else
        actor:getModel():setConfirmText(confirmText)
    end

    self.m_ActorConfirmBox = actor
end

local function initActorMainMenu(self)
    local actor = Actor.createWithModelAndViewName("sceneMain.ModelMainMenu", nil, "sceneMain.ViewMainMenu")
    actor:getModel():setModelConfirmBox(self.m_ActorConfirmBox:getModel())
        :setModelMessageIndicator(self.m_ActorMessageIndicator:getModel())
        :setRootScriptEventDispatcher(self.m_ScriptEventDispatcher)
        :updateWithIsPlayerLoggedIn(self.m_IsPlayerLoggedIn)

    self.m_ActorMainMenu = actor
end

local function initActorMessageIndicator(self)
    local actor = Actor.createWithModelAndViewName("common.ModelMessageIndicator", nil, "common.ViewMessageIndicator")

    self.m_ActorMessageIndicator = actor
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelSceneMain:ctor(param)
    param = param or {}
    self.m_IsPlayerLoggedIn = (param.isPlayerLoggedIn) and (true) or (false)

    initScriptEventDispatcher(self)
    initActorConfirmBox(      self, param.confirmText)
    initActorMessageIndicator(self)
    initActorMainMenu(        self)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelSceneMain:initView()
    local view = self.m_View
    assert(view, "ModelSceneMain:initView() no view is attached to the owner actor of the model.")

    view:setViewConfirmBox(      self.m_ActorConfirmBox:getView())
        :setViewMainMenu(        self.m_ActorMainMenu:getView())
        :setViewMessageIndicator(self.m_ActorMessageIndicator:getView())

        :setGameVersion(GameConstantFunctions.getGameVersion())

    return self
end

--------------------------------------------------------------------------------
-- The callback function on script/web socket events.
--------------------------------------------------------------------------------
function ModelSceneMain:onEvent(event)
    local eventName = event.name
    if (eventName == "EvtPlayerRequestDoAction") then
        onEvtPlayerRequestDoAction(self, event)
    elseif (eventName == "EvtSystemRequestDoAction") then
        onEvtSystemRequestDoAction(self, event)
    end

    return self
end

function ModelSceneMain:onWebSocketEvent(eventName, param)
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

return ModelSceneMain
