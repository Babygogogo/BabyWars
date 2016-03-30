
local ModelTurnManager = class("ModelTurnManager")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getNextTurnAndPlayerIndex(self, playerManager)
    local nextTurnIndex   = self.m_TurnIndex
    local nextPlayerIndex = self.m_PlayerIndex + 1

    while (true) do
        if (nextPlayerIndex > playerManager:getPlayersCount()) then
            nextPlayerIndex = 1
            nextTurnIndex   = nextTurnIndex + 1
        end

        assert(nextPlayerIndex ~= self.m_PlayerIndex, "ModelTurnManager-getNextTurnAndPlayerIndex() the number of alive players is less than 2.")

        if (playerManager:getModelPlayer(nextPlayerIndex):isAlive()) then
            return nextTurnIndex, nextPlayerIndex
        end
    end
end

local function onBeginTurnEffectDisappear(self)
    if (self.m_TurnPhase == "standby") then
        -- TODO: Add fund, repair units, destroy units that run out of fuel.
        self.m_TurnPhase = "main"
    elseif (self.m_TurnPhase == "main") then
        -- Do nothing.
    else
        error("ModelSceneWar-runTurn() the self phase is expected to be 'standby' or 'main'")
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelTurnManager:ctor(param)
    self.m_TurnIndex   = param.turnIndex
    self.m_PlayerIndex = param.playerIndex
    self.m_TurnPhase   = param.phase

    return self
end

function ModelTurnManager:setModelPlayerManager(playerManager)
    self.m_ModelPlayerManager = playerManager

    return self
end

function ModelTurnManager:setScriptEventDispatcher(dispatcher)
    self.m_ScriptEventDispatcher = dispatcher

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelTurnManager:getTurnIndex()
    return self.m_TurnIndex
end

function ModelTurnManager:getTurnPhase()
    return self.m_TurnPhase
end

function ModelTurnManager:getPlayerIndex()
    return self.m_PlayerIndex
end

function ModelTurnManager:runTurn(nextWeather)
    if (self.m_TurnPhase == "end") then
        self.m_ScriptEventDispatcher:dispatchEvent({name = "EvtTurnPhaseEnd", playerIndex = self.m_PlayerIndex})
    --[[
        if (self.m_Weather.m_CurrentWeather ~= nextWeather) then
            self.m_Weather.m_CurrentWeather = nextWeather
            self.m_ScriptEventDispatcher:dispatchEvent({name = "EvtWeatherChanged", weather = nextWeather})
        end
    ]]

        -- TODO: Change state for units, vision and so on.
        self.m_TurnPhase = "standby"
        self.m_TurnIndex, self.m_PlayerIndex = getNextTurnAndPlayerIndex(self, self.m_ModelPlayerManager)
    end

    local player = self.m_ModelPlayerManager:getModelPlayer(self.m_PlayerIndex)
    self.m_ScriptEventDispatcher:dispatchEvent({
        name        = "EvtTurnStarted",
        player      = player,
        playerIndex = self.m_PlayerIndex,
        turnIndex   = self.m_TurnIndex,
        callbackOnBeginTurnEffectDisappear = function()
            onBeginTurnEffectDisappear(self)
        end
    })

    return self
end

function ModelTurnManager:endTurn(nextWeather)
    assert(self.m_TurnPhase == "main", "ModelTurnManager:endTurn() the turn phase is expected to be 'main'.")

    self.m_TurnPhase = "end"
    self:runTurn(nextWeather)

    return self
end

return ModelTurnManager
