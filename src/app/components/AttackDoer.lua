
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

local function initPrimaryWeapon(self, param)
    if (self.m_PrimaryWeapon) then
        self.m_PrimaryWeapon.m_CurrentAmmo = param.currentAmmo
    else
        self.m_PrimaryWeapon = {}

        local weapon = self.m_PrimaryWeapon
        weapon.m_Template    = param
        weapon.m_CurrentAmmo = param.maxAmmo
    end
end

local function initSecondaryWeapon(doer, param)
    if (not doer.m_SecondaryWeapon) then
        doer.m_SecondaryWeapon = {}

        local weapon = doer.m_SecondaryWeapon
        weapon.m_Template = param
    end
end

function AttackDoer:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function AttackDoer:load(param)
    self.m_MinAttackRange = param.minAttackRange or self.m_MinAttackRange
    assert(self.m_MinAttackRange, "AttackDoer:load() failed to load the min attack range.")

    self.m_MaxAttackRange = param.maxAttackRange or self.m_MaxAttackRange
    assert(self.m_MaxAttackRange, "AttackDoer:load() failed to load the max attack range.")

    if (param.canAttackAfterMove ~= nil) then
        self.m_CanAttackAfterMove = param.canAttackAfterMove
    end
    assert(self.m_CanAttackAfterMove ~= nil, "AttackDoer:load() failed to load the attribute 'canAttackAfterMove'.")

    if (param.primaryWeapon) then
        initPrimaryWeapon(self, param.primaryWeapon)
    end
    if (param.secondaryWeapon) then
        initSecondaryWeapon(self, param.secondaryWeapon)
    end

    return self
end

function AttackDoer:bind(target)
    ComponentManager.setMethods(target, self, EXPORTED_METHODS)

    self.m_Target = target
end

function AttackDoer:unbind(target)
    assert(self.m_Target == target , "AttackDoer:unbind() the component is not bind to the param target.")
    assert(self.m_Target, "AttackDoer:unbind() the component is not bind to any target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil
end

--------------------------------------------------------------------------------
-- Exported methods.
--------------------------------------------------------------------------------
function AttackDoer:hasPrimaryWeapon()
    return self.m_PrimaryWeapon ~= nil
end

function AttackDoer:getPrimaryWeaponMaxAmmo()
    assert(self:hasPrimaryWeapon(), "AttackDoer:getPrimaryWeaponMaxAmmo() the attack doer has no primary weapon.")
    return self.m_PrimaryWeapon.m_Template.maxAmmo
end

function AttackDoer:getPrimaryWeaponCurrentAmmo()
    assert(self:hasPrimaryWeapon(), "AttackDoer:getPrimaryWeaponCurrentAmmo() the attack doer has no primary weapon.")
    return self.m_PrimaryWeapon.m_CurrentAmmo
end

function AttackDoer:getPrimaryWeaponName()
    assert(self:hasPrimaryWeapon(), "AttackDoer:getPrimaryWeaponCurrentAmmo() the attack doer has no primary weapon.")
    return self.m_PrimaryWeapon.m_Template.name
end

function AttackDoer:getPrimaryWeaponFatalList()
    assert(self:hasPrimaryWeapon(), "AttackDoer:getPrimaryWeaponFatalList() the attack doer has no primary weapon.")
    return self.m_PrimaryWeapon.m_Template.fatal
end

function AttackDoer:getPrimaryWeaponStrongList()
    assert(self:hasPrimaryWeapon(), "AttackDoer:getPrimaryWeaponStrongList() the attack doer has no primary weapon.")
    return self.m_PrimaryWeapon.m_Template.strong
end

function AttackDoer:hasSecondaryWeapon()
    return self.m_SecondaryWeapon ~= nil
end

function AttackDoer:getSecondaryWeaponName()
    assert(self:hasSecondaryWeapon(), "AttackDoer:getSecondaryWeaponName() the attack doer has no secondary weapon.")
    return self.m_SecondaryWeapon.m_Template.name
end

function AttackDoer:getSecondaryWeaponFatalList()
    assert(self:hasSecondaryWeapon(), "AttackDoer:getSecondaryWeaponFatalList() the attack doer has no secondary weapon.")
    return self.m_SecondaryWeapon.m_Template.fatal
end

function AttackDoer:getSecondaryWeaponStrongList()
    assert(self:hasSecondaryWeapon(), "AttackDoer:getSecondaryWeaponStrongList() the attack doer has no secondary weapon.")
    return self.m_SecondaryWeapon.m_Template.strong
end

function AttackDoer:canAttackTarget(targetModel)
    if (self.m_Target:getPlayerIndex() == targetModel:getPlayerIndex()) then
        return false
    end

    if (not targetModel.getDefenseType) then
        return false
    end

    local distance = GridIndexFunctions.getDistance(self.m_Target:getGridIndex(), targetModel:getGridIndex())
    if (distance < self.m_MinAttackRange) or (distance > self.m_MaxAttackRange) then
        return false
    end

    local defenseType = targetModel:getDefenseType()
    if (self:hasPrimaryWeapon() and self:getPrimaryWeaponCurrentAmmo() > 0) then
        local baseDamage = self.m_PrimaryWeapon.m_Template.baseDamage[defenseType]
        if (baseDamage) then
            return true, baseDamage
        end
    end

    if (self:hasSecondaryWeapon()) then
        local baseDamage = self.m_SecondaryWeapon.m_Template.baseDamage[defenseType]
        if (baseDamage) then
            return true, baseDamage
        end
    end

    return false
end

function AttackDoer:getAttackRangeMinMax()
    return self.m_MinAttackRange, self.m_MaxAttackRange
end

function AttackDoer:canAttackAfterMove()
    return self.m_CanAttackAfterMove
end

return AttackDoer
