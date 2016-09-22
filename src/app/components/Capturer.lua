
--[[--------------------------------------------------------------------------------
-- Capturer是ModelUnit可用的组件。只有绑定了这个组件，才能对可占领的对象（即绑定了Capturable的ModelTile）实施占领。
-- 主要职责：
--   维护有关占领的各种数值（目前只要维护“是否正在占领”。占领点数由Capturable维护），并提供必要接口给外界访问
-- 使用场景举例：
--   宿主初始化时，根据自身属性来绑定和初始化本组件（比如infantry需要绑定，lander不需要。具体需要与否，由GameConstant决定）
--   玩家操作单位时，需要通过本组件获知能否对特定目标进行占领
-- 其他：
--   占领能力受hp、co技能影响
--]]--------------------------------------------------------------------------------

local Capturer = require("src.global.functions.class")("Capturer")

local SingletonGetters       = require("src.app.utilities.SingletonGetters")
local SkillModifierFunctions = require("src.app.utilities.SkillModifierFunctions")

Capturer.EXPORTED_METHODS = {
    "isCapturingModelTile",
    "setCapturingModelTile",
    "canCaptureModelTile",
    "getCaptureAmount",
}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function round(num)
    return math.floor(num + 0.5)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function Capturer:ctor(param)
    self:loadInstantialData(param.instantialData)

    return self
end

function Capturer:loadInstantialData(data)
    self.m_IsCapturing = data.isCapturing

    return self
end

--------------------------------------------------------------------------------
-- The public callback function on start running.
--------------------------------------------------------------------------------
function Capturer:onStartRunning(sceneWarFileName)
    self.m_SceneWarFileName = sceneWarFileName

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function Capturer:toSerializableTable()
    if (not self:isCapturingModelTile()) then
        return nil
    else
        return {
            isCapturing = true,
        }
    end
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function Capturer:isCapturingModelTile()
    return self.m_IsCapturing
end

function Capturer:setCapturingModelTile(capturing)
    self.m_IsCapturing = capturing

    return self.m_Owner
end

function Capturer:canCaptureModelTile(modelTile)
    return (self.m_Owner:getPlayerIndex() ~= modelTile:getPlayerIndex() and (modelTile.getCurrentCapturePoint))
end

function Capturer:getCaptureAmount()
    local capturer    = self.m_Owner
    local modelPlayer = SingletonGetters.getModelPlayerManager(self.m_SceneWarFileName):getModelPlayer(capturer:getPlayerIndex())
    local modifier    = SkillModifierFunctions.getCaptureAmountModifier(modelPlayer:getModelSkillConfiguration())
    return round(capturer:getNormalizedCurrentHP() * (100 + modifier) / 100)
end

return Capturer
