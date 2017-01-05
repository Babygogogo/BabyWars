
local ViewZoomableNode = class("ViewZoomableNode", cc.Node)

local ORIGIN = {x = 0, y = 0}
local DEFAULT_BOUNDARY_RECT = {
    upperRightX = display.width - 10,
    upperRightY = display.height - 10,
    lowerLeftX  = 10,
    lowerLeftY  = 10
}
DEFAULT_BOUNDARY_RECT.width  = DEFAULT_BOUNDARY_RECT.upperRightX - DEFAULT_BOUNDARY_RECT.lowerLeftX
DEFAULT_BOUNDARY_RECT.height = DEFAULT_BOUNDARY_RECT.upperRightY - DEFAULT_BOUNDARY_RECT.lowerLeftY

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getNewScale(originScale, modifier, minScale, maxScale)
    local newScale = originScale * modifier
    newScale = math.max(minScale or newScale, newScale)
    newScale = math.min(maxScale or newScale, newScale)

    return newScale
end

local function getScaleModifierWithScrollValue(value)
    return 1 - value / 10
end

local function getMiddlePointForTouches(touches)
    local director = cc.Director:getInstance()
    local pos1, pos2 = director:convertToGL(touches[1]:getLocation()), director:convertToGL(touches[2]:getLocation())
    return {x = (pos1.x + pos2.x) / 2, y = (pos1.y + pos2.y) / 2}
end

local function getScaleModifierWithTouches(touches)
    local currentPos1, prevPos1 = touches[1]:getLocation(), touches[1]:getPreviousLocation()
    local currentPos2, prevPos2 = touches[2]:getLocation(), touches[2]:getPreviousLocation()
    return cc.pGetDistance(currentPos1, currentPos2) / cc.pGetDistance(prevPos1, prevPos2)
end

--------------------------------------------------------------------------------
-- The functions that deals with zooming/dragging.
--------------------------------------------------------------------------------
local function isViewSmallerThanBoundaryRect(scale, contentSize, boundaryRect)
    local width  = contentSize.width * scale
    local height = contentSize.height * scale

    return (width <= boundaryRect.width) and (height <= boundaryRect.height)
end

local function shouldZoom(self, scaleModifier)
    local currentScale = self:getScale()
    return not (((scaleModifier < 1) and (isViewSmallerThanBoundaryRect(currentScale, self.m_ContentSize, self.m_BoundaryRect))) or
        ((scaleModifier > 1) and (currentScale >= self.m_MaxScale)) or
        (scaleModifier == 1))
end

local function setZoom(self, focusPosInWorld, focusPosInNode, scaleModifier)
    self:setScale(getNewScale(self:getScale(), scaleModifier, self.m_MinScale, self.m_MaxScale))
    local scaledFocusPosInWorld = self:convertToWorldSpace(focusPosInNode)

    self:setPosition(   - scaledFocusPosInWorld.x + focusPosInWorld.x + self:getPositionX(),
                        - scaledFocusPosInWorld.y + focusPosInWorld.y + self:getPositionY())
        :placeInDragBoundary()
end

local function getNewPosComponentOnDrag(currentPosComp, dragDeltaComp, targetSizeComp, targetOriginComp, boundaryUpperRightComp, boundaryLowerLeftComp)
    local minOrigin = boundaryUpperRightComp - targetSizeComp
    local maxOrigin = boundaryLowerLeftComp

    if minOrigin <= maxOrigin then
        if dragDeltaComp + targetOriginComp < minOrigin then dragDeltaComp = minOrigin - targetOriginComp end
        if dragDeltaComp + targetOriginComp > maxOrigin then dragDeltaComp = maxOrigin - targetOriginComp end
        return dragDeltaComp + currentPosComp
    else
        return (minOrigin - maxOrigin) / 2 + boundaryLowerLeftComp
    end
end

