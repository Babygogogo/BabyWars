
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
local ActorManager = require("global.actors.ActorManager")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
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

local function enableConfirmBoxForEnteringSceneWar(self, name, data)
    self.m_ModelConfirmBox:setConfirmText("You are entering a war:\n" .. name .. ".\nAre you sure?")
        :setOnConfirmYes(function()
            local actorSceneWar = Actor.createWithModelAndViewName("ModelSceneWar", data, "ViewSceneWar")
            ActorManager.setAndRunRootActor(actorSceneWar, "FADE", 1)
        end)
        :setEnabled(true)
end

--------------------------------------------------------------------------------
-- The composition list items.
--------------------------------------------------------------------------------
local function createListItems(self, param)
    local listData = requireListData(param)
    assert(type(listData) == "table", "ModelWarList-createListItems() failed to require list data from with param.")

    local items = {}
    for _, itemData in ipairs(listData) do
        items[#items + 1] = {
            name     = itemData.name,
            data     = itemData.data,
            callback = function()
                enableConfirmBoxForEnteringSceneWar(self, itemData.name, itemData.data)
            end,
        }
    end

    return items
end

local function initWithListItems(self, items)
    self.m_ListItems = items
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelWarList:ctor(param)
    initWithListItems(self, createListItems(self, param))

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelWarList:initView()
    local view = self.m_View
    assert(view, "ModelWarList:initView() no view is attached to the actor of the model.")

    view:removeAllItems()
        :showWarList(self.m_ListItems)

    return self
end

function ModelWarList:setModelConfirmBox(model)
    assert(self.m_ModelConfirmBox == nil, "ModelWarList:setModelConfirmBox() the model has been set already.")
    self.m_ModelConfirmBox = model

    return self
end

return ModelWarList
