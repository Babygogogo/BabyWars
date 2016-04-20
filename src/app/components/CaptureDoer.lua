
local CaptureDoer = class("CaptureDoer")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")

local EXPORTED_METHODS = {
    "isCapturing",
    "canCapture",
    "getCaptureAmount",
}

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
    assert(type(data.isCapturing) == "boolean", "CaptureDoer:loadInstantialData() the param data.isCapturing is invalid.")
    self.m_IsCapturing = data.isCapturing

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function CaptureDoer:onBind(target)
    assert(self.m_Target == nil, "CaptureDoer:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Target = target

    return self
end

function CaptureDoer:onUnbind()
    assert(self.m_Target ~= nil, "CaptureDoer:onUnbind() the component has not bound a target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function CaptureDoer:isCapturing()
    return self.m_IsCapturing
end

function CaptureDoer:canCapture(modelTile)
    return (self.m_Target:getPlayerIndex() ~= modelTile:getPlayerIndex() and (modelTile.getCurrentCapturePoint))
end

function CaptureDoer:getCaptureAmount()
    return self.m_Target:getNormalizedCurrentHP()
end

return CaptureDoer
