
local MapFunctions = {}

local Requirer		= require"app.utilities.Requirer"
local TypeChecker	= Requirer.utility("TypeChecker")
local Actor			= Requirer.actor()

local function updateViewForGridActor(actor, viewClass, gridData)
    if (not actor:getView()) then
        actor:setView(viewClass.createInstance(gridData))
    end
    
    return actor
end

local function updateModelForGridActor(actor, modelClass, gridData)
    local existingModel = actor:getModel()
    if (existingModel) then
        existingModel:load(gridData)
    elseif (modelClass) then
        actor:setModel(modelClass.createInstance(gridData))
    end
    
    return actor
end

local function createGridActor(modelClass, viewClass, gridData)
    local model = modelClass and modelClass.createInstance(gridData) or nil
    local view  = viewClass  and viewClass.createInstance( gridData) or nil
    return Actor.createWithModelAndViewInstance(model, view)
end

function MapFunctions.loadMapSize(mapData)
	assert(TypeChecker.isMapData(mapData))
	
	local mapSize = mapData.MapSize or {width = mapData.width, height = mapData.height}
	assert(TypeChecker.isMapSize(mapSize))

	return mapSize
end

function MapFunctions.createEmptyMap(mapSize)
	local map = {size = mapSize}
	for i = 1, mapSize.width do
		map[i] = {}
	end
	
	return map
end

function MapFunctions.hasNilGrid(map)
	for x = 1, map.size.width do
		if (map[x] == nil) then return true end
		for y = 1, map.size.height do
			if (map[x][y] == nil) then return true end
		end
	end
	
	return false
end

function MapFunctions.createGridActorsMapWithMapData(mapData, gridModelClass, gridViewClass)
	assert(TypeChecker.isMapData(mapData))
	
	local mapSize = MapFunctions.loadMapSize(mapData)
	local map = MapFunctions.createEmptyMap(mapSize)
	
	return MapFunctions.updateGridActorsMapWithGridsData(map, mapData.Grids, gridModelClass, gridViewClass)
end

function MapFunctions.createGridActorsMapWithTiledLayer(tiledLayer, gridModelClass, gridViewClass)
	assert(TypeChecker.isTiledLayer(tiledLayer))
	
	local mapSize = MapFunctions.loadMapSize(tiledLayer)
	local map = MapFunctions.createEmptyMap(mapSize)

	local width, height = mapSize.width, mapSize.height
	for x = 1, width do
		for y = 1, height do
			local tiledID = tiledLayer.data[x + (mapSize.height - y) * mapSize.width]
			assert(TypeChecker.isTiledID(tiledID))
         
            if (tiledID ~= 0) then
                map[x][y] = createGridActor(gridModelClass, gridViewClass, {TiledID = tiledID, GridIndex = {x = x, y = y}})
            end
		end
	end
	
	return map
end

function MapFunctions.updateGridActorsMapWithGridsData(map, gridsData, gridModelClass, gridViewClass)
	local mapSize = map.size
	assert(TypeChecker.isMapSize(mapSize))
	
	for _, gridData in ipairs(gridsData) do
		local gridIndex = gridData.GridIndex
		assert(TypeChecker.isGridIndex(gridIndex))
		assert(TypeChecker.isGridInMap(gridIndex, mapSize))
		
		local x, y = gridIndex.x, gridIndex.y
		if (map[x][y] == nil) then
            map[x][y] = createGridActor(gridModelClass, gridViewClass, gridData)
		else
			print(string.format("MapFunctions.updateGridActorsMapWithGridsData() the grid on [%d, %d] is already loaded; overwriting it.", x, y))

            updateModelForGridActor(map[x][y], gridModelClass, gridData)
            updateViewForGridActor( map[x][y], gridViewClass,  gridData)
		end
	end

	return map
end

return MapFunctions
