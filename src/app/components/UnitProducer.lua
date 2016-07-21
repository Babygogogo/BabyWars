
--[[--------------------------------------------------------------------------------
-- UnitProducer是ModelTile可用的组件。只有绑定了本组件，宿主才具有“生产单位”的能力。
-- 主要职责：
--   维护相关数值并提供必要接口给外界访问
-- 使用场景举例：
--   宿主初始化时，根据属性来绑定和初始化本组件（factory需要绑定，plain不用，具体由GameConstant决定）
--   玩家点击特定tile的时候，需要通过本组件获取可生产的单位的列表及相应价格等
-- 其他：
--   生产价格受co技能影响（但目前未完成）
--]]--------------------------------------------------------------------------------

local UnitProducer = require("src.global.functions.class")("UnitProducer")

local TypeChecker           = require("src.app.utilities.TypeChecker")
local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")
local Actor                 = require("src.global.actors.Actor")
local ComponentManager      = require("src.global.components.ComponentManager")

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
        local tiledID = GameConstantFunctions.getTiledIdWithTileOrUnitName(unitName, playerIndex)
        local cost    = self:getProductionCostWithTiledId(tiledID, modelPlayer)

        list[i] = {
            modelUnit   = Actor.createModel("sceneWar.ModelUnit", {tiledID = tiledID}),
            fullName    = GameConstantFunctions.getTemplateModelUnitWithTiledId(tiledID).fullName,
            cost        = cost,
            isAvailable = cost <= fund,
            tiledID     = tiledID,
        }
    end

    return list
end

return UnitProducer
