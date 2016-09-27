
local SkillModifierFunctions = {}

local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")

local getSkillModifier = GameConstantFunctions.getSkillModifier
local isTypeInCategory = GameConstantFunctions.isTypeInCategory

local PASSIVE_SLOTS_COUNT = GameConstantFunctions.getPassiveSkillSlotsCount()
local ACTIVE_SLOTS_COUNT  = GameConstantFunctions.getActiveSkillSlotsCount()

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getAttackModifierForSkillGroup(modelSkillGroup, slotsCount,
    attacker, attackerGridIndex, target, targetGridIndex, modelSceneWar)

    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, slotsCount do
        local skill = skills[i]
        if (skill) then
            local skillID = skill.id
            if (skillID == 1) then
                modifier = modifier + getSkillModifier(skillID, skill.level)
            elseif (skillID == 20) then
                local fund = modelSceneWar:getModelPlayerManager():getModelPlayer(attacker:getPlayerIndex()):getFund()
                modifier = modifier + getSkillModifier(skillID, skill.level) * fund / 10000
            elseif (skillID == 23) then
                local modelTile = modelSceneWar:getModelWarField():getModelTileMap():getModelTile(attackerGridIndex)
                modifier = modifier + getSkillModifier(skillID, skill.level) * modelTile:getNormalizedDefenseBonusAmount()
            elseif ((skillID == 29) and (isTypeInCategory(attacker:getUnitType(), "DirectUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level)
            elseif ((skillID == 30) and (isTypeInCategory(attacker:getUnitType(), "IndirectUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level)
            elseif ((skillID == 31) and (isTypeInCategory(attacker:getUnitType(), "GroundUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level)
            elseif ((skillID == 32) and (isTypeInCategory(attacker:getUnitType(), "AirUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level)
            elseif ((skillID == 33) and (isTypeInCategory(attacker:getUnitType(), "NavalUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level)
            elseif ((skillID == 34) and (isTypeInCategory(attacker:getUnitType(), "InfantryUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level)
            elseif ((skillID == 35) and (isTypeInCategory(attacker:getUnitType(), "VehicleUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level)
            elseif ((skillID == 36) and (isTypeInCategory(attacker:getUnitType(), "DirectMachineUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level)
            end
        end
    end

    return modifier
end

local function getDefenseModifierForSkillGroup(modelSkillGroup, slotsCount,
    attacker, attackerGridIndex, target, targetGridIndex, modelSceneWar)

    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, slotsCount do
        local skill = skills[i]
        if (skill) then
            local skillID = skill.id
            if (skillID == 2) then
                modifier = modifier + getSkillModifier(skillID, skill.level)
            elseif (skillID == 21) then
                local fund = modelSceneWar:getModelPlayerManager():getModelPlayer(target:getPlayerIndex()):getFund()
                modifier   = modifier + getSkillModifier(skillID, skill.level) * fund / 10000
            elseif (skillID == 24) then
                local modelTile = modelSceneWar:getModelWarField():getModelTileMap():getModelTile(targetGridIndex)
                modifier = modifier + getSkillModifier(skillID, skill.level) * modelTile:getNormalizedDefenseBonusAmount()
            elseif ((skillID == 37) and (target.getUnitType) and (isTypeInCategory(target:getUnitType(), "DirectUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level)
            elseif ((skillID == 38) and (target.getUnitType) and (isTypeInCategory(target:getUnitType(), "IndirectUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level)
            elseif ((skillID == 39) and (target.getUnitType) and (isTypeInCategory(target:getUnitType(), "GroundUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level)
            elseif ((skillID == 40) and (target.getUnitType) and (isTypeInCategory(target:getUnitType(), "AirUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level)
            elseif ((skillID == 41) and (target.getUnitType) and (isTypeInCategory(target:getUnitType(), "NavalUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level)
            elseif ((skillID == 42) and (target.getUnitType) and (isTypeInCategory(target:getUnitType(), "InfantryUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level)
            elseif ((skillID == 43) and (target.getUnitType) and (isTypeInCategory(target:getUnitType(), "VehicleUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level)
            elseif ((skillID == 44) and (target.getUnitType) and (isTypeInCategory(target:getUnitType(), "DirectMachineUnits"))) then
                modifier = modifier + getSkillModifier(skillID, skill.level)
            end
        end
    end

    return modifier
end

local function getProductionCostModifierForSkillGroup(modelSkillGroup, slotsCount, tiledID)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, slotsCount do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 3)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level)
        end
    end

    return modifier
end

local function getMoveRangeModifierForSkillGroup(modelSkillGroup, slotsCount)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, slotsCount do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 6)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level)
        end
    end

    return modifier
end

local function getAttackRangeModifierForSkillGroup(modelSkillGroup, slotsCount)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, slotsCount do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 7)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level)
        end
    end

    return modifier
end

local function getRepairAmountModifierForSkillGroup(modelSkillGroup, slotsCount)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, slotsCount do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 10)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level)
        end
    end

    return modifier
end

local function getRepairCostModifierForSkillGroup(modelSkillGroup, slotsCount)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, slotsCount do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 11)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level)
        end
    end

    return modifier
end

local function getLuckDamageUpperModifierForSkillGroup(modelSkillGroup, slotsCount)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, slotsCount do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 14)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level)
        end
    end

    return modifier
end

local function getLuckDamageLowerModifierForSkillGroup(modelSkillGroup, slotsCount)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, slotsCount do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 25)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level)
        end
    end

    return modifier
end

local function getCaptureAmountModifierForSkillGroup(modelSkillGroup, slotsCount)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, slotsCount do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 15)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level)
        end
    end

    return modifier
end

local function getIncomeModifierForSkillGroup(modelSkillGroup, slotsCount)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, slotsCount do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 17)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level)
        end
    end

    return modifier
end

local function getAttackDamageCostToFundModifierForSkillGroup(modelSkillGroup, slotsCount)
    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, slotsCount do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 22)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level)
        end
    end

    return modifier
end

local function isPerfectMovementForSkillGroup(modelSkillGroup, slotsCount)
    if (not modelSkillGroup) then
        return false
    end

    local skills = modelSkillGroup:getAllSkills()
    for i = 1, slotsCount do
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
    return getAttackModifierForSkillGroup(configuration:getModelSkillGroupPassive(), PASSIVE_SLOTS_COUNT,
            attacker, attackerGridIndex, target, targetGridIndex, modelSceneWar) +
        getAttackModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), ACTIVE_SLOTS_COUNT,
            attacker, attackerGridIndex, target, targetGridIndex, modelSceneWar)
end

function SkillModifierFunctions.getDefenseModifier(attacker, attackerGridIndex, target, targetGridIndex, modelSceneWar)
    local configuration = modelSceneWar:getModelPlayerManager():getModelPlayer(target:getPlayerIndex()):getModelSkillConfiguration()
    return getDefenseModifierForSkillGroup(configuration:getModelSkillGroupPassive(), PASSIVE_SLOTS_COUNT,
            attacker, attackerGridIndex, target, targetGridIndex, modelSceneWar) +
        getDefenseModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), ACTIVE_SLOTS_COUNT,
            attacker, attackerGridIndex, target, targetGridIndex, modelSceneWar)
end

function SkillModifierFunctions.getProductionCostModifier(configuration, tiledID)
    return getProductionCostModifierForSkillGroup(configuration:getModelSkillGroupPassive(), PASSIVE_SLOTS_COUNT, tiledID) +
        getProductionCostModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), ACTIVE_SLOTS_COUNT, tiledID)
end

function SkillModifierFunctions.getMoveRangeModifier(configuration)
    return getMoveRangeModifierForSkillGroup(configuration:getModelSkillGroupPassive(), PASSIVE_SLOTS_COUNT) +
        getMoveRangeModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), ACTIVE_SLOTS_COUNT)
end

function SkillModifierFunctions.getAttackRangeModifier(configuration)
    return getAttackRangeModifierForSkillGroup(configuration:getModelSkillGroupPassive(), PASSIVE_SLOTS_COUNT) +
        getAttackRangeModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), ACTIVE_SLOTS_COUNT)
end

function SkillModifierFunctions.getRepairAmountModifier(configuration)
    return getRepairAmountModifierForSkillGroup(configuration:getModelSkillGroupPassive(), PASSIVE_SLOTS_COUNT)
end

function SkillModifierFunctions.getRepairCostModifier(configuration)
    return getRepairCostModifierForSkillGroup(configuration:getModelSkillGroupPassive(), PASSIVE_SLOTS_COUNT)
end

function SkillModifierFunctions.getLuckDamageUpperModifier(configuration)
    return getLuckDamageUpperModifierForSkillGroup(configuration:getModelSkillGroupPassive(), PASSIVE_SLOTS_COUNT) +
        getLuckDamageUpperModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), ACTIVE_SLOTS_COUNT)
end

function SkillModifierFunctions.getLuckDamageLowerModifier(configuration)
    return getLuckDamageLowerModifierForSkillGroup(configuration:getModelSkillGroupPassive(), PASSIVE_SLOTS_COUNT) +
        getLuckDamageLowerModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), ACTIVE_SLOTS_COUNT)
end

function SkillModifierFunctions.getCaptureAmountModifier(configuration)
    return getCaptureAmountModifierForSkillGroup(configuration:getModelSkillGroupPassive(), PASSIVE_SLOTS_COUNT) +
        getCaptureAmountModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), ACTIVE_SLOTS_COUNT)
end

function SkillModifierFunctions.getIncomeModifier(configuration)
    return getIncomeModifierForSkillGroup(configuration:getModelSkillGroupPassive(), PASSIVE_SLOTS_COUNT)
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
            modifier = modifier + getSkillModifier(skill.id, skill.level)
        end
    end

    return modifier
end

function SkillModifierFunctions.getAttackDamageCostToFundModifier(configuration)
    return getAttackDamageCostToFundModifierForSkillGroup(configuration:getModelSkillGroupPassive(), PASSIVE_SLOTS_COUNT) +
        getAttackDamageCostToFundModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), ACTIVE_SLOTS_COUNT)
end

function SkillModifierFunctions.getPassivePromotionModifier(configuration)
    local skills   = configuration:getModelSkillGroupPassive():getAllSkills()
    local modifier = 0
    for i = 1, PASSIVE_SLOTS_COUNT do
        local skill = skills[i]
        if ((skill) and (skill.id == 27)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level)
        end
    end

    return modifier
end

function SkillModifierFunctions.isPerfectMovement(configuration)
    return isPerfectMovementForSkillGroup(configuration:getModelSkillGroupPassive(), PASSIVE_SLOTS_COUNT) or
        isPerfectMovementForSkillGroup(configuration:getActivatingModelSkillGroup(), ACTIVE_SLOTS_COUNT)
end

return SkillModifierFunctions
