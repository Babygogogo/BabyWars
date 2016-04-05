
local AttackTaker = class("AttackTaker")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")

local EXPORTED_METHODS = {
    "getCurrentHP",
    "getNormalizedCurrentHP",

    "getDefenseType",
    "isAffectedByLuck",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function AttackTaker:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function AttackTaker:load(param)
    self.m_MaxHP = param.maxHP or self.m_MaxHP
    assert(self.m_MaxHP, "AttackTaker:load() failed to load the max HP.")

    self.m_CurrentHP = param.currentHP or self.m_CurrentHP or self.m_MaxHP
    assert(self.m_CurrentHP, "AttackTaker:load() failed to load the current HP.")
    assert(self.m_CurrentHP <= self.m_MaxHP, "AttackTaker:load() the current HP is invalid.")

    self.m_DefenseType = param.defenseType or self.m_DefenseType
    assert(self.m_DefenseType, "AttackTaker:load() failed to load the defense type.")

    if (param.isAffectedByLuck ~= nil) then
        self.m_IsAffectByLuck = param.isAffectedByLuck
    end
    assert(self.m_IsAffectByLuck ~= nil, "AttackTaker:load() failed to load the attribute 'isAffectedByLuck'.")

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function AttackTaker:onBind(target)
    assert(self.m_Target == nil, "AttackTaker:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Target = target

    return self
end

function AttackTaker:onUnbind()
    assert(self.m_Target ~= nil, "AttackTaker:onUnbind() the component has not bound a target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function AttackTaker:getCurrentHP()
    return self.m_CurrentHP
end

function AttackTaker:getNormalizedCurrentHP()
    return math.ceil(self.m_CurrentHP / 10)
end

function AttackTaker:getDefenseType()
    return self.m_DefenseType
end

function AttackTaker:isAffectedByLuck()
    return self.m_IsAffectByLuck
end

return AttackTaker
