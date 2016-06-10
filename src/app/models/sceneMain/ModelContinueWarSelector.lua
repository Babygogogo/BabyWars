
--[[--------------------------------------------------------------------------------
-- ModelContinueWarSelector是主场景中的“已参战、未结束的战局”的列表。
--
-- 主要职责和使用场景举例：
--   构造并显示上述战局列表
--
-- 其他：
--   目前ModelContinueWarSelector里的列表项是直接从本地获取的（res/data/warScene/WarSceneList.lua）。在联机功能下，该列表应该从服务器获取。
--]]--------------------------------------------------------------------------------

local ModelContinueWarSelector = class("ModelContinueWarSelector")

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
                name       = "EvtPlayerRequestDoAction",
                actionName = "GetSceneWarData",
                fileName   = fileName,
            })
        end)
        :setEnabled(true)
end

--------------------------------------------------------------------------------
-- The composition war list.
--------------------------------------------------------------------------------
local function initWarList(self, list)
    assert(type(list) == "table", "ModelContinueWarSelector-initWarList() failed to require list data from the server.")

    local warList = {}
    for i, item in ipairs(list) do
        warList[i] = {
            name     = item.name,
            callback = function()
                -- TODO: get the war scene data from the server.
                enableConfirmBoxForEnteringSceneWar(self, item.name, item.fileName)
            end,
        }
    end

    self.m_WarList = warList
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelContinueWarSelector:ctor(param)
    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelContinueWarSelector:initView()
    local view = self.m_View
    assert(view, "ModelContinueWarSelector:initView() no view is attached to the actor of the model.")

    view:removeAllItems()

    return self
end

function ModelContinueWarSelector:setModelConfirmBox(model)
    assert(self.m_ModelConfirmBox == nil, "ModelContinueWarSelector:setModelConfirmBox() the model has been set already.")
    self.m_ModelConfirmBox = model

    return self
end

function ModelContinueWarSelector:setModelMainMenu(model)
    assert(self.m_ModelMainMenu == nil, "ModelContinueWarSelector:setModelMainMenu() the model has been set.")
    self.m_ModelMainMenu = model

    return self
end

function ModelContinueWarSelector:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelContinueWarSelector:setRootScriptEventDispatcher() the dispatcher has been set.")
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelContinueWarSelector:doActionGetOngoingWarList(action)
    initWarList(self, action.list)
    if ((self.m_View) and (self.m_IsEnabled)) then
        self.m_View:showWarList(self.m_WarList)
    end

    return self
end

function ModelContinueWarSelector:doActionGetSceneWarData(action)
    if (self.m_IsEnabled) then
        local actorSceneWar = Actor.createWithModelAndViewName("sceneWar.ModelSceneWar", action.data, "sceneWar.ViewSceneWar")
        WebSocketManager.setOwner(actorSceneWar:getModel())
        ActorManager.setAndRunRootActor(actorSceneWar, "FADE", 1)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelContinueWarSelector:setEnabled(enabled)
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

function ModelContinueWarSelector:onButtonBackTouched()
    self:setEnabled(false)
    self.m_ModelMainMenu:setMenuEnabled(true)

    return self
end

return ModelContinueWarSelector
