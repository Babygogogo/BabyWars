
--[[--------------------------------------------------------------------------------
-- Actor是游戏中几乎所有元素的统一的容器，能够各容纳最多一个model和view。
--
-- 主要职责和使用场景举例：
--   创建新的actor实例（此功能可以考虑改由ActorManager实现）
--   提供接口给外界访问actor内的model和view
--   接收node事件（下面有详细描述）
--
-- 其他：
--   - actor实例举例：
--     刚进游戏所看到的主场景是一个actor实例，它所包含的model和view分别是ModelSceneMain和ViewSceneMain类的实例。
--     主场景中的战局列表也是一个actor实例，它所包含的model和view分别是ModelWarList和ViewWarList类的实例。
--
--   - actor间的树状层级关系：
--     继续以主场景和战局列表为例。在逻辑上，可以认为主场景是父节点，战局列表是子节点（并非继承关系，而是类似于cocos2d-x中的父显示节点和子显示节点的关系）。
--     但actor本身并没有体现父子关系的代码（这是因为一个父actor可能有很多作用迥异的子actor，强行在actor里写通用的处理函数没有太多意义），因此要手动在model里添加相应代码。
--     也就是说，以主场景和战局列表为例，我们需要在ModelSceneMain里创建和维护战局列表的actor。
--     同时，为了使得战局列表能够显示出来，我们还需要调用cc.Node:addChild()，把战局列表的view添加到主场景的view中（具体参看ViewWarList）。
--
--     场景的actor是最顶级的父节点，也就是根节点，因此又称为rootActor。
--     rootActor的view必须继承cc.Scene，而为了显示它，需要通过ActorManager的相关函数（参看ActorManager）。
--
--   - node事件是什么
--     node事件是由引擎内部在显示节点发生特定情况时派发的事件。这些特定情况包括：节点进入场景，节点离开场景（被清理），等等。
--     目前actor之所以要接收node事件，是为了在节点进入和离开节点时，为其注册/反注册到场景的EventDispatcher中。
--     这增大了actor的复杂度以及和引擎的耦合度，因此可以考虑改用别的方式注册/反注册EventDispatcher，并把actor接收node事件的功能删掉。
--
--   - model和view，以及游戏引擎的关系
--     虽然actor本身并没有强制要求，但一般来说，特定的model总是配合特定的view来一起工作的。这些有特定联系的model和view，类名也基本是一致的（分别是ModelXXX和ViewXXX）。
--     一般来说，特定的view的公有接口，应该只由相对应的model来调用。
--
--     actor和model都可以独立于游戏引擎存在，但view则不能（因为显示画面需要依靠引擎）。
--     理想状态下，如果需要更换引擎，那么我们只需要改写view就可以，其他都可以不用更改。
--]]--------------------------------------------------------------------------------

local Actor = class("Actor")

local ComponentManager = require("global.components.ComponentManager")

function Actor.createModel(name, param)
    if (not name) then
        return nil
    else
        return require("app.models." .. name):create(param)
    end
end

function Actor.createView(name, param)
    if (not name) then
        return nil
    else
        return require("app.views." .. name):create(param)
    end
end

function Actor.createWithModelAndViewInstance(modelInstance, viewInstance)
    local actor = Actor.new()
    if (modelInstance) then actor:setModel(modelInstance) end
    if (viewInstance)  then actor:setView( viewInstance)  end

    return actor
end

function Actor.createWithModelAndViewName(modelName, modelParam, viewName, viewParam)
    local model = Actor.createModel(modelName, modelParam)
    local view  = Actor.createView( viewName,  viewParam)

	return Actor.createWithModelAndViewInstance(model, view)
end

--[[
function Actor:destroy()
    self:destroyView()
        :destroyModel()
--        :unbindAllComponents()

    return self
end
--]]

function Actor:onEnter(rootActor)
    if (self.m_Model and self.m_Model.onEnter) then
        self.m_Model:onEnter(rootActor)
    end
    if (self.m_View and self.m_View.onEnter) then
        self.m_View:onEnter(rootActor)
    end

    return self
end

function Actor:onCleanup(rootActor)
    if (self.m_Model and self.m_Model.onCleanup) then
        self.m_Model:onCleanup(rootActor)
    end
    if (self.m_View and self.m_View.onCleanup) then
        self.m_View:onCleanup(rootActor)
    end

    return self
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

--[[
function Actor:destroyView()
    local view = self:getView()
    if (view) then
        self:removeView()
        if (view.onCleanup) then
            view:onCleanup()
        end
    end

    return self
end
--]]

function Actor:setModel(model)
	assert(type(model) == "table", "Actor:setModel() the param model is not a table.")
	assert(model.m_Actor == nil, "Actor:setModel() the param model already has an owner actor.")
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

--[[
function Actor:destroyModel()
    local model = self:getModel()
    if (model) then
        self:removeModel()
        if (model.onCleanup) then
            model:onCleanup()
        end
    end

    return self
end
--]]

--[[
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
--]]

return Actor
