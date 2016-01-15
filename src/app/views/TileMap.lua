
local TileMap = class("TileMap", function()
	return display.newNode()
end)
local Requirer		= require"app.utilities.Requirer"
local TypeChecker	= Requirer.utility("TypeChecker")
local MapFunctions	= Requirer.utility("MapFunctions")
local Tile			= Requirer.view("Tile")
local GridSize		= Requirer.gameConstant().GridSize

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
		mapSize, loadSizeMsg = MapFunctions.loadMapSize(mapData)
		if (mapSize == nil) then
			return nil, string.format("TileMap--createMap() failed to load MapSize from [%s]:\n%s", templateName, loadSizeMsg)
		end

		baseMap = MapFunctions.createEmptyMap(mapSize)
	end	

	local map, loadTilesIntoMapMsg = MapFunctions.loadGridsIntoMap(Tile, mapData.Tiles, baseMap, mapSize)
	if (map == nil) then
		return nil, "TileMap--createMap() failed to load tiles:\n" .. loadTilesIntoMapMsg
	end
	
	if (MapFunctions.hasNilGrid(map, mapSize)) then
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
