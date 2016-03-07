
local ViewWarField = class("ViewWarField", cc.Node)

local TypeChecker  = require("app.utilities.TypeChecker")
local GameConstant = require("res.data.GameConstant")

local ORIGIN = {x = 0, y = 0}
local BOUNDARY_RECT  = {upperRightX = display.width - 10, upperRightY = display.height - 10, lowerLeftX = 10, lowerLeftY = 10}

local function isViewSmallerThanScreen(scale, contentSize)
    local width = contentSize.width * scale
    local height = contentSize.height * scale

    return (width < display.width) and (height < display.height)
end

local function shouldZoomWithScrollValue(view, value)
    local currentScale = view:getScale()
    if ((value > 0) and (isViewSmallerThanScreen(currentScale, view:getContentSize()))) or
       ((value < 0) and (currentScale > 2)) or
       (value == 0) then
        return false
    else
        return true
    end
end

local function setSafeAnchor(view, anchorX, anchorY)
    local scale = view:getScale()
    local diffX = anchorX * view:getContentSize().width  * (scale - 1)
    local diffY = anchorY * view:getContentSize().height * (scale - 1)

    view:setAnchorPoint(anchorX, anchorY)
        :setPositionX(view:getPositionX() - diffX)
        :setPositionY(view:getPositionY() - diffY)
end

local function setAnchorPointWithCursorPos(view, pos)
    --pos.y = display.height - pos.y
--    print("cursor", pos.x, pos.y)
--    local glPos = cc.Director:getInstance():convertToGL(pos)
--    print("gl", glPos.x, glPos.y)
    
    local posInView = view:convertToNodeSpace(cc.Director:getInstance():convertToGL(pos))
    local contentSize = view:getContentSize()
    local anchorX = posInView.x / contentSize.width
    local anchorY = posInView.y / contentSize.height
    
    print("====\nsetAnchorPointWithCursorPos posInView", posInView.x, posInView.y)
    print("setAnchorPointWithCursorPos anchor", anchorX, anchorY)
    
--    setSafeAnchor(view, posInView.x / contentSize.width, posInView.y / contentSize.height)
--    view:setAnchorPoint(0.5, 0.5)
    view:setAnchorPoint(anchorX, anchorY)
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

function ViewWarField:setPositionOnDrag(previousDragPos, currentDragPos)
    local boundingBox = self:getBoundingBox()
    local dragDeltaX, dragDeltaY = currentDragPos.x - previousDragPos.x, currentDragPos.y - previousDragPos.y

    self:setPosition(dragDeltaX + self:getPositionX(), dragDeltaY + self:getPositionY())

--    self:setPosition(getNewPosComponentOnDrag(self:getPositionX(), dragDeltaX, boundingBox.width,  boundingBox.x, BOUNDARY_RECT.upperRightX, BOUNDARY_RECT.lowerLeftX),
  --                   getNewPosComponentOnDrag(self:getPositionY(), dragDeltaY, boundingBox.height, boundingBox.y, BOUNDARY_RECT.upperRightY, BOUNDARY_RECT.lowerLeftY))

    return self
end

function ViewWarField:ctor(param)
    self:ignoreAnchorPointForPosition(true)

    if (param) then
        self:load(param)
    end

    return self
end

function ViewWarField:load(param)
	return self
end

function ViewWarField.createInstance(param)
	local view = ViewWarField.new():load(param)
	assert(view, "ViewWarField.createInstance() failed.")

	return view
end

function ViewWarField:handleAndSwallowTouch(touch, touchType, event)
--[[
    local isTouchSwallowed = require("app.utilities.DispatchAndSwallowTouch")(self.m_TouchableChildrenViews, touch, touchType, event)

    if (isTouchSwallowed) then
        return true
    else
        if (touchType == cc.Handler.EVENT_TOUCH_MOVED) then
            self:setPositionOnDrag(touch:getPreviousLocation(), touch:getLocation())
            return true
        else
            return false
        end
    end
]]
end

function ViewWarField:setContentSizeWithMapSize(mapSize)
    local gridSize = GameConstant.GridSize
    self:setContentSize(mapSize.width * gridSize.width, mapSize.height * gridSize.height)
 --       :placeInDragBoundary()

	return self
end

function ViewWarField:setZoomWithScroll(cursorPos, scrollValue)
    if (shouldZoomWithScrollValue(self, scrollValue)) then
        setAnchorPointWithCursorPos(self, cursorPos)
        self:setScale(self:getScale() - scrollValue / 20)
--        setSafeAnchor(self, 0, 0)
 --           :setAnchorPoint(0, 0)

--        self    :placeInDragBoundary()
    end

    return self
end

function ViewWarField:placeInDragBoundary()
    self:setPositionOnDrag(ORIGIN, ORIGIN)

    return self
end

function ViewWarField:setTouchableChildrenViews(views)
    self.m_TouchableChildrenViews = views

    return self
end

return ViewWarField
