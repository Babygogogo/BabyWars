
local ViewWarField = class("ViewWarField", cc.Node)

local TypeChecker        = require("app.utilities.TypeChecker")

local GRID_SIZE = require("app.utilities.GameConstantFunctions").getGridSize()

local ORIGIN = {x = 0, y = 0}
local BOUNDARY_RECT  = {upperRightX = display.width - 10, upperRightY = display.height - 10, lowerLeftX = 10, lowerLeftY = 10}
      BOUNDARY_RECT.width  = BOUNDARY_RECT.upperRightX - BOUNDARY_RECT.lowerLeftX
      BOUNDARY_RECT.height = BOUNDARY_RECT.upperRightY - BOUNDARY_RECT.lowerLeftY

local MAP_CURSOR_Z_ORDER     = 4
local GRID_EXPLOSION_Z_ORDER = 3
local UNIT_MAP_Z_ORDER       = 2
local ACTION_PLANNER_Z_ORDER = 1
local TILE_MAP_Z_ORDER       = 0

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getScaleWithModifier(self, modifier)
    local newScale = self:getScale() * modifier
    newScale = math.max(self.m_MinScale, newScale)
    newScale = math.min(self.m_MaxScale, newScale)

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
local function isViewSmallerThanBoundaryRect(scale, contentSize)
    local width  = contentSize.width * scale
    local height = contentSize.height * scale

    return (width <= BOUNDARY_RECT.width) and (height <= BOUNDARY_RECT.height)
end

local function shouldZoom(self, focusPosInNode, scaleModifier)
    if ((focusPosInNode.x < 0) or (focusPosInNode.x > self.m_ContentSize.width) or
        (focusPosInNode.y < 0) or (focusPosInNode.y > self.m_ContentSize.height)) then
        return false
    end

    local currentScale = self:getScale()
    if (((scaleModifier < 1) and (isViewSmallerThanBoundaryRect(currentScale, self.m_ContentSize))) or
        ((scaleModifier > 1) and (currentScale >= self.m_MaxScale)) or
        (scaleModifier == 1)) then
        return false
    else
        return true
    end
end

local function setZoom(self, focusPosInWorld, focusPosInNode, scaleModifier)
    self:setScale(getScaleWithModifier(self, scaleModifier))
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
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewWarField:ctor(param)
    self:ignoreAnchorPointForPosition(true)
        :setAnchorPoint(0, 0)
    self.m_ContentSize = {}

    return self
end

function ViewWarField:setViewTileMap(view)
    if (self.m_ViewTileMap) then
        if (self.m_ViewTileMap == view) then
            return self
        else
            self:removeChild(self.m_ViewTileMap)
        end
    end

    self.m_ViewTileMap = view
    self:addChild(view, TILE_MAP_Z_ORDER)

    return self
end

function ViewWarField:setViewUnitMap(view)
    if (self.m_ViewUnitMap) then
        if (self.m_ViewUnitMap == view) then
            return self
        else
            self:removeChild(self.m_ViewUnitMap)
        end
    end

    self.m_ViewUnitMap = view
    self:addChild(view, UNIT_MAP_Z_ORDER)

    return self
end

function ViewWarField:setViewActionPlanner(view)
    if (self.m_ViewActionPlanner) then
        if (self.m_ViewActionPlanner == view) then
            return self
        else
            self:removeChild(self.m_ViewActionPlanner)
        end
    end

    self.m_ViewActionPlanner = view
    self:addChild(view, ACTION_PLANNER_Z_ORDER)

    return self
end

function ViewWarField:setViewMapCursor(view)
    if (self.m_MapCursorView) then
        if (self.m_MapCursorView == view) then
            return self
        else
            self:removeChild(self.m_MapCursorView)
        end
    end

    self.m_MapCursorView = view
    self:addChild(view, MAP_CURSOR_Z_ORDER)

    return self
end

function ViewWarField:setViewGridExplosion(view)
    if (self.m_ViewGridExplosion) then
        if (self.m_ViewGridExplosion == view) then
            return self
        else
            self:removeChild(self.m_ViewGridExplosion)
        end
    end

    self.m_ViewGridExplosion = view
    self:addChild(view, GRID_EXPLOSION_Z_ORDER)

    return self
end

function ViewWarField:setContentSizeWithMapSize(mapSize)
    self.m_ContentSize.width  = mapSize.width  * GRID_SIZE.width
    self.m_ContentSize.height = mapSize.height * GRID_SIZE.height
    self.m_MaxScale = 2
    self.m_MinScale = math.min(BOUNDARY_RECT.width  / self.m_ContentSize.width,
                               BOUNDARY_RECT.height / self.m_ContentSize.height)

    self:setContentSize(self.m_ContentSize.width, self.m_ContentSize.height)
        :placeInDragBoundary()

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewWarField:setZoomWithScroll(focusPosInWorld, scrollValue)
    local focusPosInNode = self:convertToNodeSpace(focusPosInWorld)
    local scaleModifier  = getScaleModifierWithScrollValue(scrollValue)
    if (shouldZoom(self, focusPosInNode, scaleModifier)) then
        setZoom(self, focusPosInWorld, focusPosInNode, scaleModifier)
    end

    return self
end

function ViewWarField:setPositionOnDrag(previousDragPos, currentDragPos)
    local boundingBox = self:getBoundingBox()
    local dragDeltaX, dragDeltaY = currentDragPos.x - previousDragPos.x, currentDragPos.y - previousDragPos.y

    self:setPosition(getNewPosComponentOnDrag(self:getPositionX(), dragDeltaX, boundingBox.width,  boundingBox.x, BOUNDARY_RECT.upperRightX, BOUNDARY_RECT.lowerLeftX),
                     getNewPosComponentOnDrag(self:getPositionY(), dragDeltaY, boundingBox.height, boundingBox.y, BOUNDARY_RECT.upperRightY, BOUNDARY_RECT.lowerLeftY))

    return self
end

function ViewWarField:placeInDragBoundary()
    self:setPositionOnDrag(ORIGIN, ORIGIN)

    return self
end

function ViewWarField:setZoomWithTouches(touches)
    local focusPosInWorld = getMiddlePointForTouches(touches)
    local focusPosInNode  = self:convertToNodeSpace(focusPosInWorld)
    local scaleModifier   = getScaleModifierWithTouches(touches)
    if (shouldZoom(self, focusPosInNode, scaleModifier)) then
        setZoom(self, focusPosInWorld, focusPosInNode, scaleModifier)
    end

    return self
end

return ViewWarField
