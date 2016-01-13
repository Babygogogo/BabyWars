
local WarScene = class("WarScene", function()
	return display.newScene()
end)
local Requirer = require"app.utilities.Requirer"
local WarField = Requirer.view("WarField")

local function createScene(templateName)
	if (type(templateName) ~= "string") then
		return nil, "WarScene--createScene() the param templateName is not a string."
	end

	local sceneData = Requirer.templateWarScene(templateName)
	if (type(sceneData) ~= "table") then
		return nil, "WarScene--createScene() failed to require scene data from template " .. templateName
	end

	local warField, createWarFieldMsg = WarField.new():load(sceneData.WarField)
	if (warField == nil) then
		return nil, "WarScene--createScene() failed to create a WarField: \n" .. createWarFieldMsg
	end

	return {warField = warField}	
end

function WarScene:ctor(templateName)
	self:load(templateName)
	
	return self
end

function WarScene:load(templateName)
	local createSceneResult, createSceneMsg = createScene(templateName)
	if (createSceneResult == nil) then
		return nil, string.format("WarScene:load() failed to load template [%s]:\n%s", templateName, createSceneMsg)
	end
	
	local warField = createSceneResult.warField
	Requirer.component("ComponentManager").bindComponent(warField, "DraggableWithinBoundary")
	warField:setDragBoundaryRect({x = 10, y = 10, width = display.width - 60, height = display.height - 10})
	
	self:removeAllChildren()
		:addChild(warField)
		
	return self
end

return WarScene
