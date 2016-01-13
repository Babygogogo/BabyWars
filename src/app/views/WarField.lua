
local WarField = class("WarField", function()
	return display.newNode()
end)
local Requirer	= require"app.utilities.Requirer"
local TileMap	= Requirer.view("TileMap")

local function createField(templateName)
	if (type(templateName) ~= "string") then
		return nil, "WarField--createField() the template name is not a string."
	end
	
	local fieldData = Requirer.templateWarField(templateName)
	if (type(fieldData) ~= "table") then
		return nil, "WarField--createField() can't load field data from template: " .. templateName
	end
	
	local tileMap = TileMap.new()
	local loadTileMapResult, loadTileMapMsg = tileMap:load(fieldData["TileMap"])
	if (loadTileMapResult == nil) then
		return nil, "WarField--createField() can't load tile map from template:" .. fieldData["TileMap"]
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
		return nil, "WarField:load() failed: " .. createFieldMsg
	end

	self:removeAllChildren()
		:addChild(createFieldResult.tileMap)
		
	return self
end

return WarField
