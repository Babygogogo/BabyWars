
local ViewActionPlanner = class("ViewActionPlanner", cc.Node)

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
-- The constructor.
--------------------------------------------------------------------------------
function ViewActionPlanner:ctor(param)
    initWithReachableGridsView(self, createReachableGridsView())

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewActionPlanner:showReachableGrids(grids)
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

return ViewActionPlanner
