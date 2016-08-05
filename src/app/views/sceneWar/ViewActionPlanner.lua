
local ViewActionPlanner = class("ViewActionPlanner", cc.Node)

local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")
local Actor              = require("src.global.actors.Actor")

local MOVE_PATH_Z_ORDER                = 1
local PREVIEW_DROP_DESTINATION_Z_ORDER = 1
local DROP_DESTIONATIONS_Z_ORDER       = 1
local REACHABLE_GRIDS_Z_ORDER          = 0
local ATTACKABLE_GRIDS_Z_ORDER         = 0
local MOVE_PATH_DESTINATION_Z_ORDER    = 0
local DROPPABLE_GRIDS_Z_ORDER          = 0
local PREVIEW_ATTACKABLE_AREA_Z_ORDER  = 0
local DROP_DESTIONATIONS_UNIT_Z_ORDER  = 0

local ATTACKABLE_GRIDS_OPACITY = 140
local REACHABLE_GRIDS_OPACITY  = 150

local SPRITE_FRAME_NAME_EMPTY             = nil
local SPRITE_FRAME_NAME_LINE_VERTICAL     = "c03_t02_s01_f01.png"
local SPRITE_FRAME_NAME_LINE_HORIZONTAL   = "c03_t02_s02_f01.png"
local SPRITE_FRAME_NAME_ARROW_UP          = "c03_t02_s03_f01.png"
local SPRITE_FRAME_NAME_ARROW_DOWN        = "c03_t02_s04_f01.png"
local SPRITE_FRAME_NAME_ARROW_LEFT        = "c03_t02_s05_f01.png"
local SPRITE_FRAME_NAME_ARROW_RIGHT       = "c03_t02_s06_f01.png"
local SPRITE_FRAME_NAME_CORNER_DOWN_LEFT  = "c03_t02_s07_f01.png"
local SPRITE_FRAME_NAME_CORNER_DOWN_RIGHT = "c03_t02_s08_f01.png"
local SPRITE_FRAME_NAME_CORNER_UP_LEFT    = "c03_t02_s09_f01.png"
local SPRITE_FRAME_NAME_CORNER_UP_RIGHT   = "c03_t02_s10_f01.png"

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createViewSingleReachableGridWithXY(x, y)
    local view = cc.Sprite:create()
    view:ignoreAnchorPointForPosition(true)
        :setPosition(GridIndexFunctions.toPositionWithXY(x, y))
        :playAnimationForever(display.getAnimationCache("ReachableGrid"))

    return view
end

local function createViewSingleReachableGrid(gridIndex)
    return createViewSingleReachableGridWithXY(gridIndex.x, gridIndex.y)
end

local function createViewSingleAttackableGridWithXY(x, y)
    local view = cc.Sprite:create()
    view:ignoreAnchorPointForPosition(true)
        :setPosition(GridIndexFunctions.toPositionWithXY(x, y))
        :playAnimationForever(display.getAnimationCache("AttackableGrid"))

    return view
end

local function createViewSingleAttackableGrid(gridIndex)
    return createViewSingleAttackableGridWithXY(gridIndex.x, gridIndex.y)
end

