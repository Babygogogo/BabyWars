
local TileMap = class("TileMap", function()
	return display.newNode()
end)
local Requirer		= require"app.utilities.Requirer"
local TypeChecker	= Requirer.utility("TypeChecker")
local MapFunctions	= Requirer.utility("MapFunctions")
local Tile			= Requirer.view("Tile")
local GridSize		= Requirer.gameConstant().GridSize

local function requireMapDataFrom(param)
	local t = type(param)
	if (t == "string") then
		return Requirer.templateTileMap(param)
	elseif (t == "table") then
		return param
	else
		return nil
	end
end

local function isTiledData(mapData)
	return mapData.tiledversion ~= nil
end

local function createModel(param)
	local mapData = requireMapDataFrom(param)
	if (mapData == nil) then
		return nil, "TileMap--createModel() failed to require MapData from param."
	end

	local map, mapSize
	if (mapData.Template ~= nil) then
		local createTemplateMapResult, createTemplateMapMsg = createModel(mapData.Template)
		if (createTemplateMapResult == nil) then
			return nil, string.format("TileMap--createModel() failed to create the template map [%s]:\n%s", mapData.Template, createTemplateMapMsg)
		end		
		
		map, mapSize = createTemplateMapResult.map, createTemplateMapResult.mapSize
	else
		local loadSizeMsg
		mapSize, loadSizeMsg = MapFunctions.loadMapSize(mapData)
		if (mapSize == nil) then
			return nil, "TileMap--createModel() failed to load MapSize from param:\n" .. loadSizeMsg
		end

		map = MapFunctions.createEmptyMap(mapSize)
	end	

	if (isTiledData(mapData)) then
		if (not TypeChecker.isSizeEqual(mapSize, MapFunctions.loadMapSize(mapData))) then
			return nil, "TileMap--createModel() the MapSize of the overwriting data and the one of the template data is not the same."
		end

		local loadTiledDataMsg
		map, loadTiledDataMsg = MapFunctions.loadTiledDataIntoMap(Tile, mapData.layers[1], map, mapSize)
		if (map == nil) then
			return nil, "TileMap--createModel() failed to load tiled data:\n" .. loadTiledDataMsg
		end
	end

	if (mapData.Tiles ~= nil) then
		local loadTilesIntoMapMsg
		map, loadTilesIntoMapMsg = MapFunctions.loadGridsIntoMap(Tile, mapData.Tiles, map, mapSize)
		if (map == nil) then
			return nil, "TileMap--createModel() failed to load tiles:\n" .. loadTilesIntoMapMsg
		end
	end
	
	if (MapFunctions.hasNilGrid(map, mapSize)) then
		return nil, "TileMap--createModel() some tiles on the map are missing."
	end
	
	return {mapSize = mapSize, map = map}
end

function TileMap:ctor(param)
	self:load(param)
	
	return self
end

function TileMap.createInstance(param)
	local map, createMapMsg = TileMap.new():load(param)
	if (map == nil) then
		return nil, "TileMap.createInstance() failed:\n" .. createMapMsg
	else
		return map
	end
end

function TileMap:load(param)
	local createModelResult, createModelMsg = createModel(param)
	if (createModelResult == nil) then
		return nil, "TileMap:load() failed to load from param:\n" .. createModelMsg
	end
	
	self.m_MapSize_ = createModelResult.mapSize
	self.m_Map_ = createModelResult.map

	self:removeAllChildren()
	for x = 1, self.m_MapSize_.width do
		for y = 1, self.m_MapSize_.height do
			local tile = self.m_Map_[x][y]
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
