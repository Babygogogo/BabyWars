
local SupplyFunctions = {}

local IS_SERVER = require("src.app.utilities.GameConstantFunctions").isServer()

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function canBeSuppliedWithWeaponAmmo(modelUnit)
    return (modelUnit.hasPrimaryWeapon)
        and (modelUnit:hasPrimaryWeapon())
        and (modelUnit:getPrimaryWeaponCurrentAmmo() < modelUnit:getPrimaryWeaponMaxAmmo())
end

local function canBeSuppliedWithFlareAmmo(modelUnit)
    return (modelUnit.getCurrentFlareAmmo) and (modelUnit:getCurrentFlareAmmo() < modelUnit:getMaxFlareAmmo())
end

local function canBeSuppliedWithFuel(modelUnit)
    return (modelUnit.getCurrentFuel) and (modelUnit:getCurrentFuel() < modelUnit:getMaxFuel())
end

local function supplyWithWeaponAmmo(modelUnit)
    if (canBeSuppliedWithWeaponAmmo(modelUnit)) then
        modelUnit:setPrimaryWeaponCurrentAmmo(modelUnit:getPrimaryWeaponMaxAmmo())
        return true
    else
        return false
    end
end

local function supplyWithFlareAmmo(modelUnit)
    if (canBeSuppliedWithFlareAmmo(modelUnit)) then
        modelUnit:setCurrentFlareAmmo(modelUnit:getMaxFlareAmmo())
        return true
    else
        return false
    end
end

local function supplyWithFuel(modelUnit)
    if (canBeSuppliedWithFuel(modelUnit)) then
        modelUnit:setCurrentFuel(modelUnit:getMaxFuel())
        return true
    else
        return false
    end
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function SupplyFunctions.canBeSuppliedWithAmmoOrFuel(modelUnit)
    return canBeSuppliedWithWeaponAmmo(modelUnit)
        or canBeSuppliedWithFlareAmmo( modelUnit)
        or canBeSuppliedWithFuel(      modelUnit)
end

function SupplyFunctions.supplyWithAmmoAndFuel(modelUnit, shouldUpdateView)
    local hasSupplied = supplyWithWeaponAmmo(modelUnit)
    hasSupplied = supplyWithFlareAmmo(modelUnit) or hasSupplied
    hasSupplied = supplyWithFuel(modelUnit)      or hasSupplied

    if ((hasSupplied) and (not IS_SERVER) and (shouldUpdateView)) then
        modelUnit:updateView()
    end

    return hasSupplied
end

return SupplyFunctions
