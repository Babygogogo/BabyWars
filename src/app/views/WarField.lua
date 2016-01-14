
local WarField = class("WarField", function()
	return display.newNode()
end)
local Requirer		= require"app.utilities.Requirer"
local TileMap		= Requirer.view("TileMap")
local GameConstant	= Requirer.gameConstant()

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
	
	return {tileMap = tileMap}
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

	self:removeAllChildren()
		:addChild(createFieldResult.tileMap)
		:setContentSize(self.m_TileMap_:getMapSize().colCount * GameConstant.GridSize.width,
						self.m_TileMap_:getMapSize().rowCount * GameConstant.GridSize.height)
		
	return self
end

return WarField
