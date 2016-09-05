
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

local AudioManager           = require("src.app.utilities.AudioManager")
local GameConstantFunctions  = require("src.app.utilities.GameConstantFunctions")
local LocalizationFunctions  = require("src.app.utilities.LocalizationFunctions")
local SerializationFunctions = require("src.app.utilities.SerializationFunctions")
local WebSocketManager       = require("src.app.utilities.WebSocketManager")
local Actor                  = require("src.global.actors.Actor")
local ActorManager           = require("src.global.actors.ActorManager")
local EventDispatcher        = require("src.global.events.EventDispatcher")

local getLocalizedText = LocalizationFunctions.getLocalizedText

--------------------------------------------------------------------------------
-- The functions for doing actions.
--------------------------------------------------------------------------------
local onWebSocketOpen, onWebSocketMessage, onWebSocketClose, onWebSocketError

local function doActionConnectionHeartbeat(self, action)
    if (self.m_HeartbeatID == action.heartbeatID) then
        self.m_IsHeartbeatAnswered = true
    end
end

local function doActionLogin(self, action)
    if (action.account ~= WebSocketManager.getLoggedInAccountAndPassword()) then
        WebSocketManager.setLoggedInAccountAndPassword(action.account, action.password)
        self.m_ActorMessageIndicator:getModel():showMessage(getLocalizedText(26, action.account))
    end

    self.m_ActorMainMenu:getModel():doActionLogin(action)
end

local function doActionLogout(self, event)
    local modelSceneMain = Actor.createModel("sceneMain.ModelSceneMain", {
        confirmText = event.message
    })
    local viewSceneMain  = Actor.createView("sceneMain.ViewSceneMain")

    WebSocketManager.setLoggedInAccountAndPassword(nil, nil)
        .setOwner(modelSceneMain)
    ActorManager.setAndRunRootActor(Actor.createWithModelAndViewInstance(modelSceneMain, viewSceneMain), "FADE", 1)
end

local function doActionRegister(self, action)
    WebSocketManager.setLoggedInAccountAndPassword(action.account, action.password)
    self.m_ActorMessageIndicator:getModel():showMessage(getLocalizedText(27, action.account))

    self.m_ActorMainMenu:getModel():doActionRegister(action)
end

local function doActionNewWar(self, action)
    self.m_ActorMainMenu:getModel():doActionNewWar(action)
    self.m_ActorMessageIndicator:getModel():showMessage(action.message)
end

local function doActionGetJoinableWarList(self, action)
    self.m_ActorMainMenu:getModel():doActionGetJoinableWarList(action)
end

local function doActionJoinWar(self, action)
    self.m_ActorMainMenu:getModel():doActionJoinWar(action)
end

local function doActionGetOngoingWarList(self, action)
    self.m_ActorMainMenu:getModel():doActionGetOngoingWarList(action)
end

local function doActionGetSceneWarData(self, action)
    self.m_ActorMainMenu:getModel():doActionGetSceneWarData(action)
end

local function doActionGetSkillConfiguration(self, action)
    self.m_ActorMainMenu:getModel():doActionGetSkillConfiguration(action)
end

local function doActionMessage(self, action)
    self.m_ActorMessageIndicator:getModel():showMessage(action.message)
end

--------------------------------------------------------------------------------
-- The private callback function on script events.
--------------------------------------------------------------------------------
local function onEvtSystemRequestDoAction(self, event)
    local actionName = event.actionName
    if     (actionName == "ConnectionHeartbeat")   then doActionConnectionHeartbeat(  self, event)
    elseif (actionName == "Login")                 then doActionLogin(                self, event)
    elseif (actionName == "Logout")                then doActionLogout(               self, event)
    elseif (actionName == "Register")              then doActionRegister(             self, event)
    elseif (actionName == "NewWar")                then doActionNewWar(               self, event)
    elseif (actionName == "GetJoinableWarList")    then doActionGetJoinableWarList(   self, event)
    elseif (actionName == "JoinWar")               then doActionJoinWar(              self, event)
    elseif (actionName == "GetOngoingWarList")     then doActionGetOngoingWarList(    self, event)
    elseif (actionName == "GetSceneWarData")       then doActionGetSceneWarData(      self, event)
    elseif (actionName == "GetSkillConfiguration") then doActionGetSkillConfiguration(self, event)
    elseif (actionName == "Message")               then doActionMessage(              self, event)
    elseif (actionName == "Error")                 then error("ModelSceneMain-onEvtSystemRequestDoAction() Error: " .. event.error)
    else
        print("ModelSceneMain-onEvtSystemRequestDoAction() unrecoginzed action.")
    end
