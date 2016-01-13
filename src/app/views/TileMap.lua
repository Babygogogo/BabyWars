
local TileMap = class("TileMap", function()
	return display.newNode()
end)
local Requirer		= require"app.utilities.Requirer"
local TypeChecker	= Requirer.utility("TypeChecker")
local Tile			= Requirer.view("Tile")
local GridSize		= Requirer.gameConstant().GridSize

local function checkTileGridIndex(tileGridIndex, mapRowCount, mapColCount)
	if (not TypeChecker.isGridIndex(tileGridIndex)) then
		return false, "TileMap--checkTileGridIndex() tileGridIndex is not a GridIndex."
	elseif (tileGridIndex.rowIndex > mapRowCount) then
		return false, "TileMap--checkTileGridIndex() tileGridIndex.rowIndex > mapRowCount."
	elseif (tileGridIndex.colIndex > mapColCount) then
		return false, "TileMap--checkTileGridIndex() tileGridIndex.colIndex > mapColCount."
	elseif (tileGridIndex.rowIndex < 1) then
		return false, "TileMap--checkTileGridIndex() tileGridIndex.rowIndex < 1."
	elseif (tileGridIndex.colIndex < 1) then
		return false, "TileMap--checkTileGridIndex() tileGridIndex.colIndex < 1."
	else
		return true
	end
end

local function loadMapSize(mapData)
	local mapSize = {rowCount = mapData.rowCount, colCount = mapData.colCount}
	if (not TypeChecker.isMapSize(mapSize)) then
		return nil, string.format("TileMap--loadMapSize() the loaded mapSize [%s(%s), %s(%s)] is invalid.",
									mapSize.rowCount, type(mapSize.rowCount), mapSize.colCount, type(mapSize.colCount))
	else
		return mapSize
	end
end

local function createEmptyMap_(rowCount, colCount)
	local map = {}
	for i = 1, colCount do
		map[i] = {}
	end
	
	return map
end

local function createMap_(rowCount, colCount, mapData)
	local map = createEmptyMap_(rowCount, colCount)
	
	local loadedTilesCount = 0
	for _, tileData in ipairs(mapData.tiles) do
		local tile = Tile.new(tileData)

		local tileGridIndex = tile:getGridIndex()
		local checkGridIndexResult, checkGridIndexMsg = checkTileGridIndex(tileGridIndex, rowCount, colCount)
		if (not checkGridIndexResult) then
			return nil, checkGridIndexMsg
		end
	
		local rowIndex, colIndex = tileGridIndex.rowIndex, tileGridIndex.colIndex
		if (map[colIndex][rowIndex] ~= nil) then
			print(string.format("TileMap--createMap() the tile on [%d, %d] is already loaded; it will be overrided", colIndex, rowIndex))
			loadedTilesCount = loadedTilesCount - 1
		end

		loadedTilesCount = loadedTilesCount + 1
		map[colIndex][rowIndex] = tile
	end
	
	if (loadedTilesCount ~= colCount * rowCount) then
		return nil, "TileMap--createMap() some tiles on the map is missing."
	end
	
	return map
end

local function createMap(templateName)
	if (type(templateName) ~= "string") then
		return nil, "TileMap--createMap() the param templateName is not a string."
	end
	
	local mapData = Requirer.templateTileMap(templateName)
	if (type(mapData) ~= "table") then
		return nil, "TileMap--createMap() the mapData is not a tabel."
	end
	
	local loadSizeResult, loadSizeMsg = loadMapSize(mapData)
	if (loadSizeResult == nil) then
		return nil, loadSizeMsg
	end
	local rowCount, colCount = loadSizeResult.rowCount, loadSizeResult.colCount

	local createMapResult, createMapMsg = createMap_(rowCount, colCount, mapData)
	if (createMapResult == nil) then
		return nil, createMapMsg
	end
	
	return {rowCount = rowCount, colCount = colCount, map = createMapResult}
end

function TileMap:ctor(templateName)
	self:load(templateName)
	
	return self
end

function TileMap:load(templateName)
	local createMapResult, createMapMsg = createMap(templateName)
	if (createMapResult == nil) then
		return nil, string.format("TileMap:load() failed to load template [%s]:\n%s", templateName, createMapMsg)
	end
	
	self.m_RowCount_, self.m_ColCount_ = createMapResult.rowCount, createMapResult.colCount
	self.m_Map_ = createMapResult.map

	self:removeAllChildren()
	for _, tileCol in ipairs(self.m_Map_) do
		for __, tile in ipairs(tileCol) do
			self:addChild(tile)
		end
	end
	
	return self
end

function TileMap:getMapSize()
	return self.m_RowCount_, self.m_ColCount_
end

return TileMap
