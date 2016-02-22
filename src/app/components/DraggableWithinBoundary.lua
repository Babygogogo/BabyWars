
local DraggableWithinBoundary = class("DraggableWithinBoundary")
local Requirer			= require"app.utilities.Requirer"
local ComponentManager	= require("app.global.components.ComponentManager")

local EXPORTED_METHODS = {
	"setDragWithinBoundaryEnabled",
	"setDragBoundaryRect"
}

function DraggableWithinBoundary:init_()
	self.target_ = nil
	self.boundaryRect_ = {width = 0, height = 0, x = 0, y = 0}
	self:initTouchListener_()
end

function DraggableWithinBoundary:initTouchListener_()
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

function DraggableWithinBoundary:registerListenerToTarget_()
	if not self.touchListener_.isRegistered_ then
		local eventDispatcher = self.target_:getEventDispatcher()
		eventDispatcher:addEventListenerWithSceneGraphPriority(self.touchListener_, self.target_)
		self.touchListener_.isRegistered_ = true
	end
end

function DraggableWithinBoundary:unregisterListenerFromTarget_()
	if self.touchListener_.isRegistered_ then
		local eventDispatcher = self.target_:getEventDispatcher()
		eventDispatcher:removeEventListener(self.touchListener_)
		self.touchListener_.isRegistered_ = false
	end
end

function DraggableWithinBoundary:bind(target)
	assert(iskindof(target, "cc.Node"), "DraggableWithinBoundary:bind() the param target is not a kind of cc.Node.")

	self:init_()
	ComponentManager.setMethods(target, self, EXPORTED_METHODS)

	self.target_ = target
	self:registerListenerToTarget_()
end

function DraggableWithinBoundary:unbind(target)
	assert(target == self.target_ , "DraggableWithinBoundary:unbind() the component is not bind to the parameter target")
	assert(self.target_, "DraggableWithinBoundary:unbind() the component is not bind to any target.")

	require"app.components.ComponentManager".unsetMethods(target, EXPORTED_METHODS)
	self:unregisterListenerFromTarget_()
	self:init_()
end

function DraggableWithinBoundary:setDragWithinBoundaryEnabled(isEnable)
	if isEnable then
		self:registerListenerToTarget_()
	else
		self:unregisterListenerFromTarget_()
	end

	return self.target_
end

function DraggableWithinBoundary:setDragBoundaryRect(boundaryRect)
	self.boundaryRect_ = boundaryRect

	return self.target_
end

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

function DraggableWithinBoundary:getNewPosOnDrag_(dragDeltaX, dragDeltaY)
	local boundingBox = self.target_:getBoundingBox()
	return
		getNewPosComponentOnDrag_(self.target_:getPositionX(), dragDeltaX, boundingBox.width,  boundingBox.x, self.boundaryRect_.width,  self.boundaryRect_.x),
		getNewPosComponentOnDrag_(self.target_:getPositionY(), dragDeltaY, boundingBox.height, boundingBox.y, self.boundaryRect_.height, self.boundaryRect_.y)
end

return DraggableWithinBoundary
