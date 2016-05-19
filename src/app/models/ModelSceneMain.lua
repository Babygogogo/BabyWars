
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
local GameConstantFunctions  = require("app.utilities.GameConstantFunctions")
local ActionTranslator       = require("app.utilities.ActionTranslator")
local WebSocketManager       = require("app.utilities.WebSocketManager")
local SerializationFunctions = require("app.utilities.SerializationFunctions")

local isServer = true -- This is for testing and should be removed.

--------------------------------------------------------------------------------
-- The functions for doing actions.
--------------------------------------------------------------------------------
local function doActionLogin(self, action)
    if ((action.isSuccessful) and (action.account ~= WebSocketManager.getLoggedInAccountAndPassword())) then
        WebSocketManager.setLoggedInAccountAndPassword(action.account, action.password)
        if (self.m_View) then
            self.m_View:showMessage("Welcome, " .. action.account .. "!")
        end
    end

    self.m_ActorMainMenu:getModel():doActionLogin(action)
end

local function doActionGetOngoingWarList(self, action)
    self.m_ActorMainMenu:getModel():doActionGetOngoingWarList(action)
end

--------------------------------------------------------------------------------
-- The private callback function on script events.
--------------------------------------------------------------------------------
local function onEvtSystemRequestDoAction(self, event)
    local actionName = event.actionName
    if (actionName == "Login") then
        doActionLogin(self, event)
    elseif (actionName == "GetOngoingWarList") then
        doActionGetOngoingWarList(self, event)
    elseif (actionName == "Error") then
        error("ModelSceneMain-onEvtSystemRequestDoAction() " .. event.error)
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
end

local function onWebSocketMessage(self, param)
    print("ModelSceneMain-onWebSocketMessage():\n" .. param.message)

    local action = assert(loadstring("return " .. param.message))()
    -- print(SerializationFunctions.serialize(action))
    onEvtSystemRequestDoAction(self, action)
end

local function onWebSocketClose(self, param)
    print("ModelSceneMain-onWebSocketClose()")
end

local function onWebSocketError(self, param)
    print("ModelSceneMain-onWebSocketError")
end

--------------------------------------------------------------------------------
-- The composition script event dispatcher.
--------------------------------------------------------------------------------
local function createScriptEventDispatcher()
    return require("global.events.EventDispatcher"):create()
end

local function initWithScriptEventDispatcher(self, dispatcher)
    dispatcher:addEventListener("EvtPlayerRequestDoAction", self)
        :addEventListener("EvtSystemRequestDoAction", self)
    self.m_ScriptEventDispatcher = dispatcher
end

--------------------------------------------------------------------------------
-- The composition confirm box actor.
--------------------------------------------------------------------------------
local function createActorConfirmBox()
    return Actor.createWithModelAndViewName("ModelConfirmBox", nil, "ViewConfirmBox")
end

local function initWithActorConfirmBox(self, actor)
    actor:getModel():setEnabled(false)
    self.m_ActorConfirmBox = actor
end

--------------------------------------------------------------------------------
-- The composition main menu actor.
--------------------------------------------------------------------------------
local function createActorMainMenu()
    return Actor.createWithModelAndViewName("ModelMainMenu", nil, "ViewMainMenu")
end

local function initWithActorMainMenu(self, actor)
    actor:getModel():setModelConfirmBox(self.m_ActorConfirmBox:getModel())
        :setRootScriptEventDispatcher(self.m_ScriptEventDispatcher)
        :updateWithIsPlayerLoggedIn(self.m_IsPlayerLoggedIn)

    self.m_ActorMainMenu = actor
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelSceneMain:ctor(isPlayerLoggedIn)
    self.m_IsPlayerLoggedIn = (isPlayerLoggedIn) and (true) or (false)

    initWithScriptEventDispatcher(self, createScriptEventDispatcher())
    initWithActorConfirmBox(      self, createActorConfirmBox())
    initWithActorMainMenu(        self, createActorMainMenu())

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelSceneMain:initView()
    local view = self.m_View
    assert(view, "ModelSceneMain:initView() no view is attached to the owner actor of the model.")

    view:setViewConfirmBox(self.m_ActorConfirmBox:getView())
        :setViewMainMenu(  self.m_ActorMainMenu:getView())
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
