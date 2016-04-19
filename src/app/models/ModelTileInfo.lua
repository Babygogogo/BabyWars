
local ModelTileInfo = class("ModelTileInfo")

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtPlayerTouchTile(self, event)
    self.m_ModelTile = event.modelTile

    if (self.m_View) then
        self.m_View:updateWithModelTile(event.modelTile)
            :setVisible(true)
    end
end

local function onEvtPlayerMovedCursor(self, event)
    self.m_CursorGridIndex = GridIndexFunctions.clone(event.gridIndex)
end

local function onEvtPlayerSelectedGrid(self, event)
    self.m_CursorGridIndex = GridIndexFunctions.clone(event.gridIndex)
end

local function onEvtModelTileUpdated(self, event)
    if ((GridIndexFunctions.isEqual(self.m_CursorGridIndex, event.modelTile:getGridIndex())) and (self.m_View)) then
        self.m_View:updateWithModelTile(self.m_ModelTile)
    end
end

--------------------------------------------------------------------------------
-- The contructor and initializers.
--------------------------------------------------------------------------------
function ModelTileInfo:ctor(param)
    self.m_CursorGridIndex = {x = 1, y = 1}

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
        :addEventListener("EvtWeatherChanged",     self)
        :addEventListener("EvtPlayerMovedCursor",  self)
        :addEventListener("EvtPlayerSelectedGrid", self)
        :addEventListener("EvtModelTileUpdated",   self)

    return self
end

function ModelTileInfo:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtModelTileUpdated", self)
        :removeEventListener("EvtPlayerSelectedGrid", self)
        :removeEventListener("EvtPlayerMovedCursor", self)
        :removeEventListener("EvtWeatherChanged",    self)
        :removeEventListener("EvtPlayerTouchTile",   self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelTileInfo:onEvent(event)
    local eventName = event.name
    if (eventName == "EvtPlayerTouchTile") then
        onEvtPlayerTouchTile(self, event)
    elseif (eventName == "EvtWeatherChanged") then
        self.m_Weather = event.weather
    elseif (eventName == "EvtPlayerMovedCursor") then
        onEvtPlayerMovedCursor(self, event)
    elseif (eventName == "EvtPlayerSelectedGrid") then
        onEvtPlayerSelectedGrid(self, event)
    elseif (eventName == "EvtModelTileUpdated") then
        onEvtModelTileUpdated(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelTileInfo:onPlayerTouch()
    if (self.m_TileDetailModel) then
        self.m_TileDetailModel:updateWithModelTile(self.m_ModelTile, self.m_Weather)
            :setEnabled(true)
    end

    return self
end

return ModelTileInfo
