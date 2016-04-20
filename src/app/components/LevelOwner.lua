
local LevelOwner = class("LevelOwner")

local TypeChecker           = require("app.utilities.TypeChecker")
local ComponentManager      = require("global.components.ComponentManager")
local GridIndexFunctions    = require("app.utilities.GridIndexFunctions")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")

local MAX_LEVEL   = GameConstantFunctions.getMaxLevel()
local LEVEL_BONUS = GameConstantFunctions.getLevelBonus()

local EXPORTED_METHODS = {
    "getLevel",
    "getLevelAttackBonus",
    "getLevelDefenseBonus",
}

--------------------------------------------------------------------------------
-- The param validators.
--------------------------------------------------------------------------------
local function isLevel(param)
    return (param >= 0) and (math.ceil(param) == param) and (param <= MAX_LEVEL)
end

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function setLevel(self, level)
    assert(isLevel(level), "LevelOwner-setLevel() the param level is invalid.")
    self.m_Level = level
end

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
    setLevel(self, data.level)

    return self
end

function LevelOwner:setRootScriptEventDispatcher(dispatcher)
    self:unsetRootScriptEventDispatcher()
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

function LevelOwner:unsetRootScriptEventDispatcher()
    if (self.m_RootScriptEventDispatcher) then
        self.m_RootScriptEventDispatcher = nil
    end

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function LevelOwner:onBind(target)
    assert(self.m_Target == nil, "LevelOwner:onBind() the LevelOwner has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Target = target

    return self
end

function LevelOwner:onUnbind()
    assert(self.m_Target, "LevelOwner:unbind() the component has not bound a target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil

    return self
end

--------------------------------------------------------------------------------
-- The functions for doing the actions.
--------------------------------------------------------------------------------
function LevelOwner:doActionAttack(action, isAttacker)
    if ((isAttacker) and
        (action.targetType == "unit") and
        (action.attackDamage >= action.target:getCurrentHP()) and
        (self.m_Level < MAX_LEVEL)) then
        setLevel(self, self.m_Level + 1)
    end

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

return LevelOwner
