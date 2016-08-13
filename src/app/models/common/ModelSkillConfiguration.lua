
local ModelSkillConfiguration = require("src.global.functions.class")("ModelSkillConfiguration")

local ModelSkillGroupPassive = require("src.app.models.common.ModelSkillGroupPassive")
local ModelSkillGroupActive  = require("src.app.models.common.ModelSkillGroupActive")
local GameConstantFunctions  = require("src.app.utilities.GameConstantFunctions")
local LocalizationFunctions  = require("src.app.utilities.LocalizationFunctions")

local getLocalizedText = LocalizationFunctions.getLocalizedText

local MIN_POINTS, MAX_POINTS, POINTS_PER_STEP = GameConstantFunctions.getSkillPointsMinMaxStep()

local SKILL_GROUP_ID_PASSIVE  = 0
local SKILL_GROUP_ID_ACTIVE_1 = 1
local SKILL_GROUP_ID_ACTIVE_2 = 2

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getDescriptionForMaxPoints(self)
    return string.format("%s: %d", getLocalizedText(3, "MaxPoints"), self.m_MaxPoints)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelSkillConfiguration:ctor(param)
    self.m_ModelSkillGroupPassive = self.m_ModelSkillGroupPassive or ModelSkillGroupPassive:create()
    self.m_ModelSkillGroupActive1 = self.m_ModelSkillGroupActive1 or ModelSkillGroupActive: create()
    self.m_ModelSkillGroupActive2 = self.m_ModelSkillGroupActive2 or ModelSkillGroupActive: create()

    param = param or {}
    self.m_MaxPoints = param.maxPoints
    self.m_ModelSkillGroupPassive:ctor(param.passive)
    self.m_ModelSkillGroupActive1:ctor(param.active1)
    self.m_ModelSkillGroupActive2:ctor(param.active2)

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelSkillConfiguration:toSerializableTable()
    local active1 = self.m_ModelSkillGroupActive1
    local active2 = self.m_ModelSkillGroupActive2
    if (active1:isEnabled()) then
        if ((not active2:isEnabled()) or
            (active1:getEnergyRequirement() > active2:getEnergyRequirement())) then
            active1, active2 = active2, active1
        end
    end

    return {
        maxPoints = self.m_MaxPoints,
        passive   = self.m_ModelSkillGroupPassive:toSerializableTable(),
        active1   = active1:toSerializableTable(),
        active2   = active2:toSerializableTable(),
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

function ModelSkillConfiguration:getModelSkillGroupWithId(skillGroupID)
    if (skillGroupID == SKILL_GROUP_ID_PASSIVE) then
        return self.m_ModelSkillGroupPassive
    elseif (skillGroupID == SKILL_GROUP_ID_ACTIVE_1) then
        return self.m_ModelSkillGroupActive1
    elseif (skillGroupID == SKILL_GROUP_ID_ACTIVE_2) then
        return self.m_ModelSkillGroupActive2
    else
        error("ModelSkillConfiguration:getModelSkillGroupWithId() the param skillGroupID is invalid.")
    end
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
    elseif (not self.m_ModelSkillGroupActive1:isValid()) then
        return false, getLocalizedText(7, "InvalidActiveSkill", 1)
    elseif (not self.m_ModelSkillGroupActive2:isValid()) then
        return false, getLocalizedText(7, "InvalidActiveSkill", 2)
    end

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
    self:getModelSkillGroupWithId(skillGroupID):setSkill(slotIndex, skillID, level)

    return self
end

function ModelSkillConfiguration:clearSkill(skillGroupID, slotIndex)
    self:getModelSkillGroupWithId(skillGroupID):clearSkill(slotIndex)

    return self
end

function ModelSkillConfiguration:getEnergyRequirement()
    return self.m_ModelSkillGroupActive1:getEnergyRequirement(),
        self.m_ModelSkillGroupActive2:getEnergyRequirement()
end

function ModelSkillConfiguration:getDescription()
    return string.format("%s\n\n%s\n\n%s\n\n%s",
        getDescriptionForMaxPoints(self),
        self.m_ModelSkillGroupPassive:getDescription(),
        self.m_ModelSkillGroupActive1:getDescription(),
        self.m_ModelSkillGroupActive2:getDescription()
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
