
local WarScene = class("WarScene", function()
	return display.newScene()
end)
local Requirer			= require"app.utilities.Requirer"
local Actor				= Requirer.actor()
local ViewWarField		= Requirer.view("ViewWarField")
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

local function createViewWarFieldActor(warFieldData)
	local actor = Actor.new()
	
	local view, createViewMsg = ViewWarField.createInstance(warFieldData)
	assert(view, "WarScene--createViewWarFieldActor() failed:\n" .. (createViewMsg or ""))
	
	ComponentManager.bindComponent(view, "DraggableWithinBoundary")
	view:setDragBoundaryRect({x = 10, y = 10, width = display.width - 60, height = display.height - 10})
	
	actor:setView(view)
	return actor
end

local function createActorsInScene(param)
	local sceneData = requireSceneData(param)
	assert(TypeChecker.isWarSceneData(sceneData))

	local warFieldActor = createViewWarFieldActor(sceneData.WarField)

	return {ViewWarFieldActor = warFieldActor}	
end

function WarScene:ctor(param)
	if (param) then self:load(param) end
	
	return self
end

function WarScene:load(param)
	local actorsInScene = createActorsInScene(param)
	local warFieldActor = actorsInScene.ViewWarFieldActor

	self.m_ViewWarFieldActor_ = warField
	self:removeAllChildren()
		:addChild(warFieldActor:getView())
		
	return self
end

function WarScene.createInstance(param)
	local warScene, createActorsInSceneMsg = WarScene.new():load(param)
	if (warScene == nil) then
		return nil, "WarScene.createInstance() failed:\n" .. createActorsInSceneMsg
	end
	
	return warScene
end

return WarScene
