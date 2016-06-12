
local ModelNewWarCreator = class("ModelNewWarCreator")

local Actor        = require("global.actors.Actor")
local WarFieldList = require("res.data.templateWarField.WarFieldList")

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

local function initWarFieldList(self, list)
    local list = {}
    for warFieldFileName, warFieldName in pairs(WarFieldList) do
        list[#list + 1] = {
            name     = warFieldName,
            callback = function()
                getActorWarFieldPreviewer(self):getModel():showWarField(warFieldFileName)
                self.m_View:setButtonNextVisible(true)
                self.m_OnButtonNextTouched = function()
                    -- TODO: enable the player to customize the settings of the game.
                    self.m_RootScriptEventDispatcher:dispatchEvent({
                        name             = "EvtPlayerRequestDoAction",
                        actionName       = "NewWar",
                        warFieldFileName = warFieldFileName,
                        playerIndex      = 1,
                        skillIndex       = 1,
                    })
                end
            end,
        }
    end

    self.m_ItemListWarField = list
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelNewWarCreator:ctor(param)
    initWarFieldList(self)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelNewWarCreator:initView()
    local view = self.m_View
    assert(view, "ModelNewWarCreator:initView() no view is attached to the actor of the model.")

    view:removeAllItems()
        :showListWarField(self.m_ItemListWarField)

    return self
end

function ModelNewWarCreator:setModelMainMenu(model)
    assert(self.m_ModelMainMenu == nil, "ModelNewWarCreator:setModelMainMenu() the model has been set.")
    self.m_ModelMainMenu = model

    return self
end

function ModelNewWarCreator:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelNewWarCreator:setRootScriptEventDispatcher() the dispatcher has been set.")
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelNewWarCreator:setEnabled(enabled)
    getActorWarFieldPreviewer(self):getModel():hideWarField()
    if (self.m_View) then
        self.m_View:setVisible(enabled)
            :setButtonNextVisible(false)
    end

    return self
end

function ModelNewWarCreator:onButtonBackTouched()
    self:setEnabled(false)
    self.m_ModelMainMenu:setMenuEnabled(true)

    return self
end

function ModelNewWarCreator:onButtonNextTouched()
    self.m_OnButtonNextTouched()

    return self
end

return ModelNewWarCreator