end

local function onEvtPlayerRequestDoAction(self, event)
    local request = event
    request.playerAccount, request.playerPassword = WebSocketManager.getLoggedInAccountAndPassword()
    WebSocketManager.sendString(SerializationFunctions.toString(request))
end

--------------------------------------------------------------------------------
-- The private callback function on web socket events.
--------------------------------------------------------------------------------
onWebSocketOpen = function(self, param)
    print("ModelSceneMain-onWebSocketOpen()")
    self.m_ActorMessageIndicator:getModel():showMessage(getLocalizedText(30))

    local view = self.m_View
    if (view) then
        if (self.m_HeartbeatAction) then
            view:stopAction(self.m_HeartbeatAction)
        end

        self.m_HeartbeatID         = 0
        self.m_IsHeartbeatAnswered = true
        self.m_HeartbeatAction     = cc.RepeatForever:create(cc.Sequence:create(
            cc.CallFunc:create(function()
                if (not self.m_IsHeartbeatAnswered) then
                    onWebSocketClose(self)
                else
                    self.m_HeartbeatID         = self.m_HeartbeatID + 1
                    self.m_IsHeartbeatAnswered = false
                    self.m_ScriptEventDispatcher:dispatchEvent({
                        name        = "EvtPlayerRequestDoAction",
                        actionName  = "ConnectionHeartbeat",
                        heartbeatID = self.m_HeartbeatID,
                    })
                end
            end),
            cc.DelayTime:create(20)
        ))

        view:runAction(self.m_HeartbeatAction)
    end
end

onWebSocketMessage = function(self, param)
    print("ModelSceneMain-onWebSocketMessage():\n" .. param.message)

    local action = assert(loadstring("return " .. param.message))()
    onEvtSystemRequestDoAction(self, action)
end

onWebSocketClose = function(self, param)
    print("ModelSceneMain-onWebSocketClose()")
    self.m_ActorMessageIndicator:getModel():showMessage(getLocalizedText(31))

    if (self.m_View) then
        if (self.m_HeartbeatAction) then
            self.m_View:stopAction(self.m_HeartbeatAction)
            self.m_HeartbeatAction = nil
        end
    end

    WebSocketManager.close()
        .init()
        .setOwner(self)
end

onWebSocketError = function(self, param)
    print("ModelSceneMain-onWebSocketError() " .. param.error)
    self.m_ActorMessageIndicator:getModel():showMessage(getLocalizedText(32, param.error))

    if (self.m_View) then
        if (self.m_HeartbeatAction) then
            self.m_View:stopAction(self.m_HeartbeatAction)
            self.m_HeartbeatAction = nil
        end
    end

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

function ModelSceneMain:onStartRunning()
    AudioManager.playMainMusic()

    return self
end

--------------------------------------------------------------------------------
-- The callback function on script/web socket events.
--------------------------------------------------------------------------------
function ModelSceneMain:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtPlayerRequestDoAction") then onEvtPlayerRequestDoAction(self, event)
    elseif (eventName == "EvtSystemRequestDoAction") then onEvtSystemRequestDoAction(self, event)
    end

    return self
end

function ModelSceneMain:onWebSocketEvent(eventName, param)
    if     (eventName == "open")    then onWebSocketOpen(   self, param)
    elseif (eventName == "message") then onWebSocketMessage(self, param)
    elseif (eventName == "close")   then onWebSocketClose(  self, param)
    elseif (eventName == "error")   then onWebSocketError(  self, param)
    end

    return self
end

return ModelSceneMain
