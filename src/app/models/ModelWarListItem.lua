
local ModelWarListItem = class("ModelWarListItem")

local Requirer        = require"app.utilities.Requirer"
local Actor           = Requirer.actor()
local TypeChecker     = Requirer.utility("TypeChecker")

local function createActorConfirmBox(warName, onConfirmYes)
    local modelData = {
        confirmText = "You are entering a war:\n" .. warName .. ".\nAre you sure?",
        onConfirmYes = onConfirmYes
    }
    
    return Actor.createWithModelAndViewName("ModelConfirmBox", modelData, "ViewConfirmBox")
end

function ModelWarListItem:ctor(param)
    if (param) then self:load(param) end

	return self
end

function ModelWarListItem:load(param)
    assert(type(param) == "table", "ModelWarListItem:load() the param is not a table.")

    self.m_Title = param.name
    self.m_Data = param.data
    
    if (self.m_View) then self:initView() end
		
	return self
end

function ModelWarListItem.createInstance(param)
	local list = ModelWarListItem.new():load(param)
    assert(list, "ModelWarListItem.createInstance() failed.")

	return list
end

function ModelWarListItem:initView()
    local view = self.m_View
	assert(view, "ModelWarListItem:initView() no view is attached to the actor of the model.")

    view:setTitleText(self.m_Title)
    
    return self
end

function ModelWarListItem:onPlayerTouch()
    self.m_ActorConfirmBox = createActorConfirmBox(self.m_Title, function()
        self.m_ActorConfirmBox = nil
        self:onPlayerConfirmEnterWar()
    end)
    self.m_View:getScene():addChild(self.m_ActorConfirmBox:getView())
    
    return self
end

function ModelWarListItem:onPlayerConfirmEnterWar()
    local warScene, createWarSceneMsg = Requirer.view("SceneWar").createInstance(self.m_Data)
    assert(warScene, createWarSceneMsg)
        
    display.runScene(warScene, "CrossFade", 0.5)
    
    return self
end

return ModelWarListItem
