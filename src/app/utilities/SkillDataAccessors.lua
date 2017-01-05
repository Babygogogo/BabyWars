
local SkillDataAccessors = {}

local SKILL_DATA = require("res.data.SkillData")

function SkillDataAccessors.getSkillConfigurationsCount()
    return SKILL_DATA.skillConfigurationsCount
end

function SkillDataAccessors.getPassiveSkillSlotsCount()
    return SKILL_DATA.passiveSkillSlotsCount
end

function SkillDataAccessors.getActiveSkillSlotsCount()
    return SKILL_DATA.activeSkillSlotsCount
end

function SkillDataAccessors.getBasePointsMinMaxStep()
    return SKILL_DATA.minBasePoints, SKILL_DATA.maxBasePoints, SKILL_DATA.basePointsPerStep
end

function SkillDataAccessors.getEnergyRequirementMinMax()
    return SKILL_DATA.minEnergyRequirement, SKILL_DATA.maxEnergyRequirement
end

function SkillDataAccessors.getSkillPointsPerEnergyRequirement()
    return SKILL_DATA.skillPointsPerEnergyRequirement
end

function SkillDataAccessors.getDamageCostPerEnergyRequirement()
    return SKILL_DATA.damageCostPerEnergyRequirement
end

function SkillDataAccessors.getSkillEnergyRequirement(id, level)
    return SKILL_DATA.skills[id].levels[level].minEnergy
end

function SkillDataAccessors.getDamageCostGrowthRates()
    return SKILL_DATA.damageCostGrowthRates
end

function SkillDataAccessors.getSkillPoints(id, level, isActive)
    assert(type(isActive) == "boolean", "SkillDataAccessors.getSkillPoints() invalid param isActive. Boolean expected.")
    if (isActive) then
        return SKILL_DATA.skills[id].levels[level].pointsActive
    else
        return SKILL_DATA.skills[id].levels[level].pointsPassive
    end
end

function SkillDataAccessors.getSkillModifier(id, level, isActive)
    assert(type(isActive) == "boolean", "SkillDataAccessors.getSkillModifier() invalid param isActive. Boolean expected.")
    if (isActive) then
        return SKILL_DATA.skills[id].levels[level].modifierActive
    else
        return SKILL_DATA.skills[id].levels[level].modifierPassive
    end
end

function SkillDataAccessors.getSkillModifierUnit(id)
    return SKILL_DATA.skills[id].modifierUnit
end

function SkillDataAccessors.getSkillLevelMinMax(id, isActive)
    local skill = SKILL_DATA.skills[id]
    if (isActive) then
        return skill.minLevelActive, skill.maxLevelActive
    else
        return skill.minLevelPassive, skill.maxLevelPassive
    end
end

function SkillDataAccessors.getSkillCategory(categoryName)
    return SKILL_DATA.categories[categoryName]
end

function SkillDataAccessors.getSkillPresets()
    return SKILL_DATA.skillPresets
end

return SkillDataAccessors
