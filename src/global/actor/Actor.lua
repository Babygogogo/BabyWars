
local Actor = class("Actor")
local Requirer			= require"app.utilities.Requirer"
local ComponentManager	= Requirer.component("ComponentManager")

function Actor.createWithModelAndViewInstance(modelInstance, viewInstance)
	local actor = Actor.new()
	if (modelInstance) then actor:setModel(modelInstance) end
	if (viewInstance) then actor:setView(viewInstance) end
	
	return actor
end

function Actor.createWithModelAndViewName(modelName, modelParam, viewName, viewParam)
	local model, createModelMsg = Requirer.model(modelName).createInstance(modelParam)
	assert(model, string.format("Actor.createWithModelAndViewName() failed to create the model '%s':\n%s", modelName, createModelMsg))
	
	local view, createViewMsg = Requirer.view(viewName).createInstance(viewParam)
	assert(view, string.format("Actor.createWithModelAndViewName() failed to create the view '%s':\n%s", viewName, createViewMsg))

	return Actor.createWithModelAndViewInstance(model, view)
end

function Actor:bindComponent(...)
	ComponentManager.bindComponent(self, ...)
	
	return self
end

function Actor:unbindComponent(...)
	ComponentManager.unbindComponent(self, ...)
    
	return self
end

function Actor:unbindAllComponents()
	ComponentManager.unbindAllComponents(self)
	
	return self
end

function Actor:hasBound(componentName)
	return ComponentManager.hasBinded(self, componentName)
end

function Actor:getComponent(componentName)
	return ComponentManager.getComponent(self, componentName)
end

function Actor:setView(view)
	assert(iskindof(view, "cc.Node"), "Actor:setView() the param view is not a kind of cc.Node.")
	assert(view.m_Actor == nil, "Actor:setView() the param view already has an owner actor.")
	assert(self.m_View == nil, "Actor:setView() the actor already has a view.")

	local model = self.m_Model
	view.m_Model = model
	if (model) then
		model.m_View = view
		if (model.initView) then model:initView() end
	end
	
	self.m_View = view
	view.m_Actor = self
	
	return self
end

function Actor:getView()
	return self.m_View
end

function Actor:removeView()
	local view = self.m_View
	if (view) then
		local model = self.m_Model
		if (model) then model.m_View = nil end
		
		view.m_Model, view.m_Actor = nil, nil
		self.m_View = nil
	end
	
	return self
end

function Actor:setModel(model)
	assert(type(model) == "table", "Actor:setModel() the param model is not a table.")
	assert(model.m_Actor_ == nil, "Actor:setModel() the param model already has an owner actor.")
	assert(self.m_Model == nil, "Actor:setModel() the actor already has a model.")
	
	local view = self.m_View
	model.m_View = view
	if (view) then
		view.m_Model = model
		if (model.initView) then model:initView() end
	end
	
	self.m_Model = model
	model.m_Actor = self
	
	return self
end

function Actor:getModel()
	return self.m_Model
end

function Actor:removeModel()
	local model = self.m_Model
	if (model) then
		local view = self.m_View
		if (view) then view.m_Model = nil end

		model.m_View, model.m_Actor = nil, nil
		self.m_Model = nil
	end
	
	return self
end

return Actor
