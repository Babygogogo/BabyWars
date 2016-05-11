
--[[--------------------------------------------------------------------------------
-- AttackTaker是ModelUnit/ModelTile可用的组件。只有绑定了这个组件，才能受到攻击者（即绑定了AttackTaker的model）的攻击。
-- 主要职责：
--   维护宿主的生命值以及防御类型，提供接口给外界访问
-- 使用场景举例：
--   宿主初始化时，根据自身属性来绑定和初始化本组件（比如infantry需要绑定，plain不需要，meteor需要）
--   AttackTaker计算伤害值时，或CaptureDoer计算占领值时，需要通过本组件获取当前生命值
--   若生命值降为0，则本组件需要发送消息以通知ModelUnitMap/ModelTileMap删除对应的unit/tile
-- 其他：
--   - 所有种类的ModelUnit都必须绑定本组件，但ModelUnit里没有写死，而是由GameConstant决定
--   - 关于防御类型：老三代里pipe与mdtank的防御属性是相同的，所以抽象出防御类型来重用其属性表。
--     但dor里每个单位的防御类型都是独立的，所以防御类型实际上可以取消，直接用宿主的类型名字（如infantry，meteor）代替
--   - unit的hp上限实际上为100，但多数情况下（如攻击，占领）按10点来计算（换算关系：实际hp / 10 并向上取整）
--]]--------------------------------------------------------------------------------

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
    assert(self.m_RootScriptEventDispatcher == nil, "AttackTaker:setRootScriptEventDispatcher() the dispatcher has been set.")
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

function AttackTaker:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "AttackTaker:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function AttackTaker:serialize(spaces)
    local currentHP = self:getCurrentHP()
    if (currentHP ~= self:getMaxHP()) then
        return string.format("%sAttackTaker = {currentHP = %d}", spaces, currentHP)
    else
        return nil
    end
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
