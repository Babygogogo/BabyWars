
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

local AttackDoer = require("src.global.functions.class")("AttackDoer")

local GameConstantFunctions  = require("src.app.utilities.GameConstantFunctions")
local GridIndexFunctions     = require("src.app.utilities.GridIndexFunctions")
local LocalizationFunctions  = require("src.app.utilities.LocalizationFunctions")
local SkillModifierFunctions = require("src.app.utilities.SkillModifierFunctions")
local ComponentManager       = require("src.global.components.ComponentManager")

local COMMAND_TOWER_ATTACK_BONUS = GameConstantFunctions.getCommandTowerAttackBonus()

AttackDoer.EXPORTED_METHODS = {
    "hasPrimaryWeapon",
    "getPrimaryWeaponFullName",
    "getPrimaryWeaponMaxAmmo",
    "getPrimaryWeaponCurrentAmmo",
    "getPrimaryWeaponFatalList",
    "getPrimaryWeaponStrongList",

    "hasSecondaryWeapon",
    "getSecondaryWeaponFullName",
    "getSecondaryWeaponFatalList",
    "getSecondaryWeaponStrongList",

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
local function getAttackDoer(owner)
    return ComponentManager.getComponent(owner, "AttackDoer")
end

local function getNormalizedHP(hp)
    return math.ceil(hp / 10)
end

local function round(num)
    return math.floor(num + 0.5)
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
    return getPrimaryWeaponBaseDamage(self, defenseType) or getSecondaryWeaponBaseDamage(self, defenseType)
end

local function canAttackTarget(self, attackerGridIndex, target, targetGridIndex)
    local attacker  = self.m_Owner
    targetGridIndex = targetGridIndex or target:getGridIndex()
    return (target)                                                                                           and
        (target.getDefenseType)                                                                               and
        (attacker:getPlayerIndex() ~= target:getPlayerIndex())                                                and
        (isInAttackRange(attackerGridIndex, targetGridIndex, self:getAttackRangeMinMax()))                    and
        (self:canAttackAfterMove() or GridIndexFunctions.isEqual(attacker:getGridIndex(), attackerGridIndex)) and
        (getBaseDamage(self, target:getDefenseType()))
end

local function getAttackBonusMultiplier(self, attackerGridIndex, target, targetGridIndex, modelTileMap)
    local attacker    = self.m_Owner
    local playerIndex = attacker:getPlayerIndex()
    local bonus       = 0

    bonus = bonus + ((attacker.getPromotionAttackBonus) and (attacker:getPromotionAttackBonus()) or 0)
    modelTileMap:forEachModelTile(function(modelTile)
        if ((modelTile:getPlayerIndex() == playerIndex) and
            (modelTile:getTileType() == "CommandTower")) then
            bonus = bonus + COMMAND_TOWER_ATTACK_BONUS
        end
    end)

    local modelWeatherManager = self.m_ModelWeatherManager
    local modelPlayerManager  = self.m_ModelPlayerManager
    bonus = bonus + SkillModifierFunctions.getAttackModifier(modelPlayerManager:getModelPlayer(playerIndex):getModelSkillConfiguration(),
        attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)
    -- TODO: take the skills of the opponent into account.

    bonus = math.max(-100, bonus)

    return 1 + bonus / 100
end

local function getDefenseBonusMultiplier(self, attackerGridIndex, target, targetGridIndex, modelTileMap)
    if (not target.getUnitType) then
        return 1
    end

    local targetType = target:getUnitType()
    local targetTile = modelTileMap:getModelTile(targetGridIndex)
    local bonus      = 0

    bonus = bonus + ((targetTile.getDefenseBonusAmount) and (targetTile:getDefenseBonusAmount(targetType)) or (0))
    bonus = bonus + ((target.getPromotionDefenseBonus)  and (target:getPromotionDefenseBonus())            or (0))
    -- TODO: Calculate the bonus with co skills and so on.

    local modelWeatherManager = self.m_ModelWeatherManager
    local modelPlayerManager  = self.m_ModelPlayerManager
    local attacker            = self.m_Owner
    local targetPlayerIndex   = target:getPlayerIndex()
    bonus = bonus + SkillModifierFunctions.getDefenseModifier(modelPlayerManager:getModelPlayer(targetPlayerIndex):getModelSkillConfiguration(),
        attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)
    -- TODO: take the skills of the opponent into account.

    if (bonus >= 0) then
        return 1 / (1 + bonus / 100)
    else
        return 1 - bonus / 100
    end
end

local function getLuckDamage(self, attackerHP)
    -- TODO: take the player skills into account.
    local playerIndex             = self.m_Owner:getPlayerIndex()
    local modelSkillConfiguration = self.m_ModelPlayerManager:getModelPlayer(playerIndex):getModelSkillConfiguration()
    local upperModifier           = SkillModifierFunctions.getLuckDamageUpperModifier(modelSkillConfiguration)
    local upperBound              = math.max(0, upperModifier + 10)

    return math.random(0, getNormalizedHP(attackerHP) * upperBound / 10)
end

local function getEstimatedAttackDamage(self, attackerGridIndex, attackerHP, target, targetGridIndex, modelTileMap)
    local baseAttackDamage = getBaseDamage(self, target:getDefenseType())
    if (not baseAttackDamage) then
        return nil
    else
        if (attackerHP <= 0) then
            return 0
        else
            return round(
                baseAttackDamage
                * (getNormalizedHP(attackerHP) / 10)
                * getAttackBonusMultiplier( self, attackerGridIndex, target, targetGridIndex, modelTileMap)
                * getDefenseBonusMultiplier(self, attackerGridIndex, target, targetGridIndex, modelTileMap)
            )
        end
    end
end

local function getUltimateAttackDamage(self, attackerGridIndex, attackerHP, target, targetGridIndex, modelTileMap)
    local estimatedAttackDamage = getEstimatedAttackDamage(self, attackerGridIndex, attackerHP, target, targetGridIndex, modelTileMap)
    if ((not estimatedAttackDamage)      or
        (estimatedAttackDamage == 0)     or
        (not target:isAffectedByLuck())) then
        return estimatedAttackDamage
    else
        return estimatedAttackDamage + getLuckDamage(self, attackerHP)
    end
end

local function getBattleDamage(self, attackerGridIndex, target, modelTileMap, getAttackDamage)
    local targetGridIndex = target:getGridIndex()
    if (not canAttackTarget(self, attackerGridIndex, target, targetGridIndex)) then
        return nil, nil
    end

    local attacker     = self.m_Owner
    local attackDamage = getAttackDamage(self, attackerGridIndex, attacker:getCurrentHP(), target, targetGridIndex, modelTileMap)
    assert(attackDamage, "AttackDoer-getBattleDamage() failed to get the attack damage.")

    local counterDamage
    local targetAttackDoer = getAttackDoer(target)
    if ((targetAttackDoer)                                                                and
        (canAttackTarget(targetAttackDoer, targetGridIndex, attacker, attackerGridIndex)) and
        (GridIndexFunctions.getDistance(attackerGridIndex, targetGridIndex)) == 1)        then
        counterDamage = getAttackDamage(targetAttackDoer, targetGridIndex, target:getCurrentHP() - attackDamage, attacker, attackerGridIndex, modelTileMap)
    end

    return attackDamage, counterDamage
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
        self:setPrimaryWeaponCurrentAmmo(data.primaryWeapon.currentAmmo)
    end

    return self
end

function AttackDoer:setModelPlayerManager(model)
    assert(self.m_ModelPlayerManager == nil, "AttackDoer:setModelPlayerManager() the model has been set.")
    self.m_ModelPlayerManager = model

    return self
end

function AttackDoer:setModelWeatherManager(model)
    assert(self.m_ModelWeatherManager == nil, "AttackDoer:setModelWeatherManager() the model has been set.")
    self.m_ModelWeatherManager = model

    return self
end

--------------------------------------------------------------------------------
-- The function for serialzation.
--------------------------------------------------------------------------------
function AttackDoer:toSerializableTable()
    if ((not self:hasPrimaryWeapon()) or (self:getPrimaryWeaponCurrentAmmo() == self:getPrimaryWeaponMaxAmmo())) then
        return nil
    else
        return {
            primaryWeapon = {
                currentAmmo = self:getPrimaryWeaponCurrentAmmo(),
            }
        }
    end
end

--------------------------------------------------------------------------------
-- The functions for doing the actions.
--------------------------------------------------------------------------------
function AttackDoer:doActionAttack(action, target)
    if (getPrimaryWeaponBaseDamage(self, target:getDefenseType())) then
        self:setPrimaryWeaponCurrentAmmo(self:getPrimaryWeaponCurrentAmmo() - 1)
    end

    if ((action.counterDamage)                                                              and
        (getPrimaryWeaponBaseDamage(getAttackDoer(target), self.m_Owner:getDefenseType()))) then
        target:setPrimaryWeaponCurrentAmmo(target:getPrimaryWeaponCurrentAmmo() - 1)
    end

    return self
end

function AttackDoer:doActionJoinModelUnit(action, target)
    if (self:hasPrimaryWeapon()) then
        target:setPrimaryWeaponCurrentAmmo(math.min(
            target:getPrimaryWeaponMaxAmmo(),
            self:getPrimaryWeaponCurrentAmmo() + target:getPrimaryWeaponCurrentAmmo()
        ))
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

function AttackDoer:getPrimaryWeaponFullName()
    assert(self:hasPrimaryWeapon(), "AttackDoer:getPrimaryWeaponFullName() the attack doer has no primary weapon.")
    return LocalizationFunctions.getLocalizedText(115, self.m_Template.primaryWeapon.type)
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

function AttackDoer:getSecondaryWeaponFullName()
    assert(self:hasSecondaryWeapon(), "AttackDoer:getSecondaryWeaponFullName() the attack doer has no secondary weapon.")
    return LocalizationFunctions.getLocalizedText(115, self.m_Template.secondaryWeapon.type)
end

function AttackDoer:getSecondaryWeaponFatalList()
    assert(self:hasSecondaryWeapon(), "AttackDoer:getSecondaryWeaponFatalList() the attack doer has no secondary weapon.")
    return self.m_Template.secondaryWeapon.fatal
end

function AttackDoer:getSecondaryWeaponStrongList()
    assert(self:hasSecondaryWeapon(), "AttackDoer:getSecondaryWeaponStrongList() the attack doer has no secondary weapon.")
    return self.m_Template.secondaryWeapon.strong
end

function AttackDoer:getEstimatedBattleDamage(target, attackerGridIndex, modelTileMap)
    return getBattleDamage(self, attackerGridIndex, target, modelTileMap, getEstimatedAttackDamage)
end

function AttackDoer:getUltimateBattleDamage(target, attackerGridIndex, modelTileMap)
    return getBattleDamage(self, attackerGridIndex, target, modelTileMap, getUltimateAttackDamage)
end

function AttackDoer:getAttackRangeMinMax()
    -- TODO: take the player skills into account.
    local minRange = self.m_Template.minAttackRange
    local maxRange = self.m_Template.maxAttackRange
    if (maxRange <= 1) then
        return minRange, maxRange
    else
        local modelPlayer = self.m_ModelPlayerManager:getModelPlayer(self.m_Owner:getPlayerIndex())
        return minRange,
            math.max(minRange, maxRange + SkillModifierFunctions.getAttackRangeModifier(modelPlayer:getModelSkillConfiguration()))
    end
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
