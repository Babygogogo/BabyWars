
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

local LocalizationFunctions  = require("src.app.utilities.LocalizationFunctions")
local SkillModifierFunctions = require("src.app.utilities.SkillModifierFunctions")
local ComponentManager       = require("src.global.components.ComponentManager")

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

    "getBaseDamage",
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

function AttackDoer:getBaseDamage(defenseType)
    return getPrimaryWeaponBaseDamage(self, defenseType) or getSecondaryWeaponBaseDamage(self, defenseType)
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
