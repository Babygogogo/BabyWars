
local Producible = require("src.global.functions.class")("Producible")

local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")

Producible.EXPORTED_METHODS = {
    "getProductionCost",
}

--------------------------------------------------------------------------------
-- The static functions.
--------------------------------------------------------------------------------
function Producible.getProductionCostWithTemplateProducible(template, modelPlayerManager, playerIndex)
    local baseCost = template.productionCost
    -- TODO: take the player skills into account.

    return baseCost
end

function Producible.getProductionCostWithTiledId(tiledID, modelPlayerManager)
    local templateUnit = GameConstantFunctions.getTemplateModelUnitWithTiledId(tiledID)
    return Producible.getProductionCostWithTemplateProducible(
        templateUnit.Producible,
        modelPlayerManager,
        GameConstantFunctions.getPlayerIndexWithTiledId(tiledID)
    )
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

--------------------------------------------------------------------------------
-- The functions for doing the actions.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function Producible:getProductionCost()
    return Producible.getProductionCostWithTemplateProducible(
        self.m_Template,
        self.m_ModelPlayerManager,
        self.m_Owner:getPlayerIndex()
    )
end

return Producible
