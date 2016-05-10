
--[[--------------------------------------------------------------------------------
-- ModelPlayer就是玩家。本类维护关于玩家在战局上的信息，如金钱、技能、能量值等。
--
-- 主要职责及使用场景举例：
--   同上
--
-- 其他：
--  - 玩家、co与技能
--    原版中有co的概念，而本作将取消co的概念，以技能的概念作为代替。
--    技能的概念源于AWDS中的co技能槽。原作中每个co有4个技能槽，允许玩家自由搭配技能。
--    本作中没有co，但同样存在技能的概念，且可用的技能将比原作的更多。这些技能同样由玩家自行搭配，并在战局上发挥作用。
--
--    为维持平衡性及避免玩家全部采取同一种搭配，本作将对技能搭配做出限制。
--    举例而言，每个可用技能都将消耗特定的技能点数，玩家可以任意组合技能，但技能总点数不能超过100点。
--    通过响应玩家的反馈，不断调整技能消耗点数，应该能够使得技能系统达到相对平衡的状态。这样一来，玩家的自由度也会得到提升，而不是局限于数量固定的、而且实力不平衡的co。
--
--  - 目前本类的功能还很少，待日后补充。
--
--  - 本类目前没有对应的view，因为暂时还不用显示。
--]]--------------------------------------------------------------------------------

local ModelPlayer = class("ModelPlayer")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function serializeID(self, spaces)
    return string.format("%sid = %d", spaces, self:getID())
end

local function serializeName(self, spaces)
    return string.format("%sname = %q", spaces, self:getName())
end

local function serializeFund(self, spaces)
    return string.format("%sfund = %d", spaces, self:getFund())
end

local function serializeIsAlive(self, spaces)
    return string.format("%sisAlive = %s", spaces, self:isAlive() and "true" or "false")
end

local function serializeCurrentEnergy(self, spaces)
    return string.format("%scurrentEnergy = %f", spaces, self:getEnergy())
end

local function serializePassiveSkill(self, spaces)
    return string.format("%spassiveSkill = {\n%s}",
        spaces,
        spaces
    )
end

local function serializeEnergyRequirement(self, spaces, skillIndex)
    return string.format("%senergyRequirement = %d",
        spaces,
        self:getActiveSkillEnergyRequirement(skillIndex)
    )
end

local function serializeActiveSkill(self, spaces, skillIndex)
    local subSpaces = spaces .. "    "

    return string.format("%s%s = {\n%s,\n%s}",
        spaces, "activeSkill" .. skillIndex,
        serializeEnergyRequirement(self, subSpaces, skillIndex),
        spaces
    )
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelPlayer:ctor(param)
    self.m_ID            = param.id
    self.m_Name          = param.name
    self.m_Fund          = param.fund
    self.m_IsAlive       = param.isAlive
    self.m_CurrentEnergy = param.currentEnergy

    self.m_PassiveSkill = param.passiveSkill
    self.m_ActiveSkill1 = param.activeSkill1
    self.m_ActiveSkill2 = param.activeSkill2

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelPlayer:getID()
    return self.m_ID
end

function ModelPlayer:getName()
    return self.m_Name
end

function ModelPlayer:isAlive()
    return self.m_IsAlive
end

function ModelPlayer:getFund()
    return self.m_Fund
end

function ModelPlayer:setFund(fund)
    self.m_Fund = fund

    return self
end

function ModelPlayer:getEnergy()
    return self.m_CurrentEnergy, self:getActiveSkillEnergyRequirement(1), self:getActiveSkillEnergyRequirement(2)
end

function ModelPlayer:getActiveSkillEnergyRequirement(skillIndex)
    assert((skillIndex == 1) or (skillIndex == 2), "ModelPlayer:getActiveSkillEnergyRequirement() the param skillIndex is invalid.")

    if (skillIndex == 1) then
        return self.m_ActiveSkill1.energyRequirement
    else
        return self.m_ActiveSkill2.energyRequirement
    end
end

function ModelPlayer:serialize(spaces)
    spaces = spaces or ""
    local subSpaces = spaces .. "    "

    return string.format("%s{\n%s,\n%s,\n%s,\n%s,\n%s,\n%s,\n%s,\n%s,\n%s}",
        spaces,
        serializeID(           self, subSpaces),
        serializeName(         self, subSpaces),
        serializeFund(         self, subSpaces),
        serializeIsAlive(      self, subSpaces),
        serializeCurrentEnergy(self, subSpaces),
        serializePassiveSkill( self, subSpaces),
        serializeActiveSkill(  self, subSpaces, 1),
        serializeActiveSkill(  self, subSpaces, 2),
        spaces
    )
end

return ModelPlayer
