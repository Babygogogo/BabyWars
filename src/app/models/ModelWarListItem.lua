
local ModelWarListItem = class("ModelWarListItem")

local COMFIRM_BOX_Z_ORDER = 99

local Actor       = require("global.actors.Actor")
local TypeChecker = require("app.utilities.TypeChecker")

local function createActorConfirmBox(modelItem, warName)
    local modelBox = require("app.models.ModelConfirmBox"):create()
    modelBox:setConfirmText("You are entering a war:\n" .. warName .. ".\nAre you sure?")

        :setOnConfirmYes(function()
            modelItem:onPlayerConfirmEnterWar()
        end)

        :setOnConfirmNo(function()
            modelBox:setEnabled(false)
        end)

        :setOnConfirmCancel(function()
            modelBox:setEnabled(false)
        end)

    return Actor.createWithModelAndViewInstance(modelBox, require("app.views.ViewConfirmBox"):create())
end

function ModelWarListItem:ctor(param)
    if (param) then self:load(param) end

	return self
end

function ModelWarListItem:load(param)
    assert(type(param) == "table", "ModelWarListItem:load() the param is not a table.")

    self.m_Title = param.name
    self.m_Data = param.data

    if (self.m_View) then self:initView() end

	return self
end

function ModelWarListItem.createInstance(param)
	local list = ModelWarListItem.new():load(param)
    assert(list, "ModelWarListItem.createInstance() failed.")

	return list
end

function ModelWarListItem:initView()
    local view = self.m_View
	assert(view, "ModelWarListItem:initView() no view is attached to the actor of the model.")

    view:setTitleText(self.m_Title)

    return self
end

function ModelWarListItem:onPlayerTouch()
    if (self.m_ActorConfirmBox) then
        self.m_ActorConfirmBox:getModel():setEnabled(true)
    else
        self.m_ActorConfirmBox = createActorConfirmBox(self, self.m_Title)
        self.m_View:getScene():addChild(self.m_ActorConfirmBox:getView(), COMFIRM_BOX_Z_ORDER)
    end

    return self
end

function ModelWarListItem:onPlayerConfirmEnterWar()
    local sceneWarActor = Actor.createWithModelAndViewName("ModelSceneWar", self.m_Data, "ViewSceneWar")
    require("global.actors.ActorManager").setAndRunRootActor(sceneWarActor, "FADE", 1)

    return self
end

return ModelWarListItem
