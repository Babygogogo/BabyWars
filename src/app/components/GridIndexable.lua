
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
    self.m_GridIndex = {x = 1, y = 1}
    if (param) then
        self:load(param)
    end

    return self
end

function GridIndexable:load(param)
    self:setGridIndex(param)

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

-- This function also sets the position of the view.
function GridIndexable:setGridIndex(gridIndex)
    assert(TypeChecker.isGridIndex(gridIndex))

    self.m_GridIndex.x, self.m_GridIndex.y = gridIndex.x, gridIndex.y
    self:setViewPositionWithGridIndex(self.m_GridIndex)

    return self
end

-- The param gridIndex may be nil. If so, the function set the position of view with self.m_GridIndex .
function GridIndexable:setViewPositionWithGridIndex(gridIndex)
    local view = self.m_Target.m_View
    if (view) then
        view:move(GridIndexFunctions.toPosition(gridIndex or self.m_GridIndex))
    end

    return self
end

return GridIndexable
