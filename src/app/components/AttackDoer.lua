
--[[--------------------------------------------------------------------------------
-- AttackDoer是ModelUnit可用的组件。只有绑定了这个组件，才能对可攻击的对象（即绑定了AttackTaker的ModelTile或ModelUnit）实施攻击。
-- 主要职责：
--   维护主副武器的各种数值（目前只有主武器的弹药残量需要维护，其他数值都是常量），并提供必要接口给外界访问
--   计算伤害值
-- 使用场景举例：
--   宿主初始化时，根据自身属性来绑定和初始化本组件（比如infantry需要绑定，lander不需要。具体需要与否，由GameConstant决定）
--   玩家操作单位时，需要通过本组件获知能否对特定目标进行攻击；选择攻击目标时，需要使用本组件计算预估的伤害值和反击伤害
--   服务器接收到玩家进攻的操作命令时，用本组件判定进攻是否合法，并计算最终伤害并返回给客户端
-- 其他：
--    在目前设定中，预估伤害值和最终伤害值的区别仅在于：预估伤害值无视幸运伤害，而最终伤害值计算幸运伤害
--    伤害值受防御类型、hp、地形、等级、co技能、天气等影响
--]]--------------------------------------------------------------------------------

local AttackDoer = class("AttackDoer")

local TypeChecker           = require("app.utilities.TypeChecker")
local ComponentManager      = require("global.components.ComponentManager")
local GridIndexFunctions    = require("app.utilities.GridIndexFunctions")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")

local EXPORTED_METHODS = {
    "hasPrimaryWeapon",
    "getPrimaryWeaponName",
    "getPrimaryWeaponMaxAmmo",
    "getPrimaryWeaponCurrentAmmo",
    "getPrimaryWeaponFatalList",
    "getPrimaryWeaponStrongList",

    "hasSecondaryWeapon",
    "getSecondaryWeaponName",
    "getSecondaryWeaponFatalList",
    "getSecondaryWeaponStrongList",

    "canAttackTarget",
    "getEstimatedBattleDamage",
    "getUltimateBattleDamage",
    "getAttackRangeMinMax",
    "canAttackAfterMove",
    "isPrimaryWeaponAmmoInShort",

    "setPrimaryWeaponCurrentAmmo",
}
--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getNormalizedHP(hp)
    return math.ceil(hp / 10)
end

local function isInAttackRange(attackerGridIndex, targetGridIndex, minRange, maxRange)
    local distance = GridIndexFunctions.getDistance(attackerGridIndex, targetGridIndex)
    return (distance >= minRange) and (distance <= maxRange)
end

local function getPrimaryWeaponBaseDamage(self, defenseType)
    if (self:hasPrimaryWeapon() and self:getPrimaryWeaponCurrentAmmo() > 0) then
        return self.m_Template.primaryWeapon.baseDamage[defenseType]
    else
        return nil
    end
end

local function getSecondaryWeaponBaseDamage(self, defenseType)
    if (self:hasSecondaryWeapon()) then
        return self.m_Template.secondaryWeapon.baseDamage[defenseType]
    else
        return nil
    end
end

local function getBaseDamage(self, defenseType)
    if (not self) then
        return nil
    end

    return getPrimaryWeaponBaseDamage(self, defenseType) or getSecondaryWeaponBaseDamage(self, defenseType)
end

local function getAttackBonus(attacker, attackerTile, target, targetTile, modelPlayerManager, weather)
    -- TODO: Calculate the bonus with co skills and so on.
    local bonus = 0
    bonus = bonus + ((attacker.getLevelAttackBonus) and (attacker:getLevelAttackBonus()) or 0)

    return bonus
end

local function getDefenseBonus(attacker, attackerTile, target, targetTile, modelPlayerManager, weather)
    local targetTypeName = GameConstantFunctions.getUnitNameWithTiledId(target:getTiledID())
    local bonus = 0
    bonus = bonus + ((targetTile.getDefenseBonusAmount) and (targetTile:getDefenseBonusAmount(targetTypeName)) or 0)
    bonus = bonus + ((target.getLevelDefenseBonus) and (target:getLevelDefenseBonus()) or 0)
    -- TODO: Calculate the bonus with co skills and so on.

    return bonus
end

