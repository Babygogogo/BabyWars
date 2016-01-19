
local MapFunctions = {}
local Requirer		= require"app.utilities.Requirer"
local TypeChecker	= Requirer.utility("TypeChecker")
local Actor			= Requirer.actor()

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

function MapFunctions.clearAndAddGridViews(mapView, gridViews)
	mapView:removeAllChildren()
	local width, height = gridViews.size.width, gridViews.size.height
	for x = 1, width do
		for y = 1, height do
			mapView:addChild(gridViews[x][y])
		end
	end
end

function MapFunctions.loadGridsIntoMap(gridClass, gridsData, map)
	local mapSize = map.size
	for _, gridData in ipairs(gridsData) do
		local gridIndex = gridData.GridIndex
		local checkIndexResult, checkIndexMsg = TypeChecker.isGridInMap(gridIndex, mapSize)
		if (checkIndexResult == false) then
			return nil, "MapFunctions.loadGridsIntoMap() find a grid that is not in the map:\n" .. checkIndexMsg
		end
		
		local y, x = gridIndex.y, gridIndex.x
		if (map[x][y] == nil) then
			local grid, createGridMsg = gridClass.createInstance(gridData)
			if (grid == nil) then
				return nil, "MapFunctions.loadGridsIntoMap() failed to create a valid grid:\n" .. createGridMsg
			else
				map[x][y] = grid
			end
		else
			print(string.format("MapFunctions.loadGridsIntoMap() the grid on [%d, %d] is already loaded; overwriting it.", x, y))
	
			local loadGridMsg
			map[x][y], loadGridMsg = map[x][y]:load(gridData)
			if (map[x][y] == nil) then
				return nil, string.format("MapFunctions.loadGridsIntoMap() failed to overwrite the grid on [%d, %d]:\n%s", x, y, loadGridMsg)
			end
		end
	end

	return map
end

function MapFunctions.createMapWithTiledLayer(tiledLayer, gridClass)
	local checkLayerResult, checkLayerMsg = TypeChecker.isTiledLayer(tiledLayer)
	if (checkLayerResult == false) then
		return nil, "MapFunctions.createMapWithTiledLayer() the param tiledLayer is invalid:\n" .. checkLayerMsg
	end

	local mapSize = MapFunctions.loadMapSize(tiledLayer)
	if (mapSize == nil) then
		return nil, "MapFunctions.createMapWithTiledLayer() failed to load MapSize from param tiledLayer."
	end

	local map = MapFunctions.createEmptyMap(mapSize)
	local width, height = mapSize.width, mapSize.height
	for x = 1, width do
		for y = 1, height do
			local tiledID = tiledLayer.data[x + (mapSize.height - y) * mapSize.width]
			if (tiledID == nil) then
				return nil, string.format("MapFunctions.createMapWithTiledLayer() failed to load a valid TiledID on '[%d, %d]' from TiledLayer.", x, y)
			end

			map[x][y] = gridClass.createInstance({TiledID = tiledID, GridIndex = {x = x, y = y}})
		end
	end
	
	return map
end

function MapFunctions.createMapModelWithTiledLayer(tiledLayer, gridModelClass)
	assert(TypeChecker.isTiledLayer(tiledLayer))

	local mapSize = MapFunctions.loadMapSize(tiledLayer)
	local map = MapFunctions.createEmptyMap(mapSize)
	local width, height = mapSize.width, mapSize.height
	
	for x = 1, width do
		for y = 1, height do
			local tiledID = tiledLayer.data[x + (mapSize.height - y) * mapSize.width]
			assert(TypeChecker.isTiledID(tiledID))
			
			map[x][y] = gridModelClass.createInstance({TiledID = tiledID, GridIndex = {x = x, y = y}})
		end
	end
	
	return map
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
	
			local gridData = {TiledID = tiledID, GridIndex = {x = x, y = y}}
			local model = gridModelClass and gridModelClass.createInstance(gridData) or nil
			local view = gridViewClass and gridViewClass.createInstance(gridData) or nil
			
			map[x][y] = Actor.createWithModelAndViewInstance(model, view)
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
			local model = gridModelClass and gridModelClass.createInstance(gridData) or nil
			local view = gridViewClass and gridViewClass.createInstance(gridData) or nil
			map[x][y] = Actor.createWithModelAndViewInstance(model, view)
		else
			print(string.format("MapFunctions.updateGridActorsMapWithGridsData() the grid on [%d, %d] is already loaded; overwriting it.", x, y))

			local view = map[x][y]:getView()
			if (view) then view:load(gridData) end

			local model = map[x][y]:getModel()
			if (model) then model:load(gridData) end
		end
	end

	return map
end

return MapFunctions
