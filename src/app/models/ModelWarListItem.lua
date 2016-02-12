
local ModelWarListItem = class("ModelWarListItem")

local Requirer        = require"app.utilities.Requirer"
local Actor           = Requirer.actor()
local ViewWarListItem = Requirer.view("ViewWarListItem")
local TypeChecker     = Requirer.utility("TypeChecker")

local function createChildrenActors(listData)
    assert(type(listData) == "table", "ModelWarListItem--createChildrenActors() the param listData is not a table.")
    
    local actors = {}
    for _, itemData in ipairs(listData) do
        
    end
end

function ModelWarListItem:ctor(param)
    if (param) then self:load(param) end

	return self
end

function ModelWarListItem:load(param)
    local childrenActors = createChildrenActors(param)
    assert(childrenActors, "ModelWarListItem:load() failed.")

    self.m_ItemActors = childrenActors
    
    if (self.m_View_) then self:initView() end
		
	return self
end

function ModelWarListItem.createInstance(param)
	local list = ModelWarListItem.new():load(param)
    assert(list, "ModelWarListItem.createInstance() failed.")

	return list
end

function ModelWarListItem:initView()
    local view = self.m_View_
	assert(view, "ModelWarListItem:initView() no view is attached to the actor of the model.")
    
    for _, itemActor = ipairs(self.m_ItemActors) do
        local itemView = itemActor:getView()
        if (itemView) then view:pushBackCustomItem(itemView) end
    end
end

return ModelWarListItem
