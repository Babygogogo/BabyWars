
local SkillDescriptionFunctions = {}

local ModelSkillConfiguration = require("src.app.models.common.ModelSkillConfiguration")
local LocalizationFunctions   = require("src.app.utilities.LocalizationFunctions")
local SkillDataAccessors      = require("src.app.utilities.SkillDataAccessors")

local getSkillPoints            = SkillDataAccessors.getSkillPoints
local getSkillEnergyRequirement = SkillDataAccessors.getSkillEnergyRequirement
local getSkillModifier          = SkillDataAccessors.getSkillModifier
local getSkillModifierUnit      = SkillDataAccessors.getSkillModifierUnit
local getLocalizedText          = LocalizationFunctions.getLocalizedText

local PASSIVE_SLOTS_COUNT    = SkillDataAccessors.getPassiveSkillSlotsCount()
local ACTIVE_SLOTS_COUNT     = SkillDataAccessors.getActiveSkillSlotsCount()
local SKILL_GROUP_ID_PASSIVE = ModelSkillConfiguration.getSkillGroupIdPassive()
local SKILL_GROUP_ID_ACTIVE1 = ModelSkillConfiguration.getSkillGroupIdActive1()
local SKILL_GROUP_ID_ACTIVE2 = ModelSkillConfiguration.getSkillGroupIdActive2()

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
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
    unit = unit or ""
    if (modifier > 0) then return "+" .. modifier .. unit
    else                   return        modifier .. unit
    end
end

local function getSkillModifierForDisplay(id, level, isActive)
    local modifier = getSkillModifier(id, level, isActive)
    if (not modifier) then
        return ""
    end

    local modifierUnit = getSkillModifierUnit(id)
    if     (id == 1)  then return transformModifier1(modifier,  modifierUnit)
    elseif (id == 2)  then return transformModifier2(modifier,  modifierUnit)
    elseif (id == 3)  then return transformModifier2(-modifier, modifierUnit)
    elseif (id == 4)  then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 5)  then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 6)  then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 7)  then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 9)  then return transformModifier2(-modifier, modifierUnit)
    elseif (id == 10) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 11) then return transformModifier2(-modifier, modifierUnit)
    elseif (id == 12) then return transformModifier1(modifier,  modifierUnit)
    elseif (id == 13) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 14) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 15) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 17) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 19) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 20) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 21) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 22) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 23) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 24) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 25) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 26) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 27) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 29) then return transformModifier1(modifier,  modifierUnit)
    elseif (id == 30) then return transformModifier1(modifier,  modifierUnit)
    elseif (id == 31) then return transformModifier1(modifier,  modifierUnit)
    elseif (id == 32) then return transformModifier1(modifier,  modifierUnit)
    elseif (id == 33) then return transformModifier1(modifier,  modifierUnit)
    elseif (id == 34) then return transformModifier1(modifier,  modifierUnit)
    elseif (id == 35) then return transformModifier1(modifier,  modifierUnit)
    elseif (id == 36) then return transformModifier1(modifier,  modifierUnit)
    elseif (id == 37) then return transformModifier2(modifier,  modifierUnit)
    elseif (id == 38) then return transformModifier2(modifier,  modifierUnit)
    elseif (id == 39) then return transformModifier2(modifier,  modifierUnit)
    elseif (id == 40) then return transformModifier2(modifier,  modifierUnit)
    elseif (id == 41) then return transformModifier2(modifier,  modifierUnit)
    elseif (id == 42) then return transformModifier2(modifier,  modifierUnit)
    elseif (id == 43) then return transformModifier2(modifier,  modifierUnit)
    elseif (id == 44) then return transformModifier2(modifier,  modifierUnit)
    elseif (id == 45) then return transformModifier2(modifier,  modifierUnit)
    elseif (id == 46) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 47) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 48) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 49) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 50) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 51) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 52) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 53) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 54) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 55) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 56) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 57) then return transformModifier3(modifier,  modifierUnit)
    elseif (id == 61) then return transformModifier3(modifier,  modifierUnit)
    end
end

local function getFullDescriptionForBaseSkillPoints(points)
    return string.format("%s: %d", getLocalizedText(3, "BasePoints"), points)
end

local function getFullDescriptionForSingleSkill(id, level, isActive)
    if (not isActive) then
        return string.format("%s      %s: %d      %s: %.2f\n%s %s",
            getLocalizedText(5, id),
            getLocalizedText(3, "Level"),       level,
            getLocalizedText(3, "SkillPoints"), getSkillPoints(id, level, false),
            getLocalizedText(4, id),            getSkillModifierForDisplay(id, level, false)
        )
    else
        return string.format("%s      %s: %d      %s: %.2f      %s: %d\n%s %s",
            getLocalizedText(5, id),
            getLocalizedText(3, "Level"),       level,
            getLocalizedText(3, "SkillPoints"), getSkillPoints(id, level, true),
            getLocalizedText(3, "MinEnergy"),   getSkillEnergyRequirement(id, level),
            getLocalizedText(4, id),            getSkillModifierForDisplay(id, level, true)
        )
    end
