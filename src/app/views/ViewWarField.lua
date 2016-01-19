
local ViewWarField = class("ViewWarField", function()
	return display.newNode()
end)
local Requirer		= require"app.utilities.Requirer"
local TypeChecker	= Requirer.utility("TypeChecker")
local TileMap		= Requirer.view("TileMap")
local UnitMap		= Requirer.view("UnitMap")
local GameConstant	= Requirer.gameConstant()

local function createField(templateName)
	if (type(templateName) ~= "string") then
		return nil, "ViewWarField--createField() the template name is not a string."
	end
	
	local fieldData = Requirer.templateWarField(templateName)
	if (type(fieldData) ~= "table") then
		return nil, "ViewWarField--createField() can't load field data from template " .. templateName
	end
	
	local tileMap, createTileMapMsg = TileMap.createInstance(fieldData.TileMap)
	if (tileMap == nil) then
		return nil, "ViewWarField--createField() failed to create a TileMap:\n" .. createTileMapMsg
	end
	
	local unitMap, createUnitMapMsg = UnitMap.createInstance(fieldData.UnitMap)
	if (unitMap == nil) then
		return nil, "ViewWarField--createField() failed to create a UnitMap:\n" .. createUnitMapMsg
	end
	
	if (not TypeChecker.isSizeEqual(unitMap:getMapSize(), tileMap:getMapSize())) then
		return nil, "ViewWarField--createField() failed: the size of the UnitMap and the one of TileMap is not the same."
	end
	
	return {tileMap = tileMap, unitMap = unitMap}
end

function ViewWarField:ctor(templateName)
	if (templateName) then self:load(templateName) end
	
	return self
end

function ViewWarField:load(templateName)
	local createFieldResult, createFieldMsg = createField(templateName)
	if (createFieldResult == nil) then
		return nil, string.format("ViewWarField:load() failed to load template [%s]:\n%s", templateName, createFieldMsg)
	end
	
	self.m_TileMap_ = createFieldResult.tileMap
	self.m_UnitMap_ = createFieldResult.unitMap

	self:removeAllChildren()
		:addChild(self.m_TileMap_)
		:addChild(self.m_UnitMap_)
		:setContentSize(self.m_TileMap_:getMapSize().width * GameConstant.GridSize.width,
						self.m_TileMap_:getMapSize().height * GameConstant.GridSize.height)
		
	return self
end

function ViewWarField.createInstance(param)
	local warField, createFieldMsg = ViewWarField.new():load(param)
	if (warField == nil) then
		return nil, "ViewWarField.createInstance() failed:\n" .. createFieldMsg
	else
		return warField
	end
end

return ViewWarField
