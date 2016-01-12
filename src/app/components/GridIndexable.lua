
local GridIndexable = class("GridIndexable")
local GridSize = require"res.GameConstant".GridSize
local ComponentManager = require"app.components.ComponentManager"

local EXPORTED_METHODS = {
	"getGridIndex",
	"setGridIndexAndPosition"
}

local function gridIndexToPosition(gridIndex)
	return	(gridIndex.rowIndex - 0.5) * GridSize.height,
			(gridIndex.colIndex - 0.5) * GridSize.width
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
	assert(self.m_Target_, "GridIndexable:unbind() the component is not bind to any m_Target.")

	ComponentManager.unsetMethods(m_Target, EXPORTED_METHODS)
	self:init_()
end

function GridIndexable:getGridIndex()
	return self.m_GridIndex_
end

function GridIndexable:setGridIndexAndPosition(gridIndex)
	assert(require"app.utilities.TypeChecker".isGridIndex(gridIndex), "GridIndexable:setGridIndexAndPosition() the param gridIndex is invalid.")

	self.m_GridIndex_.rowIndex = gridIndex.rowIndex
	self.m_GridIndex_.colIndex = gridIndex.colIndex
	self.m_Target_:move(gridIndexToPosition(self.m_GridIndex_))
end

return GridIndexable