local function getEstimatedAttackDamage(attacker, attackerTile, attackerHP, target, targetTile, modelPlayerManager, weather)
    if (attackerHP <= 0) then
        return 0
    end

    local baseAttackDamage = getBaseDamage(ComponentManager.getComponent(attacker, "AttackDoer"), target:getDefenseType())
    if (not baseAttackDamage) then
        return nil
    else
        local attackBonus  = getAttackBonus( attacker, attackerTile, target, targetTile, modelPlayerManager, weather)
        local defenseBonus = getDefenseBonus(attacker, attackerTile, target, targetTile, modelPlayerManager, weather)
        attackerHP = math.max(attackerHP, 0)

        return math.round(baseAttackDamage * (getNormalizedHP(attackerHP) / 10) * (1 + attackBonus / 100) / (1 + defenseBonus / 100))
    end
end

local function getUltimateAttackDamage(attacker, attackerTile, attackerHP, target, targetTile, modelPlayerManager, weather)
    if (attackerHP <= 0) then
        return 0
    end

    local estimatedAttackDamage = getEstimatedAttackDamage(attacker, attackerTile, attackerHP, target, targetTile, modelPlayerManager, weather)
    if (not estimatedAttackDamage) then
        return nil
    else
        if (not target:isAffectedByLuck()) then
            return estimatedAttackDamage
        else
            return math.round(estimatedAttackDamage * (1 + (getNormalizedHP(attackerHP) / 10) * math.random(0, 9) / 100))
        end
    end
end

local function getBattleDamage(self, attackerTile, target, targetTile, modelPlayerManager, weather, getAttackDamage)
    local attackerGridIndex, targetGridIndex = attackerTile:getGridIndex(), targetTile:getGridIndex()
    if (not self:canAttackTarget(attackerGridIndex, target, targetGridIndex)) then
        return nil, nil
    end

    local attacker = self.m_Target
    local attackDamage = getAttackDamage(attacker, attackerTile, attacker:getCurrentHP(), target, targetTile, modelPlayerManager, weather)
    assert(attackDamage, "AttackDoer-getBattleDamage() failed to get the attack damage.")

    if ((target.canAttackTarget) and
        (target:canAttackTarget(targetGridIndex, attacker, attackerGridIndex)) and
        (GridIndexFunctions.getDistance(attackerGridIndex, targetGridIndex)) == 1) then
        return attackDamage, getAttackDamage(target, targetTile, target:getCurrentHP() - attackDamage, attacker, attackerTile, modelPlayerManager, weather)
    else
        return attackDamage, nil
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function AttackDoer:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function AttackDoer:loadTemplate(template)
    assert(template.minAttackRange ~= nil,     "AttackDoer:loadTemplate() the param template.minAttackRange is invalid.")
    assert(template.maxAttackRange ~= nil,     "AttackDoer:loadTemplate() the param template.maxAttackRange is invalid.")
    assert(template.canAttackAfterMove ~= nil, "AttackDoer:loadTemplate() the param template.canAttackAfterMove is invalid.")
    assert(template.primaryWeapon or template.secondaryWeapon, "AttackDoer:loadTemplate() the template has no weapon.")

    self.m_Template = template

    return self
end

