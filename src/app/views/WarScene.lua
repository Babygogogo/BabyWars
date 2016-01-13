
local WarScene = class("WarScene", function()
	return display.newScene()
end)
local Requirer = require"app.utilities.Requirer"
local WarField = Requirer.view("WarField")

local function createScene(templateName)
	if (type(templateName) ~= "string") then
		return nil, "WarScene--createScene() the param templateName is not a string."
	end

	local warField, createWarFieldMsg = WarField.new():load("WarField_Test")
	if (warField == nil) then
		return nil, "WarScene--createScene() failed to create WarField: " .. createWarFieldMsg
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
		return nil, "WarScene:load() failed: " .. createSceneMsg
	end
	
	self:removeAllChildren()
		:addChild(createSceneResult.warField)
		
	return self
end

return WarScene
