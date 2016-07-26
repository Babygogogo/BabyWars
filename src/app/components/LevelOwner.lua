
--[[--------------------------------------------------------------------------------
-- LevelOwner是ModelUnit可用的组件。只有绑定了本组件，宿主才具有“等级”的属性、以及可升级。
-- 主要职责：
--   维护相关数值（包括当前等级，以及等级所带来的攻防加成），并提供必要接口给外界访问
-- 使用场景举例：
--   宿主初始化时，根据属性来绑定和初始化本组件（大部分ModelUnit需要绑定，但具体由GameConstant决定）
--   单位进行攻击时，会用到本组件提供的攻防加成数值；本组件需根据情况让单位升级
-- 其他：
--   unit默认等级为0，每摧毁一个敌方unit则升一级，最高3级
--   不能进行攻击的单位无法升级，因此无需绑定本组件
--]]--------------------------------------------------------------------------------

local LevelOwner = require("src.global.functions.class")("LevelOwner")

local ComponentManager      = require("src.global.components.ComponentManager")
local GridIndexFunctions    = require("src.app.utilities.GridIndexFunctions")
local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")

local MAX_LEVEL   = GameConstantFunctions.getMaxLevel()
local LEVEL_BONUS = GameConstantFunctions.getLevelBonus()

local EXPORTED_METHODS = {
    "getLevel",
    "getLevelAttackBonus",
    "getLevelDefenseBonus",

    "setLevel",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function LevelOwner:ctor(param)
    self:loadInstantialData(param.instantialData)

    return self
end

function LevelOwner:loadTemplate(template)
    return self
end

function LevelOwner:loadInstantialData(data)
    self:setLevel(data.level)

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function LevelOwner:toSerializableTable()
    local level = self:getLevel()
    if (level == 0) then
        return nil
    else
        return {
            level = level,
        }
    end
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function LevelOwner:onBind(target)
    assert(self.m_Owner == nil, "LevelOwner:onBind() the LevelOwner has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Owner = target

    return self
end

function LevelOwner:onUnbind()
    assert(self.m_Owner, "LevelOwner:unbind() the component has not bound a target.")

    ComponentManager.unsetMethods(self.m_Owner, EXPORTED_METHODS)
    self.m_Owner = nil

    return self
end

--------------------------------------------------------------------------------
-- The functions for doing the actions.
--------------------------------------------------------------------------------
function LevelOwner:doActionDestroyModelUnit(action)
    local owner = self.m_Owner
    if (owner == action.attacker) then
        local currentLevel = self:getLevel()
        if (currentLevel < MAX_LEVEL) then
            self:setLevel(currentLevel + 1)
        end
    end

    return owner
end

function LevelOwner:doActionJoinModelUnit(action, modelPlayerManager, target)
    target:setLevel(math.max(self:getLevel(), target:getLevel()))

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function LevelOwner:getLevel()
    return self.m_Level
end

function LevelOwner:getLevelAttackBonus()
    if (self.m_Level == 0) then
        return 0
    else
        return LEVEL_BONUS[self.m_Level].attack
    end
end

function LevelOwner:getLevelDefenseBonus()
    if (self.m_Level == 0) then
        return 0
    else
        return LEVEL_BONUS[self.m_Level].defense
    end
end

function LevelOwner:setLevel(level)
    assert((level >= 0) and (level <= MAX_LEVEL), "LevelOwner:setLevel() the param level is invalid." )
    self.m_Level = level

    return self.m_Owner
end

return LevelOwner
