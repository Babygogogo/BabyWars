
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

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function updateWithModelUnitMap(self)
    local modelUnit = self.m_ModelUnitMap:getModelUnit(self.m_CursorGridIndex)
    if (modelUnit) then
        local loadedModelUnits = self.m_ModelUnitMap:getLoadedModelUnitsWithLoader(modelUnit)
        self.m_ModelUnitList = {modelUnit, unpack(loadedModelUnits or {})}

        if (self.m_View) then
            self.m_View:updateWithModelUnit(modelUnit, loadedModelUnits)
                :setVisible(true)
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

local function onEvtTurnPhaseMain(self, event)
    self.m_ModelPlayer = event.modelPlayer
    updateWithModelUnitMap(self)
end

local function onEvtModelWeatherUpdated(self, event)
    self.m_ModelWeather = event.modelWeather
end

local function onEvtGridSelected(self, event)
    self.m_CursorGridIndex = GridIndexFunctions.clone(event.gridIndex)
    updateWithModelUnitMap(self)
end

local function onEvtMapCursorMoved(self, event)
    self.m_CursorGridIndex = GridIndexFunctions.clone(event.gridIndex)
    updateWithModelUnitMap(self)
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

function ModelUnitInfo:setModelUnitMap(model)
    assert(self.m_ModelUnitMap == nil, "ModelUnitInfo:setModelUnitMap() the model has been set.")
    self.m_ModelUnitMap = model

    return self
end

function ModelUnitInfo:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelUnitInfo:setRootScriptEventDispatcher() the dispatcher has been set.")

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtModelUnitMapUpdated", self)
        :addEventListener("EvtTurnPhaseMain",       self)
        :addEventListener("EvtModelWeatherUpdated", self)
        :addEventListener("EvtGridSelected",        self)
        :addEventListener("EvtMapCursorMoved",      self)

    return self
end

function ModelUnitInfo:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelUnitInfo:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtMapCursorMoved", self)
        :removeEventListener("EvtGridSelected",        self)
        :removeEventListener("EvtModelWeatherUpdated", self)
        :removeEventListener("EvtTurnPhaseMain",       self)
        :removeEventListener("EvtModelUnitMapUpdated", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelUnitInfo:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtModelUnitMapUpdated") then onEvtModelUnitMapUpdated(self, event)
    elseif (eventName == "EvtTurnPhaseMain")       then onEvtTurnPhaseMain(      self, event)
    elseif (eventName == "EvtModelWeatherUpdated") then onEvtModelWeatherUpdated(self, event)
    elseif (eventName == "EvtGridSelected")        then onEvtGridSelected(       self, event)
    elseif (eventName == "EvtMapCursorMoved")      then onEvtMapCursorMoved(     self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelUnitInfo:onPlayerTouch(index)
    if (self.m_ModelUnitDetail) then
        self.m_ModelUnitDetail:updateWithModelUnit(self.m_ModelUnitList[index], self.m_ModelPlayer, self.m_ModelWeather)
            :setEnabled(true)
    end

    return self
end

return ModelUnitInfo
