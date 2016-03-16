
local ModelTileInfo = class("ModelTileInfo")

local TILE_DETAIL_Z_ORDER = 2

local function onEvtPlayerTouchTile(model, event)
    model.m_ModelTile = event.tileModel

    if (model.m_View) then
        model.m_View:updateWithModelTile(event.tileModel)
        model.m_View:setVisible(true)
    end
end

--------------------------------------------------------------------------------
-- The contructor.
--------------------------------------------------------------------------------
function ModelTileInfo:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function ModelTileInfo:load(param)
    return self
end

function ModelTileInfo.createInstance(param)
    local model = ModelTileInfo.new():load(param)
    assert(model, "ModelTileInfo.createInstance() failed.")

    return model
end

function ModelTileInfo:initView()
    local view = self.m_View
    assert(view, "ModelTileInfo:initView() no view is attached to the owner actor of the model.")

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelTileInfo:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtPlayerTouchTile", self)

    return self
end

function ModelTileInfo:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtPlayerTouchTile", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelTileInfo:onEvent(event)
    if (event.name == "EvtPlayerTouchTile") then
        onEvtPlayerTouchTile(self, event)
    end

    return self
end

function ModelTileInfo:onPlayerTouch()
    if (not self.m_DetailActor) then
        self.m_DetailActor = require("global.actors.Actor").createWithModelAndViewName("ModelTileDetail", nil, "ViewTileDetail")
        self.m_View:getScene():addChild(self.m_DetailActor:getView(), TILE_DETAIL_Z_ORDER)
    end

    local modelDetail = self.m_DetailActor:getModel()
    modelDetail:updateWithModelTile(self.m_ModelTile)
        :setEnabled(true)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelTileInfo:adjustPositionOnTouch(touch)
    if (self.m_View) then
        self.m_View:adjustPositionOnTouch(touch)
    end

    return self
end

return ModelTileInfo
