
local Producible = require("src.global.functions.class")("Producible")

local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")

Producible.EXPORTED_METHODS = {
    "getProductionCost",
}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function round(num)
    return math.floor(num + 0.5)
end

--------------------------------------------------------------------------------
-- The static functions.
--------------------------------------------------------------------------------
function Producible.getProductionCostWithTiledId(tiledID, modelPlayerManager)
    local playerIndex = GameConstantFunctions.getPlayerIndexWithTiledId(tiledID)
    local modifier    = modelPlayerManager:getModelPlayer(playerIndex):getModelSkillConfiguration():getProductionCostModifier()
    -- TODO: take the skills of the opponents into account.

    local baseCost = GameConstantFunctions.getTemplateModelUnitWithTiledId(tiledID).Producible.productionCost
    if (modifier > 0) then
        return round(baseCost * (1 + modifier / 100))
    else
        return round(baseCost / (1 - modifier / 100))
    end
end

--------------------------------------------------------------------------------
-- The static functions.
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
-- The functions for doing the actions.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function Producible:getProductionCost()
    return Producible.getProductionCostWithTiledId(self.m_Owner:getTiledId(), self.m_ModelPlayerManager)
end

return Producible
