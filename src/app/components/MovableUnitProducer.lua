
local MovableUnitProducer = require("src.global.functions.class")("MovableUnitProducer")

local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")
local Actor                 = require("src.global.actors.Actor")
local ComponentManager      = require("src.global.components.ComponentManager")

local EXPORTED_METHODS = {
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

function MovableUnitProducer:loadInstantialData(data)
    return self
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function MovableUnitProducer:onBind(target)
    assert(self.m_Owner == nil, "MovableUnitProducer:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Owner = target

    return self
end

function MovableUnitProducer:onUnbind()
    assert(self.m_Owner ~= nil, "MovableUnitProducer:onUnbind() the component has not bound to a target.")

    ComponentManager.unsetMethods(self.m_Owner, EXPORTED_METHODS)
    self.m_Owner = nil

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
    local tiledID      = self:getMovableProductionTiledId()
    local templateUnit = GameConstantFunctions.getTemplateModelUnitWithTiledId(tiledID)
    -- TODO: take the ablities of the player into account
    return templateUnit.cost
end

function MovableUnitProducer:getMovableProductionTiledId()
    return GameConstantFunctions.getTiledIdWithTileOrUnitName(self.m_Template.targetType, self.m_Owner:getPlayerIndex())
end

return MovableUnitProducer
