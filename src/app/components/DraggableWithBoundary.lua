
local DraggableWithBoundary = class("DraggableWithBoundary")

local EXPORTED_METHODS = {
	"setDragWithBoundaryEnabled",
	"setDragBoundaryRect"
}

function DraggableWithBoundary:init_()
	self.target_ = nil
	self.boundaryRect_ = {width = display.width, height = display.height, x = 0, y = 0}
	self:initTouchListener_()
end

function DraggableWithBoundary:initTouchListener_()
	if self.touchListener_ then return end

	local function onTouchBegan(touch, event)
		return true
	end
	local function onTouchMoved(touch, event)
		local touchedPos = touch:getLocation()
		local prevTouchedPos = touch:getPreviousLocation()

		self.target_:setPosition(self:getNewPosOnDrag_(touchedPos.x - prevTouchedPos.x, touchedPos.y - prevTouchedPos.y))
	end

	self.touchListener_ = cc.EventListenerTouchOneByOne:create()
	self.touchListener_:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	self.touchListener_:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)

	self.touchListener_.isRegistered_ = false
end

function DraggableWithBoundary:registerListenerToTarget_()
	if not self.touchListener_.isRegistered_ then
		local eventDispatcher = self.target_:getEventDispatcher()
		eventDispatcher:addEventListenerWithSceneGraphPriority(self.touchListener_, self.target_)
		self.touchListener_.isRegistered_ = true
	end
end

function DraggableWithBoundary:unregisterListenerFromTarget_()
	if self.touchListener_.isRegistered_ then
		local eventDispatcher = self.target_:getEventDispatcher()
		eventDispatcher:removeEventListener(self.touchListener_)
		self.touchListener_.isRegistered_ = false
	end
end

function DraggableWithBoundary:bind(target)
	self:init_()
	require"app.components.ComponentManager".setMethods(target, self, EXPORTED_METHODS)

	self.target_ = target
	self:registerListenerToTarget_()
end

function DraggableWithBoundary:unbind(target)
	assert(target == self.target_ , "DraggableWithBoundary:unbind() the component is not bind to the parameter target")
	assert(self.target_, "DraggableWithBoundary:unbind() the component is not bind to any target.")

	require"app.components.ComponentManager".unsetMethods(target, EXPORTED_METHODS)
	self:unregisterListenerFromTarget_()
	self:init_()
end

function DraggableWithBoundary:setDragWithBoundaryEnabled(isEnable)
	if isEnable then
		self:registerListenerToTarget_()
	else
		self:unregisterListenerFromTarget_()
	end

	return self.target_
end

function DraggableWithBoundary:setDragBoundaryRect(boundaryRect)
	self.boundaryRect_ = boundaryRect

	return self.target_
end

function DraggableWithBoundary:getNewPosOnDrag_(dragDeltaX, dragDeltaY)
	local boundingBox = self.target_:getBoundingBox()

	return
		self:getNewPosComponentOnDrag_(self.target_:getPositionX(), dragDeltaX, boundingBox.width,  boundingBox.x, self.boundaryRect_.width,  self.boundaryRect_.x),
		self:getNewPosComponentOnDrag_(self.target_:getPositionY(), dragDeltaY, boundingBox.height, boundingBox.y, self.boundaryRect_.height, self.boundaryRect_.y)
end

function DraggableWithBoundary:getNewPosComponentOnDrag_(currentPosComp, dragDeltaComp, targetSizeComp, targetOriginComp, boundarySizeComp, boundaryOriginComp)
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

return DraggableWithBoundary
