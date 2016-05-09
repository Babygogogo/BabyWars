
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
--
--  - 目前，ModelSceneWar还简单地模拟把玩家操作（也就是EvtPlayerRequestDoAction）传送到服务器，再接收服务器传回的操作（EvtSystemRequestDoAction）的过程（参见ActionTranslator）。
--    这本不应该是ModelSceneWar的工作，等以后实现了网络模块，就应该把相关代码移除。
--]]--------------------------------------------------------------------------------

local ModelSceneWar = class("ModelSceneWar")

local isServer = true

local Actor            = require("global.actors.Actor")
local TypeChecker      = require("app.utilities.TypeChecker")
local ActionTranslator = require("app.utilities.ActionTranslator")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function requireSceneData(param)
    local t = type(param)
    if (t == "table") then
        return param
    elseif (t == "string") then
        return require("res.data.warScene." .. param)
    else
        error("ModelSceneWar-requireSceneData() the param is invalid.")
    end
end

--------------------------------------------------------------------------------
-- The functions that do the actions the system requested.
--------------------------------------------------------------------------------
local function doActionEndTurn(self, action)
    self:getModelTurnManager():endTurn()
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
    if (actionName == "EndTurn") then
        doActionEndTurn(self, event)
    elseif (actionName == "Wait") then
        doActionWait(self, event)
    elseif (actionName == "Attack") then
        doActionAttack(self, event)
    elseif (actionName == "Capture") then
        doActionCapture(self, event)
    elseif (actionName == "ProduceOnTile") then
        doActionProduceOnTile(self, event)
    else
        print("ModelSceneWar-onEvtSystemRequestDoAction() unrecognized action.")
    end
end

local function onEvtPlayerRequestDoAction(self, event)
    local requestedAction = event
    requestedAction.playerID = self:getModelPlayerManager():getModelPlayer(self:getModelTurnManager():getPlayerIndex()):getID() -- This should be replaced by the ID of the logged in player.

    if (isServer) then
        local translatedAction, translateMsg = ActionTranslator.translate(requestedAction, self)
        if (not translatedAction) then
            print("ModelSceneWar-onEvtPlayerRequestDoAction() action translation failed: " .. (translateMsg or ""))
        else
            onEvtSystemRequestDoAction(self, translatedAction)
            -- TODO: send the translatedAction to clients.
        end
    else
        -- TODO: send the requestedAction to the server.
    end
end

--------------------------------------------------------------------------------
-- The script event dispatcher.
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
-- The composition war field actor.
--------------------------------------------------------------------------------
local function createActorWarField(warFieldData)
    return Actor.createWithModelAndViewName("ModelWarField", warFieldData, "ViewWarField", warFieldData)
end

local function initWithActorWarField(self, actor)
    actor:getModel():setRootScriptEventDispatcher(self.m_ScriptEventDispatcher)
    self.m_ActorWarField = actor
end

--------------------------------------------------------------------------------
-- The composition HUD actor.
--------------------------------------------------------------------------------
local function createActorSceneWarHUD()
    return Actor.createWithModelAndViewName("ModelWarHUD", nil, "ViewWarHUD")
end

local function initWithActorWarHud(self, actor)
    actor:getModel():setRootScriptEventDispatcher(self.m_ScriptEventDispatcher)
    self.m_ActorWarHud = actor
end

--------------------------------------------------------------------------------
-- The player manager.
--------------------------------------------------------------------------------
local function createActorPlayerManager(playersData)
    return Actor.createWithModelAndViewName("ModelPlayerManager", playersData)
end

local function initWithActorPlayerManager(self, actor)
    actor:getModel():setRootScriptEventDispatcher(self.m_ScriptEventDispatcher)
    self.m_ActorPlayerManager = actor
end

--------------------------------------------------------------------------------
-- The turn manager.
--------------------------------------------------------------------------------
local function createActorTurnManager(turnData)
    return Actor.createWithModelAndViewName("ModelTurnManager", turnData)
end

local function initWithActorTurnManager(self, actor)
    actor:getModel():setModelPlayerManager(self:getModelPlayerManager())
        :setModelWarField(self.m_ActorWarField:getModel())
        :setRootScriptEventDispatcher(self.m_ScriptEventDispatcher)
    self.m_ActorTurnManager = actor
end

--------------------------------------------------------------------------------
-- The composition weather manager actor.
--------------------------------------------------------------------------------
local function createActorWeatherManager(weatherData)
    return Actor.createWithModelAndViewName("ModelWeatherManager", weatherData)
end

local function initWithActorWeatherManager(self, actor)
    self.m_ActorWeatherManager = actor
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelSceneWar:ctor(param)
    assert(param, "ModelSceneWar:ctor() tempting to initialize the instance with no param.")
    local sceneData = requireSceneData(param)

    initWithScriptEventDispatcher(self, createScriptEventDispatcher())
    initWithActorWarField(        self, createActorWarField(sceneData.warField))
    initWithActorWarHud(          self, createActorSceneWarHUD())
    initWithActorPlayerManager(   self, createActorPlayerManager(sceneData.players))
    initWithActorTurnManager(     self, createActorTurnManager(sceneData.turn))
    initWithActorWeatherManager(  self, createActorWeatherManager(sceneData.weather))

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelSceneWar:initView()
    local view = self.m_View
    assert(view, "ModelSceneWar:initView() no view is attached.")

    view:setViewWarField(self.m_ActorWarField:getView())
        :setViewWarHud(self.m_ActorWarHud:getView())

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on start/stop running and script events.
--------------------------------------------------------------------------------
function ModelSceneWar:onStartRunning()
    self.m_ScriptEventDispatcher:dispatchEvent({
            name = "EvtModelWeatherUpdated",
            modelWeather = self:getModelWeatherManager():getCurrentWeather()
        })
        :dispatchEvent({
            name = "EvtSceneWarStarted",
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

return ModelSceneWar
