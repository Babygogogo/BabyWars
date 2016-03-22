
local ModelSceneMain = class("ModelSceneMain")

local Actor	= require("global.actors.Actor")

--------------------------------------------------------------------------------
-- The composition war list actor.
--------------------------------------------------------------------------------
local function createWarListActor(mapListData)
    return Actor.createWithModelAndViewName("ModelWarList", mapListData, "ViewWarList", mapListData)
end

local function initWithWarListActor(model, actor)
    model.m_WarListActor = actor
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelSceneMain:ctor(param)
    initWithWarListActor(self, createWarListActor("WarSceneList"))

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelSceneMain:initView()
    local view = self.m_View
    assert(view, "ModelSceneMain:initView() no view is attached to the owner actor of the model.")

    view:setWarListView(self.m_WarListActor:getView())

    return self
end

return ModelSceneMain
