
local SkillModifierFunctions = {}

local SkillDataAccessors    = requireBW("src.app.utilities.SkillDataAccessors")

local getSkillModifier = SkillDataAccessors.getSkillModifier
local isTypeInCategory = requireBW("src.app.utilities.GameConstantFunctions").isTypeInCategory

local PASSIVE_SLOTS_COUNT = SkillDataAccessors.getPassiveSkillSlotsCount()
local ACTIVE_SLOTS_COUNT  = SkillDataAccessors.getActiveSkillSlotsCount()

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getSlotsCount(isActive)
    return (isActive) and (ACTIVE_SLOTS_COUNT) or (PASSIVE_SLOTS_COUNT)
end

local function getAttackModifierForSkillGroup(modelSkillGroup, isActive,
    attacker, attackerGridIndex, target, targetGridIndex, modelSceneWar)

    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, getSlotsCount(isActive) do
        local skill = skills[i]
        if (skill) then
            local skillID = skill.id
            if (skillID == 1) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif (skillID == 20) then
                local fund = modelSceneWar:getModelPlayerManager():getModelPlayer(attacker:getPlayerIndex()):getFund()
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive) * fund / 10000
            elseif (skillID == 23) then
                local modelTile = modelSceneWar:getModelWarField():getModelTileMap():getModelTile(attackerGridIndex)
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive) * modelTile:getNormalizedDefenseBonusAmount()
            elseif ((skillID == 29) and (isTypeInCategory(attacker:getUnitType(), "DirectUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 30) and (isTypeInCategory(attacker:getUnitType(), "IndirectUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 31) and (isTypeInCategory(attacker:getUnitType(), "GroundUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 32) and (isTypeInCategory(attacker:getUnitType(), "AirUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 33) and (isTypeInCategory(attacker:getUnitType(), "NavalUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 34) and (isTypeInCategory(attacker:getUnitType(), "InfantryUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 35) and (isTypeInCategory(attacker:getUnitType(), "VehicleUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 36) and (isTypeInCategory(attacker:getUnitType(), "DirectMachineUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            end
        end
    end

    return modifier
end

local function getDefenseModifierForSkillGroup(modelSkillGroup, isActive,
    attacker, attackerGridIndex, target, targetGridIndex, modelSceneWar)

    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, getSlotsCount(isActive) do
        local skill = skills[i]
        if (skill) then
            local skillID = skill.id
            if (skillID == 2) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif (skillID == 21) then
                local fund = modelSceneWar:getModelPlayerManager():getModelPlayer(target:getPlayerIndex()):getFund()
                modifier   = modifier + getSkillModifier(skillID, skill.level, isActive) * fund / 10000
            elseif (skillID == 24) then
                local modelTile = modelSceneWar:getModelWarField():getModelTileMap():getModelTile(targetGridIndex)
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive) * modelTile:getNormalizedDefenseBonusAmount()
            elseif ((skillID == 37) and (target.getUnitType) and (isTypeInCategory(target:getUnitType(), "DirectUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 38) and (target.getUnitType) and (isTypeInCategory(target:getUnitType(), "IndirectUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 39) and (target.getUnitType) and (isTypeInCategory(target:getUnitType(), "GroundUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 40) and (target.getUnitType) and (isTypeInCategory(target:getUnitType(), "AirUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 41) and (target.getUnitType) and (isTypeInCategory(target:getUnitType(), "NavalUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 42) and (target.getUnitType) and (isTypeInCategory(target:getUnitType(), "InfantryUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 43) and (target.getUnitType) and (isTypeInCategory(target:getUnitType(), "VehicleUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 44) and (target.getUnitType) and (isTypeInCategory(target:getUnitType(), "DirectMachineUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 45) and (target.getUnitType) and (isTypeInCategory(target:getUnitType(), "TransportUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            end
        end
    end

    return modifier
end

local function getProductionCostModifierForSkillGroup(modelSkillGroup, isActive, tiledID)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, getSlotsCount(isActive) do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 3)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level, isActive)
        end
    end

    return modifier
end

local function getMoveRangeModifierForSkillGroup(modelSkillGroup, isActive, modelUnit)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, getSlotsCount(isActive) do
        local skill = skills[i]
        if (skill) then
            local skillID = skill.id
            if (skillID == 6) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 46) and (isTypeInCategory(modelUnit:getUnitType(), "DirectUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 47) and (isTypeInCategory(modelUnit:getUnitType(), "IndirectUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 48) and (isTypeInCategory(modelUnit:getUnitType(), "GroundUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 49) and (isTypeInCategory(modelUnit:getUnitType(), "AirUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 50) and (isTypeInCategory(modelUnit:getUnitType(), "NavalUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 51) and (isTypeInCategory(modelUnit:getUnitType(), "InfantryUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 52) and (isTypeInCategory(modelUnit:getUnitType(), "VehicleUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 53) and (isTypeInCategory(modelUnit:getUnitType(), "DirectMachineUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif ((skillID == 54) and (isTypeInCategory(modelUnit:getUnitType(), "TransportUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            end
        end
    end

    return modifier
end

local function getAttackRangeModifierForSkillGroup(modelSkillGroup, isActive)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, getSlotsCount(isActive) do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 7)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level, isActive)
        end
    end

    return modifier
end

local function getRepairAmountModifierForSkillGroup(modelSkillGroup, isActive)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, getSlotsCount(isActive) do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 10)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level, isActive)
        end
    end

    return modifier
end

local function getRepairCostModifierForSkillGroup(modelSkillGroup, isActive)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, getSlotsCount(isActive) do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 11)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level, isActive)
        end
    end

    return modifier
end

local function getLuckDamageUpperModifierForSkillGroup(modelSkillGroup, isActive)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, getSlotsCount(isActive) do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 14)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level, isActive)
        end
    end

    return modifier
end

local function getLuckDamageLowerModifierForSkillGroup(modelSkillGroup, isActive)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, getSlotsCount(isActive) do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 25)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level, isActive)
        end
    end

    return modifier
end

local function getCaptureAmountModifierForSkillGroup(modelSkillGroup, isActive)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, getSlotsCount(isActive) do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 15)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level, isActive)
        end
    end

    return modifier
end

local function getIncomeModifierForSkillGroup(modelSkillGroup, isActive)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, getSlotsCount(isActive) do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 17)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level, isActive)
        end
    end

    return modifier
end

local function getAttackDamageCostToFundModifierForSkillGroup(modelSkillGroup, isActive)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, getSlotsCount(isActive) do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 22)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level, isActive)
        end
    end

    return modifier
end

local function isPerfectMovementForSkillGroup(modelSkillGroup, isActive)
    if (not modelSkillGroup) then
        return false
    end

    local skills = modelSkillGroup:getAllSkills()
    for i = 1, getSlotsCount(isActive) do
        local skill = skills[i]
        if ((skill) and (skill.id == 28)) then
            return true
        end
    end

    return false
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function SkillModifierFunctions.getAttackModifier(attacker, attackerGridIndex, target, targetGridIndex, modelSceneWar)
    local configuration = modelSceneWar:getModelPlayerManager():getModelPlayer(attacker:getPlayerIndex()):getModelSkillConfiguration()
    return getAttackModifierForSkillGroup(configuration:getModelSkillGroupPassive(), false,
            attacker, attackerGridIndex, target, targetGridIndex, modelSceneWar) +
        getAttackModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), true,
            attacker, attackerGridIndex, target, targetGridIndex, modelSceneWar)
