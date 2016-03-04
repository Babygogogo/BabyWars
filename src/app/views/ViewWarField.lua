
local ViewWarField = class("ViewWarField", cc.Node)

local TypeChecker  = require("app.utilities.TypeChecker")
local GameConstant = require("res.data.GameConstant")

local BoundaryRect  = {width = display.width - 10, height = display.height - 10, x = 10, y = 10}

local function getNewPosComponentOnDrag(currentPosComp, dragDeltaComp, targetSizeComp, targetOriginComp, boundarySizeComp, boundaryOriginComp)
    local minOrigin = boundarySizeComp - targetSizeComp
    local maxOrigin = boundaryOriginComp

    if minOrigin <= maxOrigin then
        if dragDeltaComp + targetOriginComp < minOrigin then dragDeltaComp = minOrigin - targetOriginComp end
        if dragDeltaComp + targetOriginComp > maxOrigin then dragDeltaComp = maxOrigin - targetOriginComp end
        return dragDeltaComp + currentPosComp
    else
        return (minOrigin - maxOrigin) / 2 + boundaryOriginComp
    end
end

function ViewWarField:setPositionOnDrag(previousDragPos, currentDragPos)
    local boundingBox = self:getBoundingBox()
    local dragDeltaX, dragDeltaY = currentDragPos.x - previousDragPos.x, currentDragPos.y - previousDragPos.y
    
    self:move(getNewPosComponentOnDrag(self:getPositionX(), dragDeltaX, boundingBox.width,  boundingBox.x, BoundaryRect.width,  BoundaryRect.x),
              getNewPosComponentOnDrag(self:getPositionY(), dragDeltaY, boundingBox.height, boundingBox.y, BoundaryRect.height, BoundaryRect.y))
              
    return self
end

function ViewWarField:ctor(param)
	if (param) then self:load(param) end
	
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
end

function ViewWarField:setContentSizeWithMapSize(mapSize)
    local gridSize = GameConstant.GridSize
    self:setContentSize(mapSize.width * gridSize.width, mapSize.height * gridSize.height)
        :setPositionOnDrag({x = 0, y = 0}, {x = 0, y = 0}) -- to make the field sits in middle of the screen, if the field is smaller than screen.

	return self
end

function ViewWarField:setTouchableChildrenViews(views)
    self.m_TouchableChildrenViews = views
    
    return self
end

return ViewWarField
