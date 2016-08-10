
local ModelSkillConfiguration = require("src.global.functions.class")("ModelSkillConfiguration")

local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local getSkillPoints        = GameConstantFunctions.getSkillPoints
local getSkillModifier      = GameConstantFunctions.getSkillModifier
local getLocalizedText      = LocalizationFunctions.getLocalizedText

local PASSIVE_SKILL_SLOTS_COUNT = GameConstantFunctions.getPassiveSkillSlotsCount()
local ACTIVE_SKILL_SLOTS_COUNT  = GameConstantFunctions.getActiveSkillSlotsCount()
local MIN_POINTS, MAX_POINTS, POINTS_PER_STEP = GameConstantFunctions.getSkillPointsMinMaxStep()

local ID_PASSIVE_SKILL  = 0
local ID_ACTIVE_SKILL_1 = 1
local ID_ACTIVE_SKILL_2 = 2

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getSkillWithId(self, skillID)
    if (skillID == ID_PASSIVE_SKILL) then
        self.m_Passive = self.m_Passive or {}
        return self.m_Passive
    elseif (skillID == ID_ACTIVE_SKILL_1) then
        self.m_Active1 = self.m_Active1 or {}
        return self.m_Active1
    elseif (skillID == ID_ACTIVE_SKILL_2) then
        self.m_Active2 = self.m_Active2
        return self.m_Active2
    else
        error("ModelSkillConfiguration-getSkillWithId() the param skillID is invalid.")
    end
end

local function getDescriptionForMaxPoints(self)
    return string.format("%s: %d", getLocalizedText(3, "MaxPoints"), self.m_MaxPoints)
end

local function getDescriptionForSingleSkill(name, level, points, modifier)
    return string.format("%s  %s: %d  %s: %.2f  %s: %s%%\n%s",
        getLocalizedText(5, name),
        getLocalizedText(3, "Level"),
        level,
        getLocalizedText(3, "SkillPoints"),
        points,
        getLocalizedText(3, "Modifier"),
        (modifier) and ("" .. modifier) or ("--"),
        getLocalizedText(4, name)
    )
end

local function getDescriptionForPassiveSkill(passiveSkill)
    local totalPoints  = 0
    local descriptions = {""}

    for i = 1, PASSIVE_SKILL_SLOTS_COUNT do
        local skill = passiveSkill[i]
        if (skill) then
            local name, level = skill.name, skill.level
            local modifier    = getSkillModifier(name, level)
            local points      = getSkillPoints(name, level)
            totalPoints       = totalPoints + points
            descriptions[#descriptions + 1] = string.format("%d. %s", i, getDescriptionForSingleSkill(name, level, points, modifier))
        else
            descriptions[#descriptions + 1] = string.format("%d. %s", i, getLocalizedText(3, "None"))
        end
    end

    descriptions[1] = string.format("%s (%s: %.2f)", getLocalizedText(3, "PassiveSkill"), getLocalizedText(3, "TotalPoints"), totalPoints)
    return table.concat(descriptions, "\n")
end

local function getDescriptionForActiveSkill(activeSkill, index)
    return string.format("主动技能%d正在开发中，敬请期待。", index)
end

local function isPassiveSkillValid(self)
    local maxPoints     = self.m_MaxPoints
    local passivePoints = 0
    local passiveSkills = self.m_Passive

    for i = 1, PASSIVE_SKILL_SLOTS_COUNT do
        local skill = passiveSkills[i]
        if (skill) then
            local name    = skill.name
            passivePoints = passivePoints + getSkillPoints(name, skill.level)

            for j = i + 1, PASSIVE_SKILL_SLOTS_COUNT do
                if ((passiveSkills[j]) and (passiveSkills[j].name == name)) then
                    return false, getLocalizedText(7, "ReduplicatedPassiveSkills")
                end
            end
        end
    end

    if (passivePoints > maxPoints) then
        return false, getLocalizedText(7, "OverloadedPassiveSkillPoints")
    else
        return true, nil, maxPoints - passivePoints
    end
end

local function toSerializableTableFromPassiveSkill(self)
    local t             = {}
    local passiveSkills = self.m_Passive
    for i = 1, PASSIVE_SKILL_SLOTS_COUNT do
        local skill = passiveSkills[i]
        if (skill) then
            t[#t + 1] = {
                name  = skill.name,
                level = skill.level,
            }
        end
    end

    return t
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelSkillConfiguration:ctor(param)
    if (param) then
        self.m_MaxPoints = param.maxPoints
        self.m_Passive   = param.passive
        self.m_Active1   = param.active1
        self.m_Active2   = param.active2
    else
        self.m_MaxPoints = nil
        self.m_Passive   = nil
        self.m_Active1   = nil
        self.m_Active2   = nil
    end

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelSkillConfiguration:toSerializableTable()
    -- TODO: serialize the active skills.
    return {
        maxPoints = self.m_MaxPoints,
        passive   = toSerializableTableFromPassiveSkill(self),
        active1   = {},
        active2   = {},
    }
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelSkillConfiguration.getSkillIdPassive()
    return ID_PASSIVE_SKILL
end

function ModelSkillConfiguration.getSkillIdActive1()
    return ID_ACTIVE_SKILL_1
end

function ModelSkillConfiguration.getSkillIdActive2()
    return ID_ACTIVE_SKILL_2
end

function ModelSkillConfiguration:isEmpty()
    return not ((self.m_MaxPoints) and (self.m_Passive) and (self.m_Active1) and (self.m_Active2))
end

function ModelSkillConfiguration:isValid()
    if (self:isEmpty()) then
        return false
    end

    -- TODO: validate the active skills.
    return isPassiveSkillValid(self)
end

function ModelSkillConfiguration:setMaxPoints(points)
    assert((points >= MIN_POINTS) and (points <= MAX_POINTS) and ((points - MIN_POINTS) % POINTS_PER_STEP == 0))
    self.m_MaxPoints = points

    return self
end

function ModelSkillConfiguration:setSkillSlot(skillID, slotIndex, skillName, level)
    getSkillWithId(self, skillID)[slotIndex] = {
        name  = skillName,
        level = level,
    }

    return self
end

function ModelSkillConfiguration:clearSkillSlot(skillID, slotIndex)
    getSkillWithId(self, skillID)[slotIndex] = nil

    return self
end

function ModelSkillConfiguration:getDescription()
    return string.format("%s\n\n%s\n\n%s\n\n%s",
        getDescriptionForMaxPoints(self),
        getDescriptionForPassiveSkill(self.m_Passive),
        getDescriptionForActiveSkill(self.m_Active1, 1),
        getDescriptionForActiveSkill(self.m_Active2, 2)
    )
end

return ModelSkillConfiguration
