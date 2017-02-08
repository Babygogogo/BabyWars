
local ViewActionPlanner = class("ViewActionPlanner", cc.Node)

local GridIndexFunctions = requireBW("src.app.utilities.GridIndexFunctions")
local Actor              = requireBW("src.global.actors.Actor")

local MOVE_PATH_Z_ORDER                = 1
local PREVIEW_DROP_DESTINATION_Z_ORDER = 1
local DROP_DESTIONATIONS_Z_ORDER       = 1
local FLARE_AREA_Z_ORDER               = 0
local REACHABLE_GRIDS_Z_ORDER          = 0
local ATTACKABLE_GRIDS_Z_ORDER         = 0
local MOVE_PATH_DESTINATION_Z_ORDER    = 0
local DROPPABLE_GRIDS_Z_ORDER          = 0
local PREVIEW_ATTACKABLE_AREA_Z_ORDER  = 0
local PREVIEW_REACHABLE_AREA_Z_ORDER   = 0
local DROP_DESTIONATIONS_UNIT_Z_ORDER  = 0

local ATTACKABLE_GRIDS_OPACITY = 140
local REACHABLE_GRIDS_OPACITY  = 150

local SPRITE_FRAME_NAME_EMPTY             = nil
local SPRITE_FRAME_NAME_LINE_VERTICAL     = "c01_t99_s04_f01.png"
local SPRITE_FRAME_NAME_LINE_HORIZONTAL   = "c01_t99_s04_f02.png"
local SPRITE_FRAME_NAME_ARROW_UP          = "c01_t99_s04_f03.png"
local SPRITE_FRAME_NAME_ARROW_DOWN        = "c01_t99_s04_f04.png"
local SPRITE_FRAME_NAME_ARROW_LEFT        = "c01_t99_s04_f05.png"
local SPRITE_FRAME_NAME_ARROW_RIGHT       = "c01_t99_s04_f06.png"
local SPRITE_FRAME_NAME_CORNER_DOWN_LEFT  = "c01_t99_s04_f07.png"
local SPRITE_FRAME_NAME_CORNER_DOWN_RIGHT = "c01_t99_s04_f08.png"
local SPRITE_FRAME_NAME_CORNER_UP_LEFT    = "c01_t99_s04_f09.png"
local SPRITE_FRAME_NAME_CORNER_UP_RIGHT   = "c01_t99_s04_f10.png"

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

local function createViewAreaAndGrids(mapSize, gridCreator, opacity)
    local area = cc.Node:create()
    area:setOpacity(opacity)
        :setCascadeOpacityEnabled(true)

    local grids = {}
    local width, height = mapSize.width, mapSize.height
    for x = 1, width do
        grids[x] = {}
        for y = 1, height do
            local grid = gridCreator(x, y)
            grid:setVisible(false)

            area:addChild(grid)
            grids[x][y] = grid
        end
    end

    return area, grids
end

local function setGridsVisibleWithArea(grids, area)
    for x = 1, #grids do
        for y = 1, #grids[x] do
            grids[x][y]:setVisible((area[x]) and (area[x][y] ~= nil))
        end
    end
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
    self.m_ViewReachableArea, self.m_ViewReachableGrids = createViewAreaAndGrids(
        self.m_MapSize,
        createViewSingleReachableGridWithXY,
        REACHABLE_GRIDS_OPACITY
    )
    self:addChild(self.m_ViewReachableArea, REACHABLE_GRIDS_Z_ORDER)
end

local function initViewPreviewAttackableArea(self)
    self.m_ViewPreviewAttackableArea, self.m_ViewPreviewAttackableGrids = createViewAreaAndGrids(
        self.m_MapSize,
        createViewSingleAttackableGridWithXY,
        ATTACKABLE_GRIDS_OPACITY
    )
    self:addChild(self.m_ViewPreviewAttackableArea, PREVIEW_ATTACKABLE_AREA_Z_ORDER)
end

local function initViewPreviewReachableArea(self)
    self.m_ViewPreviewReachableArea, self.m_ViewPreviewReachableGrids = createViewAreaAndGrids(
        self.m_MapSize,
        createViewSingleReachableGridWithXY,
        REACHABLE_GRIDS_OPACITY
    )
    self:addChild(self.m_ViewPreviewReachableArea, PREVIEW_REACHABLE_AREA_Z_ORDER)
end

local function initViewFlareArea(self)
    self.m_ViewFlareArea, self.m_ViewFlareGrids = createViewAreaAndGrids(
        self.m_MapSize,
        createViewSingleReachableGridWithXY,
        REACHABLE_GRIDS_OPACITY
    )
    self:addChild(self.m_ViewFlareArea, FLARE_AREA_Z_ORDER)
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
    if (not self.m_MapSize) then
        self.m_MapSize = size
        initViewReachableArea(        self)
        initViewPreviewAttackableArea(self)
        initViewPreviewReachableArea( self)
        initViewFlareArea(            self)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
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

function ViewActionPlanner:setMovePath(pathNodes)
    self.m_ViewMovePath:removeAllChildren()

    for i = 1, #pathNodes do
        local gridView = createViewSingleMovePathGrid(pathNodes[i], pathNodes[i - 1], pathNodes[i + 1])
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
        local viewUnit = Actor.createView("sceneWar.ViewUnit")
        viewUnit:updateWithModelUnit(destination.modelUnit)
            :setPosition(GridIndexFunctions.toPosition(destination.gridIndex))
            :setCascadeOpacityEnabled(true)
        viewDropDestinations:addChild(viewUnit, DROP_DESTIONATIONS_UNIT_Z_ORDER)
    end

    return self
end

function ViewActionPlanner:setDropDestinationsVisible(visible)
    self.m_ViewDropDestinations:setVisible(visible)

    return self
end

function ViewActionPlanner:setReachableArea(area)
    setGridsVisibleWithArea(self.m_ViewReachableGrids, area)

    return self
end

function ViewActionPlanner:setReachableAreaVisible(visible)
    self.m_ViewReachableArea:setVisible(visible)

    return self
end

function ViewActionPlanner:setPreviewAttackableArea(area)
    setGridsVisibleWithArea(self.m_ViewPreviewAttackableGrids, area)

    return self
end

function ViewActionPlanner:setPreviewAttackableAreaVisible(visible)
    self.m_ViewPreviewAttackableArea:setVisible(visible)

    return self
end

function ViewActionPlanner:setPreviewReachableArea(area)
    setGridsVisibleWithArea(self.m_ViewPreviewReachableGrids, area)

    return self
end

function ViewActionPlanner:setPreviewReachableAreaVisible(visible)
    self.m_ViewPreviewReachableArea:setVisible(visible)

    return self
end

function ViewActionPlanner:setFlareGrids(origin, radius)
    local grids         = self.m_ViewFlareGrids
    local mapSize       = self.m_MapSize
    local width, height = mapSize.width, mapSize.height

    for x = 1, width do
        for y = 1, height do
            grids[x][y]:setVisible(GridIndexFunctions.getDistance(origin, {x = x, y = y}) <= radius)
        end
    end

    return self
end

function ViewActionPlanner:setFlareGridsVisible(visible)
    self.m_ViewFlareArea:setVisible(visible)

    return self
end

return ViewActionPlanner
