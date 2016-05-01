
local ModelMapCursor = class("ModelMapCursor")

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")
local ComponentManager   = require("global.components.ComponentManager")

local DRAG_FIELD_TRIGGER_DISTANCE_SQUARED = 400

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function dispatchEventPlayerMovedCursor(self, gridIndex)
    self:setGridIndex(gridIndex)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name = "EvtPlayerMovedCursor",
        gridIndex = gridIndex
    })
end

local function dispatchEventPlayerSelectedGrid(self, gridIndex)
    self:setGridIndex(gridIndex)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name = "EvtPlayerSelectedGrid",
        gridIndex = gridIndex
    })
end

--------------------------------------------------------------------------------
-- The callback functions on EvtPlayerPreviewAttackTarget/EvtPlayerPreviewNoAttackTarget.
--------------------------------------------------------------------------------
local function onEvtPlayerPreviewAttackTarget(self, event)
    if (self.m_View) then
        self.m_View:setNormalCursorVisible(false)
            :setTargetCursorVisible(true)
    end
end

local function onEvtPlayerPreviewNoAttackTarget(self, event)
    if (self.m_View) then
        self.m_View:setNormalCursorVisible(true)
            :setTargetCursorVisible(false)
    end
end

--------------------------------------------------------------------------------
-- The touch/scroll event listeners.
--------------------------------------------------------------------------------
local function createTouchListener(self)
    local isTouchMoved, isTouchingCursor
    local initialTouchPosition, initialTouchGridIndex
    local touchListener = cc.EventListenerTouchAllAtOnce:create()

    local function onTouchesBegan(touches, event)
        isTouchMoved = false
        initialTouchPosition = touches[1]:getLocation()
        initialTouchGridIndex = GridIndexFunctions.worldPosToGridIndexInNode(initialTouchPosition, self.m_View)
        isTouchingCursor = GridIndexFunctions.isEqual(initialTouchGridIndex, self:getGridIndex())
    end

    local function onTouchesMoved(touches, event)
        local touchesCount = #touches
        isTouchMoved = (isTouchMoved) or
            (touchesCount > 1) or
            (cc.pDistanceSQ(touches[1]:getLocation(), initialTouchPosition) > DRAG_FIELD_TRIGGER_DISTANCE_SQUARED)

        if (touchesCount >= 2) then
            self.m_RootScriptEventDispatcher:dispatchEvent({
                name    = "EvtPlayerZoomFieldWithTouches",
                touches = touches,
            })
        else
            if (isTouchingCursor) then
                local gridIndex = GridIndexFunctions.worldPosToGridIndexInNode(touches[1]:getLocation(), self.m_View)
                if ((GridIndexFunctions.isWithinMap(gridIndex, self.m_MapSize)) and
                    (not GridIndexFunctions.isEqual(gridIndex, self:getGridIndex()))) then
                    dispatchEventPlayerMovedCursor(self, gridIndex)
                    isTouchMoved = true
                end
            else
                if (isTouchMoved) then
                    self.m_RootScriptEventDispatcher:dispatchEvent({
                        name             = "EvtPlayerDragField",
                        previousPosition = touches[1]:getPreviousLocation(),
                        currentPosition  = touches[1]:getLocation()
                    })
                end
            end
        end
    end

    local function onTouchesCancelled(touch, event)
    end

    local function onTouchesEnded(touches, event)
        local gridIndex = GridIndexFunctions.worldPosToGridIndexInNode(touches[1]:getLocation(), self.m_View)
        if (GridIndexFunctions.isWithinMap(gridIndex, self.m_MapSize)) then
            if (not isTouchMoved) then
                dispatchEventPlayerSelectedGrid(self, gridIndex)
            elseif ((isTouchingCursor) and (not GridIndexFunctions.isEqual(gridIndex, self:getGridIndex()))) then
                dispatchEventPlayerMovedCursor(self, gridIndex)
            end
        end
    end

    touchListener:registerScriptHandler(onTouchesBegan,     cc.Handler.EVENT_TOUCHES_BEGAN)
    touchListener:registerScriptHandler(onTouchesMoved,     cc.Handler.EVENT_TOUCHES_MOVED)
    touchListener:registerScriptHandler(onTouchesCancelled, cc.Handler.EVENT_TOUCHES_CANCELLED)
    touchListener:registerScriptHandler(onTouchesEnded,     cc.Handler.EVENT_TOUCHES_ENDED)

    return touchListener
end

local function createMouseListener(model)
    local function onMouseScroll(event)
        model.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerZoomField", scrollEvent = event})
    end

    local mouseListener = cc.EventListenerMouse:create()
    mouseListener:registerScriptHandler(onMouseScroll, cc.Handler.EVENT_MOUSE_SCROLL)

    return mouseListener
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelMapCursor:ctor(param)
    if (not ComponentManager:getComponent(self, "GridIndexable")) then
        ComponentManager.bindComponent(self, "GridIndexable", {instantialData = {gridIndex = param.gridIndex or {x = 1, y = 1}}})
    end

    assert(param.mapSize, "ModelMapCursor:ctor() param.mapSize expected.")
    self:setMapSize(param.mapSize)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelMapCursor:initView()
    local view = self.m_View
    assert(view, "ModelMapCursor:initView() no view is attached to the owner actor of the model.")

    self:setViewPositionWithGridIndex()
    view:setTouchListener(createTouchListener(self))
        :setMouseListener(createMouseListener(self))

        :setNormalCursorVisible(true)
        :setTargetCursorVisible(false)

    return self
end

function ModelMapCursor:setMapSize(size)
    self.m_MapSize = self.m_MapSize or {}
    self.m_MapSize.width  = size.width
    self.m_MapSize.height = size.height

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelMapCursor:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerMovedCursor", gridIndex = self:getGridIndex()})
        :addEventListener("EvtPlayerPreviewAttackTarget",   self)
        :addEventListener("EvtPlayerPreviewNoAttackTarget", self)
        :addEventListener("EvtActionPlannerIdle",           self)
        :addEventListener("EvtActionPlannerMakingMovePath", self)
        :addEventListener("EvtActionPlannerChoosingAction", self)

    return self
end

function ModelMapCursor:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtActionPlannerChoosingAction", self)
        :removeEventListener("EvtActionPlannerMakingMovePath", self)
        :removeEventListener("EvtActionPlannerIdle",           self)
        :removeEventListener("EvtPlayerPreviewNoAttackTarget", self)
        :removeEventListener("EvtPlayerPreviewAttackTarget",   self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelMapCursor:onEvent(event)
    local eventName = event.name
    if ((eventName == "EvtActionPlannerIdle") or
        (eventName == "EvtActionPlannerMakingMovePath") or
        (eventName == "EvtActionPlannerChoosingAction") or
        (eventName == "EvtPlayerPreviewNoAttackTarget")) then
        onEvtPlayerPreviewNoAttackTarget(self, event)
    elseif (eventName == "EvtPlayerPreviewAttackTarget") then
        onEvtPlayerPreviewAttackTarget(self, event)
    end

    return self
end

return ModelMapCursor
