
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
local function onEvtPlayerTouchUnit(self, event)
    updateWithModelUnit(self, event.modelUnit)
end

local function onEvtPlayerTouchNoUnit(self, event)
    if (self.m_View) then
        self.m_View:setVisible(false)
    end
end

local function onEvtPlayerMovedCursor(self, event)
    self.m_CursorGridIndex = GridIndexFunctions.clone(event.gridIndex)
end

local function onEvtPlayerSelectedGrid(self, event)
    self.m_CursorGridIndex = GridIndexFunctions.clone(event.gridIndex)
end

local function onEvtDestroyModelUnit(self, event)
    if (GridIndexFunctions.isEqual(self.m_CursorGridIndex, event.gridIndex) and (self.m_View)) then
        self.m_View:setVisible(false)
    end
end

local function onEvtModelUnitMoved(self, event)
    if (GridIndexFunctions.isEqual(self.m_CursorGridIndex, event.modelUnit:getGridIndex())) then
        updateWithModelUnit(self, event.modelUnit)
    end
end

local function onEvtModelUnitUpdated(self, event)
    local modelUnit = event.modelUnit
    if (GridIndexFunctions.isEqual(self.m_CursorGridIndex, modelUnit:getGridIndex())) then
        if ((modelUnit:getCurrentHP() <= 0) and (self.m_View)) then
            self.m_View:setVisible(false)
        else
            updateWithModelUnit(self, modelUnit)
        end
    end
end

local function onEvtModelUnitProduced(self, event)
    if (GridIndexFunctions.isEqual(self.m_CursorGridIndex, event.modelUnit:getGridIndex())) then
        updateWithModelUnit(self, event.modelUnit)
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializer.
--------------------------------------------------------------------------------
function ModelUnitInfo:ctor(param)
    self.m_CursorGridIndex = {x = 1, y = 1}

    return self
end

function ModelUnitInfo:setModelUnitDetail(model)
    self.m_UnitDetailModel = model

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelUnitInfo:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtPlayerTouchUnit", self)
        :addEventListener("EvtPlayerTouchNoUnit",  self)
        :addEventListener("EvtPlayerMovedCursor",  self)
        :addEventListener("EvtPlayerSelectedGrid", self)
        :addEventListener("EvtDestroyModelUnit",   self)
        :addEventListener("EvtModelUnitMoved",     self)
        :addEventListener("EvtModelUnitUpdated",   self)
        :addEventListener("EvtModelUnitProduced",  self)

    return self
end

function ModelUnitInfo:onCleanup(rootActor)
    -- removeEventListener can be commented out because the dispatcher itself is being destroyed.
    self.m_RootScriptEventDispatcher:removeEventListener("EvtModelUnitProduced", self)
        :removeEventListener("EvtModelUnitUpdated",   self)
        :removeEventListener("EvtModelUnitMoved",     self)
        :removeEventListener("EvtDestroyModelUnit",   self)
        :removeEventListener("EvtPlayerSelectedGrid", self)
        :removeEventListener("EvtPlayerMovedCursor",  self)
        :removeEventListener("EvtPlayerTouchUnit",    self)
        :removeEventListener("EvtPlayerTouchNoUnit",  self)

    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelUnitInfo:onEvent(event)
    local eventName = event.name
    if (eventName == "EvtPlayerTouchNoUnit") then
        onEvtPlayerTouchNoUnit(self, event)
    elseif (eventName == "EvtPlayerTouchUnit") then
        onEvtPlayerTouchUnit(self, event)
    elseif (eventName == "EvtPlayerMovedCursor") then
        onEvtPlayerMovedCursor(self, event)
    elseif (eventName == "EvtPlayerSelectedGrid") then
        onEvtPlayerSelectedGrid(self, event)
    elseif (eventName == "EvtDestroyModelUnit") then
        onEvtDestroyModelUnit(self, event)
    elseif (eventName == "EvtModelUnitMoved") then
        onEvtModelUnitMoved(self, event)
    elseif (eventName == "EvtModelUnitUpdated") then
        onEvtModelUnitUpdated(self, event)
    elseif (eventName == "EvtModelUnitProduced") then
        onEvtModelUnitProduced(self, event)
    end

    return self
end

function ModelUnitInfo:onPlayerTouch()
    if (self.m_UnitDetailModel) then
        self.m_UnitDetailModel:updateWithModelUnit(self.m_ModelUnit)
            :setEnabled(true)
    end

    return self
end

return ModelUnitInfo
