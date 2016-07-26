
--[[--------------------------------------------------------------------------------
-- CaptureDoer是ModelUnit可用的组件。只有绑定了这个组件，才能对可占领的对象（即绑定了CaptureTaker的ModelTile）实施占领。
-- 主要职责：
--   维护有关占领的各种数值（目前只要维护“是否正在占领”。占领点数由CaptureTaker维护），并提供必要接口给外界访问
-- 使用场景举例：
--   宿主初始化时，根据自身属性来绑定和初始化本组件（比如infantry需要绑定，lander不需要。具体需要与否，由GameConstant决定）
--   玩家操作单位时，需要通过本组件获知能否对特定目标进行占领
-- 其他：
--   占领能力受hp、co技能影响
--]]--------------------------------------------------------------------------------

local CaptureDoer = require("src.global.functions.class")("CaptureDoer")

local TypeChecker        = require("src.app.utilities.TypeChecker")
local ComponentManager   = require("src.global.components.ComponentManager")
local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")

CaptureDoer.EXPORTED_METHODS = {
    "isCapturing",
    "canCapture",
    "getCaptureAmount",
}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function updateIsCapturingWithPath(self, path)
    if (#path ~= 1) then
        self.m_IsCapturing = false
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function CaptureDoer:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function CaptureDoer:loadTemplate(template)
    return self
end

function CaptureDoer:loadInstantialData(data)
    self.m_IsCapturing = (data.isCapturing == true) and (true) or (false)

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function CaptureDoer:toSerializableTable()
    if (not self:isCapturing()) then
        return nil
    else
        return {
            isCapturing = true,
        }
    end
end

--------------------------------------------------------------------------------
-- The functions for doing the actions.
--------------------------------------------------------------------------------
function CaptureDoer:doActionMoveModelUnit(action)
    if (#action.path > 1) then
        self.m_IsCapturing = false
    end

    return self.m_Owner
end

function CaptureDoer:doActionCapture(action, capturer, target)
    self.m_IsCapturing = (self:getCaptureAmount() < target:getCurrentCapturePoint())

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function CaptureDoer:isCapturing()
    return self.m_IsCapturing
end

function CaptureDoer:canCapture(modelTile)
    return (self.m_Owner:getPlayerIndex() ~= modelTile:getPlayerIndex() and (modelTile.getCurrentCapturePoint))
end

function CaptureDoer:getCaptureAmount()
    return self.m_Owner:getNormalizedCurrentHP()
end

return CaptureDoer
