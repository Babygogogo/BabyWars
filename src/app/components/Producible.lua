
local Producible = require("src.global.functions.class")("Producible")

local GameConstantFunctions  = require("src.app.utilities.GameConstantFunctions")
local SkillModifierFunctions = require("src.app.utilities.SkillModifierFunctions")

Producible.EXPORTED_METHODS = {
    "getProductionCost",
}

--------------------------------------------------------------------------------
-- The static functions.
--------------------------------------------------------------------------------
function Producible.getProductionCostWithTiledId(tiledID, modelPlayerManager)
    local playerIndex = GameConstantFunctions.getPlayerIndexWithTiledId(tiledID)
    local modifier    = SkillModifierFunctions.getProductionCostModifier(modelPlayerManager:getModelPlayer(playerIndex):getModelSkillConfiguration())
    -- TODO: take the skills of the opponents into account.

    local baseCost = GameConstantFunctions.getTemplateModelUnitWithTiledId(tiledID).Producible.productionCost
    if (modifier > 0) then
        return math.floor(baseCost * (1 + modifier / 100))
    else
        return math.floor(baseCost / (1 - modifier / 100))
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function Producible:ctor(param)
    self:loadTemplate(param.template)

    return self
end

function Producible:loadTemplate(template)
    self.m_Template = template

    return self
end

function Producible:setModelPlayerManager(model)
    assert(self.m_ModelPlayerManager == nil, "Producible:setModelPlayerManager() the model has been set already.")
    self.m_ModelPlayerManager = model

    return self
end

function Producible:unsetModelPlayerManager()
    assert(self.m_ModelPlayerManager, "Producible:unsetModelPlayerManager() the model hasn't been set.")
    self.m_ModelPlayerManager = nil

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function Producible:getProductionCost()
    return Producible.getProductionCostWithTiledId(self.m_Owner:getTiledId(), self.m_ModelPlayerManager)
end

return Producible
