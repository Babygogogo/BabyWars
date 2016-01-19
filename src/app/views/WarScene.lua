
local WarScene = class("WarScene", function()
	return display.newScene()
end)
local Requirer			= require"app.utilities.Requirer"
local Actor				= Requirer.actor()
local ViewWarField		= Requirer.view("ViewWarField")
local ModelWarField		= Requirer.model("ModelWarField")
local TypeChecker		= Requirer.utility("TypeChecker")
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

local function createWarFieldActor(warFieldData)
	local view, createViewMsg = ViewWarField.createInstance(warFieldData)
	assert(view, "WarScene--createWarFieldActor() failed to create ViewWarField:\n" .. (createViewMsg or ""))
	ComponentManager.bindComponent(view, "DraggableWithinBoundary")
	view:setDragBoundaryRect({x = 10, y = 10, width = display.width - 60, height = display.height - 10})
	
	local model, createModelMsg = ModelWarField.createInstance(warFieldData)
	assert(model, "WarScene--createWarFieldActor() failed to create ModelWarField:\n" .. (createModelMsg or ""))

	return Actor.createWithModelAndViewInstance(model, view)
end

local function createActorsInScene(param)
	local sceneData = requireSceneData(param)
	assert(TypeChecker.isWarSceneData(sceneData))

	local warFieldActor = createWarFieldActor(sceneData.WarField)
	assert(warFieldActor, "WarScene--createActorsInScene() failed to create WarField actor.")

	return {WarFieldActor = warFieldActor}	
end

function WarScene:ctor(param)
	if (param) then self:load(param) end
	
	return self
end

function WarScene:load(param)
	local actorsInScene = createActorsInScene(param)
	assert(actorsInScene, "WarScene:load() failed to create actors in scene with param.")
	
	local warFieldActor = actorsInScene.WarFieldActor

	self.m_ViewWarFieldActor_ = warFieldActor
	self:removeAllChildren()
		:addChild(warFieldActor:getView())
		
	return self
end

function WarScene.createInstance(param)
	local warScene, createActorsInSceneMsg = WarScene.new():load(param)
	assert(warScene, "WarScene.createInstance() failed:\n" .. (createActorsInSceneMsg or ""))
	
	return warScene
end

return WarScene
