
local GridIndexable = class("GridIndexable")

local TypeChecker		= require("app.utilities.TypeChecker")
local GridSize			= require("res.data.GameConstant").GridSize
local ComponentManager	= require("global.components.ComponentManager")

local EXPORTED_METHODS = {
	"getGridIndex",
	"setGridIndex",
    "setViewPositionWithGridIndex"
}

local function gridIndexToPosition(gridIndex)
	return	(gridIndex.x - 1) * GridSize.width,
			(gridIndex.y - 1) * GridSize.height
end

function GridIndexable:init_()
	self.m_Target = nil
	self.m_GridIndex = {}
end

function GridIndexable:bind(target)
	self:init_()
	ComponentManager.setMethods(target, self, EXPORTED_METHODS)

	self.m_Target = target
end

function GridIndexable:unbind(target)
	assert(self.m_Target == target , "GridIndexable:unbind() the component is not bind to the parameter target")
	assert(self.m_Target, "GridIndexable:unbind() the component is not bind to any target.")

	ComponentManager.unsetMethods(m_Target, EXPORTED_METHODS)
	self:init_()
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

-- The param gridIndex may be nil. If so, the function set the position of view with self.m_GridIdex_ .
function GridIndexable:setViewPositionWithGridIndex(gridIndex)
    local view = self.m_Target.m_View
    if (view) then
        view:move(gridIndexToPosition(gridIndex or self.m_GridIndex))
    end
    
    return self
end

return GridIndexable
