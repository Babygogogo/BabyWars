
local UnitSupplier = require("src.global.functions.class")("UnitSupplier")

local ComponentManager   = require("src.global.components.ComponentManager")
local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")

UnitSupplier.EXPORTED_METHODS = {
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

local function supplyModelUnit(modelUnit)
    if (canSupplyFuel(modelUnit)) then
        modelUnit:setCurrentFuel(modelUnit:getMaxFuel())
    end
    if (canSupplyAmmo(modelUnit)) then
        modelUnit:setPrimaryWeaponCurrentAmmo(modelUnit:getPrimaryWeaponMaxAmmo())
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function UnitSupplier:ctor(param)
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
