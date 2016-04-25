
local UnitProducer = class("UnitProducer")

local TypeChecker           = require("app.utilities.TypeChecker")
local ComponentManager      = require("global.components.ComponentManager")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")

local EXPORTED_METHODS = {
    "getProductionCostWithTiledId",
    "getProductionList",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function UnitProducer:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function UnitProducer:loadTemplate(template)
    assert(type(template.productionList) == "table", "UnitProducer:loadTemplate() the param template is invalid.")
    self.m_Template = template

    return self
end

function UnitProducer:loadInstantialData(data)
    return self
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function UnitProducer:onBind(target)
    assert(self.m_Target == nil, "UnitProducer:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Target = target

    return self
end

function UnitProducer:onUnbind()
    assert(self.m_Target ~= nil, "UnitProducer:onUnbind() the component has not bound to a target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function UnitProducer:getProductionCostWithTiledId(tiledID, modelPlayer)
    if (GameConstantFunctions.getPlayerIndexWithTiledId(tiledID) ~= self.m_Target:getPlayerIndex()) then
        return nil
    end

    local templateUnit = GameConstantFunctions.getTemplateModelUnitWithTiledId(tiledID)
    -- TODO: take the ablities of the player into account
    return templateUnit.cost
end

function UnitProducer:getProductionList(modelPlayer)
    local list        = {}
    local fund        = modelPlayer:getFund()
    local playerIndex = self.m_Target:getPlayerIndex()

    for i, unitName in ipairs(self.m_Template.productionList) do
        list[i]            = {}
        local tiledID      = GameConstantFunctions.getTiledIdWithTileOrUnitName(unitName, playerIndex)
        local cost         = self:getProductionCostWithTiledId(tiledID, modelPlayer)

        list[i].fullName    = GameConstantFunctions.getTemplateModelUnitWithTiledId(tiledID).fullName
        list[i].cost        = cost
        list[i].isAvaliable = cost <= fund
        list[i].tiledID     = tiledID
    end

    return list
end

return UnitProducer
