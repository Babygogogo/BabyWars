
local GridIndexable = class("GridIndexable")

local Requirer			= require"app.utilities.Requirer"
local TypeChecker		= Requirer.utility("TypeChecker")
local GridSize			= Requirer.gameConstant().GridSize
local ComponentManager	= Requirer.component("ComponentManager")

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
	self.m_Target_ = nil
	self.m_GridIndex_ = {}
end

function GridIndexable:bind(target)
	self:init_()
	ComponentManager.setMethods(target, self, EXPORTED_METHODS)

	self.m_Target_ = target
end

function GridIndexable:unbind(target)
	assert(self.m_Target_ == target , "GridIndexable:unbind() the component is not bind to the parameter target")
	assert(self.m_Target_, "GridIndexable:unbind() the component is not bind to any target.")

	ComponentManager.unsetMethods(m_Target, EXPORTED_METHODS)
	self:init_()
end

function GridIndexable:getGridIndex()
	return self.m_GridIndex_
end

-- This function also sets the position of the view.
function GridIndexable:setGridIndex(gridIndex)
    assert(TypeChecker.isGridIndex(gridIndex))

    self.m_GridIndex_.x, self.m_GridIndex_.y = gridIndex.x, gridIndex.y
    self:setViewPositionWithGridIndex(self.m_GridIndex_)

    return self
end

-- The param gridIndex may be nil. If so, the function set the position of view with self.m_GridIdex_ .
function GridIndexable:setViewPositionWithGridIndex(gridIndex)
    local view = self.m_Target_.m_View_
    if (view) then
        view:move(gridIndexToPosition(gridIndex or self.m_GridIndex_))
    end
    
    return self
end

return GridIndexable
