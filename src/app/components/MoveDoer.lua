
--[[--------------------------------------------------------------------------------
-- MoveDoer是ModelUnit可用的组件。只有绑定了本组件，宿主才具有“移动力”的属性。
-- 主要职责：
--   维护相关数值并提供必要接口给外界访问
-- 使用场景举例：
--   宿主初始化时，根据属性来绑定和初始化本组件（所有ModelUnit都需要绑定，但具体由GameConstant决定）
--   unit进行移动时，会用到本组件提供的移动力及移动类型
-- 其他：
--   关于移动类型：本作有26种单位，但只有8种移动类型。每种单位都有特定的移动类型，不同的单位的移动类型可能相同（如tank和mdtank）
--   单位移动范围同时受到燃料残量、天气、co技能等的影响
--]]--------------------------------------------------------------------------------

local MoveDoer = requireBW("src.global.functions.class")("MoveDoer")

local GridIndexFunctions     = requireBW("src.app.utilities.GridIndexFunctions")
local LocalizationFunctions  = requireBW("src.app.utilities.LocalizationFunctions")
local SingletonGetters       = requireBW("src.app.utilities.SingletonGetters")
local SkillModifierFunctions = requireBW("src.app.utilities.SkillModifierFunctions")
local ComponentManager       = requireBW("src.global.components.ComponentManager")

local MOVE_TYPES = requireBW("res.data.GameConstant").moveTypes

MoveDoer.EXPORTED_METHODS = {
    "getMoveRange",
    "getMoveType",
    "getMoveTypeFullName",
}

--------------------------------------------------------------------------------
-- The param validators.
--------------------------------------------------------------------------------
local function isMoveRange(param)
    return (param > 0) and (math.ceil(param) == param)
end

local function isMoveType(param)
    for _, validType in ipairs(MOVE_TYPES) do
        if (validType == param) then
            return true
        end
    end

    return false
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function MoveDoer:ctor(param)
    self:loadTemplate(param.template)

    return self
end

function MoveDoer:loadTemplate(template)
    assert(isMoveRange(template.range), "MoveDoer:loadTemplate() the template.range is expected to be an integer.")
    assert(isMoveType(template.type), "MoveDoer:loadTemplate() the template.type is invalid.")
    self.m_Template = template

    return self
end

--------------------------------------------------------------------------------
-- The public callback function on start running.
--------------------------------------------------------------------------------
function MoveDoer:onStartRunning(modelSceneWar)
    self.m_ModelSceneWar = modelSceneWar

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function MoveDoer:getMoveRange()
    -- TODO: Take modelPlayer and modelWeather into account.
    local owner       = self.m_Owner
    local modelPlayer = SingletonGetters.getModelPlayerManager(self.m_ModelSceneWar):getModelPlayer(owner:getPlayerIndex())
    return math.max(1, self.m_Template.range + SkillModifierFunctions.getMoveRangeModifier(modelPlayer:getModelSkillConfiguration(), owner))
end

function MoveDoer:getMoveType()
    return self.m_Template.type
end

function MoveDoer:getMoveTypeFullName()
    return LocalizationFunctions.getLocalizedText(110, self:getMoveType())
end

return MoveDoer
