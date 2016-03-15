
local GridIndexable = class("GridIndexable")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

local EXPORTED_METHODS = {
	"getGridIndex",
	"setGridIndex",
    "setViewPositionWithGridIndex"
}

local function init_(component)
    component.m_Target = nil
    component.m_GridIndex = {}
end

function GridIndexable:bind(target)
	init_(self)
	ComponentManager.setMethods(target, self, EXPORTED_METHODS)

	self.m_Target = target
end

function GridIndexable:unbind(target)
    assert(self.m_Target == target , "GridIndexable:unbind() the component is not bind to the parameter target")
    assert(self.m_Target, "GridIndexable:unbind() the component is not bind to any target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    init_(self)
end

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