function AttackDoer:loadInstantialData(data)
    if (data.primaryWeapon) then
        self.m_PrimaryWeaponCurrentAmmo = data.primaryWeapon.currentAmmo or self.m_PrimaryWeaponCurrentAmmo
    end

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function AttackDoer:onBind(target)
    assert(self.m_Target == nil, "AttackDoer:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Target = target

    return self
end

function AttackDoer:onUnbind()
    assert(self.m_Target ~= nil, "AttackDoer:onUnbind() the component has not bound a target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil

    return self
end

--------------------------------------------------------------------------------
-- The functions for doing the actions.
--------------------------------------------------------------------------------
function AttackDoer:doActionAttack(action, isAttacker)
    if (((isAttacker)     and (getPrimaryWeaponBaseDamage(self, action.target:getDefenseType()))                             ) or
        ((not isAttacker) and (getPrimaryWeaponBaseDamage(self, action.attacker:getDefenseType())) and (action.counterDamage))) then
        self.m_PrimaryWeaponCurrentAmmo = self.m_PrimaryWeaponCurrentAmmo - 1
    end

    return self
end

--------------------------------------------------------------------------------
-- Exported methods.
--------------------------------------------------------------------------------
function AttackDoer:hasPrimaryWeapon()
    return self.m_Template.primaryWeapon ~= nil
end

function AttackDoer:getPrimaryWeaponMaxAmmo()
    assert(self:hasPrimaryWeapon(), "AttackDoer:getPrimaryWeaponMaxAmmo() the attack doer has no primary weapon.")
    return self.m_Template.primaryWeapon.maxAmmo
end

function AttackDoer:getPrimaryWeaponCurrentAmmo()
    assert(self:hasPrimaryWeapon(), "AttackDoer:getPrimaryWeaponCurrentAmmo() the attack doer has no primary weapon.")
    return self.m_PrimaryWeaponCurrentAmmo
end

function AttackDoer:getPrimaryWeaponName()
    assert(self:hasPrimaryWeapon(), "AttackDoer:getPrimaryWeaponCurrentAmmo() the attack doer has no primary weapon.")
    return self.m_Template.primaryWeapon.name
end

function AttackDoer:getPrimaryWeaponFatalList()
    assert(self:hasPrimaryWeapon(), "AttackDoer:getPrimaryWeaponFatalList() the attack doer has no primary weapon.")
    return self.m_Template.primaryWeapon.fatal
end

function AttackDoer:getPrimaryWeaponStrongList()
    assert(self:hasPrimaryWeapon(), "AttackDoer:getPrimaryWeaponStrongList() the attack doer has no primary weapon.")
    return self.m_Template.primaryWeapon.strong
end

function AttackDoer:hasSecondaryWeapon()
    return self.m_Template.secondaryWeapon ~= nil
end

function AttackDoer:getSecondaryWeaponName()
    assert(self:hasSecondaryWeapon(), "AttackDoer:getSecondaryWeaponName() the attack doer has no secondary weapon.")
    return self.m_Template.secondaryWeapon.name
end

function AttackDoer:getSecondaryWeaponFatalList()
    assert(self:hasSecondaryWeapon(), "AttackDoer:getSecondaryWeaponFatalList() the attack doer has no secondary weapon.")
    return self.m_Template.secondaryWeapon.fatal
end

function AttackDoer:getSecondaryWeaponStrongList()
    assert(self:hasSecondaryWeapon(), "AttackDoer:getSecondaryWeaponStrongList() the attack doer has no secondary weapon.")
    return self.m_Template.secondaryWeapon.strong
end

function AttackDoer:canAttackTarget(attackerGridIndex, target, targetGridIndex)
    if ((not target) or
        (not target.getDefenseType) or
        (not isInAttackRange(attackerGridIndex, targetGridIndex, self:getAttackRangeMinMax())) or
        ((not GridIndexFunctions.isEqual(self.m_Target:getGridIndex(), attackerGridIndex) and (not self:canAttackAfterMove()))) or
        (self.m_Target:getPlayerIndex() == target:getPlayerIndex())) then
        return false
    end

    return (getBaseDamage(self, target:getDefenseType()) ~= nil)
end

function AttackDoer:getEstimatedBattleDamage(attackerTile, target, targetTile, modelPlayerManager, weather)
    return getBattleDamage(self, attackerTile, target, targetTile, modelPlayerManager, weather, getEstimatedAttackDamage)
end

function AttackDoer:getUltimateBattleDamage(attackerTile, target, targetTile, modelPlayerManager, weather)
    return getBattleDamage(self, attackerTile, target, targetTile, modelPlayerManager, weather, getUltimateAttackDamage)
end

function AttackDoer:getAttackRangeMinMax()
    return self.m_Template.minAttackRange, self.m_Template.maxAttackRange
end

function AttackDoer:canAttackAfterMove()
    return self.m_Template.canAttackAfterMove
end

function AttackDoer:isPrimaryWeaponAmmoInShort()
    if (not self:hasPrimaryWeapon()) then
        return false
    else
        return (self:getPrimaryWeaponCurrentAmmo() / self:getPrimaryWeaponMaxAmmo()) <= 0.4
    end
end

function AttackDoer:setPrimaryWeaponCurrentAmmo(ammo)
    assert(self:hasPrimaryWeapon(), "AttackDoer:setPrimaryWeaponCurrentAmmo() there's no primary weapon.")
    assert((ammo >= 0) and (ammo <= self:getPrimaryWeaponMaxAmmo()) and (math.floor(ammo) == ammo), "AttackDoer:setPrimaryWeaponCurrentAmmo() the param ammo is invalid.")

    self.m_PrimaryWeaponCurrentAmmo = ammo

    return self
end

return AttackDoer