end

function SkillModifierFunctions.getDefenseModifier(attacker, attackerGridIndex, target, targetGridIndex, modelSceneWar)
    local configuration = modelSceneWar:getModelPlayerManager():getModelPlayer(target:getPlayerIndex()):getModelSkillConfiguration()
    return getDefenseModifierForSkillGroup(configuration:getModelSkillGroupPassive(), false,
            attacker, attackerGridIndex, target, targetGridIndex, modelSceneWar) +
        getDefenseModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), true,
            attacker, attackerGridIndex, target, targetGridIndex, modelSceneWar)
end

function SkillModifierFunctions.getProductionCostModifier(configuration, tiledID)
    return getProductionCostModifierForSkillGroup(configuration:getModelSkillGroupPassive(), false, tiledID) +
        getProductionCostModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), true, tiledID)
end

function SkillModifierFunctions.getMoveRangeModifier(configuration, modelUnit)
    return getMoveRangeModifierForSkillGroup(configuration:getModelSkillGroupPassive(), false, modelUnit) +
        getMoveRangeModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), true, modelUnit)
end

function SkillModifierFunctions.getAttackRangeModifier(configuration)
    return getAttackRangeModifierForSkillGroup(configuration:getModelSkillGroupPassive(), false) +
        getAttackRangeModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), true)
end

function SkillModifierFunctions.getRepairAmountModifier(configuration)
    return getRepairAmountModifierForSkillGroup(configuration:getModelSkillGroupPassive(), false)
end

function SkillModifierFunctions.getRepairCostModifier(configuration)
    return getRepairCostModifierForSkillGroup(configuration:getModelSkillGroupPassive(), false)
end

function SkillModifierFunctions.getLuckDamageUpperModifier(configuration)
    return getLuckDamageUpperModifierForSkillGroup(configuration:getModelSkillGroupPassive(), false) +
        getLuckDamageUpperModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), true)
end

function SkillModifierFunctions.getLuckDamageLowerModifier(configuration)
    return getLuckDamageLowerModifierForSkillGroup(configuration:getModelSkillGroupPassive(), false) +
        getLuckDamageLowerModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), true)
end

function SkillModifierFunctions.getCaptureAmountModifier(configuration)
    return getCaptureAmountModifierForSkillGroup(configuration:getModelSkillGroupPassive(), false) +
        getCaptureAmountModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), true)
end

function SkillModifierFunctions.getIncomeModifier(configuration)
    return getIncomeModifierForSkillGroup(configuration:getModelSkillGroupPassive(), false)
end

