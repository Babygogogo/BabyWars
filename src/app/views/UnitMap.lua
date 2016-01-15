
local UnitMap = class("UnitMap", function()
	return display.newNode()
end)
local Requirer		= require"app.utilities.Requirer"
local TypeChecker	= Requirer.utility("TypeChecker")
local MapFunctions	= Requirer.utility("MapFunctions")
local Unit			= Requirer.view("Unit")
local GridSize		= Requirer.gameConstant().GridSize

local function createModel(param)
	if (type(param) ~= "string") then
		return nil, "UnitMap--createModel() the param is not a string."
	end
	
	local mapData = Requirer.templateUnitMap(param)
	if (type(mapData) ~= "table") then
		return nil, "UnitMap--createModel() the mapData is not a tabel."
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
	self:loadWithTemplateName(param)
	
	return self
end

function UnitMap:loadWithTemplateName(param)
	local createModelResult, createModelMsg = createModel(param)
	if (createModelResult == nil) then
		return nil, string.format("UnitMap:load() failed to load template [%s].\n%s", param, createModelMsg)
	end
	
	self.m_Map_ = createModelResult.map
	self.m_MapSize_ = createModelResult.mapSize

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
