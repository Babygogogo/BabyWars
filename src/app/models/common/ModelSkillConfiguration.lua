
local ModelSkillConfiguration = require("src.global.functions.class")("ModelSkillConfiguration")

local ModelSkillGroupPassive = require("src.app.models.common.ModelSkillGroupPassive")
local GameConstantFunctions  = require("src.app.utilities.GameConstantFunctions")
local LocalizationFunctions  = require("src.app.utilities.LocalizationFunctions")

local getLocalizedText = LocalizationFunctions.getLocalizedText

local ACTIVE_SKILL_SLOTS_COUNT = GameConstantFunctions.getActiveSkillSlotsCount()
local MIN_POINTS, MAX_POINTS, POINTS_PER_STEP = GameConstantFunctions.getSkillPointsMinMaxStep()

local SKILL_GROUP_ID_PASSIVE  = 0
local SKILL_GROUP_ID_ACTIVE_1 = 1
local SKILL_GROUP_ID_ACTIVE_2 = 2

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getSkillGroupWithId(self, skillGroupID)
    if (skillGroupID == SKILL_GROUP_ID_PASSIVE) then
        return self.m_ModelSkillGroupPassive
    elseif (skillGroupID == SKILL_GROUP_ID_ACTIVE_1) then
        self.m_Active1 = self.m_Active1 or {}
        return self.m_Active1
    elseif (skillGroupID == SKILL_GROUP_ID_ACTIVE_2) then
        self.m_Active2 = self.m_Active2
        return self.m_Active2
    else
        error("ModelSkillConfiguration-getSkillGroupWithId() the param skillGroupID is invalid.")
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
    self.m_ModelSkillGroupPassive = self.m_ModelSkillGroupPassive or ModelSkillGroupPassive:create()
    self.m_ModelSkillGroupPassive:ctor((param) and (param.passive) or (nil))

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
        passive   = self.m_ModelSkillGroupPassive:toSerializableTable(),
        active1   = {},
        active2   = {},
    }
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelSkillConfiguration.getSkillGroupIdPassive()
    return SKILL_GROUP_ID_PASSIVE
end

function ModelSkillConfiguration.getSkillGroupIdActive1()
    return SKILL_GROUP_ID_ACTIVE_1
end

function ModelSkillConfiguration.getSkillGroupIdActive2()
    return SKILL_GROUP_ID_ACTIVE_2
end

function ModelSkillConfiguration:isEmpty()
    return not self.m_MaxPoints
end

function ModelSkillConfiguration:isValid()
    if (self:isEmpty()) then
        return false
    end

    local maxPoints         = self.m_MaxPoints
    local modelPassiveSkill = self.m_ModelSkillGroupPassive
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

function ModelSkillConfiguration:setSkill(skillGroupID, slotIndex, skillID, level)
    getSkillGroupWithId(self, skillGroupID):setSkill(slotIndex, skillID, level)

    return self
end

function ModelSkillConfiguration:clearSkill(skillGroupID, slotIndex)
    getSkillGroupWithId(self, skillGroupID):clearSkill(slotIndex)

    return self
end

function ModelSkillConfiguration:getEnergyRequirement()
    return self.m_Active1.energyRequirement or 0,
        self.m_Active2.energyRequirement or 0
end

function ModelSkillConfiguration:getDescription()
    return string.format("%s\n\n%s\n\n%s\n\n%s",
        getDescriptionForMaxPoints(self),
        self.m_ModelSkillGroupPassive:getDescription(),
        getDescriptionForActiveSkill(self.m_Active1, 1),
        getDescriptionForActiveSkill(self.m_Active2, 2)
    )
end

function ModelSkillConfiguration:getProductionCostModifier(tiledID)
    local modifier = self.m_ModelSkillGroupPassive:getProductionCostModifier(tiledID)
    -- TODO: take the active skills into account.

    return modifier
end

function ModelSkillConfiguration:getAttackModifier(attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)
    local modifier = self.m_ModelSkillGroupPassive:getAttackModifier(
        attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)
    -- TODO: take the active skills into account.

    return modifier
end

function ModelSkillConfiguration:getDefenseModifier(attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)
    local modifier = self.m_ModelSkillGroupPassive:getDefenseModifier(
        attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)
    -- TODO: take the active skills into account.

    return modifier
end

return ModelSkillConfiguration