local function getSpriteFrameName(prevDirection, nextDirection)
    if (prevDirection == nextDirection) then
        return SPRITE_FRAME_NAME_EMPTY
    end

    if (prevDirection == "invalid") then
        if     (nextDirection == "invalid") then return SPRITE_FRAME_NAME_EMPTY
        elseif (nextDirection == "up"     ) then return SPRITE_FRAME_NAME_LINE_VERTICAL
        elseif (nextDirection == "down"   ) then return SPRITE_FRAME_NAME_LINE_VERTICAL
        elseif (nextDirection == "left"   ) then return SPRITE_FRAME_NAME_LINE_HORIZONTAL
        elseif (nextDirection == "right"  ) then return SPRITE_FRAME_NAME_LINE_HORIZONTAL
        else   error("ViewActionPlanner-getSpriteFrameName() the param nextDirection is invalid.")
        end
    elseif (prevDirection == "up") then
        if     (nextDirection == "invalid") then return SPRITE_FRAME_NAME_ARROW_DOWN
        elseif (nextDirection == "up"     ) then return SPRITE_FRAME_NAME_EMPTY
        elseif (nextDirection == "down"   ) then return SPRITE_FRAME_NAME_LINE_VERTICAL
        elseif (nextDirection == "left"   ) then return SPRITE_FRAME_NAME_CORNER_UP_LEFT
        elseif (nextDirection == "right"  ) then return SPRITE_FRAME_NAME_CORNER_UP_RIGHT
        else   error("ViewActionPlanner-getSpriteFrameName() the param nextDirection is invalid.")
        end
    elseif (prevDirection == "down") then
        if     (nextDirection == "invalid") then return SPRITE_FRAME_NAME_ARROW_UP
        elseif (nextDirection == "up"     ) then return SPRITE_FRAME_NAME_LINE_VERTICAL
        elseif (nextDirection == "down"   ) then return SPRITE_FRAME_NAME_EMPTY
        elseif (nextDirection == "left"   ) then return SPRITE_FRAME_NAME_CORNER_DOWN_LEFT
        elseif (nextDirection == "right"  ) then return SPRITE_FRAME_NAME_CORNER_DOWN_RIGHT
        else   error("ViewActionPlanner-getSpriteFrameName() the param nextDirection is invalid.")
        end
    elseif (prevDirection == "left") then
        if     (nextDirection == "invalid") then return SPRITE_FRAME_NAME_ARROW_RIGHT
        elseif (nextDirection == "up"     ) then return SPRITE_FRAME_NAME_CORNER_UP_LEFT
        elseif (nextDirection == "down"   ) then return SPRITE_FRAME_NAME_CORNER_DOWN_LEFT
        elseif (nextDirection == "left"   ) then return SPRITE_FRAME_NAME_EMPTY
        elseif (nextDirection == "right"  ) then return SPRITE_FRAME_NAME_LINE_HORIZONTAL
        else   error("ViewActionPlanner-getSpriteFrameName() the param nextDirection is invalid.")
        end
    elseif (prevDirection == "right") then
        if     (nextDirection == "invalid") then return SPRITE_FRAME_NAME_ARROW_LEFT
        elseif (nextDirection == "up"     ) then return SPRITE_FRAME_NAME_CORNER_UP_RIGHT
        elseif (nextDirection == "down"   ) then return SPRITE_FRAME_NAME_CORNER_DOWN_RIGHT
        elseif (nextDirection == "left"   ) then return SPRITE_FRAME_NAME_LINE_HORIZONTAL
        elseif (nextDirection == "right"  ) then return SPRITE_FRAME_NAME_EMPTY
        else   error("ViewActionPlanner-getSpriteFrameName() the param nextDirection is invalid.")
        end
    else
        error("ViewActionPlanner-getSpriteFrameName() the param prevDirection is invalid.")
    end
end

local function createViewSingleMovePathGrid(gridIndex, prevGridIndex, nextGridIndex)
    local prevDirection   = GridIndexFunctions.getAdjacentDirection(prevGridIndex, gridIndex)
    local nextDirection   = GridIndexFunctions.getAdjacentDirection(nextGridIndex, gridIndex)
    local spriteFrameName = getSpriteFrameName(prevDirection, nextDirection)

    if (spriteFrameName) then
        local view = cc.Sprite:createWithSpriteFrameName(spriteFrameName)
        view:ignoreAnchorPointForPosition(true)
            :setPosition(GridIndexFunctions.toPosition(gridIndex))

        return view
    else
        return nil
    end
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initViewAttackableGrids(self)
    local view = cc.Node:create()
    view:setOpacity(ATTACKABLE_GRIDS_OPACITY)
        :setCascadeOpacityEnabled(true)

    self.m_ViewAttackableGrids = view
    self:addChild(view, ATTACKABLE_GRIDS_Z_ORDER)
