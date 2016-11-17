
local UnitSupplier = require("src.global.functions.class")("UnitSupplier")

local SupplyFunctions = require("src.app.utilities.SupplyFunctions")

local canBeSuppliedWithAmmoOrFuel = SupplyFunctions.canBeSuppliedWithAmmoOrFuel

UnitSupplier.EXPORTED_METHODS = {
    "canSupplyModelUnit",
}

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
    return (self.m_Owner:getPlayerIndex() == modelUnit:getPlayerIndex()) and (canBeSuppliedWithAmmoOrFuel(modelUnit))
end

return UnitSupplier
