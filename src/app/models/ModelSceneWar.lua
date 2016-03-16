
local ModelSceneWar = class("ModelSceneWar")

local Actor       = require("global.actors.Actor")
local TypeChecker = require("app.utilities.TypeChecker")

local function createNodeEventHandler(model, rootActor)
    return function(event)
        if (event == "enter") then
            model:onEnter(rootActor)
        elseif (event == "cleanup") then
            model:onCleanup(rootActor)
        end
    end
end

local function requireSceneData(param)
    local t = type(param)
    if (t == "table") then
        return param
    elseif (t == "string") then
        return require("res.data.warScene." .. param)
    else
        error("ModelSceneWar-requireSceneData() the param is invalid.")
	end
end

local function createChildrenActors(param)
	local sceneData = requireSceneData(param)
	assert(TypeChecker.isWarSceneData(sceneData))

    local warFieldActor = Actor.createWithModelAndViewName("ModelWarField", sceneData.WarField, "ViewWarField", sceneData.WarField)
	assert(warFieldActor, "SceneWar--createChildrenActors() failed to create a WarField actor.")

    local hudActor = Actor.createWithModelAndViewName("ModelSceneWarHUD", nil, "ViewSceneWarHUD")
    assert(hudActor, "SceneWar--createChildrenActors() failed to create a HUD actor.")

	return {warFieldActor = warFieldActor, sceneWarHUDActor = hudActor}
end

local function initWithChildrenActors(model, actors)
    model.m_WarFieldActor    = actors.warFieldActor
    model.m_SceneWarHUDActor = actors.sceneWarHUDActor
end

local function getTouchableChildrenViews(model)
    local views = {}
    local getTouchableViewFromActor = require("app.utilities.GetTouchableViewFromActor")

    -- TODO: Add more children views. Be careful of the order of the views!
    views[#views + 1] = getTouchableViewFromActor(model.m_WarFieldActor)

    return views
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelSceneWar:ctor(param)
    self.m_ScriptEventDispatcher = require("global.events.EventDispatcher"):create()

    if (param) then
        self:load(param)
    end

    return self
end

function ModelSceneWar:load(param)
    self.m_ScriptEventDispatcher:reset()
    initWithChildrenActors(self, createChildrenActors(param))

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelSceneWar.createInstance(param)
    local model = ModelSceneWar:create():load(param)
    assert(model, "ModelSceneWar.createInstance() failed.")

    return model
end

function ModelSceneWar:initView()
    local view = self.m_View
    assert(view, "ModelSceneWar:initView() no view is attached.")

    view:setWarFieldView(self.m_WarFieldActor:getView())
        :setSceneHudView(self.m_SceneWarHUDActor:getView())

        :initTouchListener(getTouchableChildrenViews(self))
        :registerScriptHandler(createNodeEventHandler(self, self.m_Actor))

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node events.
--------------------------------------------------------------------------------
function ModelSceneWar:onEnter(rootActor)
    print("ModelSceneWar:onEnter()")

    self.m_SceneWarHUDActor:onEnter(rootActor)
    self.m_WarFieldActor:onEnter(rootActor)

    return self
end

function ModelSceneWar:onCleanup(rootActor)
    print("ModelSceneWar:onCleanup()")

    self.m_SceneWarHUDActor:onCleanup(rootActor)
    self.m_WarFieldActor:onCleanup(rootActor)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelSceneWar:getScriptEventDispatcher()
    return self.m_ScriptEventDispatcher
end

return ModelSceneWar
