
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
    -- TODO: Calculate the bonus with attacker level, co skills and so on.
    return 0
end

local function getDefenseBonus(attacker, attackerTile, target, targetTile, modelPlayerManager, weather)
    local targetTypeName = GameConstantFunctions.getUnitNameWithTiledId(target:getTiledID())
    local bonusFromTile  = (targetTile.getDefenseBonusAmount) and (targetTile:getDefenseBonusAmount(targetTypeName)) or 0
    -- TODO: Calculate the bonus with target level, co skills and so on.

    return bonusFromTile
end

local function getEstimatedAttackDamage(attacker, attackerTile, attackerHP, target, targetTile, modelPlayerManager, weather)
    if (attackerHP <= 0) then
        return nil
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
        return nil
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

function AttackDoer:setRootScriptEventDispatcher(dispatcher)
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

function AttackDoer:unsetRootScriptEventDispatcher()
    self.m_RootScriptEventDispatcher = nil

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

return AttackDoer
