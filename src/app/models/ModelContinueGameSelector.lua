
--[[--------------------------------------------------------------------------------
-- ModelContinueGameSelector是主场景中的“已参战、未结束的战局”的列表。
--
-- 主要职责和使用场景举例：
--   构造并显示上述战局列表
--
-- 其他：
--   目前ModelContinueGameSelector里的列表项是直接从本地获取的（res/data/warScene/WarSceneList.lua）。在联机功能下，该列表应该从服务器获取。
--]]--------------------------------------------------------------------------------

local ModelContinueGameSelector = class("ModelContinueGameSelector")

local Actor            = require("global.actors.Actor")
local ActorManager     = require("global.actors.ActorManager")
local WebSocketManager = require("app.utilities.WebSocketManager")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function enableConfirmBoxForEnteringSceneWar(self, name, fileName)
    self.m_ModelConfirmBox:setConfirmText("You are entering a war:\n" .. name .. ".\nAre you sure?")
        :setOnConfirmYes(function()
            self.m_RootScriptEventDispatcher:dispatchEvent({
                name = "EvtPlayerRequestDoAction",
                actionName = "GetSceneWarData",
                fileName = fileName
            })
        end)
        :setEnabled(true)
end

--------------------------------------------------------------------------------
-- The composition list items.
--------------------------------------------------------------------------------
local function createListItems(self, list)
    assert(type(list) == "table", "ModelContinueGameSelector-createListItems() failed to require list data from with param.")

    local items = {}
    for i, item in ipairs(list) do
        items[i] = {
            name     = item.name,
            callback = function()
                -- TODO: get the war scene data from the server.
                enableConfirmBoxForEnteringSceneWar(self, item.name, item.fileName)
            end,
        }
    end

    return items
end

local function initWithListItems(self, items)
    self.m_ListItems = items
end

--------------------------------------------------------------------------------
-- The back item.
--------------------------------------------------------------------------------
local function createItemBack(self)
    return {
        name     = "back",
        callback = function()
            self:setEnabled(false)
            self.m_ModelMainMenu:setMenuEnabled(true)
        end,
    }
end

local function initWithItemBack(self, item)
    self.m_ItemBack = item
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelContinueGameSelector:ctor(param)
    initWithItemBack(self, createItemBack(self))

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelContinueGameSelector:initView()
    local view = self.m_View
    assert(view, "ModelContinueGameSelector:initView() no view is attached to the actor of the model.")

    view:removeAllItems()
        :setButtonBack(self.m_ItemBack)

    return self
end

function ModelContinueGameSelector:setModelConfirmBox(model)
    assert(self.m_ModelConfirmBox == nil, "ModelContinueGameSelector:setModelConfirmBox() the model has been set already.")
    self.m_ModelConfirmBox = model

    return self
end

function ModelContinueGameSelector:setModelMainMenu(model)
    assert(self.m_ModelMainMenu == nil, "ModelContinueGameSelector:setModelMainMenu() the model has been set.")
    self.m_ModelMainMenu = model

    return self
end

function ModelContinueGameSelector:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelContinueGameSelector:setRootScriptEventDispatcher() the dispatcher has been set.")
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelContinueGameSelector:doActionLogin(action)
    self:setEnabled(false)

    return self
end

function ModelContinueGameSelector:doActionGetOngoingWarList(action)
    initWithListItems(self, createListItems(self, action.list))
    if ((self.m_View) and (self.m_IsEnabled)) then
        self.m_View:showWarList(self.m_ListItems)
    end

    return self
end

function ModelContinueGameSelector:doActionGetSceneWarData(action)
    if (self.m_IsEnabled) then
        local actorSceneWar = Actor.createWithModelAndViewName("ModelSceneWar", action.data, "ViewSceneWar")
        WebSocketManager.setOwner(actorSceneWar:getModel())
        ActorManager.setAndRunRootActor(actorSceneWar, "FADE", 1)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelContinueGameSelector:setEnabled(enabled)
    self.m_IsEnabled = enabled

    if (enabled) then
        self.m_RootScriptEventDispatcher:dispatchEvent({
            name = "EvtPlayerRequestDoAction",
            actionName = "GetOngoingWarList",
        })
    end

    if (self.m_View) then
        self.m_View:setVisible(enabled)
            :removeAllItems()
    end

    return self
end

return ModelContinueGameSelector
