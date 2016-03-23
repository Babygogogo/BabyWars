
local ViewActionPlanner = class("ViewActionPlanner", cc.Node)

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

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

--------------------------------------------------------------------------------
-- The reachable grids view.
--------------------------------------------------------------------------------
local function createSingleReachableGridView(gridIndex)
    local view = cc.Sprite:createWithSpriteFrameName("c03_t03_s01_f01.png")
    view:ignoreAnchorPointForPosition(true)
        :setPosition(GridIndexFunctions.toPosition(gridIndex))

    return view
end

local function createReachableGridsView()
    local view = cc.Node:create()
    view:setOpacity(160)
        :setCascadeOpacityEnabled(true)

    return view
end

local function initWithReachableGridsView(view, gridsView)
    view.m_ReachableGridsView = gridsView
    view:addChild(gridsView)
end

--------------------------------------------------------------------------------
-- The move path.
--------------------------------------------------------------------------------
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
        else   error("ViewActionPlanner-getSpriteFrameName() the param nextDirection is invalid.") end
    elseif (prevDirection == "up") then
        if     (nextDirection == "invalid") then return SPRITE_FRAME_NAME_ARROW_DOWN
        elseif (nextDirection == "up"     ) then return SPRITE_FRAME_NAME_EMPTY
        elseif (nextDirection == "down"   ) then return SPRITE_FRAME_NAME_LINE_VERTICAL
        elseif (nextDirection == "left"   ) then return SPRITE_FRAME_NAME_CORNER_UP_LEFT
        elseif (nextDirection == "right"  ) then return SPRITE_FRAME_NAME_CORNER_UP_RIGHT
        else   error("ViewActionPlanner-getSpriteFrameName() the param nextDirection is invalid.") end
    elseif (prevDirection == "down") then
        if     (nextDirection == "invalid") then return SPRITE_FRAME_NAME_ARROW_UP
        elseif (nextDirection == "up"     ) then return SPRITE_FRAME_NAME_LINE_VERTICAL
        elseif (nextDirection == "down"   ) then return SPRITE_FRAME_NAME_EMPTY
        elseif (nextDirection == "left"   ) then return SPRITE_FRAME_NAME_CORNER_DOWN_LEFT
        elseif (nextDirection == "right"  ) then return SPRITE_FRAME_NAME_CORNER_DOWN_RIGHT
        else   error("ViewActionPlanner-getSpriteFrameName() the param nextDirection is invalid.") end
    elseif (prevDirection == "left") then
        if     (nextDirection == "invalid") then return SPRITE_FRAME_NAME_ARROW_RIGHT
        elseif (nextDirection == "up"     ) then return SPRITE_FRAME_NAME_CORNER_UP_LEFT
        elseif (nextDirection == "down"   ) then return SPRITE_FRAME_NAME_CORNER_DOWN_LEFT
        elseif (nextDirection == "left"   ) then return SPRITE_FRAME_NAME_EMPTY
        elseif (nextDirection == "right"  ) then return SPRITE_FRAME_NAME_LINE_HORIZONTAL
        else   error("ViewActionPlanner-getSpriteFrameName() the param nextDirection is invalid.") end
    elseif (prevDirection == "right") then
        if     (nextDirection == "invalid") then return SPRITE_FRAME_NAME_ARROW_LEFT
        elseif (nextDirection == "up"     ) then return SPRITE_FRAME_NAME_CORNER_UP_RIGHT
        elseif (nextDirection == "down"   ) then return SPRITE_FRAME_NAME_CORNER_DOWN_RIGHT
        elseif (nextDirection == "left"   ) then return SPRITE_FRAME_NAME_LINE_HORIZONTAL
        elseif (nextDirection == "right"  ) then return SPRITE_FRAME_NAME_EMPTY
        else   error("ViewActionPlanner-getSpriteFrameName() the param nextDirection is invalid.") end
    else
        error("ViewActionPlanner-getSpriteFrameName() the param prevDirection is invalid.")
    end
end

local function createSingleMovePathGridView(gridIndex, prevGridIndex, nextGridIndex)
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

local function createMovePathView()
    return cc.Node:create()
end

local function initWithMovePathView(view, pathView)
    view.m_MovePathView = pathView
    view:addChild(pathView)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewActionPlanner:ctor(param)
    initWithReachableGridsView(self, createReachableGridsView())
    initWithMovePathView(      self, createMovePathView())

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewActionPlanner:showReachableGrids(grids)
    self.m_ReachableGridsView:removeAllChildren()

    for x, column in pairs(grids) do
        if (type(column) == "table") then
            for y, _ in pairs(column) do
                self.m_ReachableGridsView:addChild(createSingleReachableGridView({x = x, y = y}))
            end
        end
    end

    return self
end

function ViewActionPlanner:hideReachableGrids()
    self.m_ReachableGridsView:removeAllChildren()

    return self
end

function ViewActionPlanner:showMovePath(path)
    self.m_MovePathView:removeAllChildren()

    for i = 1, #path do
        local prevGridIndex = path[i - 1] and path[i - 1].gridIndex or nil
        local nextGridIndex = path[i + 1] and path[i + 1].gridIndex or nil

        local gridView = createSingleMovePathGridView(path[i].gridIndex, prevGridIndex, nextGridIndex)
        if (gridView) then
            self.m_MovePathView:addChild(gridView)
        end
    end

    return self
end

function ViewActionPlanner:hideMovePath()
    self.m_MovePathView:removeAllChildren()

    return self
end

return ViewActionPlanner
