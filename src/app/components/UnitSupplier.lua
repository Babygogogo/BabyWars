
local UnitSupplier = require("src.global.functions.class")("UnitSupplier")

local ComponentManager = require("src.global.components.ComponentManager")

local EXPORTED_METHODS = {
    "canSupplyModelUnit",
}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function canSupplyFuel(modelUnit)
    return (modelUnit.getCurrentFuel)                         and
        (modelUnit:getCurrentFuel() < modelUnit:getMaxFuel())
end

local function canSupplyAmmo(modelUnit)
    return (modelUnit.hasPrimaryWeapon)                                                 and
        (modelUnit:hasPrimaryWeapon())                                                  and
        (modelUnit:getPrimaryWeaponCurrentAmmo() < modelUnit:getPrimaryWeaponMaxAmmo())
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function UnitSupplier:ctor(param)
    return self
end

function UnitSupplier:loadTemplate(template)
    return self
end

function UnitSupplier:loadInstantialData(data)
    return self
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function UnitSupplier:onBind(target)
    assert(self.m_Owner == nil, "UnitSupplier:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Owner = target

    return self
end

function UnitSupplier:onUnbind()
    assert(self.m_Owner ~= nil, "UnitSupplier:onUnbind() the component has not bound to a target.")

    ComponentManager.unsetMethods(self.m_Owner, EXPORTED_METHODS)
    self.m_Owner = nil

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function UnitSupplier:canSupplyModelUnit(modelUnit)
    return (self.m_Owner:getPlayerIndex() == modelUnit:getPlayerIndex()) and
        ((canSupplyFuel(modelUnit)) or (canSupplyAmmo(modelUnit)))
end

return UnitSupplier
