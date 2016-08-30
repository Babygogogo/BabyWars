
local ModelSkillGroupPassive = require("src.global.functions.class")("ModelSkillGroupPassive")

local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

local getSkillModifier     = GameConstantFunctions.getSkillModifier
local getSkillModifierUnit = GameConstantFunctions.getSkillModifierUnit
local getSkillPoints       = GameConstantFunctions.getSkillPoints
local getLocalizedText     = LocalizationFunctions.getLocalizedText

local SLOTS_COUNT = GameConstantFunctions.getPassiveSkillSlotsCount()

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function initSlots(self, param)
    local slots = {}
    if (param) then
        for i = 1, SLOTS_COUNT do
            slots[#slots + 1] = param[i]
        end
    end

    self.m_Slots = slots
end

--------------------------------------------------------------------------------
-- The constructor and initializer.
--------------------------------------------------------------------------------
function ModelSkillGroupPassive:ctor(param)
    self:setMaxSkillPoints(0)
    initSlots(self, param)

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
    local slots       = self.m_Slots
    local totalPoints = 0
    local maxPoints   = self:getMaxSkillPoints()

    for i = 1, SLOTS_COUNT do
        local skill = slots[i]
        if (skill) then
            local id    = skill.id
            totalPoints = totalPoints + getSkillPoints(id, skill.level)

            for j = i + 1, SLOTS_COUNT do
                if ((slots[j]) and (slots[j].id == id)) then
                    return false, getLocalizedText(7, "ReduplicatedSkills")
                end
            end
        end
    end

    if (totalPoints > self:getMaxSkillPoints()) then
        return false, getLocalizedText(7, "SkillPointsExceedsLimit")
    else
        return true
    end
end

function ModelSkillGroupPassive:getSkillPoints()
    local totalPoints = 0
    local slots       = self.m_Slots

    for i = 1, SLOTS_COUNT do
        local skill = slots[i]
        if (skill) then
            totalPoints = totalPoints + getSkillPoints(skill.id, skill.level)
        end
    end

    return totalPoints
end

function ModelSkillGroupPassive:getMaxSkillPoints()
    return self.m_MaxSkillPoints
end

function ModelSkillGroupPassive:setMaxSkillPoints(points)
    assert(points >= 0)
    self.m_MaxSkillPoints = points

    return self
end

function ModelSkillGroupPassive:getAllSkills()
    return self.m_Slots
end

function ModelSkillGroupPassive:setSkill(slotIndex, skillID, skillLevel)
    assert((slotIndex > 0) and (slotIndex <= SLOTS_COUNT) and (slotIndex == math.floor(slotIndex)),
        "ModelSkillGroupPassive:setSkill() the param slotIndex is invalid.")
    self.m_Slots[slotIndex] = {
        id    = skillID,
        level = skillLevel,
    }

    return self
end

function ModelSkillGroupPassive:clearSkill(slotIndex)
    assert((slotIndex > 0) and (slotIndex <= SLOTS_COUNT) and (slotIndex == math.floor(slotIndex)),
        "ModelSkillGroupPassive:clearSkill() the param slotIndex is invalid.")
    self.m_Slots[slotIndex] = nil

    return self
end

return ModelSkillGroupPassive
