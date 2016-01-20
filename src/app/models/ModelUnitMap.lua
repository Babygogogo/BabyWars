
local ModelUnitMap = class("ModelUnitMap")

local Requirer		= require"app.utilities.Requirer"
local TypeChecker	= Requirer.utility("TypeChecker")
local MapFunctions	= Requirer.utility("MapFunctions")
local ViewUnit		= Requirer.view("Unit")
local GridSize		= Requirer.gameConstant().GridSize

local function requireMapData(param)
	local t = type(param)
	if (t == "string") then
		return Requirer.templateUnitMap(param)
	elseif (t == "table") then
		return param
	else
		return nil
	end
end

local function getTiledUnitLayer(tiledData)
	return tiledData.layers[2]
end

local function createModel(param)
	local mapData = requireMapData(param)
	if (mapData == nil) then
		return nil, "ModelUnitMap--createModel() failed to require MapData from param."
	end

	local baseMap, mapSize
	if (mapData.Template ~= nil) then
		local createTemplateMapResult, createTemplateMapMsg = createModel(mapData.Template)
		if (createTemplateMapResult == nil) then
			return nil, string.format("ModelUnitMap--createModel() failed to create the template map [%s]:\n%s", mapData.Template, createTemplateMapMsg)
		end		
		
		baseMap, mapSize = createTemplateMapResult.map, createTemplateMapResult.mapSize
	else
		local loadSizeMsg
		mapSize, loadSizeMsg = MapFunctions.loadMapSize(mapData)
		if (mapSize == nil) then
			return nil, "ModelUnitMap--createModel() failed to load MapSize from param:\n" .. loadSizeMsg
		end

		baseMap = MapFunctions.createEmptyMap(mapSize)
	end	

	local map, loadUnitsIntoMapMsg = MapFunctions.loadGridsIntoMap(Unit, mapData.Units, baseMap, mapSize)
	if (map == nil) then
		return nil, "ModelUnitMap--createModel() failed to load units:\n" .. loadUnitsIntoMapMsg
	end
	
	return {map = map, mapSize = mapSize}
end

local function createChildrenActors(param)
	local mapData = requireMapData(param)
	assert(TypeChecker.isMapData(mapData))
	
	local unitActorsMap = TypeChecker.isTiledData(mapData)
		and MapFunctions.createGridActorsMapWithTiledLayer(getTiledUnitLayer(mapData), nil, ViewUnit)
		or MapFunctions.createGridActorsMapWithMapData(mapData, nil, ViewUnit)
	assert(unitActorsMap, "ModelUnitMap--createChildrenActors() failed to create the unit actors map.")
	
	return {UnitActorsMap = unitActorsMap}
end

function ModelUnitMap:ctor(param)
	if (param) then self:load(param) end
	
	return self
end

function ModelUnitMap:load(param)
	local childrenActors = createChildrenActors(param)
	assert(childrenActors, "ModelUnitMap:load() failed to create children actors.")

	self.m_UnitActorsMap_ = childrenActors.UnitActorsMap
	
	if (self.m_View_) then self:initView()

	return self
end

function ModelUnitMap.createInstance(param)
	local model = ModelUnitMap.new():load(param)
	assert(model, "ModelUnitMap.createInstance() failed.")
	
	return model
end

function ModelUnitMap:initView()
	local view = self.m_View_
	assert(TypeChecker.isView(view))
	
	view:removeAllChildren()
	
	local mapSize = self.m_UnitActorsMap_.size
	for x = 1, mapSize.width do
		for y = 1, mapSize.height do
			view:addChild(self.m_UnitActorsMap_[x][y]:getView())
		end
	end
	
	return self
end

function ModelUnitMap:getMapSize()
	return self.m_MapSize_
end

return ModelUnitMap
