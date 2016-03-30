
local ModelSceneWar = class("ModelSceneWar")

local isServer = true

local Actor            = require("global.actors.Actor")
local TypeChecker      = require("app.utilities.TypeChecker")
local ActionTranslator = require("app.utilities.ActionTranslator")
local ActionExecutor   = require("app.utilities.ActionExecutor")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createNodeEventHandler(model, rootActor)
    return function(event)
        if (event == "enter") then
            model:onEnter(rootActor)
        elseif (event == "enterTransitionFinish") then
            model:onEnterTransitionFinish(rootActor)
        elseif (event == "cleanup") then
            model:onCleanup(rootActor)
        end
    end
end

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
-- The functions on EvtPlayerRequestDoAction/EvtSystemRequestDoAction.
--------------------------------------------------------------------------------
local function onEvtSystemRequestDoAction(self, event)
    ActionExecutor.execute(event, self)
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

local function initWithScriptEventDispatcher(model, dispatcher)
    model.m_ScriptEventDispatcher = dispatcher
end

--------------------------------------------------------------------------------
-- The composition war field actor.
--------------------------------------------------------------------------------
local function createActorWarField(warFieldData)
    return Actor.createWithModelAndViewName("ModelWarField", warFieldData, "ViewWarField", warFieldData)
end

local function initWithActorWarField(self, actor)
    self.m_ActorWarField = actor
end

--------------------------------------------------------------------------------
-- The composition HUD actor.
--------------------------------------------------------------------------------
local function createActorSceneWarHUD()
    return Actor.createWithModelAndViewName("ModelSceneWarHUD", nil, "ViewSceneWarHUD")
end

local function initWithActorSceneWarHUD(self, actor)
    self.m_ActorSceneWarHUD = actor
end

--------------------------------------------------------------------------------
-- The player manager.
--------------------------------------------------------------------------------
local function createActorPlayerManager(playersData)
    return Actor.createWithModelAndViewName("ModelPlayerManager", playersData)
end

local function initWithActorPlayerManager(self, actor)
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
        :setScriptEventDispatcher(self.m_ScriptEventDispatcher)
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
    initWithActorSceneWarHUD(     self, createActorSceneWarHUD())
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

    view:setWarFieldView(self.m_ActorWarField:getView())
        :setSceneHudView(self.m_ActorSceneWarHUD:getView())

        :registerScriptHandler(createNodeEventHandler(self, self.m_Actor))

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node events.
--------------------------------------------------------------------------------
function ModelSceneWar:onEnter(rootActor)
    print("ModelSceneWar:onEnter()")

    self.m_ScriptEventDispatcher:addEventListener("EvtPlayerRequestDoAction", self)
        :addEventListener("EvtSystemRequestDoAction", self)

    self.m_ActorSceneWarHUD:onEnter(rootActor)
    self.m_ActorWarField:onEnter(rootActor)

    self.m_ScriptEventDispatcher:dispatchEvent({name = "EvtWeatherChanged", weather = self:getModelWeatherManager():getCurrentWeather()})

    return self
end

function ModelSceneWar:onEnterTransitionFinish(rootActor)
    self:getModelTurnManager():runTurn()

    return self
end

function ModelSceneWar:onCleanup(rootActor)
    print("ModelSceneWar:onCleanup()")

    self.m_ScriptEventDispatcher:removeEventListener("EvtSystemRequestDoAction", self)
        :removeEventListener("EvtPlayerRequestDoAction", self)

    self.m_ActorSceneWarHUD:onCleanup(rootActor)
    self.m_ActorWarField:onCleanup(rootActor)

    return self
end

function ModelSceneWar:onEvent(event)
    if (event.name == "EvtPlayerRequestDoAction") then
        onEvtPlayerRequestDoAction(self, event)
    elseif (event.name == "EvtSystemRequestDoAction") then
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
