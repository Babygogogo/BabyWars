
local WarScene = class("WarScene", function()
	return display.newScene()
end)
local Requirer			= require"app.utilities.Requirer"
local WarField			= Requirer.view("WarField")
local ComponentManager	= Requirer.component("ComponentManager")

local function requireSceneData(param)
	local t = type(param)
	if (t == "table") then
		return param
	elseif (t == "string") then
		return Requirer.templateWarScene(param)
	else
		return nil
	end
end

local function createScene(param)
	local sceneData = requireSceneData(param)
	if (type(sceneData) ~= "table") then
		return nil, "WarScene--createScene() failed to require SceneData from param."
	end

	local warField, createWarFieldMsg = WarField.new():load(sceneData.WarField)
	if (warField == nil) then
		return nil, "WarScene--createScene() failed to create a WarField: \n" .. createWarFieldMsg
	end

	return {warField = warField}	
end

function WarScene:ctor(param)
	self:load(param)
	
	return self
end

function WarScene:load(param)
	local createSceneResult, createSceneMsg = createScene(param)
	if (createSceneResult == nil) then
		return nil, string.format("WarScene:load() failed to load template '%s':\n%s", param, createSceneMsg)
	end
	
	local warField = createSceneResult.warField
	ComponentManager.bindComponent(warField, "DraggableWithinBoundary")
	warField:setDragBoundaryRect({x = 10, y = 10, width = display.width - 60, height = display.height - 10})
	
	self:removeAllChildren()
		:addChild(warField)
		
	return self
end

function WarScene.createInstance(param)
	local warScene, createSceneMsg = WarScene.new():load(param)
	if (warScene == nil) then
		return nil, "WarScene.createInstance() failed:\n" .. createSceneMsg
	end
	
	return warScene
end

return WarScene
