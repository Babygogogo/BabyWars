
--[[--------------------------------------------------------------------------------
-- ModelUnitInfo是战局场景里的unit的简要属性框（即场景下方的小框）。
--
-- 主要职责和使用场景举例：
--   - 构造和显示unit的简要属性框。
--   - 自身被点击时，呼出unit的详细属性页面。
--
-- 其他：
--  - 本类所显示的是光标所指向的unit的信息（通过event获知光标指向的是哪个unit）
--]]--------------------------------------------------------------------------------

local ModelUnitInfo = class("ModelUnitInfo")

local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")
local SingletonGetters   = require("src.app.utilities.SingletonGetters")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function updateWithModelUnitMap(self)
    local modelUnitMap = SingletonGetters.getModelUnitMap()
    local modelUnit    = modelUnitMap:getModelUnit(self.m_CursorGridIndex)
    if (modelUnit) then
        local loadedModelUnits = modelUnitMap:getLoadedModelUnitsWithLoader(modelUnit)
        self.m_ModelUnitList = {modelUnit, unpack(loadedModelUnits or {})}

        if (self.m_View) then
            self.m_View:updateWithModelUnit(modelUnit, loadedModelUnits)
                :setVisible(not SingletonGetters.getModelWarCommandMenu():isEnabled())
        end
    elseif (self.m_View) then
        self.m_View:setVisible(false)
    end
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtModelUnitMapUpdated(self, event)
    updateWithModelUnitMap(self)
end

local function onEvtGridSelected(self, event)
    self.m_CursorGridIndex = GridIndexFunctions.clone(event.gridIndex)
    updateWithModelUnitMap(self)
end

local function onEvtMapCursorMoved(self, event)
    self.m_CursorGridIndex = GridIndexFunctions.clone(event.gridIndex)
    updateWithModelUnitMap(self)
end

local function onEvtWarCommandMenuUpdated(self, event)
    if (event.modelWarCommandMenu:isEnabled()) then
        if (self.m_View) then
            self.m_View:setVisible(false)
        end
    else
        updateWithModelUnitMap(self)
    end
end

local function onEvtHideUI(self, event)
    if (self.m_View) then
        self.m_View:setVisible(false)
    end
end

local function onEvtPlayerIndexUpdated(self, event)
    if (self.m_View) then
        self.m_View:updateWithPlayerIndex(event.playerIndex)
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelUnitInfo:ctor(param)
    self.m_CursorGridIndex = {x = 1, y = 1}

    return self
end

function ModelUnitInfo:setModelUnitDetail(model)
    assert(self.m_ModelUnitDetail == nil, "ModelUnitInfo:setModelUnitDetail() the model has been set.")
    self.m_ModelUnitDetail = model

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelUnitInfo:onStartRunning(sceneWarFileName)
    SingletonGetters.getScriptEventDispatcher()
        :addEventListener("EvtModelUnitMapUpdated",   self)
        :addEventListener("EvtGridSelected",          self)
        :addEventListener("EvtMapCursorMoved",        self)
        :addEventListener("EvtWarCommandMenuUpdated", self)
        :addEventListener("EvtHideUI",                self)
        :addEventListener("EvtPlayerIndexUpdated",    self)

    if (self.m_View) then
        self.m_View:updateWithPlayerIndex(SingletonGetters.getModelTurnManager():getPlayerIndex())
    end

    updateWithModelUnitMap(self)

    return self
end

function ModelUnitInfo:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtModelUnitMapUpdated")   then onEvtModelUnitMapUpdated(  self, event)
    elseif (eventName == "EvtGridSelected")          then onEvtGridSelected(         self, event)
    elseif (eventName == "EvtMapCursorMoved")        then onEvtMapCursorMoved(       self, event)
    elseif (eventName == "EvtWarCommandMenuUpdated") then onEvtWarCommandMenuUpdated(self, event)
    elseif (eventName == "EvtHideUI")                then onEvtHideUI(               self, event)
    elseif (eventName == "EvtPlayerIndexUpdated")    then onEvtPlayerIndexUpdated(   self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelUnitInfo:onPlayerTouch(index)
    if (self.m_ModelUnitDetail) then
        self.m_ModelUnitDetail:updateWithModelUnit(self.m_ModelUnitList[index])
            :setEnabled(true)
    end

    return self
end

return ModelUnitInfo
