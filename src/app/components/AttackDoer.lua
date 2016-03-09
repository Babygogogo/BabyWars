
local AttackDoer = class("AttackDoer")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")

local EXPORTED_METHODS = {
    "getMainWeaponCurrentAmmo",
}

local function initMainWeapon(doer, param)
    if (doer.m_MainWeapon) then
        doer.m_MainWeapon.m_CurrentAmmo = param.currentAmmo
    else
        doer.m_MainWeapon = {}

        local weapon = doer.m_MainWeapon
        weapon.m_MaxAmmo     = param.maxAmmo
        weapon.m_CurrentAmmo = param.currentAmmo
        weapon.m_Target      = param.target
        weapon.m_BaseDamage  = param.baseDamage
    end
end

local function initSideWeapon(doer, param)
    if (not doer.m_SideWeapon) then
        doer.m_SideWeapon = {}

        local weapon = doer.m_SideWeapon
        weapon.m_Target     = param.target
        weapon.m_BaseDamage = param.baseDamage
    end
end

function AttackDoer:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function AttackDoer:load(param)
    if (param.mainWeapon) then
        initMainWeapon(self, param.mainWeapon)
    end
    if (param.sideWeapon) then
        initSideWeapon(self, param.sideWeapon)
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

function AttackDoer:getMainWeaponCurrentAmmo()
    if (self.m_MainWeapon) then
        return self.m_MainWeapon.m_CurrentAmmo
    else
        return nil
    end
end

return AttackDoer
