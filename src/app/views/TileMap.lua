
local TileMap = class("TileMap", function()
	return display.newNode()
end)
local Requirer		= require"app.utilities.Requirer"
local TypeChecker	= Requirer.utility("TypeChecker")
local Tile			= Requirer.view("Tile")
local GridSize		= Requirer.gameConstant().GridSize

local function checkTileGridIndex(tileGridIndex, mapSize)
	if (not TypeChecker.isGridIndex(tileGridIndex)) then
		return false, "TileMap--checkTileGridIndex() tileGridIndex is not a GridIndex."
	elseif (tileGridIndex.rowIndex > mapSize.rowCount) then
		return false, "TileMap--checkTileGridIndex() tileGridIndex.rowIndex > mapSize.rowCount."
	elseif (tileGridIndex.colIndex > mapSize.colCount) then
		return false, "TileMap--checkTileGridIndex() tileGridIndex.colIndex > mapSize.colCount."
	elseif (tileGridIndex.rowIndex < 1) then
		return false, "TileMap--checkTileGridIndex() tileGridIndex.rowIndex < 1."
	elseif (tileGridIndex.colIndex < 1) then
		return false, "TileMap--checkTileGridIndex() tileGridIndex.colIndex < 1."
	else
		return true
	end
end

local function loadMapSize(mapData)
	local mapSize = mapData.MapSize
	if (not TypeChecker.isMapSize(mapSize)) then
		return nil, string.format("TileMap--loadMapSize() the loaded mapSize [%s(%s), %s(%s)] is invalid.",
									mapSize.rowCount, type(mapSize.rowCount), mapSize.colCount, type(mapSize.colCount))
	else
		return mapSize
	end
end

local function createEmptyMap(mapSize)
	local map = {}
	for i = 1, mapSize.colCount do
		map[i] = {}
	end
	
	return map
end

local function createTileAndCheckIndex(tileData, mapSize)
	local tile, createTileMsg = Tile.new():loadData(tileData)
	if (tile == nil) then
		return nil, "TileMap--createTileAndCheckIndex() failed to create tile with param tileData.\n" .. createTileMsg
	end
	
	local checkGridIndexResult, checkGridIndexMsg = checkTileGridIndex(tile:getGridIndex(), mapSize)
	if (not checkGridIndexResult) then
		return nil, "TileMap--createTileAndCheckIndex() the GridIndex of the created tile is invalid.\n" .. checkGridIndexMsg
	end
	
	return tile
end

local function hasMissingTile(map, mapSize)
	for colIndex = 1, mapSize.colCount do
		for rowIndex = 1, mapSize.rowCount do
			if (map[colIndex][rowIndex] == nil) then
				return true
			end
		end
	end
	
	return false
end

local function loadTilesIntoMap(map, mapSize, tilesData)
	for _, tileData in ipairs(tilesData) do
		local tile, createTileMsg = createTileAndCheckIndex(tileData, mapSize)
		if (tile == nil) then
			return nil, "TileMap--loadTilesIntoMap() failed to create a valid tile.\n" .. createTileMsg
		end
		
		local rowIndex, colIndex = tile:getGridIndex().rowIndex, tile:getGridIndex().colIndex
		if (map[colIndex][rowIndex] ~= nil) then
			print(string.format("TileMap--loadTilesIntoMap() the tile on [%d, %d] is already loaded; it will be overrided", colIndex, rowIndex))
		end

		map[colIndex][rowIndex] = tile
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

	local baseMap, mapSize, loadSizeMsg
	if (mapData.Template ~= nil) then
		local createTemplateMapResult, createTemplateMapMsg = createMap(mapData.Template)
		if (createTemplateMapResult == nil) then
			return nil, string.format("TileMap--createMap() failed to create the template map [%s]:\n%s", mapData.Template, createTemplateMapMsg)
		end		
		
		baseMap, mapSize = createTemplateMapResult.map, createTemplateMapResult.mapSize
	else
		mapSize, loadSizeMsg = loadMapSize(mapData)
		if (mapSize == nil) then
			return nil, string.format("TileMap--createMap() failed to load MapSize from [%s]\n%s", templateName, loadSizeMsg)
		end

		baseMap = createEmptyMap(mapSize)
	end	

	local map, loadTilesIntoMapMsg = loadTilesIntoMap(baseMap, mapSize, mapData.Tiles)
	if (map == nil) then
		return nil, "TileMap--createMap() failed to load tiles.\n" .. loadTilesIntoMapMsg
	end
	
	if (hasMissingTile(map, mapSize)) then
		return nil, "TileMap--createMap() some tiles on the map are missing."
	end
	
	return {mapSize = mapSize, map = map}
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
	
	self.m_MapSize_ = createMapResult.mapSize
	self.m_Map_ = createMapResult.map

	self:removeAllChildren()
	for colIndex = 1, self.m_MapSize_.colCount do
		for rowIndex = 1, self.m_MapSize_.rowCount do
			local tile = self.m_Map_[colIndex][rowIndex]
			if (tile) then
				self:addChild(tile)
			end
		end
	end
	
	return self
end

function TileMap:getMapSize()
	return self.m_MapSize_
end

return TileMap