--------------------------------------------------------------------------------
-- The touch/mouse event listener.
--------------------------------------------------------------------------------
local function initTouchListener(self)
    local areTouchesWithinNode
    local function onTouchesBegan(touches, event)
        local touchPos = self:convertToNodeSpace(touches[1]:getLocation())
        local scale = self:getScale()
        local posXInRect, posYInRect = touchPos.x * scale + self:getPositionX(), touchPos.y * scale + self:getPositionY()
        local boundaryRect = self.m_BoundaryRect
        areTouchesWithinNode = ((posXInRect >= boundaryRect.lowerLeftX) and (posXInRect <= boundaryRect.upperRightX) and
                                (posYInRect >= boundaryRect.lowerLeftY) and (posYInRect <= boundaryRect.upperRightY))
    end

    local function onTouchesMoved(touches, event)
        if (areTouchesWithinNode) then
            if (#touches >= 2) then
                self:setZoomWithTouches(touches)
            else
                self:setPositionOnDrag(touches[1]:getPreviousLocation(), touches[1]:getLocation())
            end
        end
    end

    local touchListener = cc.EventListenerTouchAllAtOnce:create()
    touchListener:registerScriptHandler(onTouchesBegan, cc.Handler.EVENT_TOUCHES_BEGAN)
    touchListener:registerScriptHandler(onTouchesMoved, cc.Handler.EVENT_TOUCHES_MOVED)

    self.m_TouchListener = touchListener
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(touchListener, self)
end

local function initMouseListener(self)
    local function onMouseScroll(event)
        local mousePos = self:convertToNodeSpace(cc.Director:getInstance():convertToGL(event:getLocation()))
        local scale = self:getScale()
        local posXInRect, posYInRect = mousePos.x * scale + self:getPositionX(), mousePos.y * scale + self:getPositionY()
        local boundaryRect = self.m_BoundaryRect
        if ((posXInRect >= boundaryRect.lowerLeftX) and (posXInRect <= boundaryRect.upperRightX) and
            (posYInRect >= boundaryRect.lowerLeftY) and (posYInRect <= boundaryRect.upperRightY)) then
            self:setZoomWithScroll(cc.Director:getInstance():convertToGL(event:getLocation()), event:getScrollY())
        end
    end

    local mouseListener = cc.EventListenerMouse:create()
    mouseListener:registerScriptHandler(onMouseScroll, cc.Handler.EVENT_MOUSE_SCROLL)

    self.m_MouseListener = mouseListener
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(mouseListener, self)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewZoomableNode:ctor(boundaryRect)
    initTouchListener(self)
    initMouseListener(self)

    self:ignoreAnchorPointForPosition(true)
        :setAnchorPoint(0, 0)

    self.m_BoundaryRect = boundaryRect or DEFAULT_BOUNDARY_RECT
    self.m_ContentSize = {
        width = self.m_BoundaryRect.width,
        height = self.m_BoundaryRect.height,
    }
    self.m_MaxScale, self.m_MinScale = 1, 1

    return self
end

--------------------------------------------------------------------------------
-- The public functions for zooming/dragging.
--------------------------------------------------------------------------------
function ViewZoomableNode:setZoomWithScroll(focusPosInWorld, scrollValue)
    local focusPosInNode = self:convertToNodeSpace(focusPosInWorld)
    local scaleModifier  = getScaleModifierWithScrollValue(scrollValue)
    if (shouldZoom(self, scaleModifier)) then
        setZoom(self, focusPosInWorld, focusPosInNode, scaleModifier)
    end

    return self
end

function ViewZoomableNode:setPositionOnDrag(previousDragPos, currentDragPos)
    local boundingBox = self:getBoundingBox()
    local dragDeltaX, dragDeltaY = currentDragPos.x - previousDragPos.x, currentDragPos.y - previousDragPos.y

    self:setPosition(
        getNewPosComponentOnDrag(self:getPositionX(), dragDeltaX, boundingBox.width,  boundingBox.x, self.m_BoundaryRect.upperRightX, self.m_BoundaryRect.lowerLeftX),
        getNewPosComponentOnDrag(self:getPositionY(), dragDeltaY, boundingBox.height, boundingBox.y, self.m_BoundaryRect.upperRightY, self.m_BoundaryRect.lowerLeftY)
    )

    return self
end

function ViewZoomableNode:placeInDragBoundary()
    self:setPositionOnDrag(ORIGIN, ORIGIN)

    return self
end

function ViewZoomableNode:setZoomWithTouches(touches)
    local focusPosInWorld = getMiddlePointForTouches(touches)
    local focusPosInNode  = self:convertToNodeSpace(focusPosInWorld)
    local scaleModifier   = getScaleModifierWithTouches(touches)
    if (shouldZoom(self, scaleModifier)) then
        setZoom(self, focusPosInWorld, focusPosInNode, scaleModifier)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewZoomableNode:setContentAndSize(node, size)
    self.m_ContentSize = size
    self.m_MinScale = math.min(
        self.m_BoundaryRect.width  / self.m_ContentSize.width,
        self.m_BoundaryRect.height / self.m_ContentSize.height
    )
    self.m_MaxScale = math.max(self.m_MinScale, 2)

    self:addChild(node)
        :setContentSize(self.m_ContentSize.width, self.m_ContentSize.height)

    return self
end

function ViewZoomableNode:setEnabled(enabled)
    if (enabled) then
        self:setScale(self.m_MinScale)
            :placeInDragBoundary()
    end

    self:setVisible(enabled)
    self.m_MouseListener:setEnabled(enabled)
    self.m_TouchListener:setEnabled(enabled)

    return self
end

return ViewZoomableNode
