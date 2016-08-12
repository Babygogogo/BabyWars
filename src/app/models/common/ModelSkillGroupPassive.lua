
local ModelSkillGroupPassive = require("src.global.functions.class")("ModelSkillGroupPassive")

local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

local getSkillModifier = GameConstantFunctions.getSkillModifier
local getSkillPoints   = GameConstantFunctions.getSkillPoints
local getLocalizedText = LocalizationFunctions.getLocalizedText

local SLOTS_COUNT = GameConstantFunctions.getPassiveSkillSlotsCount()

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getDescriptionForSingleSkill(id, level, points, modifier)
    return string.format("%s  %s: %d  %s: %.2f  %s: %s%%\n%s",
        getLocalizedText(5, id),
        getLocalizedText(3, "Level"),
        level,
        getLocalizedText(3, "SkillPoints"),
        points,
        getLocalizedText(3, "Modifier"),
        (modifier) and ("" .. modifier) or ("--"),
        getLocalizedText(4, id)
    )
end

local function initSlots(self, param)
    local slots = {}
    if (param) then
        for i = 1, SLOTS_COUNT do
            slots[#slots + 1] = param[i]
        end
    end

    self.m_Slots = slots
end

local function resetSkillPoints(self)
    local totalPoints = 0
    local slots       = self.m_Slots

    for i = 1, SLOTS_COUNT do
        local skill = slots[i]
        if (skill) then
            local point = getSkillPoints(skill.id, skill.level)
            assert(type(point) == "number", "ModelSkillGroupPassive-resetSkillPoints() a skill is invalid: " .. i)
            totalPoints = totalPoints + point
        end
    end

    self.m_SkillPoints = totalPoints
end

local function resetIsValid(self)
    local slots = self.m_Slots
    for i = 1, SLOTS_COUNT do
        local skill = slots[i]
        if (skill) then
            local id = skill.id
            for j = i + 1, SLOTS_COUNT do
                if ((slots[j]) and (slots[j].id == id)) then
                    self.m_IsValid = false
                    return
                end
            end
        end
    end

    self.m_IsValid = true
end

--------------------------------------------------------------------------------
-- The constructor and initializer.
--------------------------------------------------------------------------------
function ModelSkillGroupPassive:ctor(param)
    initSlots(       self, param)
    resetSkillPoints(self)
    resetIsValid(    self)

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelSkillGroupPassive:toSerializableTable()
    local t     = {}
    local slots = self.m_Slots

    for i = 1, SLOTS_COUNT do
        local skill = slots[i]
        if (skill) then
            t[#t + 1] = {
                id    = skill.id,
                level = skill.level,
            }
        end
    end

    return t
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelSkillGroupPassive:isValid()
    return self.m_IsValid
end

function ModelSkillGroupPassive:getSkillPoints()
    return self.m_SkillPoints
end

function ModelSkillGroupPassive:getDescription()
    local descriptions = {
        string.format("%s (%s: %.2f)", getLocalizedText(3, "PassiveSkill"), getLocalizedText(3, "TotalPoints"), self:getSkillPoints())
    }

    local slots = self.m_Slots
    for i = 1, SLOTS_COUNT do
        local skill = slots[i]
        if (skill) then
            local id, level = skill.id, skill.level
            local modifier  = getSkillModifier(id, level)
            local points    = getSkillPoints(  id, level)
            descriptions[#descriptions + 1] = string.format("%d. %s", i, getDescriptionForSingleSkill(id, level, points, modifier))
        else
            descriptions[#descriptions + 1] = string.format("%d. %s", i, getLocalizedText(3, "None"))
        end
    end

    return table.concat(descriptions, "\n")
end

function ModelSkillGroupPassive:setSkill(slotIndex, skillID, skillLevel)
    assert((slotIndex > 0) and (slotIndex <= SLOTS_COUNT) and (slotIndex == math.floor(slotIndex)),
        "ModelSkillGroupPassive:setSkill() the param slotIndex is invalid.")

    self.m_Slots[slotIndex] = {
        id    = skillID,
        level = skillLevel,
    }
    resetSkillPoints(self)
    resetIsValid(    self)

    return self
end

function ModelSkillGroupPassive:clearSkill(slotIndex)
    assert((slotIndex > 0) and (slotIndex <= SLOTS_COUNT) and (slotIndex == math.floor(slotIndex)),
        "ModelSkillGroupPassive:clearSkill() the param slotIndex is invalid.")

    self.m_Slots[slotIndex] = nil
    resetSkillPoints(self)
    resetIsValid(    self)

    return self
end

function ModelSkillGroupPassive:getProductionCostModifier(tiledID)
    local slots    = self.m_Slots
    local modifier = 0

    for i = 1, SLOTS_COUNT do
        local skill = slots[i]
        if ((skill)          and
            (skill.id == 3)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level)
        end
    end

    return modifier
end

function ModelSkillGroupPassive:getAttackModifier(attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)
    local slots    = self.m_Slots
    local modifier = 0

    for i = 1, SLOTS_COUNT do
        local skill = slots[i]
        if ((skill)          and
            (skill.id == 1)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level)
        end
    end

    return modifier
end

function ModelSkillGroupPassive:getDefenseModifier(attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)
    local slots    = self.m_Slots
    local modifier = 0

    for i = 1, SLOTS_COUNT do
        local skill = slots[i]
        if ((skill)          and
            (skill.id == 2)) then
            modifier = modifier + getSkillModifier(skill.id, skill.level)
        end
    end

    return modifier
end

return ModelSkillGroupPassive
