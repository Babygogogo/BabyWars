
local MapFunctions = {}

local TypeChecker = require("app.utilities.TypeChecker")
local Actor       = require("global.actors.Actor")

local function updateViewForGridActor(actor, viewName, gridData)
    local existingView = actor:getView()
    if (existingView) then
        existingView:ctor(gridData)
    else
        actor:setView(Actor.createView(viewName, gridData))
    end

    return actor
end

local function updateModelForGridActor(actor, modelName, gridData)
    local existingModel = actor:getModel()
    if (existingModel) then
        existingModel:ctor(gridData)
    elseif (modelClass) then
        actor:setModel(Actor.createModel(modelName, gridData))
    end

    return actor
end

local function createGridActor(modelClass, viewClass, gridData)
    local model = modelClass and modelClass.createInstance(gridData) or nil
    local view  = viewClass  and viewClass.createInstance( gridData) or nil
    return Actor.createWithModelAndViewInstance(model, view)
end

function MapFunctions.loadMapSize(mapData)
	local mapSize = mapData.mapSize or {width = mapData.width, height = mapData.height}
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

function MapFunctions.createGridActorsMapWithTiledLayer(tiledLayer, modelName, viewName)
    local mapSize = MapFunctions.loadMapSize(tiledLayer)
    assert(TypeChecker.isMapSize(mapSize))
    local map = MapFunctions.createEmptyMap(mapSize)

    local width, height = mapSize.width, mapSize.height
    for x = 1, width do
        for y = 1, height do
            local tiledID = tiledLayer.data[x + (height - y) * width]
            if (tiledID ~= 0) then
                local actorData = {tiledID = tiledID, gridIndex = {x = x, y = y}}
                local actor = Actor.createWithModelAndViewName(modelName, actorData, viewName, actorData)
                assert(actor, "MapFunctions.createGridActorsMapWithTiledLayer() failed to create a grid actor.")

                map[x][y] = actor
            end
        end
    end

    return map
end

function MapFunctions.updateGridActorsMapWithGridsData(map, gridsData, modelName, viewName)
	local mapSize = map.size
	assert(TypeChecker.isMapSize(mapSize))

	for _, gridData in ipairs(gridsData) do
		local gridIndex = gridData.gridIndex
		assert(TypeChecker.isGridIndex(gridIndex))
		assert(TypeChecker.isGridInMap(gridIndex, mapSize))

		local x, y = gridIndex.x, gridIndex.y
		if (map[x][y] == nil) then
            map[x][y] = Actor.createWithModelAndViewName(modelName, gridData, viewName, gridData)
		else
			print(string.format("MapFunctions.updateGridActorsMapWithGridsData() the grid on [%d, %d] is already loaded; overwriting it.", x, y))

            updateModelForGridActor(map[x][y], modelName, gridData)
            updateViewForGridActor( map[x][y], viewName,  gridData)
		end
	end

	return map
end

return MapFunctions
