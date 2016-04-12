
local GridIndexable = class("GridIndexable")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

local EXPORTED_METHODS = {
    "getGridIndex",
    "setGridIndex",
    "setViewPositionWithGridIndex"
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function GridIndexable:ctor(param)
    self.m_GridIndex = {x = 0, y = 0}
    self:loadInstantialData(param.instantialData)

    return self
end

function GridIndexable:loadInstantialData(data)
    if (data.gridIndex) then
        self:setGridIndex(data.gridIndex)
    end

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function GridIndexable:onBind(target)
    assert(self.m_Target == nil, "GridIndexable:onBind() the GridIndexable has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Target = target

    return self
end

function GridIndexable:onUnbind()
    assert(self.m_Target, "GridIndexable:unbind() the component has not bound a target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function GridIndexable:getGridIndex()
    return self.m_GridIndex
end

function GridIndexable:setGridIndex(gridIndex, shouldMoveView)
    assert(TypeChecker.isGridIndex(gridIndex))
    self.m_GridIndex.x, self.m_GridIndex.y = gridIndex.x, gridIndex.y

    if (shouldMoveView ~= false) then
        self:setViewPositionWithGridIndex(self.m_GridIndex)
    end

    return self.m_Target
end

-- The param gridIndex may be nil. If so, the function set the position of view with self.m_GridIndex .
function GridIndexable:setViewPositionWithGridIndex(gridIndex)
    local view = self.m_Target and self.m_Target.m_View or nil
    if (view) then
        view:setPosition(GridIndexFunctions.toPosition(gridIndex or self.m_GridIndex))
    end

    return self.m_Target
end

return GridIndexable
