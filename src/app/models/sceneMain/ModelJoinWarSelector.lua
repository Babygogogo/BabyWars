
local ModelJoinWarSelector = class("ModelJoinWarSelector")

local Actor            = require("global.actors.Actor")
local ActorManager     = require("global.actors.ActorManager")
local WebSocketManager = require("app.utilities.WebSocketManager")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function enableConfirmBoxForJoiningSceneWar(self, warFieldName, fileName)
    self.m_ModelConfirmBox:setConfirmText("You are joining a war:\n" .. warFieldName .. ".\nAre you sure?")
        :setOnConfirmYes(function()
            self.m_RootScriptEventDispatcher:dispatchEvent({
                name       = "EvtPlayerRequestDoAction",
                actionName = "JoinWar",
                fileName   = fileName,
            })
        end)
        :setEnabled(true)
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function getActorWarFieldPreviewer(self)
    if (not self.m_ActorWarFieldPreviewer) then
        local actor = Actor.createWithModelAndViewName("sceneMain.ModelWarFieldPreviewer", nil, "sceneMain.ViewWarFieldPreviewer")

        self.m_ActorWarFieldPreviewer = actor
        if (self.m_View) then
            self.m_View:setViewWarFieldPreviewer(actor:getView())
        end
    end

    return self.m_ActorWarFieldPreviewer
end

local function initWarList(self, list)
    assert(type(list) == "table", "ModelJoinWarSelector-initWarList() failed to require list data from the server.")

    local warList = {}
    for sceneWarFileName, warFieldFileName in pairs(list) do
        warList[#warList + 1] = {
            name     = require("res.data.templateWarField." .. warFieldFileName).warFieldName,
            callback = function()
                -- enableConfirmBoxForJoiningSceneWar(self, warFieldName, sceneWarFileName)
                getActorWarFieldPreviewer(self):getModel():showWarField(warFieldFileName)
                self.m_View:setButtonNextVisible(true)
                self.m_OnButtonNextTouched = function()
                    print("join: " .. sceneWarFileName)
                end
            end,
        }
    end

    self.m_WarList = warList
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelJoinWarSelector:ctor(param)
    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelJoinWarSelector:initView()
    local view = self.m_View
    assert(view, "ModelJoinWarSelector:initView() no view is attached to the actor of the model.")

    view:removeAllItems()

    return self
end

function ModelJoinWarSelector:setModelConfirmBox(model)
    assert(self.m_ModelConfirmBox == nil, "ModelJoinWarSelector:setModelConfirmBox() the model has been set already.")
    self.m_ModelConfirmBox = model

    return self
end

function ModelJoinWarSelector:setModelMainMenu(model)
    assert(self.m_ModelMainMenu == nil, "ModelJoinWarSelector:setModelMainMenu() the model has been set.")
    self.m_ModelMainMenu = model

    return self
end

function ModelJoinWarSelector:setModelMessageIndicator(model)
    assert(self.m_ModelMessageIndicator == nil, "ModelJoinWarSelector:setModelMessageIndicator() the model has been set.")
    self.m_ModelMessageIndicator = model

    return self
end

function ModelJoinWarSelector:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelJoinWarSelector:setRootScriptEventDispatcher() the dispatcher has been set.")
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelJoinWarSelector:doActionGetJoinableWarList(action)
    initWarList(self, action.list)
    if (#self.m_WarList == 0) then
        self.m_ModelMessageIndicator:showMessage("Sorry, but no war is currently joinable. Please wait for or create a new war.")
    elseif ((self.m_View) and (self.m_IsEnabled)) then
        self.m_View:showWarList(self.m_WarList)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelJoinWarSelector:setEnabled(enabled)
    self.m_IsEnabled = enabled

    if (enabled) then
        self.m_RootScriptEventDispatcher:dispatchEvent({
            name = "EvtPlayerRequestDoAction",
            actionName = "GetJoinableWarList",
        })
    end

    if (self.m_View) then
        self.m_View:setVisible(enabled)
            :removeAllItems()
            :setButtonNextVisible(false)
    end

    getActorWarFieldPreviewer(self):getModel():hideWarField()
    return self
end

function ModelJoinWarSelector:onButtonBackTouched()
    self:setEnabled(false)
    self.m_ModelMainMenu:setMenuEnabled(true)

    return self
end

function ModelJoinWarSelector:onButtonNextTouched()
    self.m_OnButtonNextTouched()

    return self
end

return ModelJoinWarSelector
