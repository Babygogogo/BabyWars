
local ModelTileInfo = class("ModelTileInfo")

local function onEvtPlayerTouchTile(model, event)
    model.m_ModelTile = event.tileModel

    if (model.m_View) then
        model.m_View:updateWithModelTile(event.tileModel)
        model.m_View:setVisible(true)
    end
end

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
        self.m_View:getScene():addChild(self.m_DetailActor:getView())
    end

    local modelDetail = self.m_DetailActor:getModel()
    modelDetail:updateWithModelTile(self.m_ModelTile)
        :setEnabled(true)

    return self
end

return ModelTileInfo
