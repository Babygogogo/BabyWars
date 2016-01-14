
local WarField = class("WarField", function()
	return display.newNode()
end)
local Requirer		= require"app.utilities.Requirer"
local TileMap		= Requirer.view("TileMap")
local UnitMap		= Requirer.view("UnitMap")
local GameConstant	= Requirer.gameConstant()

local function isMapSizeEqual(size1, size2)
	return size1.colCount == size2.colCount and size1.rowCount == size2.rowCount
end

local function createField(templateName)
	if (type(templateName) ~= "string") then
		return nil, "WarField--createField() the template name is not a string."
	end
	
	local fieldData = Requirer.templateWarField(templateName)
	if (type(fieldData) ~= "table") then
		return nil, "WarField--createField() can't load field data from template " .. templateName
	end
	
	local tileMap, createTileMapMsg = TileMap.new():load(fieldData.TileMap)
	if (tileMap == nil) then
		return nil, "WarField--createField() failed to create a TileMap:\n" .. createTileMapMsg
	end
	
	local unitMap, createUnitMapMsg = UnitMap.new():loadWithTemplateName(fieldData.UnitMap)
	if (unitMap == nil) then
		return nil, "WarField--createField() failed to create a UnitMap:\n" .. createUnitMapMsg
	end
	
	if (not isMapSizeEqual(unitMap:getMapSize(), tileMap:getMapSize())) then
		return nil, "WarField--createField() failed: the size of the UnitMap and the one of TileMap is not the same."
	end
	
	return {tileMap = tileMap, unitMap = unitMap}
end

function WarField:ctor(templateName)
	self:load(templateName)
	
	return self
end

function WarField:load(templateName)
	local createFieldResult, createFieldMsg = createField(templateName)
	if (createFieldResult == nil) then
		return nil, string.format("WarField:load() failed to load template [%s]:\n%s", templateName, createFieldMsg)
	end
	
	self.m_TileMap_ = createFieldResult.tileMap
	self.m_UnitMap_ = createFieldResult.unitMap

	self:removeAllChildren()
		:addChild(self.m_TileMap_)
		:addChild(self.m_UnitMap_)
		:setContentSize(self.m_TileMap_:getMapSize().colCount * GameConstant.GridSize.width,
						self.m_TileMap_:getMapSize().rowCount * GameConstant.GridSize.height)
		
	return self
end

return WarField
