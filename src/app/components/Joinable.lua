
local Joinable = requireBW("src.global.functions.class")("Joinable")

local ComponentManager = requireBW("src.global.components.ComponentManager")

Joinable.EXPORTED_METHODS = {
    "canJoinModelUnit",
    "getJoinIncome",
}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function round(num)
    return math.floor(num + 0.5)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function Joinable:ctor(param)
    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function Joinable:canJoinModelUnit(modelUnit)
    local owner = self.m_Owner
    if ((owner:getTiledId() ~= modelUnit:getTiledId() or
        (modelUnit:getNormalizedCurrentHP() == 10)))  then
        return false
    end

    if ((owner.getCurrentLoadCount)                                                   and
        ((owner:getCurrentLoadCount() > 0) or (modelUnit:getCurrentLoadCount() > 0))) then
        return false
    end

    return true
end

function Joinable:getJoinIncome(modelUnit)
    if (not self:canJoinModelUnit(modelUnit)) then
        return nil
    else
        -- TODO: take the player skills into account.
        local joinedNormalizedHP = self.m_Owner:getNormalizedCurrentHP() + modelUnit:getNormalizedCurrentHP()
        return (joinedNormalizedHP > 10)                                               and
            (math.floor((joinedNormalizedHP - 10) * self.m_Owner:getProductionCost() / 10)) or
            (0)
    end
end

return Joinable
