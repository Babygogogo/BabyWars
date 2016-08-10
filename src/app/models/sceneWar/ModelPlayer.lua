
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

local ModelPlayer = require("src.global.functions.class")("ModelPlayer")

local ModelSkillConfiguration = require("src.app.models.common.ModelSkillConfiguration")

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelPlayer:ctor(param)
    self.m_Account       = param.account
    self.m_Nickname      = param.nickname
    self.m_Fund          = param.fund
    self.m_IsAlive       = param.isAlive
    self.m_CurrentEnergy = param.currentEnergy

    self.m_ModelSkillConfiguration = ModelSkillConfiguration:create(param.skillConfiguration)

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function ModelPlayer:toSerializableTable()
    return {
        account            = self:getAccount(),
        nickname           = self:getNickname(),
        fund               = self:getFund(),
        isAlive            = self:isAlive(),
        currentEnergy      = self:getEnergy(),
        skillConfiguration = self:getModelSkillConfiguration():toSerializableTable(),
    }
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelPlayer:getAccount()
    return self.m_Account
end

function ModelPlayer:getNickname()
    return self.m_Nickname
end

function ModelPlayer:isAlive()
    return self.m_IsAlive
end

function ModelPlayer:setAlive(isAlive)
    self.m_IsAlive = isAlive

    return self
end

function ModelPlayer:getFund()
    return self.m_Fund
end

function ModelPlayer:setFund(fund)
    self.m_Fund = fund

    return self
end

function ModelPlayer:getEnergy()
    local modelSkillConfiguration = self:getModelSkillConfiguration()
    return self.m_CurrentEnergy, self:getModelSkillConfiguration():getEnergyRequirement()
end

function ModelPlayer:getModelSkillConfiguration()
    return self.m_ModelSkillConfiguration
end

return ModelPlayer
