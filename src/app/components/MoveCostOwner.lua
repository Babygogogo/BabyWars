
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

local GameConstantFunctions  = require("src.app.utilities.GameConstantFunctions")
local SingletonGetters       = require("src.app.utilities.SingletonGetters")
local SkillModifierFunctions = require("src.app.utilities.SkillModifierFunctions")
local ComponentManager       = require("src.global.components.ComponentManager")

MoveCostOwner.EXPORTED_METHODS = {
    "getMoveCostWithMoveType",
    "getMoveCostWithModelUnit",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function MoveCostOwner:ctor(param)
    self:loadTemplate(param.template)

    return self
end

function MoveCostOwner:loadTemplate(template)
    assert(type(template) == "table", "MoveCostOwner:loadTemplate() the param template is invalid.")
    self.m_Template = template

    return self
end

--------------------------------------------------------------------------------
-- The public callback function on start running.
--------------------------------------------------------------------------------
function MoveCostOwner:onStartRunning(sceneWarFileName)
    self.m_SceneWarFileName = sceneWarFileName

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
        local baseCost = self:getMoveCostWithMoveType(modelUnit:getMoveType())
        if (not baseCost) then
            return baseCost
        else
            local modelPlayer = SingletonGetters.getModelPlayerManager(self.m_SceneWarFileName):getModelPlayer(modelUnit:getPlayerIndex())
            return SkillModifierFunctions.isPerfectMovement(modelPlayer:getModelSkillConfiguration()) and (1) or (baseCost)
        end
    end
end

return MoveCostOwner
