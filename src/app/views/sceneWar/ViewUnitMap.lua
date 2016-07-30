
local ViewUnitMap = class("ViewUnitMap", cc.Node)

local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")
local Actor              = require("src.global.actors.Actor")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createEmptyMap(width, height)
    local map = {}
    for i = 1, width do
        map[i] = {}
    end

    return map
end

local function setViewUnit(self, view, gridIndex)
    self.m_Map[gridIndex.x][gridIndex.y] = view

    if (view) then
        view:setLocalZOrder(self.m_MapSize.height - gridIndex.y)
    end
end

local function getViewUnit(self, gridIndex)
    assert(GridIndexFunctions.isWithinMap(gridIndex, self.m_MapSize), "ViewUnitMap-getViewUnit() the param gridIndex is not within the map.")

    return self.m_Map[gridIndex.x][gridIndex.y]
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initPreviewLaunchUnit(self)
    local view = Actor.createView("sceneWar.ViewUnit")
    view:setVisible(false)

    self.m_PreviewLaunchUnit = view
    self:addChild(view)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewUnitMap:ctor(param)
    self.m_LoadedViewUnit = {}
    initPreviewLaunchUnit(self)

    return self
end

function ViewUnitMap:setMapSize(size)
    assert(not self.m_Map, "ViewUnitMap:setMapSize() the map already exists.")

    local width, height = size.width, size.height
    self.m_Map     = createEmptyMap(width, height)
    self.m_MapSize = {width = width, height = height}

    self.m_PreviewLaunchUnit:setLocalZOrder(height + 1)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewUnitMap:addViewUnit(view, gridIndex)
    assert(not getViewUnit(self, gridIndex), "ViewUnitMap:addViewUnit() there's a view in the gridIndex already.")

    setViewUnit(self, view, gridIndex)
    self:addChild(view)

    return self
end

function ViewUnitMap:removeViewUnit(gridIndex)
    local view = getViewUnit(self, gridIndex)
    setViewUnit(self, nil, gridIndex)
    self:removeChild(view)

    return self
end

function ViewUnitMap:addLoadedViewUnit(unitID, view)
    self.m_LoadedViewUnit[unitID] = view
    view:setVisible(false)
    self:addChild(view)

    return self
end

function ViewUnitMap:removeLoadedViewUnit(unitID)
    self:removeChild(self.m_LoadedViewUnit[unitID])
    self.m_LoadedViewUnit[unitID] = nil

    return self
end

function ViewUnitMap:setViewUnitJoinedWithGridIndex(gridIndex)
    self.m_Map[gridIndex.x][gridIndex.y] = nil

    return self
end

function ViewUnitMap:setViewUnitJoinedWithUnitId(unitID)
    self.m_LoadedViewUnit[unitID] = nil

    return self
end

function ViewUnitMap:swapViewUnit(gridIndex1, gridIndex2)
    if (GridIndexFunctions.isEqual(gridIndex1, gridIndex2)) then
        return
    end

    local view1, view2 = getViewUnit(self, gridIndex1), getViewUnit(self, gridIndex2)
    setViewUnit(self, view1, gridIndex2)
    setViewUnit(self, view2, gridIndex1)

    return self
end

function ViewUnitMap:setViewUnitLoaded(gridIndex, unitID)
    local view = getViewUnit(self, gridIndex)
    assert(view, "ViewUnitMap:setViewUnitLoaded() there's no view unit on the grid.")

    self.m_LoadedViewUnit[unitID] = view
    self.m_Map[gridIndex.x][gridIndex.y] = nil

    return self
end

function ViewUnitMap:setViewUnitUnloaded(gridIndex, unitID)
    local viewUnit = self.m_LoadedViewUnit[unitID]
    assert(viewUnit, "ViewUnitMap:setViewUnitUnloaded() the target view doesn't exist.")

    self.m_LoadedViewUnit[unitID] = nil
    self.m_Map[gridIndex.x][gridIndex.y] = viewUnit

    return self
end

function ViewUnitMap:setPreviewLaunchUnit(modelUnit, gridIndex)
    self.m_PreviewLaunchUnit:updateWithModelUnit(modelUnit)
        :showMovingAnimation()
        :setPosition(GridIndexFunctions.toPosition(gridIndex))

    return self
end

function ViewUnitMap:setPreviewLaunchUnitVisible(visible)
    self.m_PreviewLaunchUnit:setVisible(visible)

    return self
end

return ViewUnitMap
