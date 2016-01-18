
local Actor = class("Actor")
local Requirer			= require"app.utilities.Requirer"
local ComponentManager	= Requirer.component("ComponentManager")

function Actor:ctor(...)
	self:bindComponent(...)
	
	return self
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

function Actor:hasBinded(componentName)
	return ComponentManager.hasBinded(self, componentName)
end

function Actor:getComponent(componentName)
	return ComponentManager.getComponent(self, componentName)
end

function Actor:setView(view)
	assert(iskindof(view, "cc.Node"), "Actor:setView() the param view is not a kind of cc.Node.")
	assert(view.m_Actor_ == nil, "Actor:setView() the param view already has an owner actor.")
	
	self.m_View_ = view
	view.m_Actor_ = self
	
	return self
end

function Actor:getView()
	return self.m_View_
end

function Actor:removeView()
	if (self.m_View_ ~= nil) then
		assert(type(self.m_View_) == "table", "Actor:removeView() the view of the actor is invalid.")
		self.m_View_.m_Actor_ = nil
		self.m_View_ = nil
	end
	
	return self
end

function Actor:setModel(model)
	assert(type(model) == "table", "Actor:setModel() the param model is not a table.")
	assert(model.m_Actor_ == nil, "Actor:setModel() the param model already has an owner actor.")
	
	self.m_Model_ = model
	model.m_Actor_ = self
	
	return self
end

function Actor:getModel()
	return self.m_Model_
end

function Actor:removeModel()
	if (self.m_Model_ ~= nil) then
		assert(type(self.m_Model_) == "table", "Actor:removeModel() the model of the actor is invalid.")
		self.m_Model_.m_Actor_ = nil
		self.m_Model_ = nil
	end
	
	return self
end

return Actor
