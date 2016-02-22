
local ViewWarField = class("ViewWarField", cc.Node)

local TypeChecker  = require("app.utilities.TypeChecker")
local GameConstant = require("res.data.GameConstant")

local BoundaryRect  = {width = display.width - 10, height = display.height - 10, x = 10, y = 10}

local function getNewPosComponentOnDrag_(currentPosComp, dragDeltaComp, targetSizeComp, targetOriginComp, boundarySizeComp, boundaryOriginComp)
	local minOrigin = boundarySizeComp - targetSizeComp
	local maxOrigin = boundaryOriginComp

	if minOrigin <= maxOrigin then
		if dragDeltaComp + targetOriginComp < minOrigin then dragDeltaComp = minOrigin - targetOriginComp end
		if dragDeltaComp + targetOriginComp > maxOrigin then dragDeltaComp = maxOrigin - targetOriginComp end
	else
		dragDeltaComp = 0
	end

	return dragDeltaComp + currentPosComp
end

function ViewWarField:setPositionOnDrag(previousDragPos, currentDragPos)
    local boundingBox = self:getBoundingBox()
    local dragDeltaX, dragDeltaY = currentDragPos.x - previousDragPos.x, currentDragPos.y - previousDragPos.y
    
    self:move(getNewPosComponentOnDrag_(self:getPositionX(), dragDeltaX, boundingBox.width,  boundingBox.x, BoundaryRect.width,  BoundaryRect.x),
              getNewPosComponentOnDrag_(self:getPositionY(), dragDeltaY, boundingBox.height, boundingBox.y, BoundaryRect.height, BoundaryRect.y))
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

function ViewWarField:isResponsiveToTouch(touch, touchType, event)
    if (touchType == cc.Handler.EVENT_TOUCH_MOVED) then
        return true
    end
    
    return false
end

function ViewWarField:onTouch(touch, touchType, event)
    if (touchType == cc.Handler.EVENT_TOUCH_MOVED) then
        self:setPositionOnDrag(touch:getPreviousLocation(), touch:getLocation())
    end
end

function ViewWarField:setContentSizeWithMapSize(mapSize)
	assert(TypeChecker.isMapSize(mapSize))

	local gridSize = GameConstant.GridSize
	self:setContentSize(mapSize.width * gridSize.width, mapSize.height * gridSize.height)
	
	return self
end

return ViewWarField
