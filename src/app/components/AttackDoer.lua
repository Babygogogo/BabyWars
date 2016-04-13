
local AttackDoer = class("AttackDoer")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

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
    "getAttackRangeMinMax",
    "canAttackAfterMove",
}
--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getBaseDamage(self, selfGridIndex, targetDefenseType, targetGridIndex)
    if (not self) then
        return nil
    end

    local distance = GridIndexFunctions.getDistance(selfGridIndex, targetGridIndex)
    local minRange, maxRange = self:getAttackRangeMinMax()
    if (distance < minRange) or (distance > maxRange) then
        return nil
    end

    if (self:hasPrimaryWeapon() and self:getPrimaryWeaponCurrentAmmo() > 0) then
        local baseDamage = self.m_Template.primaryWeapon.baseDamage[targetDefenseType]
        if (baseDamage) then
            return baseDamage
        end
    end

    if (self:hasSecondaryWeapon()) then
        local baseDamage = self.m_Template.secondaryWeapon.baseDamage[targetDefenseType]
        if (baseDamage) then
            return baseDamage
        end
    end

    return nil
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

function AttackDoer:canAttackTarget(selfGridIndex, targetModel, targetGridIndex)
    if ((not targetModel) or
        (not targetModel.getDefenseType) or
        (self.m_Target:getPlayerIndex() == targetModel:getPlayerIndex())) then
        return false
    end

    local baseDoDamage  = getBaseDamage(self, selfGridIndex, targetModel:getDefenseType(), targetGridIndex)
    local baseGetDamage = getBaseDamage(ComponentManager.getComponent(targetModel, "AttackDoer"), targetGridIndex, self.m_Target:getDefenseType(), selfGridIndex)
    if (not baseDoDamage) then
        return false
    else
        return true, baseDoDamage, baseGetDamage
    end
end

function AttackDoer:getAttackDamage(selfModelTile, targetModel, targetModelTile, modelPlayerManager, modelWeatherManager)
    if ((not targetModel) or
        (not targetModel.getDefenseType) or
        (self.m_Target:getPlayerIndex() == targetModel:getPlayerIndex())) then
        return nil, nil
    end

    local selfGridIndex, targetGridIndex = selfModelTile:getGridIndex(), targetModelTile:getGridIndex()
    local baseDoDamage  = getBaseDamage(self, selfGridIndex, targetModel:getDefenseType(), targetGridIndex)
    local baseGetDamage = getBaseDamage(ComponentManager.getComponent(targetModel, "AttackDoer"), targetGridIndex, self.m_Target:getDefenseType(), selfGridIndex)


end

function AttackDoer:getAttackRangeMinMax()
    return self.m_Template.minAttackRange, self.m_Template.maxAttackRange
end

function AttackDoer:canAttackAfterMove()
    return self.m_Template.canAttackAfterMove
end

return AttackDoer
