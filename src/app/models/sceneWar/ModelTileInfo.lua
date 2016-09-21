
--[[--------------------------------------------------------------------------------
-- ModelTileInfo是战局场景里的tile的简要属性框（即场景下方的小框）。
--
-- 主要职责和使用场景举例：
--   - 构造和显示tile的简要属性框。
--   - 自身被点击时，呼出tile的详细属性页面。
--
-- 其他：
--  - 本类所显示的是光标所指向的tile的信息（通过event获知光标指向的是哪个tile）
--]]--------------------------------------------------------------------------------

local ModelTileInfo = class("ModelTileInfo")

local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")
local SingletonGetters   = require("src.app.utilities.SingletonGetters")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function updateWithModelTile(self, modelTile)
    self.m_ModelTile = modelTile

    if (self.m_View) then
        self.m_View:updateWithModelTile(modelTile)
            :setVisible(true)
    end
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtModelTileMapUpdated(self, event)
    updateWithModelTile(self, SingletonGetters.getModelTileMap():getModelTile(self.m_CursorGridIndex))
end

local function onEvtMapCursorMoved(self, event)
    if (self.m_View) then
        self.m_View:setVisible(true)
    end

    local gridIndex = event.gridIndex
    if (not GridIndexFunctions.isEqual(gridIndex, self.m_CursorGridIndex)) then
        self.m_CursorGridIndex = GridIndexFunctions.clone(gridIndex)
        updateWithModelTile(self, SingletonGetters.getModelTileMap():getModelTile(gridIndex))
    end
end

local function onEvtGridSelected(self, event)
    onEvtMapCursorMoved(self, event)
end

local function onEvtWarCommandMenuUpdated(self, event)
    if (self.m_View) then
        self.m_View:setVisible(not event.isEnabled)
    end
end

local function onEvtPlayerIndexUpdated(self, event)
    if (self.m_View) then
        self.m_View:updateWithPlayerIndex(event.playerIndex)
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
    assert(self.m_ModelTileDetail == nil, "ModelTileInfo:setModelTileDetail() the model has been set.")
    self.m_ModelTileDetail = model

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelTileInfo:onStartRunning(sceneWarFileName)
    SingletonGetters.getScriptEventDispatcher()
        :addEventListener("EvtModelTileMapUpdated",   self)
        :addEventListener("EvtMapCursorMoved",        self)
        :addEventListener("EvtGridSelected",          self)
        :addEventListener("EvtWarCommandMenuUpdated", self)
        :addEventListener("EvtPlayerIndexUpdated",    self)

    updateWithModelTile(self, SingletonGetters.getModelTileMap():getModelTile(self.m_CursorGridIndex))

    return self
end

function ModelTileInfo:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtModelTileMapUpdated")       then onEvtModelTileMapUpdated(      self, event)
    elseif (eventName == "EvtMapCursorMoved")            then onEvtMapCursorMoved(           self, event)
    elseif (eventName == "EvtGridSelected")              then onEvtGridSelected(             self, event)
    elseif (eventName == "EvtWarCommandMenuUpdated")     then onEvtWarCommandMenuUpdated(    self, event)
    elseif (eventName == "EvtPlayerIndexUpdated")        then onEvtPlayerIndexUpdated(       self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelTileInfo:onPlayerTouch()
    if (self.m_ModelTileDetail) then
        self.m_ModelTileDetail:updateWithModelTile(self.m_ModelTile)
            :setEnabled(true)
    end

    return self
end

return ModelTileInfo
