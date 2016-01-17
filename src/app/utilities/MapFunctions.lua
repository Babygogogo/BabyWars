
local MapFunctions = {}
local Requirer		= require"app.utilities.Requirer"
local TypeChecker	= Requirer.utility("TypeChecker")

function MapFunctions.loadMapSize(mapData)
	if (type(mapData) ~= "table") then
		return nil, "MapFunctions.loadMapSize() the param mapData is not a table."
	end
	
	local mapSize = mapData.MapSize or {width = mapData.width, height = mapData.height}
	local checkSizeResult, checkSizeMsg = TypeChecker.isMapSize(mapSize)
	if (not checkSizeResult) then
		return nil, "MapFunctions.loadMapSize() failed to load a valid MapSize from param mapData:\n" .. checkSizeMsg
	else
		return mapSize
	end
end

function MapFunctions.createEmptyMap(mapSize)
	local map = {size = mapSize}
	for i = 1, mapSize.width do
		map[i] = {}
	end
	
	return map
end

function MapFunctions.hasNilGrid(map, mapSize)
	for x = 1, mapSize.width do
		if (map[x] == nil) then return true end
		for y = 1, mapSize.height do
			if (map[x][y] == nil) then return true end
		end
	end
	
	return false
end

function MapFunctions.loadGridsIntoMap(gridClass, gridsData, map, mapSize)
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

function MapFunctions.loadTiledDataIntoMap(gridClass, tiledLayer, map, mapSize)
	for x = 1, mapSize.width do
		for y = 1, mapSize.height do
			local gridData = {TiledID = tiledLayer.data[x + (mapSize.height - y) * mapSize.width], GridIndex = {x = x, y = y}}
			if (map[x][y] == nil) then
				local grid, createGridMsg = gridClass.createInstance(gridData)
				if (grid == nil) then
					return nil, "MapFunctions.loadTiledDataIntoMap() failed to create a valid grid:\n" .. createGridMsg
				else
					map[x][y] = grid
				end
			else
				print(string.format("MapFunctions.loadTiledDataIntoMap() the grid on [%d, %d] is already loaded; overwriting it.", x, y))
				
				local loadGridMsg
				map[x][y], loadGridMsg = map[x][y]:load(gridData)
				if (map[x][y] == nil) then
					return nil, string.format("MapFunctions.loadTiledDataIntoMap() failed to overwrite the grid on [%d, %d]:\n%s", x, y, loadGridMsg)
				end
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
			local checkIdResult, checkIdMsg = TypeChecker.isTiledID(tiledID)
			if (checkIdResult == false) then
				return nil, "MapFunctions.createMapWithTiledLayer() failed to load a valid TiledID from TiledLayer:\n" .. checkIdMsg
			end
			
			local grid, createGridMsg = gridClass.createInstance({TiledID = tiledID, GridIndex = {x = x, y = y}})
			if (grid == nil) then
				return nil, "MapFunctions.createMapWithTiledLayer() failed to create a valid grid:\n" .. createGridMsg
			else
				map[x][y] = grid
			end
		end
	end
	
	return map
end


return MapFunctions
