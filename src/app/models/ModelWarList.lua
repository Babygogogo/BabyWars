
local ModelWarList = class("ModelWarList")

local Actor            = require("global.actors.Actor")
local ViewWarListItem  = require("app.views.ViewWarListItem")
local ModelWarListItem = require("app.models.ModelWarListItem")
local TypeChecker      = require("app.utilities.TypeChecker")

local function requireListData(param)
    local t = type(param)
    if (t == "table") then
        return param
    elseif (t == "string") then
        return require("res.data.warScene." .. param)
    else
        return nil
    end
end

local function createChildrenActors(param)
    local listData = requireListData(param)
    assert(type(listData) == "table", "ModelWarList--createChildrenActors() failed to require list data from with param.")
    
    local actors = {}
    for _, itemData in ipairs(listData) do
        local actor = Actor.createWithModelAndViewName("ModelWarListItem", itemData, "ViewWarListItem", itemData)
        assert(actor, "ModelWarList--createChildrenActors() failed to create a item actor.")

        actors[#actors + 1] = actor
    end
    
    return actors
end

function ModelWarList:ctor(param)
    if (param) then self:load(param) end

	return self
end

function ModelWarList:load(param)
    local childrenActors = createChildrenActors(param)
    assert(childrenActors, "ModelWarList:load() failed.")

    self.m_ItemActors = childrenActors
    
    if (self.m_View) then self:initView() end
		
	return self
end

function ModelWarList.createInstance(param)
	local list = ModelWarList.new():load(param)
    assert(list, "ModelWarList.createInstance() failed.")

	return list
end

function ModelWarList:initView()
    local view = self.m_View
	assert(view, "ModelWarList:initView() no view is attached to the actor of the model.")
    
    view:removeAllItems()
    for _, itemActor in ipairs(self.m_ItemActors) do
        local itemView = itemActor:getView()
        if (itemView) then view:pushBackItem(itemView) end
    end
end

return ModelWarList
