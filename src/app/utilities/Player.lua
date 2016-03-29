
local Player = class("Player")

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function Player:ctor(param)
    self.m_ID      = param.id
    self.m_Name    = param.name
    self.m_Fund    = param.fund
    self.m_IsAlive = param.isAlive
    self.m_CO      = {
        m_CurrentEnergy    = param.co.currentEnergy,
        m_COPowerEnergy    = param.co.coPowerEnergy,
        m_SuperPowerEnergy = param.co.superPowerEnergy,
    }

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function Player:getID()
    return self.m_ID
end

function Player:getName()
    return self.m_Name
end

function Player:isAlive()
    return self.m_IsAlive
end

function Player:getFund()
    return self.m_Fund
end

function Player:getCOEnergy()
    return self.m_CO.m_CurrentEnergy, self.m_CO.m_COPowerEnergy, self.m_CO.m_SuperPowerEnergy
end

return Player
