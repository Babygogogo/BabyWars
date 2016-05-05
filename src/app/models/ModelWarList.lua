
--[[--------------------------------------------------------------------------------
-- ModelWarList是主场景中的“已参战、未结束的战局”的列表。
--
-- 主要职责和使用场景举例：
--   构造并显示上述战局列表
--
-- 其他：
--   目前ModelWarList里的列表项是直接从本地获取的（res/data/warScene/WarSceneList.lua）。在联机功能下，该列表应该从服务器获取。
--]]--------------------------------------------------------------------------------

local ModelWarList = class("ModelWarList")

local Actor            = require("global.actors.Actor")
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

--------------------------------------------------------------------------------
-- The composition item actors.
--------------------------------------------------------------------------------
local function createItemActors(param)
    local listData = requireListData(param)
    assert(type(listData) == "table", "ModelWarList-createItemActors() failed to require list data from with param.")

    local actors = {}
    for _, itemData in ipairs(listData) do
        local actor = Actor.createWithModelAndViewName("ModelWarListItem", itemData, "ViewWarListItem", itemData)
        assert(actor, "ModelWarList-createItemActors() failed to create a item actor.")

        actors[#actors + 1] = actor
    end

    return actors
end

local function initWithItemActors(model, actors)
    model.m_ItemActors = actors
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelWarList:ctor(param)
    initWithItemActors(self, createItemActors(param))

    if (self.m_View) then
        self:initView()
    end

	return self
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
