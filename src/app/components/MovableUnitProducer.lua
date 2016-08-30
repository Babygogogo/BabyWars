
local MovableUnitProducer = require("src.global.functions.class")("MovableUnitProducer")

local Producible            = require("src.app.components.Producible")
local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")
local Actor                 = require("src.global.actors.Actor")
local ComponentManager      = require("src.global.components.ComponentManager")

MovableUnitProducer.EXPORTED_METHODS = {
    "getMovableProductionCost",
    "getMovableProductionTiledId",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function MovableUnitProducer:ctor(param)
    self:loadTemplate(param.template)

    return self
end

function MovableUnitProducer:loadTemplate(template)
    self.m_Template = template

    return self
end

function MovableUnitProducer:setModelPlayerManager(model)
    assert(self.m_ModelPlayerManager == nil, "MovableUnitProducer:setModelPlayerManager() the model has been set already.")
    self.m_ModelPlayerManager = model

    return self
end

function MovableUnitProducer:unsetModelPlayerManager()
    assert(self.m_ModelPlayerManager, "MovableUnitProducer:unsetModelPlayerManager() the model hasn't been set.")
    self.m_ModelPlayerManager = nil

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function MovableUnitProducer:doActionProduceModelUnitOnUnit(action, producedUnitID)
    local owner = self.m_Owner
    owner:setCurrentMaterial(owner:getCurrentMaterial() - 1)
        :addLoadUnitId(producedUnitID)

    return owner
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function MovableUnitProducer:getMovableProductionCost()
    return Producible.getProductionCostWithTiledId(self:getMovableProductionTiledId(), self.m_ModelPlayerManager)
end

function MovableUnitProducer:getMovableProductionTiledId()
    return GameConstantFunctions.getTiledIdWithTileOrUnitName(self.m_Template.targetType, self.m_Owner:getPlayerIndex())
end

return MovableUnitProducer
