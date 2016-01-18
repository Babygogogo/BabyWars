
local UnitMap = class("UnitMap", function()
	return display.newNode()
end)
local Requirer		= require"app.utilities.Requirer"
local TypeChecker	= Requirer.utility("TypeChecker")
local MapFunctions	= Requirer.utility("MapFunctions")
local Unit			= Requirer.view("Unit")
local GridSize		= Requirer.gameConstant().GridSize

local function requireMapDataFrom(param)
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
	local mapData = requireMapDataFrom(param)
	if (mapData == nil) then
		return nil, "UnitMap--createModel() failed to require MapData from param."
	end

	local baseMap, mapSize
	if (mapData.Template ~= nil) then
		local createTemplateMapResult, createTemplateMapMsg = createModel(mapData.Template)
		if (createTemplateMapResult == nil) then
			return nil, string.format("UnitMap--createModel() failed to create the template map [%s]:\n%s", mapData.Template, createTemplateMapMsg)
		end		
		
		baseMap, mapSize = createTemplateMapResult.map, createTemplateMapResult.mapSize
	else
		local loadSizeMsg
		mapSize, loadSizeMsg = MapFunctions.loadMapSize(mapData)
		if (mapSize == nil) then
			return nil, "UnitMap--createModel() failed to load MapSize from param:\n" .. loadSizeMsg
		end

		baseMap = MapFunctions.createEmptyMap(mapSize)
	end	

	local map, loadUnitsIntoMapMsg = MapFunctions.loadGridsIntoMap(Unit, mapData.Units, baseMap, mapSize)
	if (map == nil) then
		return nil, "UnitMap--createModel() failed to load units:\n" .. loadUnitsIntoMapMsg
	end
	
	return {map = map, mapSize = mapSize}
end

function UnitMap:ctor(param)
	self:load(param)
	
	return self
end

function UnitMap.createInstance(param)
	local map, createMapMsg = UnitMap.new():load(param)
	if (map == nil) then
		return nil, "UnitMap.createInstance() failed:\n" .. createMapMsg
	else
		return map
	end
end

function UnitMap:load(param)
	local createModelResult, createModelMsg = createModel(param)
	if (createModelResult == nil) then
		return nil, "UnitMap:load() failed to load from param:\n" .. createModelMsg
	end
	
	self.m_Map_ = createModelResult.map
	self.m_MapSize_ = createModelResult.mapSize

	self:removeAllChildren()
	for colIndex = 1, self.m_MapSize_.width do
		for rowIndex = 1, self.m_MapSize_.height do
			local unit = self.m_Map_[colIndex][rowIndex]
			if (unit) then
				self:addChild(unit)
			end
		end
	end
	
	return self
end

function UnitMap:getMapSize()
	return self.m_MapSize_
end

return UnitMap
