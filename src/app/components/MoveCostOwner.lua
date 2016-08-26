
--[[--------------------------------------------------------------------------------
-- MoveCostOwner是ModelTile可用的组件。只有绑定了本组件，宿主才具有“移动力消耗值”的属性。
-- 主要职责：
--   维护相关数值并提供必要接口给外界访问
-- 使用场景举例：
--   宿主初始化时，根据属性来绑定和初始化本组件（所有ModelTile都需要绑定，但具体由GameConstant决定）
--   unit进行移动时，会用到本组件提供的移动消耗值
-- 其他：
--   加入co技能后，本组件需要考虑技能对移动消耗的影响
--   需要传入移动类型，本组件才能返回相应的移动力消耗值
--]]--------------------------------------------------------------------------------

local MoveCostOwner = require("src.global.functions.class")("MoveCostOwner")

local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")
local ComponentManager      = require("src.global.components.ComponentManager")

MoveCostOwner.EXPORTED_METHODS = {
    "getMoveCostWithMoveType",
    "getMoveCostWithModelUnit",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function MoveCostOwner:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function MoveCostOwner:loadTemplate(template)
    assert(type(template) == "table", "MoveCostOwner:loadTemplate() the param template is invalid.")
    self.m_Template = template

    return self
end

function MoveCostOwner:loadInstantialData(data)
    return self
end

function MoveCostOwner:setModelPlayerManager(model)
    assert(self.m_ModelPlayerManager == nil, "MoveCostOwner:setModelPlayerManager() the model has been set already.")
    self.m_ModelPlayerManager = model

    return self
end

function MoveCostOwner:unsetModelPlayerManager()
    assert(self.m_ModelPlayerManager, "MoveCostOwner:unsetModelPlayerManager() the model hasn't been set.")
    self.m_ModelPlayerManager = nil

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function MoveCostOwner:getMoveCostWithMoveType(moveType)
    -- TODO: take the skills of the players into account.

    return self.m_Template[moveType]
end

function MoveCostOwner:getMoveCostWithModelUnit(modelUnit)
    local owner    = self.m_Owner
    local tileType = owner:getTileType()
    if (((tileType == "Seaport") or (tileType == "TempSeaport"))                              and
        (owner:getPlayerIndex() ~= modelUnit:getPlayerIndex())                                and
        (GameConstantFunctions.isTypeInCategory(modelUnit:getUnitType(), "LargeNavalUnits"))) then
        return nil
    else
        return self:getMoveCostWithMoveType(modelUnit:getMoveType())
    end
end

return MoveCostOwner
