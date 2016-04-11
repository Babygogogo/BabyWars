
local CaptureTaker = class("CaptureTaker")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")

local EXPORTED_METHODS = {
    "getCurrentCapturePoint",
    "setCurrentCapturePoint",
    "getMaxCapturePoint",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function CaptureTaker:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function CaptureTaker:loadTemplate(template)
    assert(template.maxCapturePoint, "CaptureTaker:loadTemplate() the param template.maxCapturePoint is invalid.")
    self.m_Template = template

    return self
end

function CaptureTaker:loadInstantialData(data)
    assert(data.currentCapturePoint, "CaptureTaker:loadInstantialData() the param data.currentCapturePoint is invalid.")
    self.m_CurrentCapturePoint = data.currentCapturePoint

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function CaptureTaker:onBind(target)
    assert(self.m_Target == nil, "CaptureTaker:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Target = target

    return self
end

function CaptureTaker:onUnbind()
    assert(self.m_Target ~= nil, "CaptureTaker:onUnbind() the component has not bound a target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function CaptureTaker:getCurrentCapturePoint()
    return self.m_CurrentCapturePoint
end

function CaptureTaker:setCurrentCapturePoint(point)
    self.m_CurrentCapturePoint = point

    return self
end

function CaptureTaker:getMaxCapturePoint()
    return self.m_Template.maxCapturePoint
end

return CaptureTaker
