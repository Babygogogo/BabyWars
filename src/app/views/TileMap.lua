
local TileMap = class("TileMap", function()
	return display.newNode()
end)
local TypeChecker = require"app.utilities.TypeChecker"

local function checkMapSize(rowCount, colCount)
	if (not TypeChecker.isInt(rowCount)) then
		return false, "TileMap--checkMapSize() rowCount is not an integer."
	elseif (not TypeChecker.isInt(colCount)) then
		return false, "TileMap--checkMapSize() colCount is not an integer."
	elseif (rowCount < 1) then
		return false, "TileMap--checkMapSize() rowCount < 1."
	elseif (colCount < 1) then
		return false, "TileMap--checkMapSize() colCount < 1."
	else
		return true
	end
end

local function checkTileGridIndex(tileGridIndex, mapRowCount, mapColCount)
	if (not TypeChecker.isGridIndex(tileGridIndex)) then
		return false, "TileMap--checkTileGridIndex() tileGridIndex is not a GridIndex.")
	elseif (tileGridIndex.rowIndex > mapRowCount) then
		return false, "TileMap--checkTileGridIndex() tileGridIndex.rowIndex > mapRowCount.")
	elseif (tileGridIndex.colIndex > mapColCount) then
		return false, "TileMap--checkTileGridIndex() tileGridIndex.colIndex > mapColCount.")
	elseif (tileGridIndex.rowIndex < 1) then
		return false, "TileMap--checkTileGridIndex() tileGridIndex.rowIndex < 1.")
	elseif (tileGridIndex.colIndex < 1) then
		return false, "TileMap--checkTileGridIndex() tileGridIndex.colIndex < 1.")
	else
		return true
	end
end

function TileMap:ctor(params)
	self:load(params)
end

function TileMap:clearAndResizeMap_(rowCount, colCount)
	self.m_RowCount_ = rowCount
	self.m_ColCount_ = colCount
	self.m_Map_ = {}
	for i = 1, rowCount do
		self.m_Map_ = {}
	end
end

function TileMap:loadTiles_(tiles)
	local Tile = require"app.views.Tile"
	for _, tileData in ipairs(tiles) do
		local tile = Tile.new(tileData)
		local tileGridIndex = tile:getGridIndex()
		
		assert(checkTileGridIndex(tileGridIndex, self.m_RowCount_, self.m_ColCount_))
		self.m_Map_[tileGridIndex.colIndex][tileGridIndex.rowIndex] = tile
		self:addChild(tile)
	end 
end

function TileMap:load(params)
	if (params == nil) then return end
	
	assert(checkMapSize(params.rowCount, params.colCount))
	self:clearAndResizeMap_(params.rowCount, params.colCount)

	self:loadTiles_(params.tiles)
	
	return self
end

return TileMap
