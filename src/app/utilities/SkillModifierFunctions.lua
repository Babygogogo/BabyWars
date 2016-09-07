
local SkillModifierFunctions = {}

local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")

local getSkillModifier = GameConstantFunctions.getSkillModifier

local PASSIVE_SLOTS_COUNT = GameConstantFunctions.getPassiveSkillSlotsCount()
local ACTIVE_SLOTS_COUNT  = GameConstantFunctions.getActiveSkillSlotsCount()

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getAttackModifierForSkillGroup(modelSkillGroup, slotsCount,
    attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)

    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, slotsCount do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 1)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level)
        end
    end

    return modifier
end

local function getDefenseModifierForSkillGroup(modelSkillGroup, slotsCount,
    attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)

    if (not modelSkillGroup) then
        return 0
    end

    local modifier = 0
    local skills   = modelSkillGroup:getAllSkills()
    for i = 1, slotsCount do
        local skill = skills[i]
        if ((skill)          and
            (skill.id == 2)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level)
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

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function SkillModifierFunctions.getAttackModifier(configuration,
    attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)

    return getAttackModifierForSkillGroup(configuration:getModelSkillGroupPassive(), PASSIVE_SLOTS_COUNT,
            attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager) +
        getAttackModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), ACTIVE_SLOTS_COUNT,
            attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)
end

function SkillModifierFunctions.getDefenseModifier(configuration,
    attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)

    return getDefenseModifierForSkillGroup(configuration:getModelSkillGroupPassive(), PASSIVE_SLOTS_COUNT,
            attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager) +
        getDefenseModifierForSkillGroup(configuration:getActivatingModelSkillGroup(), ACTIVE_SLOTS_COUNT,
            attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)
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

return SkillModifierFunctions
