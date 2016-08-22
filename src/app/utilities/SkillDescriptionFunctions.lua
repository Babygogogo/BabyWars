
local SkillDescriptionFunctions = {}

local ModelSkillConfiguration = require("src.app.models.common.ModelSkillConfiguration")
local GameConstantFunctions   = require("src.app.utilities.GameConstantFunctions")
local LocalizationFunctions   = require("src.app.utilities.LocalizationFunctions")

local getSkillPoints            = GameConstantFunctions.getSkillPoints
local getSkillEnergyRequirement = GameConstantFunctions.getSkillEnergyRequirement
local getSkillModifier          = GameConstantFunctions.getSkillModifier
local getSkillModifierUnit      = GameConstantFunctions.getSkillModifierUnit
local getLocalizedText          = LocalizationFunctions.getLocalizedText

local PASSIVE_SLOTS_COUNT    = GameConstantFunctions.getPassiveSkillSlotsCount()
local ACTIVE_SLOTS_COUNT     = GameConstantFunctions.getActiveSkillSlotsCount()
local SKILL_GROUP_ID_PASSIVE = ModelSkillConfiguration.getSkillGroupIdPassive()
local SKILL_GROUP_ID_ACTIVE1 = ModelSkillConfiguration.getSkillGroupIdActive1()
local SKILL_GROUP_ID_ACTIVE2 = ModelSkillConfiguration.getSkillGroupIdActive2()

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getDescriptionForMaxSkillPoints(points)
    return string.format("%s: %d", getLocalizedText(3, "MaxPoints"), points)
end

local function transformModifier1(modifier, unit)
    return string.format("%d%s", 100 + modifier, unit)
end

local function transformModifier2(modifier, unit)
    if (modifier >= 0) then
        return string.format("%.2f%s", 10000 / (100 + modifier), unit)
    else
        return string.format("%.2f%s", 100 - modifier,           unit)
    end
end

local function transformModifier3(modifier, unit)
    if (modifier > 0) then return "+" .. modifier
    else                   return modifier
    end
end

local function getSkillModifierForDisplay(id, level)
    local modifier = getSkillModifier(id, level)
    if (not modifier) then
        return ""
    end

    local modifierUnit = getSkillModifierUnit(id)
    if     (id == 1) then return transformModifier1(modifier,  modifierUnit)
    elseif (id == 2) then return transformModifier2(modifier,  modifierUnit)
    elseif (id == 3) then return transformModifier2(-modifier, modifierUnit)
    elseif (id == 4) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 5) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 6) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 7) then return transformModifier3(modifier,  modifierUnit)
    end
end

local function getDescriptionForSingleSkill(id, level, isPassive)
    if (isPassive) then
        return string.format("%s      %s: %d      %s: %.2f\n%s %s",
            getLocalizedText(5, id),
            getLocalizedText(3, "Level"),       level,
            getLocalizedText(3, "SkillPoints"), getSkillPoints(id, level, false),
            getLocalizedText(4, id),            getSkillModifierForDisplay(id, level)
        )
    else
        return string.format("%s      %s: %d      %s: %.2f      %s: %d\n%s %s",
            getLocalizedText(5, id),
            getLocalizedText(3, "Level"),       level,
            getLocalizedText(3, "SkillPoints"), getSkillPoints(id, level, true),
            getLocalizedText(3, "MinEnergy"),   getSkillEnergyRequirement(id, level),
            getLocalizedText(4, id),            getSkillModifierForDisplay(id, level)
        )
    end
end

local function getDescriptionForSkillGroup(skillGroup, skillGroupID)
    local isPassive = skillGroupID == SKILL_GROUP_ID_PASSIVE
    local prefix    = (isPassive)                                                     and
        (string.format("%s : ",    getLocalizedText(3, "PassiveSkill")))              or
        (string.format("%s %d : ", getLocalizedText(3, "ActiveSkill"), skillGroupID))

    if ((not isPassive) and (not skillGroup:isEnabled())) then
        return prefix .. getLocalizedText(3, "Disabled")
    end

    local descriptions = {
        string.format("%s    (%s: %.2f      %s: %.2f)",
            prefix,
            getLocalizedText(3, "TotalPoints"), skillGroup:getSkillPoints(),
            getLocalizedText(3, "MaxPoints"),   skillGroup:getMaxSkillPoints()
        )
    }
    if (not isPassive) then
        descriptions[#descriptions + 1] = string.format("%s:   %d",
            getLocalizedText(3, "EnergyRequirement"), skillGroup:getEnergyRequirement())
    end

    local slotsCount = (isPassive) and (PASSIVE_SLOTS_COUNT) or (ACTIVE_SLOTS_COUNT)
    local skills     = skillGroup:getAllSkills()
    for i = 1, slotsCount do
        local skill = skills[i]
        if (skill) then
            descriptions[#descriptions + 1] = string.format("%d. %s", i, getDescriptionForSingleSkill(skill.id, skill.level, isPassive))
        else
            descriptions[#descriptions + 1] = string.format("%d. %s", i, getLocalizedText(3, "None"))
        end
    end

    return table.concat(descriptions, "\n")
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function SkillDescriptionFunctions.getDescription(modelSkillConfiguration)
    local maxSkillPoints = modelSkillConfiguration:getMaxSkillPoints()
    if (not maxSkillPoints) then
        return getLocalizedText(3, "NoSkills")
    end

    return string.format("%s\n%s\n\n%s\n\n%s",
        getDescriptionForMaxSkillPoints(maxSkillPoints),
        getDescriptionForSkillGroup(modelSkillConfiguration:getModelSkillGroupPassive(), SKILL_GROUP_ID_PASSIVE),
        getDescriptionForSkillGroup(modelSkillConfiguration:getModelSkillGroupActive1(), SKILL_GROUP_ID_ACTIVE1),
        getDescriptionForSkillGroup(modelSkillConfiguration:getModelSkillGroupActive2(), SKILL_GROUP_ID_ACTIVE2)
    )
end

return SkillDescriptionFunctions