function SkillModifierFunctions.isDamageCostPerEnergyRequirementLocked(configuration)
    local skills = configuration:getModelSkillGroupPassive():getAllSkills()
    for i = 1, PASSIVE_SLOTS_COUNT do
        local skill = skills[i]
        if ((skill) and (skill.id == 18)) then
            return true
        end
    end

    return false
end

function SkillModifierFunctions.getEnergyGrowthRateModifier(configuration)
    local skills   = configuration:getModelSkillGroupPassive():getAllSkills()
    local modifier = 0
    for i = 1, PASSIVE_SLOTS_COUNT do
        local skill = skills[i]
        if ((skill) and (skill.id == 19)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level, false)
        end
    end

    return modifier
end

function SkillModifierFunctions.getAttackDamageCostToFundModifier(configuration)
    return getAttackDamageCostToFundModifierForSkillGroup(configuration:getModelSkillGroupPassive(), false) +
        getAttackDamageCostToFundModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), true)
end

function SkillModifierFunctions.getPassivePromotionModifier(configuration)
    local skills   = configuration:getModelSkillGroupPassive():getAllSkills()
    local modifier = 0
    for i = 1, PASSIVE_SLOTS_COUNT do
        local skill = skills[i]
        if ((skill) and (skill.id == 27)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level, false)
        end
    end

    return modifier
end

function SkillModifierFunctions.isPerfectMovement(configuration)
    return isPerfectMovementForSkillGroup(configuration:getModelSkillGroupPassive(), false) or
        isPerfectMovementForSkillGroup(configuration:getActivatingModelSkillGroup(), true)
end

function SkillModifierFunctions.getVisionModifierForUnitsForSkillGroup(modelSkillGroup, isActive)
    if (not modelSkillGroup) then
        return 0
    end

    local skills   = modelSkillGroup:getAllSkills()
    local modifier = 0
    for i = 1, getSlotsCount(isActive) do
        local skill = skills[i]
        if (skill) then
            local skillID = skill.id
            if     (skillID == 55) then modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif (skillID == 57) then modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            end
        end
    end

    return modifier
end

function SkillModifierFunctions.getVisionModifierForUnits(configuration)
    return SkillModifierFunctions.getVisionModifierForUnitsForSkillGroup(configuration:getModelSkillGroupPassive(), false) +
        SkillModifierFunctions.getVisionModifierForUnitsForSkillGroup(configuration:getActivatingModelSkillGroup(), true)
end

function SkillModifierFunctions.getVisionModifierForTilesForSkillGroup(modelSkillGroup, isActive)
    if (not modelSkillGroup) then
        return 0
    end

    local skills   = modelSkillGroup:getAllSkills()
    local modifier = 0
    for i = 1, getSlotsCount(isActive) do
        local skill = skills[i]
        if (skill) then
            local skillID = skill.id
            if     (skillID == 56) then modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            elseif (skillID == 57) then modifier = modifier + getSkillModifier(skillID, skill.level, isActive)
            end
        end
    end

    return modifier
end

function SkillModifierFunctions.getVisionModifierForTiles(configuration)
    return SkillModifierFunctions.getVisionModifierForTilesForSkillGroup(configuration:getModelSkillGroupPassive(), false) +
        SkillModifierFunctions.getVisionModifierForTilesForSkillGroup(configuration:getActivatingModelSkillGroup(), true)
end

function SkillModifierFunctions.canRevealHidingPlacesWithUnitsForSkillGroup(modelSkillGroup, isActive)
    if (not modelSkillGroup) then
        return false
    end

    local skills = modelSkillGroup:getAllSkills()
    for i = 1, getSlotsCount(isActive) do
        local skill = skills[i]
        if (skill) then
            local skillID = skill.id
            if ((skillID == 58) or (skillID == 60)) then
                return true
            end
        end
    end

    return false
end

function SkillModifierFunctions.canRevealHidingPlacesWithUnits(configuration)
    return SkillModifierFunctions.canRevealHidingPlacesWithUnitsForSkillGroup(configuration:getModelSkillGroupPassive(), false) or
        SkillModifierFunctions.canRevealHidingPlacesWithUnitsForSkillGroup(configuration:getActivatingModelSkillGroup(), true)
end

function SkillModifierFunctions.canRevealHidingPlacesWithTilesForSkillGroup(modelSkillGroup, isActive)
    if (not modelSkillGroup) then
        return false
    end

    local skills = modelSkillGroup:getAllSkills()
    for i = 1, getSlotsCount(isActive) do
        local skill = skills[i]
        if (skill) then
            local skillID = skill.id
            if ((skillID == 59) or (skillID == 60)) then
                return true
            end
        end
    end

    return false
end

function SkillModifierFunctions.canRevealHidingPlacesWithTiles(configuration)
    return SkillModifierFunctions.canRevealHidingPlacesWithTilesForSkillGroup(configuration:getModelSkillGroupPassive(), false) or
        SkillModifierFunctions.canRevealHidingPlacesWithTilesForSkillGroup(configuration:getActivatingModelSkillGroup(), true)
end

return SkillModifierFunctions
