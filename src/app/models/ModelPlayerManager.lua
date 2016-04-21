
local ModelPlayerManager = class("ModelPlayerManager")

local Player      = require("app.models.ModelPlayer")

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseGetFund(self, event)
    local playerIndex = event.playerIndex
    local modelPlayer = self:getModelPlayer(playerIndex)

    if (modelPlayer:isAlive()) then
        local income = 0
        event.modelTileMap:forEachModelTile(function(modelTile)
            if (modelTile.getIncomeAmount) then
                income = income + (modelTile:getIncomeAmount(playerIndex) or 0)
            end
        end)

        modelPlayer:setFund(modelPlayer:getFund() + income)
        self.m_RootScriptEventDispatcher:dispatchEvent({
            name        = "EvtModelPlayerUpdated",
            modelPlayer = modelPlayer,
            playerIndex = playerIndex,
        })
    end
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelPlayerManager:ctor(param)
    self.m_Players = {}
    for i, player in ipairs(param) do
        self.m_Players[i] = Player:create(player)
    end

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelPlayerManager:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtTurnPhaseGetFund", self)

    return self
end

function ModelPlayerManager:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseGetFund", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelPlayerManager:onEvent(event)
    local eventName = event.name
    if (eventName == "EvtTurnPhaseGetFund") then
        onEvtTurnPhaseGetFund(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelPlayerManager:getModelPlayer(playerIndex)
    return self.m_Players[playerIndex]
end

function ModelPlayerManager:getPlayersCount()
    return #self.m_Players
end

return ModelPlayerManager
