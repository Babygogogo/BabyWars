
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
    requestedAction.playerID = self.m_PlayerManager:getPlayer(self.m_TurnManager:getPlayerIndex()):getID() -- This should be replaced by the ID of the logged in player.

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
-- The comsition actors.
--------------------------------------------------------------------------------
local function createCompositionActors(sceneData)
    local warFieldActor = Actor.createWithModelAndViewName("ModelWarField", sceneData.warField, "ViewWarField", sceneData.warField)
    assert(warFieldActor, "SceneWar--createCompositionActors() failed to create a war field actor.")

    local hudActor = Actor.createWithModelAndViewName("ModelSceneWarHUD", nil, "ViewSceneWarHUD")
    assert(hudActor, "SceneWar--createCompositionActors() failed to create a HUD actor.")

    return {
        warFieldActor    = warFieldActor,
        sceneWarHUDActor = hudActor,
    }
end

local function initWithCompositionActors(self, actors)
    self.m_WarFieldActor    = actors.warFieldActor
    self.m_SceneWarHUDActor = actors.sceneWarHUDActor
end

--------------------------------------------------------------------------------
-- The player manager.
--------------------------------------------------------------------------------
local function createPlayerManager(playersData)
    return require("app.utilities.PlayerManager"):create(playersData)
end

local function initWithPlayerManager(self, playerManager)
    self.m_PlayerManager = playerManager
end

--------------------------------------------------------------------------------
-- The turn manager.
--------------------------------------------------------------------------------
local function createTurnManager(turnData)
    return require("app.utilities.TurnManager"):create(turnData)
end

local function initWithTurnManager(self, turnManager)
    turnManager:setPlayerManager(self.m_PlayerManager)
        :setScriptEventDispatcher(self.m_ScriptEventDispatcher)
    self.m_TurnManager = turnManager
end

--------------------------------------------------------------------------------
-- The weather.
--------------------------------------------------------------------------------
local function initWeather(model, weather)
    model.m_Weather = {
        m_CurrentWeather = weather.current
    }
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelSceneWar:ctor(param)
    assert(param, "ModelSceneWar:ctor() tempting to initialize the instance with no param.")
    local sceneData = requireSceneData(param)

    initWithScriptEventDispatcher(self, createScriptEventDispatcher())
    initWithCompositionActors(    self, createCompositionActors(sceneData))
    initWithPlayerManager(        self, createPlayerManager(sceneData.players))
    initWithTurnManager(          self, createTurnManager(sceneData.turn))
    initWeather(self, sceneData.weather)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelSceneWar:initView()
    local view = self.m_View
    assert(view, "ModelSceneWar:initView() no view is attached.")

    view:setWarFieldView(self.m_WarFieldActor:getView())
        :setSceneHudView(self.m_SceneWarHUDActor:getView())

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

    self.m_SceneWarHUDActor:onEnter(rootActor)
    self.m_WarFieldActor:onEnter(rootActor)

    self.m_ScriptEventDispatcher:dispatchEvent({name = "EvtWeatherChanged", weather = self.m_Weather.m_CurrentWeather})

    return self
end

function ModelSceneWar:onEnterTransitionFinish(rootActor)
    self.m_TurnManager:runTurn()

    return self
end

function ModelSceneWar:onCleanup(rootActor)
    print("ModelSceneWar:onCleanup()")

    self.m_ScriptEventDispatcher:removeEventListener("EvtSystemRequestDoAction", self)
        :removeEventListener("EvtPlayerRequestDoAction", self)

    self.m_SceneWarHUDActor:onCleanup(rootActor)
    self.m_WarFieldActor:onCleanup(rootActor)

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
-- The functions that should only be called by ActionTranslator.
--------------------------------------------------------------------------------
function ModelSceneWar:getNextWeather()
    -- TODO: add code to do the real work.
    return "clear"
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelSceneWar:getScriptEventDispatcher()
    return self.m_ScriptEventDispatcher
end

function ModelSceneWar:getTurnManager()
    return self.m_TurnManager
end

function ModelSceneWar:getPlayerManager()
    return self.m_PlayerManager
end

return ModelSceneWar