end

local function initViewMovePathDestination(self)
    local view = cc.Sprite:create()
    view:ignoreAnchorPointForPosition(true)
        :setOpacity(REACHABLE_GRIDS_OPACITY)
        :setVisible(false)
        :playAnimationForever(display.getAnimationCache("ReachableGrid"))

    self.m_ViewMovePathDestination = view
    self:addChild(view, MOVE_PATH_DESTINATION_Z_ORDER)
end

local function initViewMovePath(self)
    local view = cc.Node:create()

    self.m_ViewMovePath = view
    self:addChild(view, MOVE_PATH_Z_ORDER)
end

local function initViewPreviewDropDestination(self)
    local view = Actor.createView("sceneWar.ViewUnit")
    view:setVisible(false)
        :setOpacity(REACHABLE_GRIDS_OPACITY)
        :setCascadeOpacityEnabled(true)

    self.m_ViewPreviewDropDestination = view
    self:addChild(view, PREVIEW_DROP_DESTINATION_Z_ORDER)
end

local function initViewDropDestinations(self)
    local view = cc.Node:create()
    view:ignoreAnchorPointForPosition(true)
        :setVisible(false)
        :setOpacity(REACHABLE_GRIDS_OPACITY)
        :setCascadeOpacityEnabled(true)

    self.m_ViewDropDestinations = view
    self:addChild(view, DROP_DESTIONATIONS_Z_ORDER)
end

local function initViewDroppableGrids(self)
    local view = cc.Node:create()
    view:setOpacity(REACHABLE_GRIDS_OPACITY)
        :setCascadeOpacityEnabled(true)

    self.m_ViewDroppableGrids = view
    self:addChild(view, DROPPABLE_GRIDS_Z_ORDER)
end

local function initViewReachableArea(self)
    local view = cc.Node:create()
    view:setOpacity(REACHABLE_GRIDS_OPACITY)
        :setCascadeOpacityEnabled(true)

    local grids = {}
    local width, height = self.m_MapSize.width, self.m_MapSize.height
    for x = 1, width do
        grids[x] = {}
        for y = 1, height do
            local grid = createViewSingleReachableGridWithXY(x, y)
            grid:setVisible(false)

            view:addChild(grid)
            grids[x][y] = grid
        end
    end

    self.m_ViewReachableArea  = view
    self.m_ViewReachableGrids = grids
    self:addChild(view, REACHABLE_GRIDS_Z_ORDER)
end

