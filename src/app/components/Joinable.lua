
local Joinable = require("src.global.functions.class")("Joinable")

local ComponentManager = require("src.global.components.ComponentManager")

Joinable.EXPORTED_METHODS = {
    "canJoinModelUnit",
    "getJoinIncome",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function Joinable:ctor(param)
    return self
end

function Joinable:setModelPlayerManager(model)
    assert(self.m_ModelPlayerManager == nil, "Joinable:setModelPlayerManager() the model has been set already.")
    self.m_ModelPlayerManager = model

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function Joinable:canJoinModelUnit(modelUnit)
    local owner = self.m_Owner
    if (owner:getTiledID() ~= modelUnit:getTiledID()) then
        return false
    end

    for _, component in pairs(ComponentManager.getAllComponents(owner)) do
        if ((component ~= self)                          and
            (component.canJoinModelUnit)                 and
            (not component:canJoinModelUnit(modelUnit))) then
            return false
        end
    end

    return true
end

function Joinable:getJoinIncome(modelUnit)
    if (not self:canJoinModelUnit(modelUnit)) then
        return nil
    else
        -- TODO: take the player skills into account.
        local joinedNormalizedHP = self.m_Owner:getNormalizedCurrentHP() + modelUnit:getNormalizedCurrentHP()
        return (joinedNormalizedHP > 10)                                        and
            ((joinedNormalizedHP - 10) * self.m_Owner:getProductionCost() / 10) or
            (0)
    end
end

return Joinable
