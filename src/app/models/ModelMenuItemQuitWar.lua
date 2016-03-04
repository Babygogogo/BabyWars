
local ModelMenuItemQuitWar = class("ModelMenuItemQuitWar")

local Actor        = require("global.actors.Actor")
local ActorManager = require("global.actors.ActorManager")
local TypeChecker  = require("app.utilities.TypeChecker")

local TITLE_TEXT   = "Quit"
local CONFIRM_TEXT = "You are quitting the war.\nAre you sure?"

local function onConfirmYes()
    local mainSceneActor = Actor.createWithModelAndViewName("ModelSceneMain", nil, "ViewSceneMain")
    assert(mainSceneActor, "ModelMenuItemQuitWar-onConfirmYes() failed to create a main scene actor.")
    ActorManager.setAndRunRootActor(mainSceneActor, "FADE", 1)
    
    return self
end

local function createConfirmBoxActor(itemModel, warName)
    local boxModel = require("app.models.ModelConfirmBox"):create()
    boxModel:setConfirmText(CONFIRM_TEXT)
    
        :setOnConfirmYes(function()
            onConfirmYes()
        end)
        :setOnConfirmNo(function()
            boxModel:setEnabled(false)
        end)
        :setOnConfirmCancel(function()
            boxModel:setEnabled(false)
        end)
    
    return Actor.createWithModelAndViewInstance(boxModel, require("app.views.ViewConfirmBox"):create())
end

function ModelMenuItemQuitWar:ctor(param)
    if (param) then
        self:load(param)
    end

	return self
end

function ModelMenuItemQuitWar:load(param)
	return self
end

function ModelMenuItemQuitWar.createInstance(param)
	local list = ModelMenuItemQuitWar.new():load(param)
    assert(list, "ModelMenuItemQuitWar.createInstance() failed.")

	return list
end

function ModelMenuItemQuitWar:initView()
    local view = self.m_View
	assert(view, "ModelMenuItemQuitWar:initView() no view is attached to the actor of the model.")

    view:setTitleText(TITLE_TEXT)
    
    return self
end

function ModelMenuItemQuitWar:onPlayerTouch()
    if (self.m_ConfirmBoxActor) then
        self.m_ConfirmBoxActor:getModel():setEnabled(true)
    else
        self.m_ConfirmBoxActor = createConfirmBoxActor(self, self.m_TitleText)
        self.m_View:getScene():addChild(self.m_ConfirmBoxActor:getView())
    end

    return self
end

return ModelMenuItemQuitWar
