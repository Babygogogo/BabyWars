
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

local function getTiledLayer(tiledData)
	-- TODO: search the tiledData for the real TiledLayer
	return tiledData.layers[1]
end

local function createModel(param)
	local mapData = requireMapDataFrom(param)
	if (mapData == nil) then
		return nil, "TileMap--createModel() failed to require MapData from param."
	end

	if (mapData.Template ~= nil) then
		local templateTiledData = requireMapDataFrom(mapData.Template)
		local checkTemplateResult, checkTemplateMsg = TypeChecker.isTiledData(templateTiledData)
		if (checkTemplateResult == false) then
			return nil, "TileMap--createModel() failed to require template TiledData from param."
		end
		
		local templateMap, createMapMsg = MapFunctions.createMapWithTiledLayer(getTiledLayer(templateTiledData), Tile)
		if (templateMap == nil) then
			return nil, "TileMap--createModel() failed to create a template map from template TiledData:\n" .. createMapMsg
		end
		
		local map, loadTilesMsg = MapFunctions.loadGridsIntoMap(Tile, mapData.Tiles, templateMap, templateMap.size)
		if (map == nil) then
			return nil, "TileMap--createModel() failed to load tiles to overwrite the template map:\n" .. loadTilesMsg
		end
		
		return {map = map, mapSize = map.size}
	else
		local checkTiledDataResult, checkTiledDataMsg = TypeChecker.isTiledData(mapData)
		if (checkTiledDataResult == false) then
			return nil, "TileMap--createModel() the MapData has no template and is not TiledData:\n" .. checkTiledDataMsg
		end
	
		local map, createMapMsg = MapFunctions.createMapWithTiledLayer(getTiledLayer(mapData), Tile)
		if (map == nil) then
			return nil, "TileMap--createModel() failed to create a map from the MapData (as TiledData):\n" .. createMapMsg
		end
		
		return {map = map, mapSize = map.size}
	end
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
