
local PlayerManager = class("PlayerManager")

local Player      = require("app.utilities.Player")
local TypeChecker = require("app.utilities.TypeChecker")

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function PlayerManager:ctor(param)
    self.m_Players = {}
    for i, player in ipairs(param) do
        self.m_Players[i] = Player:create(player)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function PlayerManager:getPlayer(playerIndex)
    return self.m_Players[playerIndex]
end

function PlayerManager:getPlayersCount()
    return #self.m_Players
end

return PlayerManager
