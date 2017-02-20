
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

local GridIndexFunctions = requireBW("src.app.utilities.GridIndexFunctions")
local SingletonGetters   = requireBW("src.app.utilities.SingletonGetters")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function updateWithModelTileMap(self)
    local menu = self.m_ModelWarCommandMenu
    if ((menu:isEnabled()) or (menu:isHiddenWithHideUI())) then
        self.m_View:setVisible(false)
    else
        local modelTile = SingletonGetters.getModelTileMap(self.m_ModelSceneWar):getModelTile(self.m_CursorGridIndex)
        self.m_View:updateWithModelTile(modelTile)
            :setVisible(true)
    end
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtModelTileMapUpdated(self, event)
    updateWithModelTileMap(self)
end

local function onEvtMapCursorMoved(self, event)
    self.m_CursorGridIndex = GridIndexFunctions.clone(event.gridIndex)
    updateWithModelTileMap(self)
end

local function onEvtGridSelected(self, event)
    self.m_CursorGridIndex = GridIndexFunctions.clone(event.gridIndex)
    updateWithModelTileMap(self)
end

local function onEvtWarCommandMenuUpdated(self, event)
    updateWithModelTileMap(self)
end

local function onEvtPlayerIndexUpdated(self, event)
    self.m_View:updateWithPlayerIndex(event.playerIndex)
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
function ModelTileInfo:onStartRunning(modelSceneWar)
    self.m_ModelSceneWar       = modelSceneWar
    self.m_ModelWarCommandMenu = SingletonGetters.getModelWarCommandMenu(modelSceneWar)
    SingletonGetters.getScriptEventDispatcher(modelSceneWar)
        :addEventListener("EvtModelTileMapUpdated",   self)
        :addEventListener("EvtMapCursorMoved",        self)
        :addEventListener("EvtGridSelected",          self)
        :addEventListener("EvtWarCommandMenuUpdated", self)
        :addEventListener("EvtPlayerIndexUpdated",    self)

    if (self.m_View) then
        self.m_View:updateWithPlayerIndex(SingletonGetters.getModelTurnManager(modelSceneWar):getPlayerIndex())
    end

    updateWithModelTileMap(self)

    return self
end

function ModelTileInfo:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtModelTileMapUpdated")   then onEvtModelTileMapUpdated(  self, event)
    elseif (eventName == "EvtMapCursorMoved")        then onEvtMapCursorMoved(       self, event)
    elseif (eventName == "EvtGridSelected")          then onEvtGridSelected(         self, event)
    elseif (eventName == "EvtWarCommandMenuUpdated") then onEvtWarCommandMenuUpdated(self, event)
    elseif (eventName == "EvtPlayerIndexUpdated")    then onEvtPlayerIndexUpdated(   self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelTileInfo:onPlayerTouch()
    if (self.m_ModelTileDetail) then
        local modelTile = SingletonGetters.getModelTileMap(self.m_ModelSceneWar):getModelTile(self.m_CursorGridIndex)
        self.m_ModelTileDetail:updateWithModelTile(modelTile)
            :setEnabled(true)
    end

    return self
end

return ModelTileInfo
