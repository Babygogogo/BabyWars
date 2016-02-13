
local ModelWarListItem = class("ModelWarListItem")

local Requirer        = require"app.utilities.Requirer"
local Actor           = Requirer.actor()
local ViewWarListItem = Requirer.view("ViewWarListItem")
local TypeChecker     = Requirer.utility("TypeChecker")

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

function ModelWarListItem:onPlayerRequestEnterWar()
    local warScene, createWarSceneMsg = Requirer.view("SceneWar").createInstance(self.m_Data)
    assert(warScene, createWarSceneMsg)
        
    display.runScene(warScene, "CrossFade", 0.5)
end

return ModelWarListItem
