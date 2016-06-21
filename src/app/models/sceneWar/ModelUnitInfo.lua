
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

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function updateWithModelUnit(self, modelUnit)
    self.m_ModelUnit = modelUnit

    if (self.m_View) then
        self.m_View:updateWithModelUnit(modelUnit)
            :setVisible(true)
    end
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtPreviewModelUnit(self, event)
    local modelUnit = event.modelUnit
    self.m_CursorGridIndex = GridIndexFunctions.clone(modelUnit:getGridIndex())
    updateWithModelUnit(self, modelUnit)
end

local function onEvtPreviewNoModelUnit(self, event)
    self.m_CursorGridIndex = GridIndexFunctions.clone(event.gridIndex)

    if (self.m_View) then
        self.m_View:setVisible(false)
    end
end

local function onEvtDestroyModelUnit(self, event)
    if (GridIndexFunctions.isEqual(self.m_CursorGridIndex, event.gridIndex) and (self.m_View)) then
        self.m_View:setVisible(false)
    end
end

local function onEvtModelUnitUpdated(self, event)
    if (self.m_View) then
        local modelUnit        = event.modelUnit
        local currentGridIndex = modelUnit:getGridIndex()

        if ((GridIndexFunctions.isEqual(event.previousGridIndex, self.m_CursorGridIndex)) and
            (not GridIndexFunctions.isEqual(event.previousGridIndex, currentGridIndex))) then
            self.m_View:setVisible(false)
        elseif (GridIndexFunctions.isEqual(self.m_CursorGridIndex, currentGridIndex)) then
            if (modelUnit:getCurrentHP() <= 0) then
                self.m_View:setVisible(false)
            else
                updateWithModelUnit(self, modelUnit)
            end
        end
    end
end

local function onEvtModelUnitProduced(self, event)
    if (GridIndexFunctions.isEqual(self.m_CursorGridIndex, event.modelUnit:getGridIndex())) then
        updateWithModelUnit(self, event.modelUnit)
    end
end

local function onEvtTurnPhaseMain(self, event)
    self.m_ModelPlayer = event.modelPlayer
end

local function onEvtModelWeatherUpdated(self, event)
    self.m_ModelWeather = event.modelWeather
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

function ModelUnitInfo:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelUnitInfo:setRootScriptEventDispatcher() the dispatcher has been set.")

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtPreviewModelUnit", self)
        :addEventListener("EvtPreviewNoModelUnit",  self)
        :addEventListener("EvtDestroyModelUnit",    self)
        :addEventListener("EvtModelUnitUpdated",    self)
        :addEventListener("EvtModelUnitProduced",   self)
        :addEventListener("EvtTurnPhaseMain",       self)
        :addEventListener("EvtModelWeatherUpdated", self)

    return self
end

function ModelUnitInfo:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelUnitInfo:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtModelWeatherUpdated", self)
        :removeEventListener("EvtTurnPhaseMain",      self)
        :removeEventListener("EvtModelUnitProduced",  self)
        :removeEventListener("EvtModelUnitUpdated",   self)
        :removeEventListener("EvtDestroyModelUnit",   self)
        :removeEventListener("EvtPreviewModelUnit",   self)
        :removeEventListener("EvtPreviewNoModelUnit", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelUnitInfo:onEvent(event)
    local eventName = event.name
    if (eventName == "EvtPreviewNoModelUnit") then
        onEvtPreviewNoModelUnit(self, event)
    elseif (eventName == "EvtPreviewModelUnit") then
        onEvtPreviewModelUnit(self, event)
    elseif (eventName == "EvtDestroyModelUnit") then
        onEvtDestroyModelUnit(self, event)
    elseif (eventName == "EvtModelUnitUpdated") then
        onEvtModelUnitUpdated(self, event)
    elseif (eventName == "EvtModelUnitProduced") then
        onEvtModelUnitProduced(self, event)
    elseif (eventName == "EvtTurnPhaseMain") then
        onEvtTurnPhaseMain(self, event)
    elseif (eventName == "EvtModelWeatherUpdated") then
        onEvtModelWeatherUpdated(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelUnitInfo:onPlayerTouch()
    if (self.m_ModelUnitDetail) then
        self.m_ModelUnitDetail:updateWithModelUnit(self.m_ModelUnit, self.m_ModelPlayer, self.m_ModelWeather)
            :setEnabled(true)
    end

    return self
end

return ModelUnitInfo
