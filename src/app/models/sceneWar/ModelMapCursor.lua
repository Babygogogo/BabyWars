
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
--       发送EvtZoomFieldWithTouches，光标本身不移动
--     - 触摸点只有1个
--       - 如果触摸没有移动过，那么把光标移动到相应位置，发送事件EvtGridSelected
--       - 如果触摸有移动过
--         - 如果触摸是在光标外的，发送事件EvtDragField，光标本身不移动。
--         - 如果触摸是在光标内的，发送事件EvtMapCursorMoved，光标跟着触摸移动。
--     实际实现请看代码。
--]]--------------------------------------------------------------------------------

local ModelMapCursor = class("ModelMapCursor")

local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")
local SingletonGetters   = require("src.app.utilities.SingletonGetters")
local ComponentManager   = require("src.global.components.ComponentManager")

local getScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher

local DRAG_FIELD_TRIGGER_DISTANCE_SQUARED = 400

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function dispatchEvtMapCursorMoved(self, gridIndex)
    getScriptEventDispatcher():dispatchEvent({
        name      = "EvtMapCursorMoved",
        gridIndex = gridIndex,
    })
end

local function dispatchEvtGridSelected(self, gridIndex)
    getScriptEventDispatcher():dispatchEvent({
        name      = "EvtGridSelected",
        gridIndex = gridIndex,
    })
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtGridSelected(self, event)
    self:setGridIndex(event.gridIndex)
end

local function onEvtMapCursorMoved(self, event)
    self:setGridIndex(event.gridIndex)
end

local function onEvtSceneWarStarted(self, event)
    dispatchEvtMapCursorMoved(self, self:getGridIndex())
end

local function onEvtWarCommandMenuUpdated(self, event)
    self.m_IsWarCommandMenuVisible = event.isEnabled and event.isVisible
end

local function setCursorAppearance(self, normalVisible, targetVisible, siloVisible)
    if (self.m_View) then
        self.m_View:setNormalCursorVisible(normalVisible)
            :setTargetCursorVisible(targetVisible)
            :setSiloCursorVisible(siloVisible)
    end
end

