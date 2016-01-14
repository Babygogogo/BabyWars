
local UnitMap = class("UnitMap", function()
	return display.newNode()
end)
local Requirer		= require"app.utilities.Requirer"
local TypeChecker	= Requirer.utility("TypeChecker")
local Unit			= Requirer.view("Unit")
local GridSize		= Requirer.gameConstant().GridSize

local function checkUnitGridIndex(unitGridIndex, mapSize)
	if (not TypeChecker.isGridIndex(unitGridIndex)) then
		return false, "UnitMap--checkUnitGridIndex() unitGridIndex is not a GridIndex."
	elseif (unitGridIndex.rowIndex > mapSize.rowCount) then
		return false, "UnitMap--checkUnitGridIndex() unitGridIndex.rowIndex > mapSize.rowCount."
	elseif (unitGridIndex.colIndex > mapSize.colCount) then
		return false, "UnitMap--checkUnitGridIndex() unitGridIndex.colIndex > mapSize.colCount."
	elseif (unitGridIndex.rowIndex < 1) then
		return false, "UnitMap--checkUnitGridIndex() unitGridIndex.rowIndex < 1."
	elseif (unitGridIndex.colIndex < 1) then
		return false, "UnitMap--checkUnitGridIndex() unitGridIndex.colIndex < 1."
	else
		return true
	end
end

local function loadMapSize(mapData)
	local mapSize = mapData.MapSize
	if (not TypeChecker.isMapSize(mapSize)) then
		return nil, string.format("UnitMap--loadMapSize() the loaded mapSize [%s(%s), %s(%s)] is invalid.",
									mapSize.rowCount, type(mapSize.rowCount), mapSize.colCount, type(mapSize.colCount))
	else
		return mapSize
	end
end

local function createEmptyMap(mapSize)
	local map = {}
	for i = 1, mapSize.colCount do
		map[i] = {}
	end
	
	return map
end

local function createUnitAndCheckIndex(unitData, mapSize)
	local unit, createUnitMsg = Unit.new():loadData(unitData)
	if (unit == nil) then
		return nil, "UnitMap--createUnitAndCheckIndex() failed to create unit with param unitData.\n" .. createUnitMsg
	end
	
	local checkGridIndexResult, checkGridIndexMsg = checkUnitGridIndex(unit:getGridIndex(), mapSize)
	if (not checkGridIndexResult) then
		return nil, "UnitMap--createUnitAndCheckIndex() the GridIndex of the created unit is invalid.\n" .. checkGridIndexMsg
	end
	
	return unit
end

local function loadUnitsIntoMap(map, mapSize, unitsData)
	for _, unitData in ipairs(unitsData) do
		local unit, createUnitMsg = createUnitAndCheckIndex(unitData, mapSize)
		if (unit == nil) then
			return nil, "UnitMap--loadUnitsIntoMap() failed to create a valid unit.\n" .. createUnitMsg
		end
		
		local rowIndex, colIndex = unit:getGridIndex().rowIndex, unit:getGridIndex().colIndex
		if (map[colIndex][rowIndex] ~= nil) then
			print(string.format("UnitMap--loadUnitsIntoMap() the unit on [%d, %d] is already loaded; it will be overrided", colIndex, rowIndex))
		end

		map[colIndex][rowIndex] = unit
	end
	
	return map
end

local function createMap(templateName)
	if (type(templateName) ~= "string") then
		return nil, "UnitMap--createMap() the param templateName is not a string."
	end
	
	local mapData = Requirer.templateUnitMap(templateName)
	if (type(mapData) ~= "table") then
		return nil, "UnitMap--createMap() the mapData is not a tabel."
	end

	local baseMap, mapSize, loadSizeMsg
	if (mapData.Template ~= nil) then
		local createTemplateMapResult, createTemplateMapMsg = createMap(mapData.Template)
		if (createTemplateMapResult == nil) then
			return nil, string.format("UnitMap--createMap() failed to create the template map [%s]:\n%s", mapData.Template, createTemplateMapMsg)
		end		
		
		baseMap, mapSize = createTemplateMapResult.map, createTemplateMapResult.mapSize
	else
		mapSize, loadSizeMsg = loadMapSize(mapData)
		if (mapSize == nil) then
			return nil, string.format("UnitMap--createMap() failed to load MapSize from [%s]\n%s", templateName, loadSizeMsg)
		end

		baseMap = createEmptyMap(mapSize)
	end	

	local map, loadUnitsIntoMapMsg = loadUnitsIntoMap(baseMap, mapSize, mapData.Units)
	if (map == nil) then
		return nil, "UnitMap--createMap() failed to load units.\n" .. loadUnitsIntoMapMsg
	end
	
	return {map = map, mapSize = mapSize}
end

function UnitMap:ctor(templateName)
	self:loadWithTemplateName(templateName)
	
	return self
end

function UnitMap:loadWithTemplateName(templateName)
	local createMapResult, createMapMsg = createMap(templateName)
	if (createMapResult == nil) then
		return nil, string.format("UnitMap:load() failed to load template [%s].\n%s", templateName, createMapMsg)
	end
	
	self.m_Map_ = createMapResult.map
	self.m_MapSize_ = createMapResult.mapSize

	self:removeAllChildren()
	for colIndex = 1, self.m_MapSize_.colCount do
		for rowIndex = 1, self.m_MapSize_.rowCount do
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
