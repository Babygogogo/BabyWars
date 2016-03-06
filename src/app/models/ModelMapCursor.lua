
local ModelMapCursor = class("ModelMapCursor")

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")
local DRAG_FIELD_TRIGGER_DISTANCE_SQUARED = 400

local function isWorldPosOnCursor(model, pos)
    local posIndex = GridIndexFunctions.worldPosToGridIndexInNode(pos, model.m_View)
    local modelIndex = model:getGridIndex()

    return GridIndexFunctions.isEqual(posIndex, modelIndex)
end

local function createTouchListener(model)
    local isTouchMoved, isTouchingCursor
    local initialTouchPosition, initialTouchGridIndex
    local touchListener = cc.EventListenerTouchOneByOne:create()

    local function onTouchBegan(touch, event)
        isTouchMoved = false
        initialTouchPosition = touch:getLocation()
        initialTouchGridIndex = GridIndexFunctions.worldPosToGridIndexInNode(initialTouchPosition, model.m_View)
        isTouchingCursor = GridIndexFunctions.isEqual(initialTouchGridIndex, model:getGridIndex())

        touchListener:setSwallowTouches(isTouchingCursor)

        return true
    end

    local function onTouchMoved(touch, event)
        isTouchMoved = (isTouchMoved) or (cc.pDistanceSQ(touch:getLocation(), initialTouchPosition) > DRAG_FIELD_TRIGGER_DISTANCE_SQUARED)

        if (isTouchingCursor) then
            local gridIndex = GridIndexFunctions.worldPosToGridIndexInNode(touch:getLocation(), model.m_View)
            if (GridIndexFunctions.isWithinMap(gridIndex, model.m_MapSize)
               and not GridIndexFunctions.isEqual(gridIndex, model:getGridIndex())) then
                model:setGridIndex(gridIndex)
                isTouchMoved = true
            end
        else
            if (isTouchMoved) then
                model.m_ScriptEventDispatcher:dispatchEvent({name = "EvtPlayerDragField",
                                                             previousPosition = touch:getPreviousLocation(),
                                                             currentPosition = touch:getLocation()})
            end
        end
    end

    local function onTouchCancelled(touch, event)
    end

    local function onTouchEnded(touch, event)
        local gridIndex = GridIndexFunctions.worldPosToGridIndexInNode(touch:getLocation(), model.m_View)
        if (not GridIndexFunctions.isWithinMap(gridIndex, model.m_MapSize)) then
            return
        end

        if (not isTouchMoved) or
           ((isTouchingCursor) and (GridIndexFunctions.isEqual(gridIndex, initialTouchGridIndex))) then
            model:setGridIndex(gridIndex)
            print("Player activate a grid:", gridIndex.x, gridIndex.y)
        end
    end

    touchListener:registerScriptHandler(onTouchBegan,     cc.Handler.EVENT_TOUCH_BEGAN)
    touchListener:registerScriptHandler(onTouchMoved,     cc.Handler.EVENT_TOUCH_MOVED)
    touchListener:registerScriptHandler(onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED)
    touchListener:registerScriptHandler(onTouchEnded,     cc.Handler.EVENT_TOUCH_ENDED)

    return touchListener
end

function ModelMapCursor:ctor(param)
    require("global.components.ComponentManager").bindComponent(self, "GridIndexable")
    self:setGridIndex({x = 1, y = 1})
    self.m_MapSize = {}

    if (param) then
        self:load(param)
    end

    return self
end

function ModelMapCursor:load(param)
    if (param.mapSize) then
        self:setMapSize(param.mapSize)
    end

    if (param.gridIndex) then
        self:setGridIndex(param.gridIndex)
    end

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelMapCursor.createInstance(param)
    local model = ModelMapCursor:create():load(param)
    assert(model, "ModelMapCursor.createInstance() failed.")

    return model
end

function ModelMapCursor:onEnter(rootActor)
    self.m_ScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()

    return self
end

function ModelMapCursor:onCleanup(rootActor)
    return self
end

function ModelMapCursor:initView()
    local view = self.m_View
    assert(view, "ModelMapCursor:initView() no view is attached to the owner actor of the model.")

    self:setViewPositionWithGridIndex()
    view:initWithTouchListener(createTouchListener(self))

    return self
end

function ModelMapCursor:setMapSize(size)
    self.m_MapSize.width = size.width
    self.m_MapSize.height = size.height

    return self
end

return ModelMapCursor
