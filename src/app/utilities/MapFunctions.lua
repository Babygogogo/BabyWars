
local MapFunctions = {}
local Requirer		= require"app.utilities.Requirer"
local TypeChecker	= Requirer.utility("TypeChecker")

function MapFunctions.loadMapSize(mapData)
	local mapSize = mapData.MapSize
	local checkSizeResult, checkSizeMsg = TypeChecker.isMapSize(mapSize)
	if (not checkSizeResult) then
		return nil, "MapFunctions.loadMapSize() failed to load a valid MapSize from param mapData:\n" .. checkSizeMsg
	else
		return mapSize
	end
end

function MapFunctions.createEmptyMap(mapSize)
	local map = {}
	for i = 1, mapSize.colCount do
		map[i] = {}
	end
	
	return map
end

function MapFunctions.hasNilGrid(map, mapSize)
	for colIndex = 1, mapSize.colCount do
		if (map[colIndex] == nil) then return true end
		for rowIndex = 1, mapSize.rowCount do
			if (map[colIndex][rowIndex] == nil) then return true end
		end
	end
	
	return false
end

function MapFunctions.createGridAndCheckIndex(gridClass, gridData, mapSize)
	local grid, createGridMsg = gridClass.createInstance(gridData)
	if (grid == nil) then
		return nil, "MapFunctions.createGridAndCheckIndex() failed to create a grid:\n" .. createGridMsg
	end
	
	local checkGridIndexResult, checkGridIndexMsg = TypeChecker.isGridInMap(grid:getGridIndex(), mapSize)
	if (not checkGridIndexResult) then
		return nil, "MapFunctions.createGridAndCheckIndex() the GridIndex of the created grid is invalid:\n" .. checkGridIndexMsg
	end
	
	return grid
end

function MapFunctions.loadGridsIntoMap(gridClass, gridsData, map, mapSize)
	for _, gridData in ipairs(gridsData) do
		local gridIndex = gridData.GridIndex
		local checkIndexResult, checkIndexMsg = TypeChecker.isGridInMap(gridIndex, mapSize)
		if (checkIndexResult == false) then
			return nil, "MapFunctions.loadGridsIntoMap() find a grid that is not in the map:\n" .. checkIndexMsg
		end
		
		local rowIndex, colIndex = gridIndex.rowIndex, gridIndex.colIndex
		if (map[colIndex][rowIndex] == nil) then
			local grid, createGridMsg = MapFunctions.createGridAndCheckIndex(gridClass, gridData, mapSize)
			if (grid == nil) then
				return nil, "MapFunctions.loadGridsIntoMap() failed to create a valid grid:\n" .. createGridMsg
			else
				map[colIndex][rowIndex] = grid
			end
		else
			print(string.format("MapFunctions.loadGridsIntoMap() the grid on [%d, %d] is already loaded; overwriting it.", colIndex, rowIndex))
	
			local loadGridMsg
			map[colIndex][rowIndex], loadGridMsg = map[colIndex][rowIndex]:load(gridData)
			if (map[colIndex][rowIndex] == nil) then
				return nil, string.format("MapFunctions.loadGridsIntoMap() failed to overwrite the grid on [%d, %d]:\n%s", colIndex, rowIndex, loadGridMsg)
			end
		end
	end

	return map
end

return MapFunctions