end

local function getBriefDescriptionForSingleSkill(id, level, isActive)
    return string.format("%s\n%s %s",
        getLocalizedText(5, id),
        getLocalizedText(4, id), getSkillModifierForDisplay(id, level, isActive)
    )
end

local function getFullDescriptionForSkillGroup(skillGroup, skillGroupID)
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
            descriptions[#descriptions + 1] = string.format("%d. %s", i, getFullDescriptionForSingleSkill(skill.id, skill.level, not isPassive))
        else
            descriptions[#descriptions + 1] = string.format("%d. %s", i, getLocalizedText(3, "None"))
        end
    end

    return table.concat(descriptions, "\n")
end

local function getBriefDescriptionForSkillGroup(skillGroup, skillGroupID)
    local isPassive = skillGroupID == SKILL_GROUP_ID_PASSIVE
    local prefix    = (isPassive)                                                     and
        (string.format("%s : ",    getLocalizedText(3, "PassiveSkill")))              or
        (string.format("%s %d : ", getLocalizedText(3, "ActiveSkill"), skillGroupID))

    if ((isPassive) and (skillGroup:isEmpty())) then
        return prefix .. getLocalizedText(3, "None")
    elseif ((not isPassive) and (not skillGroup:isEnabled())) then
        return prefix .. getLocalizedText(3, "Disabled")
    end

    local descriptions = {
        (isPassive) and
        (prefix)    or
        (string.format("%s    %s:   %d", prefix, getLocalizedText(3, "EnergyRequirement"), skillGroup:getEnergyRequirement())),
    }

    local slotsCount = (isPassive) and (PASSIVE_SLOTS_COUNT) or (ACTIVE_SLOTS_COUNT)
    local skills     = skillGroup:getAllSkills()
    for i = 1, slotsCount do
        local skill = skills[i]
        if (skill) then
            descriptions[#descriptions + 1] = string.format("%d. %s", i, getBriefDescriptionForSingleSkill(skill.id, skill.level, not isPassive))
        else
            if (i == 1) then
                descriptions[#descriptions + 1] = string.format("1. %s", getLocalizedText(3, "None"))
            end

            for j = i + 1, slotsCount do
                assert(not skills[j], "SkillDescriptionFunctions-getBriefDescriptionForSkillGroup() invalid skill group: ".. skillGroupID)
            end
            break
        end
    end

    return table.concat(descriptions, "\n")
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function SkillDescriptionFunctions.getFullDescription(modelSkillConfiguration)
    return string.format("%s\n%s\n\n%s\n\n%s",
        getFullDescriptionForBaseSkillPoints(modelSkillConfiguration:getBaseSkillPoints()),
        getFullDescriptionForSkillGroup(modelSkillConfiguration:getModelSkillGroupPassive(), SKILL_GROUP_ID_PASSIVE),
        getFullDescriptionForSkillGroup(modelSkillConfiguration:getModelSkillGroupActive1(), SKILL_GROUP_ID_ACTIVE1),
        getFullDescriptionForSkillGroup(modelSkillConfiguration:getModelSkillGroupActive2(), SKILL_GROUP_ID_ACTIVE2)
    )
end

function SkillDescriptionFunctions.getBriefDescription(modelSkillConfiguration)
    local skillGroupPassive = modelSkillConfiguration:getModelSkillGroupPassive()
    local skillGroupActive1 = modelSkillConfiguration:getModelSkillGroupActive1()
    local skillGroupActive2 = modelSkillConfiguration:getModelSkillGroupActive2()
    if ((skillGroupPassive:isEmpty())        and
        (not skillGroupActive1:isEnabled())  and
        (not skillGroupActive2:isEnabled())) then
        return getLocalizedText(3, "NoSkills")
    end

    return string.format("%s\n%s\n\n%s\n\n%s",
        getFullDescriptionForBaseSkillPoints(modelSkillConfiguration:getBaseSkillPoints()),
        getBriefDescriptionForSkillGroup(skillGroupPassive, SKILL_GROUP_ID_PASSIVE),
        getBriefDescriptionForSkillGroup(skillGroupActive1, SKILL_GROUP_ID_ACTIVE1),
        getBriefDescriptionForSkillGroup(skillGroupActive2, SKILL_GROUP_ID_ACTIVE2)
    )
end

return SkillDescriptionFunctions
