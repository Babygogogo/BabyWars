
local ModelTileMap = class("ModelTileMap")

local Requirer		= require"app.utilities.Requirer"
local TypeChecker	= Requirer.utility("TypeChecker")
local MapFunctions	= Requirer.utility("MapFunctions")
local Tile			= Requirer.view("Tile")

local function requireMapData(param)
	local t = type(param)
	if (t == "string") then
		return Requirer.templateTileMap(param)
	elseif (t == "table") then
		return param
	else
		return nil
	end
end

local function getTiledTileLayer(tiledData)
	return tiledData.layers[1]
end

local function createModelWithTemplateAndOverwriting(mapData)
	if (type(mapData.Template) ~= "string") then
		return nil, "ModelTileMap--createModelWithTemplateAndOverwriting() the template field is not the file name of a TiledData."
	end

	local templateTiledData = requireMapData(mapData.Template)
	local checkTemplateResult, checkTemplateMsg = TypeChecker.isTiledData(templateTiledData)
	if (checkTemplateResult == false) then
		return nil, "ModelTileMap--createModelWithTemplateAndOverwriting() failed to require template TiledData from param mapData."
	end
	
	local templateMap, createMapMsg = MapFunctions.createMapWithTiledLayer(getTiledTileLayer(templateTiledData), Tile)
	if (templateMap == nil) then
		return nil, "ModelTileMap--createModelWithTemplateAndOverwriting() failed to create a template map from template TiledData:\n" .. createMapMsg
	end
	
	local map, loadTilesMsg = MapFunctions.loadGridsIntoMap(Tile, mapData.Tiles, templateMap, templateMap.size)
	if (map == nil) then
		return nil, "ModelTileMap--createModelWithTemplateAndOverwriting() failed to load tiles to overwrite the template map:\n" .. loadTilesMsg
	end
	
	return map
end

local function createModelWithoutTemplate(mapData)
	local checkTiledDataResult, checkTiledDataMsg = TypeChecker.isTiledData(mapData)
	if (checkTiledDataResult == false) then
		return nil, "ModelTileMap--createModelWithoutTemplate() the MapData has no template and is not TiledData:\n" .. checkTiledDataMsg
	end

	local map, createMapMsg = MapFunctions.createMapWithTiledLayer(getTiledTileLayer(mapData), Tile)
	if (map == nil) then
		return nil, "ModelTileMap--createModelWithoutTemplate() failed to create a map from the MapData (as TiledData):\n" .. createMapMsg
	end
	
	return map
end

local function createModel(param)
	local mapData = requireMapData(param)
	if (mapData == nil) then
		return nil, "ModelTileMap--createModel() failed to require MapData from param."
	end

	local map, createMapMsg
	if (mapData.Template ~= nil) then
		map, createMapMsg = createModelWithTemplateAndOverwriting(mapData)
	else
		map, createMapMsg = createModelWithoutTemplate(mapData)
	end
	
	if (map == nil) then
		return nil, "ModelTileMap--createModel() failed:\n" .. createMapMsg
	elseif (MapFunctions.hasNilGrid(map)) then
		return nil, "ModelTileMap--createModel() some tiles on the map are missing."
	end
	
	return map
end

local function createTileActorsWithTemplateAndOverwriting(mapData)
	local templateTiledData = requireMapData(mapData.Template)
	assert(TypeChecker.isTiledData(templateTiledData))
	
	local templateMap = MapFunctions.createGridActorsMapWithTiledLayer(getTiledTileLayer(templateTiledData), nil, Tile)
	assert(templateMap, "ModelTileMap--createTileActorsWithTemplateAndOverwriting() failed to create the template tile actors map.")
	
	
end

local function createChildrenActors(param)
	local mapData = requireMapData(param)
	assert(TypeChecker.isMapData(mapData))
	
	local tileActorsMap
	if (mapData.Template ~= nil) then
		tileActorsMap = 
	end
	
end

function ModelTileMap:ctor(param)
	if (param) then self:load(param) end
	
	return self
end

function ModelTileMap:load(param)
	local childrenActors = createChildrenActors(param)
	assert(childrenActors, "ModelTileMap:load() failed to create children actors with param.")
	
	self.m_TileActorsMap_ = childrenActors.TileActorsMap
	
	if (self.m_View_) then self:initView() end

	return self
end

function ModelTileMap.createInstance(param)
	local model = ModelTileMap.new():load(param)
	assert(model, "ModelTileMap.createInstance() failed to create the model with param.")
	
	return model
end

function ModelTileMap:initView()
	local view = self.m_View_
	assert(TypeChecker.isView(view))
	
	view:removeAllChildren()

	local mapSize = self.m_TileActorsMap_.size
	for x = 1, mapSize.width do
		for y = 1, mapSize.height do
			view:addChild(self.m_TileActorsMap_[x][y]:getView())
		end
	end	
end

function ModelTileMap:getMapSize()
	return self.m_TileActorsMap_.size
end

return ModelTileMap
