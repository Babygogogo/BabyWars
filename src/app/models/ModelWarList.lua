
local ModelWarList = class("ModelWarList")

local Requirer         = require"app.utilities.Requirer"
local Actor            = Requirer.actor()
local ViewWarListItem  = Requirer.view("ViewWarListItem")
local ModelWarListItem = Requirer.model("ModelWarListItem")
local TypeChecker      = Requirer.utility("TypeChecker")

local function requireListData(param)
    local t = type(param)
    if (t == "table") then
        return param
    elseif (t == "string") then
        return Requirer.warList(param)
    else
        return nil
    end
end

local function createChildrenActors(param)
    local listData = requireListData(param)
    assert(type(listData) == "table", "ModelWarList--createChildrenActors() failed to require list data from with param.")
    
    local actors = {}
    for _, itemData in ipairs(listData) do
        
    end
end

function ModelWarList:ctor(param)
    if (param) then self:load(param) end

	return self
end

function ModelWarList:load(param)
    local childrenActors = createChildrenActors(param)
    assert(childrenActors, "ModelWarList:load() failed.")

    self.m_ItemActors = childrenActors
    
    if (self.m_View_) then self:initView() end
		
	return self
end

function ModelWarList.createInstance(param)
	local list = ModelWarList.new():load(param)
    assert(list, "ModelWarList.createInstance() failed.")

	return list
end

function ModelWarList:initView()
    local view = self.m_View_
	assert(view, "ModelWarList:initView() no view is attached to the actor of the model.")
    
    for _, itemActor = ipairs(self.m_ItemActors) do
        local itemView = itemActor:getView()
        if (itemView) then view:pushBackCustomItem(itemView) end
    end
end

return ModelWarList
