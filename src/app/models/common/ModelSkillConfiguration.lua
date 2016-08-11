
local ModelSkillConfiguration = require("src.global.functions.class")("ModelSkillConfiguration")

local ModelPassiveSkill     = require("src.app.models.common.ModelPassiveSkill")
local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

local getLocalizedText = LocalizationFunctions.getLocalizedText

local ACTIVE_SKILL_SLOTS_COUNT = GameConstantFunctions.getActiveSkillSlotsCount()
local MIN_POINTS, MAX_POINTS, POINTS_PER_STEP = GameConstantFunctions.getSkillPointsMinMaxStep()

local ID_PASSIVE_SKILL  = 0
local ID_ACTIVE_SKILL_1 = 1
local ID_ACTIVE_SKILL_2 = 2

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getSkillWithId(self, skillID)
    if (skillID == ID_PASSIVE_SKILL) then
        return self.m_ModelPassiveSkill
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

local function getDescriptionForActiveSkill(activeSkill, index)
    return string.format("主动技能%d正在开发中，敬请期待。", index)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelSkillConfiguration:ctor(param)
    self.m_ModelPassiveSkill = self.m_ModelPassiveSkill or ModelPassiveSkill:create()
    self.m_ModelPassiveSkill:ctor((param) and (param.passive) or (nil))

    if (param) then
        self.m_MaxPoints = param.maxPoints
        self.m_Active1   = param.active1
        self.m_Active2   = param.active2
    else
        self.m_MaxPoints = nil
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
        passive   = self.m_ModelPassiveSkill:toSerializableTable(),
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
    return not self.m_MaxPoints
end

function ModelSkillConfiguration:isValid()
    if (self:isEmpty()) then
        return false
    end

    local maxPoints         = self.m_MaxPoints
    local modelPassiveSkill = self.m_ModelPassiveSkill
    if (not modelPassiveSkill:isValid()) then
        return false, getLocalizedText(7, "ReduplicatedPassiveSkills")
    elseif (modelPassiveSkill:getSkillPoints() > maxPoints) then
        return false, getLocalizedText(7, "OverloadedPassiveSkillPoints")
    end
    -- TODO: validate the active skills.

    return true
end

function ModelSkillConfiguration:setMaxPoints(points)
    assert((points >= MIN_POINTS) and (points <= MAX_POINTS) and ((points - MIN_POINTS) % POINTS_PER_STEP == 0))
    self.m_MaxPoints = points

    return self
end

function ModelSkillConfiguration:getMaxPoints()
    return self.m_MaxPoints
end

function ModelSkillConfiguration:setSkillSlot(skillID, slotIndex, skillName, level)
    getSkillWithId(self, skillID):setSkill(slotIndex, skillName, level)

    return self
end

function ModelSkillConfiguration:clearSkill(skillID, slotIndex)
    getSkillWithId(self, skillID):clearSkill(slotIndex)

    return self
end

function ModelSkillConfiguration:getEnergyRequirement()
    return self.m_Active1.energyRequirement or 0,
        self.m_Active2.energyRequirement or 0
end

function ModelSkillConfiguration:getDescription()
    return string.format("%s\n\n%s\n\n%s\n\n%s",
        getDescriptionForMaxPoints(self),
        self.m_ModelPassiveSkill:getDescription(),
        getDescriptionForActiveSkill(self.m_Active1, 1),
        getDescriptionForActiveSkill(self.m_Active2, 2)
    )
end

return ModelSkillConfiguration
