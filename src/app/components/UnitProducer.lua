
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

local UnitProducer = requireBW("src.global.functions.class")("UnitProducer")

local GameConstantFunctions = requireBW("src.app.utilities.GameConstantFunctions")
local SingletonGetters      = requireBW("src.app.utilities.SingletonGetters")
local Actor                 = requireBW("src.global.actors.Actor")
local ComponentManager      = requireBW("src.global.components.ComponentManager")

UnitProducer.EXPORTED_METHODS = {
    "canProduceUnitWithTiledId",
    "getProductionList",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function UnitProducer:ctor(param)
    self:loadTemplate(param.template)

    return self
end

function UnitProducer:loadTemplate(template)
    assert(type(template.productionList) == "table", "UnitProducer:loadTemplate() the param template is invalid.")
    self.m_Template = template

    return self
end

--------------------------------------------------------------------------------
-- The public callback functions on start running.
--------------------------------------------------------------------------------
function UnitProducer:onStartRunning(modelSceneWar)
    self.m_ModelSceneWar = modelSceneWar

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function UnitProducer:canProduceUnitWithTiledId(tiledID)
    if (self.m_Owner:getPlayerIndex() ~= GameConstantFunctions.getPlayerIndexWithTiledId(tiledID)) then
        return false
    else
        local unitType = GameConstantFunctions.getUnitTypeWithTiledId(tiledID)
        for _, t in pairs(self.m_Template.productionList) do
            if (unitType == t) then
                return true
            end
        end

        return false
    end
end

function UnitProducer:getProductionList()
    local playerIndex      = self.m_Owner:getPlayerIndex()
    local modelSceneWar    = self.m_ModelSceneWar
    local fund             = SingletonGetters.getModelPlayerManager(modelSceneWar):getModelPlayer(playerIndex):getFund()
    local list             = {}

    for i, unitName in ipairs(self.m_Template.productionList) do
        local tiledID   = GameConstantFunctions.getTiledIdWithTileOrUnitName(unitName, playerIndex)
        local modelUnit = Actor.createModel("sceneWar.ModelUnit", {tiledID = tiledID})
        modelUnit:onStartRunning(modelSceneWar)
        local cost      = modelUnit:getProductionCost()

        list[i] = {
            modelUnit   = modelUnit,
            fullName    = modelUnit:getUnitType(),
            cost        = cost,
            isAvailable = cost <= fund,
            tiledID     = tiledID,
        }
    end

    return list
end

return UnitProducer
