
local AttackTaker = class("AttackTaker")

local GameConstantFunctions = require("app.utilities.GameConstantFunctions")
local TypeChecker           = require("app.utilities.TypeChecker")
local ComponentManager      = require("global.components.ComponentManager")

local UNIT_MAX_HP = GameConstantFunctions.getUnitMaxHP()
local TILE_MAX_HP = GameConstantFunctions.getTileMaxHP()

local EXPORTED_METHODS = {
    "getCurrentHP",
    "setCurrentHP",
    "getNormalizedCurrentHP",

    "getDefenseType",
    "getDefenseFatalList",
    "getDefenseWeakList",
    "isAffectedByLuck",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function AttackTaker:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function AttackTaker:loadTemplate(template)
    assert(template.maxHP ~= nil,            "AttackTaker:loadTemplate() the param template.maxHP is invalid.")
    assert(template.defenseType ~= nil,      "AttackTaker:loadTemplate() the param template.defenseType is invalid.")
    assert(template.isAffectedByLuck ~= nil, "AttackTaker:loadTemplate() the param template.isAffectedByLuck is invalid.")

    self.m_Template = template

    return self
end

function AttackTaker:loadInstantialData(data)
    assert(data.currentHP <= self:getMaxHP(), "AttackTaker:loadInstantialData() the param data.currentHP is invalid.")
    self.m_CurrentHP = data.currentHP

    return self
end

function AttackTaker:setRootScriptEventDispatcher(dispatcher)
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

function AttackTaker:unsetRootScriptEventDispatcher()
    self.m_RootScriptEventDispatcher = nil

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
-- The functions for doing the actions.
--------------------------------------------------------------------------------
function AttackTaker:doActionAttack(action, isAttacker)
    if (isAttacker) then
        self:setCurrentHP(math.max(self:getCurrentHP() - (action.counterDamage or 0), 0))
        if (self:getCurrentHP() <= 0) then
            self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtDestroyModelUnit", gridIndex = self.m_Target:getGridIndex()})
        end
    else
        self:setCurrentHP(math.max(self:getCurrentHP() - action.attackDamage, 0))
        if (self:getCurrentHP() <= 0) then
            if (action.targetType == "unit") then
                self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtDestroyModelUnit", gridIndex = self.m_Target:getGridIndex()})
            else
                self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtDestroyModelTile", gridIndex = self.m_Target:getGridIndex()})
            end
        end
    end

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function AttackTaker:getMaxHP()
    return self.m_Template.maxHP
end

function AttackTaker:getCurrentHP()
    return self.m_CurrentHP
end

function AttackTaker:setCurrentHP(hp)
    assert((hp >= 0) and (hp <= math.max(UNIT_MAX_HP, TILE_MAX_HP)) and (hp == math.floor(hp)), "AttackTaker:setCurrentHP() the param hp is invalid.")
    self.m_CurrentHP = hp

    return self.m_Target
end

function AttackTaker:getNormalizedCurrentHP()
    return math.ceil(self.m_CurrentHP / 10)
end

function AttackTaker:getDefenseType()
    return self.m_Template.defenseType
end

function AttackTaker:isAffectedByLuck()
    return self.m_Template.isAffectedByLuck
end

function AttackTaker:getDefenseFatalList()
    return self.m_Template.fatal
end

function AttackTaker:getDefenseWeakList()
    return self.m_Template.weak
end

return AttackTaker
