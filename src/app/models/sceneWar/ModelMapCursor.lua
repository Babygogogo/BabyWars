
--[[--------------------------------------------------------------------------------
-- ModelMapCursor是战局上的光标，同时也负责解读玩家的触摸操作，并翻译为游戏内使用的event。
--
-- 主要职责及使用场景举例：
--   玩家触摸地图时，判断触摸的具体类型，并发送对应的event。
--   在适当的时候切换光标的显示形态。
--
-- 其他：
--   - 游戏的输入响应机制
--     游戏中有两类物体可以响应玩家的输入，一种是本类ModelMapCursor，另一种是各个UI菜单按钮等。
--     UI响应触摸优先于光标响应触摸，具体如何响应由相应的model和view自行处理。
--     其他的所有物体都不会直接响应玩家输入，包括各unit/tile等。它们只响应由ModelMapCursor发出的事件。
--     这种机制使得一旦输入响应异常，我们就可以直接来本类找问题，不用整个代码库去debug。而且事实证明，本类的代码也不长。
--
--   - 光标如何解读玩家的触摸操作
--     - 触摸点数量达到2个或以上
--       发送EvtPlayerZoomFieldWithTouches，光标本身不移动
--     - 触摸点只有1个
--       - 如果触摸没有移动过，那么把光标移动到相应位置，发送事件EvtPlayerSelectedGrid
--       - 如果触摸有移动过
--         - 如果触摸是在光标外的，发送事件EvtPlayerDragField，光标本身不移动。
--         - 如果触摸是在光标内的，发送事件EvtPlayerMovedCursor，光标跟着触摸移动。
--     实际实现请看代码。
--]]--------------------------------------------------------------------------------

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
-- The private callback functions on script events.
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

local function onEvtSceneWarStarted(self, event)
    dispatchEventPlayerMovedCursor(self, self:getGridIndex())
end

--------------------------------------------------------------------------------
-- The touch/scroll event listeners.
--------------------------------------------------------------------------------
local function createTouchListener(self)
    local isTouchBegan, isTouchMoved, isTouchingCursor
    local initialTouchPosition, initialTouchGridIndex
    local touchListener = cc.EventListenerTouchAllAtOnce:create()

    local function onTouchesBegan(touches, event)
        isTouchBegan = true
        isTouchMoved = false
        initialTouchPosition = touches[1]:getLocation()
        initialTouchGridIndex = GridIndexFunctions.worldPosToGridIndexInNode(initialTouchPosition, self.m_View)
        isTouchingCursor = GridIndexFunctions.isEqual(initialTouchGridIndex, self:getGridIndex())
    end

    local function onTouchesMoved(touches, event)
        if (not isTouchBegan) then --Sometimes this function is invoked without the onTouchesBegan() being invoked first, so we must do the manual check here.
            return
        end

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
        if (not isTouchBegan) then --Sometimes this function is invoked without the onTouchesBegan() being invoked first, so we must do the manual check here.
            return
        end

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

function ModelMapCursor:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelMapCursor:setRootScriptEventDispatcher() the dispatcher has been set.")

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtPlayerPreviewAttackTarget", self)
        :addEventListener("EvtPlayerPreviewNoAttackTarget", self)
        :addEventListener("EvtActionPlannerIdle",           self)
        :addEventListener("EvtActionPlannerMakingMovePath", self)
        :addEventListener("EvtActionPlannerChoosingAction", self)
        :addEventListener("EvtSceneWarStarted",             self)

    return self
end

function ModelMapCursor:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelMapCursor:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtSceneWarStarted", self)
        :removeEventListener("EvtActionPlannerChoosingAction", self)
        :removeEventListener("EvtActionPlannerMakingMovePath", self)
        :removeEventListener("EvtActionPlannerIdle",           self)
        :removeEventListener("EvtPlayerPreviewNoAttackTarget", self)
        :removeEventListener("EvtPlayerPreviewAttackTarget",   self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelMapCursor:onEvent(event)
    local eventName = event.name
    if ((eventName == "EvtActionPlannerIdle") or
        (eventName == "EvtActionPlannerMakingMovePath") or
        (eventName == "EvtActionPlannerChoosingAction") or
        (eventName == "EvtPlayerPreviewNoAttackTarget")) then
        onEvtPlayerPreviewNoAttackTarget(self, event)
    elseif (eventName == "EvtPlayerPreviewAttackTarget") then
        onEvtPlayerPreviewAttackTarget(self, event)
    elseif (eventName == "EvtSceneWarStarted") then
        onEvtSceneWarStarted(self, event)
    end

    return self
end

return ModelMapCursor
