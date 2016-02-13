
local ModelTileMap = class("ModelTileMap")

local Requirer	   = require"app.utilities.Requirer"
local TypeChecker  = Requirer.utility("TypeChecker")
local MapFunctions = Requirer.utility("MapFunctions")
local ViewTile     = Requirer.view("ViewTile")
local ModelTile    = Requirer.model("ModelTile")

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
	
	local templateMap = MapFunctions.createGridActorsMapWithTiledLayer(getTiledTileLayer(templateTiledData), ModelTile, ViewTile)
	assert(templateMap, "ModelTileMap--createTileActorsMapWithTemplateAndOverwriting() failed to create the template tile actors map.")
	
	local overwroteMap = MapFunctions.updateGridActorsMapWithGridsData(templateMap, mapData.Grids, ModelTile, ViewTile)
	assert(overwroteMap, "ModelTileMap--createTileActorsMapWithTemplateAndOverwriting() failed to overwrite the template tile actors map.")
	
	return overwroteMap
end

local function createTileActorsMapWithoutTemplate(mapData)
	assert(TypeChecker.isTiledData(mapData))
	
	local map = MapFunctions.createGridActorsMapWithTiledLayer(getTiledTileLayer(mapData), ModelTile, ViewTile)
	assert(map, "ModelTileMap--createTileActorsMapWithoutTemplate() failed to create the map.")
	
	return map
end

local function createChildrenActors(param)
	local mapData = requireMapData(param)
	assert(TypeChecker.isMapData(mapData))
	
	local tileActorsMap = (mapData.Template == nil
		and createTileActorsMapWithoutTemplate(mapData)
		or  createTileActorsMapWithTemplateAndOverwriting(mapData))
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
	
	self.m_TileActorsMap = childrenActors.TileActorsMap
	
	if (self.m_View) then self:initView() end

	return self
end

function ModelTileMap.createInstance(param)
	local model = ModelTileMap.new():load(param)
	assert(model, "ModelTileMap.createInstance() failed to create the model with param.")
	
	return model
end

function ModelTileMap:initView()
	local view = self.m_View
	assert(TypeChecker.isView(view))
	
	view:removeAllChildren()

    local tileActors = self.m_TileActorsMap
	local mapSize = tileActors.size
    for y = mapSize.height, 1, -1 do
        for x = mapSize.width, 1, -1 do
            view:addChild(tileActors[x][y]:getView())
        end
    end
end

function ModelTileMap:getMapSize()
	return self.m_TileActorsMap.size
end

return ModelTileMap
