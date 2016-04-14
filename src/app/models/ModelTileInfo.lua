
local ModelTileInfo = class("ModelTileInfo")

local function onEvtPlayerTouchTile(model, event)
    model.m_ModelTile = event.tileModel

    if (model.m_View) then
        model.m_View:updateWithModelTile(event.tileModel)
        model.m_View:setVisible(true)
    end
end

--------------------------------------------------------------------------------
-- The contructor and initializers.
--------------------------------------------------------------------------------
function ModelTileInfo:ctor(param)
    return self
end

function ModelTileInfo:setModelTileDetail(model)
    self.m_TileDetailModel = model

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelTileInfo:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtPlayerTouchTile", self)
        :addEventListener("EvtWeatherChanged", self)

    return self
end

function ModelTileInfo:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtWeatherChanged", self)
        :removeEventListener("EvtPlayerTouchTile", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelTileInfo:onEvent(event)
    if (event.name == "EvtPlayerTouchTile") then
        onEvtPlayerTouchTile(self, event)
    elseif (event.name == "EvtWeatherChanged") then
        self.m_Weather = event.weather
    end

    return self
end

function ModelTileInfo:onPlayerTouch()
    if (self.m_TileDetailModel) then
        self.m_TileDetailModel:updateWithModelTile(self.m_ModelTile, self.m_Weather)
            :setEnabled(true)
    end

    return self
end

return ModelTileInfo
