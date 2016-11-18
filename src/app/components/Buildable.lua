
local Buildable = require("src.global.functions.class")("Buildable")

local ComponentManager      = require("src.global.components.ComponentManager")
local GridIndexFunctions    = require("src.app.utilities.GridIndexFunctions")

Buildable.EXPORTED_METHODS = {
    "getCurrentBuildPoint",
    "getMaxBuildPoint",

    "setCurrentBuildPoint",
}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function isBuilderDestroyed(selfGridIndex, builder)
    return ((GridIndexFunctions.isEqual(selfGridIndex, builder:getGridIndex())) and
        (builder:getCurrentHP() <= 0))
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function Buildable:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function Buildable:loadTemplate(template)
    assert(template.maxBuildPoint, "Buildable:loadTemplate() the param template.maxBuildPoint is invalid.")
    self.m_Template = template

    return self
end

function Buildable:loadInstantialData(data)
    assert(data.currentBuildPoint, "Buildable:loadInstantialData() the param data.currentBuildPoint is invalid.")
    self:setCurrentBuildPoint(data.currentBuildPoint)

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function Buildable:toSerializableTable()
    local currentBuildPoint = self:getCurrentBuildPoint()
    if (currentBuildPoint == self:getMaxBuildPoint()) then
        return nil
    else
        return {
            currentBuildPoint = currentBuildPoint,
        }
    end
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function Buildable:updateAsFogEnabled()
    self:setCurrentBuildPoint(self:getMaxBuildPoint())

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function Buildable:getCurrentBuildPoint()
    return self.m_CurrentBuildPoint
end

function Buildable:getMaxBuildPoint()
    return self.m_Template.maxBuildPoint
end

function Buildable:setCurrentBuildPoint(point)
    assert((point >= 0) and (point <= self:getMaxBuildPoint()) and (math.floor(point) == point))
    self.m_CurrentBuildPoint = point

    return self.m_Owner
end

return Buildable
