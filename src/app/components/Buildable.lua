
local Buildable = require("src.global.functions.class")("Buildable")

local ComponentManager      = require("src.global.components.ComponentManager")
local GridIndexFunctions    = require("src.app.utilities.GridIndexFunctions")

local EXPORTED_METHODS = {
    "getCurrentBuildPoint",
    "getMaxBuildPoint",
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
    self.m_CurrentBuildPoint = data.currentBuildPoint

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
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function Buildable:onBind(target)
    assert(self.m_Owner == nil, "Buildable:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Owner = target

    return self
end

function Buildable:onUnbind()
    assert(self.m_Owner ~= nil, "Buildable:onUnbind() the component has not bound a target.")

    ComponentManager.unsetMethods(self.m_Owner, EXPORTED_METHODS)
    self.m_Owner = nil

    return self
end

--------------------------------------------------------------------------------
-- The functions for doing the actions.
--------------------------------------------------------------------------------
function Buildable:doActionDestroyModelUnit(action)
    if (GridIndexFunctions.isEqual(self.m_Owner:getGridIndex(), action.gridIndex)) then
        self.m_CurrentBuildPoint = self:getMaxBuildPoint()
    end

    return self.m_Owner
end

function Buildable:doActionSurrender(action)
    self.m_CurrentBuildPoint = self:getMaxBuildPoint()

    return self
end

function Buildable:doActionMoveModelUnit(action)
    if ((not action.launchUnitID)                                                   and
        (#action.path > 1)                                                          and
        (GridIndexFunctions.isEqual(action.path[1], self.m_Owner:getGridIndex()))) then
        self.m_CurrentBuildPoint = self:getMaxBuildPoint()
    end

    return self
end

function Buildable:doActionBuildModelTile(action, builder, target)
    self.m_CurrentBuildPoint = math.max(self.m_CurrentBuildPoint - builder:getBuildAmount(), 0)
    if (self.m_CurrentBuildPoint <= 0) then
        local modelTile = self.m_Owner
        local _, baseID = modelTile:getObjectAndBaseId()
        modelTile:updateWithObjectAndBaseId(builder:getBuildTiledIdWithTileType(modelTile:getTileType()), baseID)
    end

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

return Buildable
