
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
    requestedAction.playerID = self:getCurrentPlayerID() -- This should be replaced by the ID of the logged in player.

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
-- The turn.
--------------------------------------------------------------------------------
local function getNextTurnAndPlayerIndex(turn, players)
    local nextTurnIndex   = turn.m_TurnIndex
    local nextPlayerIndex = turn.m_PlayerIndex + 1

    while (true) do
        if (nextPlayerIndex > #players) then
            nextPlayerIndex = 1
            nextTurnIndex   = nextTurnIndex + 1
        end

        assert(nextPlayerIndex ~= turn.m_PlayerIndex, "ModelSceneWar-getNextTurnAndPlayerIndex() the number of alive players is less than 2.")

        if (players[nextPlayerIndex].m_IsAlive) then
            return nextTurnIndex, nextPlayerIndex
        end
    end
end

local function initTurn(model, turn)
    model.m_Turn = {
        m_TurnIndex   = turn.turnIndex,
        m_PlayerIndex = turn.playerIndex,
        m_TurnPhase   = turn.phase,
    }
end

local function runTurn(self, nextWeather)
    local turn = self.m_Turn
    if (turn.m_TurnPhase == "end") then
        if (self.m_Weather.m_CurrentWeather ~= nextWeather) then
            self.m_Weather.m_CurrentWeather = nextWeather
            self.m_ScriptEventDispatcher:dispatchEvent({name = "EvtWeatherChanged", weather = nextWeather})
        end

        -- TODO: Change state for units, vision and so on.
        turn.m_TurnPhase = "standby"
        turn.m_TurnIndex, turn.m_PlayerIndex = getNextTurnAndPlayerIndex(turn, self.m_Players)
    end

    local player = self.m_Players[turn.m_PlayerIndex]
    self.m_ScriptEventDispatcher:dispatchEvent({name = "EvtPlayerSwitched", player = player, playerIndex = turn.m_PlayerIndex})

    self.m_SceneWarHUDActor:getModel():showBeginTurnEffect(turn.m_TurnIndex, player.m_Name, function()
        if (turn.m_TurnPhase == "standby") then
            -- TODO: Add fund, repair units, destroy units that run out of fuel.
            turn.m_TurnPhase = "main"
        elseif (turn.m_TurnPhase == "main") then
            -- Do nothing.
        else
            error("ModelSceneWar-runTurn() the turn phase is expected to be 'standby' or 'main'")
        end
    end)
end

--------------------------------------------------------------------------------
-- The players.
--------------------------------------------------------------------------------
local function initPlayers(model, players)
    model.m_Players = {}
    for i, p in ipairs(players) do
        model.m_Players[i] = {
            m_ID      = p.id,
            m_Name    = p.name,
            m_Fund    = p.fund,
            m_IsAlive = p.isAlive,
            m_CO      = {
                m_CurrentEnergy    = p.co.currentEnergy,
                m_COPowerEnergy    = p.co.coPowerEnergy,
                m_SuperPowerEnergy = p.co.superPowerEnergy,
            },

            getFund = function(self)
                return self.m_Fund
            end,

            getCOEnergy = function(self)
                return self.m_CO.m_CurrentEnergy, self.m_CO.m_COPowerEnergy, self.m_CO.m_SuperPowerEnergy
            end,
        }
    end
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
    initTurn(   self, sceneData.turn)
    initPlayers(self, sceneData.players)
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
    runTurn(self)

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

function ModelSceneWar:getCurrentTurnPhase()
    return self.m_Turn.m_TurnPhase
end

--------------------------------------------------------------------------------
-- The functions that should only be called by ActionExecutor.
--------------------------------------------------------------------------------
function ModelSceneWar:endTurn(nextWeather)
    local turn = self.m_Turn
    assert(turn.m_TurnPhase == "main", "ModelSceneWar:endTurn() the turn phase is expected to be 'main'.")

    turn.m_TurnPhase = "end"
    runTurn(self, nextWeather)
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelSceneWar:getScriptEventDispatcher()
    return self.m_ScriptEventDispatcher
end

function ModelSceneWar:getCurrentPlayerID()
    return self.m_Players[self.m_Turn.m_PlayerIndex].m_ID
end

return ModelSceneWar
