
--[[--------------------------------------------------------------------------------
-- Capturable是ModelTile可用的组件。只有绑定了本组件，才能被可实施占领的对象（即绑定了CaptureDoer的ModelUnit）实施占领。
-- 主要职责：
--   维护有关占领的各种数值（目前只要维护当前占领点数），并提供必要接口给外界访问
-- 使用场景举例：
--   宿主初始化时，根据自身属性来绑定和初始化本组件（比如city需要绑定，plain不需要。具体需要与否，由GameConstant决定）
--   占领点数降为0后，若满足占领即失败的条件（如HQ），则派发相应事件（未完成）。
--]]--------------------------------------------------------------------------------

local Capturable = require("src.global.functions.class")("Capturable")

local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")

Capturable.EXPORTED_METHODS = {
    "getCurrentCapturePoint",
    "getMaxCapturePoint",
    "isDefeatOnCapture",

    "setCurrentCapturePoint",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function Capturable:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function Capturable:loadTemplate(template)
    assert(template.maxCapturePoint, "Capturable:loadTemplate() the param template.maxCapturePoint is invalid.")
    self.m_Template = template

    return self
end

function Capturable:loadInstantialData(data)
    assert(data.currentCapturePoint, "Capturable:loadInstantialData() the param data.currentCapturePoint is invalid.")
    self:setCurrentCapturePoint(data.currentCapturePoint)

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function Capturable:toSerializableTable()
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
-- The functions for doing the actions.
--------------------------------------------------------------------------------
function Capturable:doActionSurrender(action)
    self:setCurrentCapturePoint(self:getMaxCapturePoint())

    return self
end

function Capturable:doActionMoveModelUnit(action)
    if ((not action.launchUnitID)                                                   and
        (#action.path > 1)                                                          and
        (GridIndexFunctions.isEqual(action.path[1], self.m_Owner:getGridIndex()))) then
        self:setCurrentCapturePoint(self:getMaxCapturePoint())
    end

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function Capturable:getCurrentCapturePoint()
    return self.m_CurrentCapturePoint
end

function Capturable:getMaxCapturePoint()
    return self.m_Template.maxCapturePoint
end

function Capturable:isDefeatOnCapture()
    return self.m_Template.defeatOnCapture
end

function Capturable:setCurrentCapturePoint(point)
    assert((point >= 0) and (point <= self:getMaxCapturePoint()) and (point == math.floor(point)),
        "Capturable:setCurrentCapturePoint() the param point is invalid.")

    self.m_CurrentCapturePoint = point

    return self.m_Owner
end

return Capturable
