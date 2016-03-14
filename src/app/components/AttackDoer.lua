
local AttackDoer = class("AttackDoer")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")

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
}

local function initPrimaryWeapon(doer, param)
    if (doer.m_PrimaryWeapon) then
        doer.m_PrimaryWeapon.m_CurrentAmmo = param.currentAmmo
    else
        doer.m_PrimaryWeapon = {}

        local weapon = doer.m_PrimaryWeapon
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

return AttackDoer
