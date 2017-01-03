
local Producible = require("src.global.functions.class")("Producible")

local GameConstantFunctions  = require("src.app.utilities.GameConstantFunctions")
local SingletonGetters       = require("src.app.utilities.SingletonGetters")
local SkillModifierFunctions = require("src.app.utilities.SkillModifierFunctions")

Producible.EXPORTED_METHODS = {
    "getProductionCost",
    "getBaseProductionCost",
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

--------------------------------------------------------------------------------
-- The public callback function on start running.
--------------------------------------------------------------------------------
function Producible:onStartRunning(modelSceneWar, sceneWarFileName)
    self.m_SceneWarFileName = sceneWarFileName

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function Producible:getProductionCost()
    return Producible.getProductionCostWithTiledId(self.m_Owner:getTiledId(), SingletonGetters.getModelPlayerManager(self.m_SceneWarFileName))
end

function Producible:getBaseProductionCost()
    return self.m_Template.productionCost
end

return Producible
