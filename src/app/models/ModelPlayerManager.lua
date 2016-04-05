
local ModelPlayerManager = class("ModelPlayerManager")

local Player      = require("app.models.ModelPlayer")

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
-- The public functions.
--------------------------------------------------------------------------------
function ModelPlayerManager:getModelPlayer(playerIndex)
    return self.m_Players[playerIndex]
end

function ModelPlayerManager:getPlayersCount()
    return #self.m_Players
end

return ModelPlayerManager