--------------------------------------------------------------------------------
-- The touch/scroll event listeners.
--------------------------------------------------------------------------------
local function createTouchListener(self)
    local isTouchBegan, isTouchMoved, isTouchingCursor
    local initialTouchPosition, initialTouchGridIndex
    local touchListener = cc.EventListenerTouchAllAtOnce:create()

    local function onTouchesBegan(touches, event)
        if (self.m_IsWarCommandMenuVisible) then
            return
        end

        isTouchBegan = true
        isTouchMoved = false
        initialTouchPosition = touches[1]:getLocation()
        initialTouchGridIndex = GridIndexFunctions.worldPosToGridIndexInNode(initialTouchPosition, self.m_View)
        isTouchingCursor = GridIndexFunctions.isEqual(initialTouchGridIndex, self:getGridIndex())
    end

    local function onTouchesMoved(touches, event)
        if ((not isTouchBegan)                or --Sometimes this function is invoked without the onTouchesBegan() being invoked first, so we must do the manual check here.
            (self.m_IsWarCommandMenuVisible)) then
            return
        end

        local touchesCount = #touches
        isTouchMoved = (isTouchMoved) or
            (touchesCount > 1) or
            (cc.pDistanceSQ(touches[1]:getLocation(), initialTouchPosition) > DRAG_FIELD_TRIGGER_DISTANCE_SQUARED)

        if (touchesCount >= 2) then
            getScriptEventDispatcher():dispatchEvent({
                name    = "EvtZoomFieldWithTouches",
                touches = touches,
            })
        else
            if (isTouchingCursor) then
                local gridIndex = GridIndexFunctions.worldPosToGridIndexInNode(touches[1]:getLocation(), self.m_View)
                if ((GridIndexFunctions.isWithinMap(gridIndex, self.m_MapSize)) and
                    (not GridIndexFunctions.isEqual(gridIndex, self:getGridIndex()))) then
                    dispatchEvtMapCursorMoved(self, gridIndex)
                    isTouchMoved = true
                end
            else
                if (isTouchMoved) then
                    getScriptEventDispatcher():dispatchEvent({
                        name             = "EvtDragField",
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
        if ((not isTouchBegan)                or --Sometimes this function is invoked without the onTouchesBegan() being invoked first, so we must do the manual check here.
            (self.m_IsWarCommandMenuVisible)) then
            return
        end

        local gridIndex = GridIndexFunctions.worldPosToGridIndexInNode(touches[1]:getLocation(), self.m_View)
        if (GridIndexFunctions.isWithinMap(gridIndex, self.m_MapSize)) then
            if (not isTouchMoved) then
                dispatchEvtGridSelected(self, gridIndex)
            elseif ((isTouchingCursor) and (not GridIndexFunctions.isEqual(gridIndex, self:getGridIndex()))) then
                dispatchEvtMapCursorMoved(self, gridIndex)
            end
        end
    end

    touchListener:registerScriptHandler(onTouchesBegan,     cc.Handler.EVENT_TOUCHES_BEGAN)
    touchListener:registerScriptHandler(onTouchesMoved,     cc.Handler.EVENT_TOUCHES_MOVED)
    touchListener:registerScriptHandler(onTouchesCancelled, cc.Handler.EVENT_TOUCHES_CANCELLED)
    touchListener:registerScriptHandler(onTouchesEnded,     cc.Handler.EVENT_TOUCHES_ENDED)

    return touchListener
end

local function createMouseListener()
    local function onMouseScroll(event)
        getScriptEventDispatcher():dispatchEvent({
            name        = "EvtZoomFieldWithScroll",
            scrollEvent = event
        })
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

    self.m_MapSize = {
        width  = param.mapSize.width,
        height = param.mapSize.height,
    }

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
        :setMouseListener(createMouseListener())

        :setNormalCursorVisible(true)
        :setTargetCursorVisible(false)

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelMapCursor:onStartRunning(sceneWarFileName)
    getScriptEventDispatcher()
        :addEventListener("EvtGridSelected",                    self)
        :addEventListener("EvtMapCursorMoved",                  self)
        :addEventListener("EvtPreviewBattleDamage",             self)
        :addEventListener("EvtPreviewNoBattleDamage",           self)
        :addEventListener("EvtActionPlannerIdle",               self)
        :addEventListener("EvtActionPlannerMakingMovePath",     self)
        :addEventListener("EvtActionPlannerChoosingAction",     self)
        :addEventListener("EvtActionPlannerChoosingSiloTarget", self)
        :addEventListener("EvtSceneWarStarted",                 self)
        :addEventListener("EvtWarCommandMenuUpdated",           self)

    return self
end

function ModelMapCursor:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtGridSelected")                    then onEvtGridSelected(         self, event)
    elseif (eventName == "EvtMapCursorMoved")                  then onEvtMapCursorMoved(       self, event)
    elseif (eventName == "EvtSceneWarStarted")                 then onEvtSceneWarStarted(      self, event)
    elseif (eventName == "EvtWarCommandMenuUpdated")           then onEvtWarCommandMenuUpdated(self, event)
    elseif (eventName == "EvtActionPlannerIdle")               then setCursorAppearance(self, true,  false, false)
    elseif (eventName == "EvtActionPlannerMakingMovePath")     then setCursorAppearance(self, true,  false, false)
    elseif (eventName == "EvtActionPlannerChoosingAction")     then setCursorAppearance(self, true,  false, false)
    elseif (eventName == "EvtActionPlannerChoosingSiloTarget") then setCursorAppearance(self, false, true,  true )
    elseif (eventName == "EvtPreviewNoBattleDamage")           then setCursorAppearance(self, true,  false, false)
    elseif (eventName == "EvtPreviewBattleDamage")             then setCursorAppearance(self, false, true,  false)
    end

    return self
end

return ModelMapCursor