local function initViewPreviewAttackableArea(self)
    local view = cc.Node:create()
    view:setOpacity(ATTACKABLE_GRIDS_OPACITY)
        :setCascadeOpacityEnabled(true)

    local grids = {}
    local width, height = self.m_MapSize.width, self.m_MapSize.height
    for x = 1, width do
        grids[x] = {}
        for y = 1, height do
            local grid = createViewSingleAttackableGridWithXY(x, y)
            grid:setVisible(false)

            view:addChild(grid)
            grids[x][y] = grid
        end
    end

    self.m_ViewPreviewAttackableArea  = view
    self.m_ViewPreviewAttackableGrids = grids
    self:addChild(view, PREVIEW_ATTACKABLE_AREA_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewActionPlanner:ctor(param)
    initViewAttackableGrids(       self)
    initViewMovePathDestination(   self)
    initViewMovePath(              self)
    initViewPreviewDropDestination(self)
    initViewDropDestinations(      self)
    initViewDroppableGrids(        self)

    return self
end

function ViewActionPlanner:setMapSize(size)
    assert(self.m_MapSize == nil, "ViewActionPlanner:setMapSize() the size has been set already.")
    self.m_MapSize = size
    initViewReachableArea(        self)
    initViewPreviewAttackableArea(self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewActionPlanner:setReachableArea(area)
    local width, height = self.m_MapSize.width, self.m_MapSize.height
    local grids         = self.m_ViewReachableGrids
    for x = 1, width do
        for y = 1, height do
            grids[x][y]:setVisible((area[x]) and (area[x][y] ~= nil))
        end
    end

    return self
end

function ViewActionPlanner:setReachableAreaVisible(visible)
    self.m_ViewReachableArea:setVisible(visible)

    return self
end

function ViewActionPlanner:setAttackableGrids(grids)
    self.m_ViewAttackableGrids:removeAllChildren()

    for _, gridIndex in ipairs(grids) do
        self.m_ViewAttackableGrids:addChild(createViewSingleAttackableGrid(gridIndex))
    end

    return self
end

function ViewActionPlanner:setAttackableGridsVisible(visible)
    self.m_ViewAttackableGrids:setVisible(visible)

    return self
end

function ViewActionPlanner:setMovePath(path)
    self.m_ViewMovePath:removeAllChildren()

    for i = 1, #path do
        local prevGridIndex = path[i - 1] and path[i - 1].gridIndex or nil
        local nextGridIndex = path[i + 1] and path[i + 1].gridIndex or nil

        local gridView = createViewSingleMovePathGrid(path[i].gridIndex, prevGridIndex, nextGridIndex)
        if (gridView) then
            self.m_ViewMovePath:addChild(gridView)
        end
    end

    return self
end

function ViewActionPlanner:setMovePathVisible(visible)
    self.m_ViewMovePath:setVisible(visible)

    return self
end

function ViewActionPlanner:setMovePathDestination(gridIndex)
    self.m_ViewMovePathDestination:setPosition(GridIndexFunctions.toPosition(gridIndex))

    return self
end

function ViewActionPlanner:setMovePathDestinationVisible(visible)
    self.m_ViewMovePathDestination:setVisible(visible)

    return self
end

function ViewActionPlanner:setDroppableGrids(grids)
    self.m_ViewDroppableGrids:removeAllChildren()

    for _, gridIndex in pairs(grids) do
        self.m_ViewDroppableGrids:addChild(createViewSingleReachableGrid(gridIndex))
    end

    return self
end

function ViewActionPlanner:setDroppableGridsVisible(visible)
    self.m_ViewDroppableGrids:setVisible(visible)

    return self
end

function ViewActionPlanner:setPreviewDropDestination(gridIndex, modelUnit)
    self.m_ViewPreviewDropDestination:updateWithModelUnit(modelUnit)
        :setPosition(GridIndexFunctions.toPosition(gridIndex))

    return self
end

function ViewActionPlanner:setPreviewDropDestinationVisible(visible)
    self.m_ViewPreviewDropDestination:setVisible(visible)

    return self
end

function ViewActionPlanner:setDropDestinations(destinations)
    local viewDropDestinations = self.m_ViewDropDestinations
    viewDropDestinations:removeAllChildren()

    for _, destination in pairs(destinations) do
        local viewUnit = Actor.createView("sceneWar.ViewUnit"):updateWithModelUnit(destination.modelUnit)
        viewUnit:setPosition(GridIndexFunctions.toPosition(destination.gridIndex))
            :setCascadeOpacityEnabled(true)
        viewDropDestinations:addChild(viewUnit, DROP_DESTIONATIONS_UNIT_Z_ORDER)
    end

    return self
end

function ViewActionPlanner:setDropDestinationsVisible(visible)
    self.m_ViewDropDestinations:setVisible(visible)

    return self
end

function ViewActionPlanner:setPreviewAttackableArea(area)
    local width, height = self.m_MapSize.width, self.m_MapSize.height
    local grids         = self.m_ViewPreviewAttackableGrids
    for x = 1, width do
        for y = 1, height do
            grids[x][y]:setVisible((area[x]) and (area[x][y] ~= nil))
        end
    end

    return self
end

function ViewActionPlanner:setPreviewAttackableAreaVisible(visible)
    self.m_ViewPreviewAttackableArea:setVisible(visible)

    return self
end

return ViewActionPlanner
