
local CaptureTaker = class("CaptureTaker")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")

local EXPORTED_METHODS = {
	"getCurrentCapturePoint",
	"setCurrentCapturePoint",
    "getMaxCapturePoint",
    "getCapturerID",
    "setCapturerID",
}

function CaptureTaker:ctor(param)
    self.m_CapturerID = 0

    if (param) then
        self:load(param)
    end

    return self
end

function CaptureTaker:bind(target)
	ComponentManager.setMethods(target, self, EXPORTED_METHODS)

	self.m_Target = target
end

function CaptureTaker:unbind(target)
    assert(self.m_Target == target , "CaptureTaker:unbind() the component is not bind to the parameter target")
    assert(self.m_Target, "CaptureTaker:unbind() the component is not bind to any target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil
end

function CaptureTaker:load(param)
    self.m_MaxCapturePoint     = param.maxCapturePoint or self.m_MaxCapturePoint
    self.m_CurrentCapturePoint = param.capturePoint    or self.m_MaxCapturePoint
    self.m_CapturerID          = param.capturerID      or self.m_CapturerID

    return self
end

--------------------------------------------------------------------------------
-- Exported methods.
--------------------------------------------------------------------------------
function CaptureTaker:getCurrentCapturePoint()
    return self.m_CurrentCapturePoint
end

function CaptureTaker:setCurrentCapturePoint(point)
    self.m_CurrentCapturePoint = point

    return self
end

function CaptureTaker:getMaxCapturePoint()
    return self.m_MaxCapturePoint
end

function CaptureTaker:getCapturerID()
    return self.m_CapturerID
end

function CaptureTaker:setCapturerID(id)
    self.m_CapturerID = id

    return self
end

return CaptureTaker
