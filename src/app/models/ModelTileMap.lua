
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

local function createTileActorsMapWithTemplateAndOverwriting(mapData)
	local templateTiledData = requireMapData(mapData.Template)
	assert(TypeChecker.isTiledData(templateTiledData))
	
	local templateMap = MapFunctions.createGridActorsMapWithTiledLayer(getTiledTileLayer(templateTiledData), nil, Tile)
	assert(templateMap, "ModelTileMap--createTileActorsMapWithTemplateAndOverwriting() failed to create the template tile actors map.")
	
	local overwroteMap = MapFunctions.updateGridActorsMapWithGridsData(templateMap, mapData.Tiles, nil, Tile)
	assert(overwroteMap, "ModelTileMap--createTileActorsMapWithTemplateAndOverwriting() failed to overwrite the template tile actors map.")
	
	return overwroteMap
end

local function createTileActorsMapWithoutTemplate(mapData)
	assert(TypeChecker.isTiledData(mapData))
	
	local map = MapFunctions.createGridActorsMapWithTiledLayer(getTiledTileLayer(mapData), nil, Tile)
	assert(map, "ModelTileMap--createTileActorsMapWithoutTemplate() failed to create the map.")
	
	return map
end

local function createChildrenActors(param)
	local mapData = requireMapData(param)
	assert(TypeChecker.isMapData(mapData))
	
	local tileActorsMap = (mapData.Template == nil
		and createTileActorsMapWithoutTemplate(mapData)
		or createTileActorsMapWithTemplateAndOverwriting(mapData))
	assert(tileActorsMap, "ModelTileMap--createChildrenActors() failed to create tile actors map.")
	assert(not MapFunctions.hasNilGrid(tileActorsMap), "ModelTileMap--createChildrenActors() some tiles are missing in the created map.")

	return {TileActorsMap = tileActorsMap}
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
