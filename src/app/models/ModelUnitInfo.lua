
local ModelUnitInfo = class("ModelUnitInfo")

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtPlayerTouchUnit(self, event)
    self.m_ModelUnit = event.unitModel

    if (self.m_View) then
        self.m_View:updateWithModelUnit(event.unitModel)
        self.m_View:setVisible(true)
    end
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
    if (GridIndexFunctions.isEqual(self.m_CursorGridIndex, event.modelUnit:getGridIndex()) and (self.m_View)) then
        self.m_View:updateWithModelUnit(event.modelUnit)
            :setVisible(true)
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializer.
--------------------------------------------------------------------------------
function ModelUnitInfo:ctor(param)
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

    return self
end

function ModelUnitInfo:onCleanup(rootActor)
    -- removeEventListener can be commented out because the dispatcher itself is being destroyed.
    self.m_RootScriptEventDispatcher:removeEventListener("EvtModelUnitMoved", self)
        :removeEventListener("EvtDestroyModelUnit", self)
        :removeEventListener("EvtPlayerSelectedGrid", self)
        :removeEventListener("EvtPlayerMovedCursor", self)
        :removeEventListener("EvtPlayerTouchUnit",   self)
        :removeEventListener("EvtPlayerTouchNoUnit", self)

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
