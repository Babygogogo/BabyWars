
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

return SkillModifierFunctions
