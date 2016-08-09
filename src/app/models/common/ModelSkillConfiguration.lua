
local ModelSkillConfiguration = require("src.global.functions.class")("ModelSkillConfiguration")

local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local getSkillPoints        = GameConstantFunctions.getSkillPoints
local getSkillModifier      = GameConstantFunctions.getSkillModifier
local getLocalizedText      = LocalizationFunctions.getLocalizedText

local PASSIVE_SKILL_SLOTS_COUNT = GameConstantFunctions.getPassiveSkillSlotsCount()
local ACTIVE_SKILL_SLOTS_COUNT  = GameConstantFunctions.getActiveSkillSlotsCount()
local MIN_POINTS, MAX_POINTS, POINTS_PER_STEP = GameConstantFunctions.getSkillPointsMinMaxStep()

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
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
-- The public functions.
--------------------------------------------------------------------------------
function ModelSkillConfiguration:isEmpty()
    return not ((self.m_MaxPoints) and (self.m_Passive) and (self.m_Active1) and (self.m_Active2))
end

function ModelSkillConfiguration:setMaxPoints(points)
    assert((points >= MIN_POINTS) and (points <= MAX_POINTS) and ((points - MIN_POINTS) % POINTS_PER_STEP == 0))
    self.m_MaxPoints = points

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
