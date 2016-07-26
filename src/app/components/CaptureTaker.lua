
--[[--------------------------------------------------------------------------------
-- CaptureTaker是ModelTile可用的组件。只有绑定了本组件，才能被可实施占领的对象（即绑定了CaptureDoer的ModelUnit）实施占领。
-- 主要职责：
--   维护有关占领的各种数值（目前只要维护当前占领点数），并提供必要接口给外界访问
-- 使用场景举例：
--   宿主初始化时，根据自身属性来绑定和初始化本组件（比如city需要绑定，plain不需要。具体需要与否，由GameConstant决定）
--   占领点数降为0后，若满足占领即失败的条件（如HQ），则派发相应事件（未完成）。
--]]--------------------------------------------------------------------------------

local CaptureTaker = require("src.global.functions.class")("CaptureTaker")

local TypeChecker        = require("src.app.utilities.TypeChecker")
local ComponentManager   = require("src.global.components.ComponentManager")
local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")

local EXPORTED_METHODS = {
    "getCurrentCapturePoint",
    "getMaxCapturePoint",
    "isDefeatOnCapture",
}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function isCapturerMovedAway(selfGridIndex, beginningGridIndex, endingGridIndex)
    return ((GridIndexFunctions.isEqual(selfGridIndex, beginningGridIndex)) and
            (not GridIndexFunctions.isEqual(beginningGridIndex, endingGridIndex)))
end

local function isCapturerDestroyed(selfGridIndex, capturer)
    return ((GridIndexFunctions.isEqual(selfGridIndex, capturer:getGridIndex())) and
            (capturer:getCurrentHP() <= 0))
end

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
-- The function for serialization.
--------------------------------------------------------------------------------
function CaptureTaker:toSerializableTable()
    local currentCapturePoint = self:getCurrentCapturePoint()
    if (currentCapturePoint == self:getMaxCapturePoint()) then
        return nil
    else
        return {
            currentCapturePoint = currentCapturePoint,
        }
    end
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function CaptureTaker:onBind(target)
    assert(self.m_Owner == nil, "CaptureTaker:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Owner = target

    return self
end

function CaptureTaker:onUnbind()
    assert(self.m_Owner ~= nil, "CaptureTaker:onUnbind() the component has not bound a target.")

    ComponentManager.unsetMethods(self.m_Owner, EXPORTED_METHODS)
    self.m_Owner = nil

    return self
end

--------------------------------------------------------------------------------
-- The functions for doing the actions.
--------------------------------------------------------------------------------
function CaptureTaker:doActionDestroyModelUnit(action)
    self.m_CurrentCapturePoint = self:getMaxCapturePoint()

    return self.m_Owner
end

function CaptureTaker:doActionSurrender(action)
    self.m_CurrentCapturePoint = self:getMaxCapturePoint()

    return self
end

function CaptureTaker:doActionMoveModelUnit(action)
    if ((not action.launchUnitID)                                                   and
        (#action.path > 1)                                                          and
        (GridIndexFunctions.isEqual(action.path[1], self.m_Owner:getGridIndex()))) then
        self.m_CurrentCapturePoint = self:getMaxCapturePoint()
    end

    return self
end

function CaptureTaker:doActionCapture(action, capturer, target)
    self.m_CurrentCapturePoint = math.max(self.m_CurrentCapturePoint - capturer:getCaptureAmount(), 0)
    if (self.m_CurrentCapturePoint <= 0) then
        self.m_CurrentCapturePoint = self:getMaxCapturePoint()
        self.m_Owner:updateWithPlayerIndex(capturer:getPlayerIndex())
    end

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function CaptureTaker:getCurrentCapturePoint()
    return self.m_CurrentCapturePoint
end

function CaptureTaker:getMaxCapturePoint()
    return self.m_Template.maxCapturePoint
end

function CaptureTaker:isDefeatOnCapture()
    return self.m_Template.defeatOnCapture
end

return CaptureTaker
