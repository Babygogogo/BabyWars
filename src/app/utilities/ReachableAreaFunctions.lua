
local ReachableAreaFunctions = {}

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

local function pushBackToAvailableGridList(list, gridIndex, prevGridIndex, totalMoveCost)
    list[#list + 1] = {
        gridIndex     = GridIndexFunctions.clone(gridIndex),
        prevGridIndex = (prevGridIndex) and (GridIndexFunctions.clone(prevGridIndex)) or nil,
        totalMoveCost = totalMoveCost,
    }
end

local function updateArea(area, gridIndex, prevGridIndex, totalMoveCost)
    local x, y = gridIndex.x, gridIndex.y
    area[x]    = area[x]    or {}
    area[x][y] = area[x][y] or {}

    local areaNode = area[x][y]
    if ((areaNode.rangeConsumption) and (areaNode.rangeConsumption <= totalMoveCost)) then
        return false
    else
        areaNode.prevGridIndex    = (prevGridIndex) and (GridIndexFunctions.clone(prevGridIndex)) or nil
        areaNode.rangeConsumption = totalMoveCost

        return true
    end
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ReachableAreaFunctions.getAreaNode(area, gridIndex)
    if ((area) and (gridIndex) and (area[gridIndex.x])) then
        return area[gridIndex.x][gridIndex.y]
    else
        return nil
    end
end

function ReachableAreaFunctions.createArea(origin, maxMoveCost, moveCostGetter)
    local area, availableGridList = {}, {}
    pushBackToAvailableGridList(availableGridList, origin, nil, 0)

    local listIndex = 1
    while (listIndex <= #availableGridList) do
        local listNode         = availableGridList[listIndex]
        local currentGridIndex = listNode.gridIndex
        local totalMoveCost    = listNode.totalMoveCost

        if (updateArea(area, currentGridIndex, listNode.prevGridIndex, totalMoveCost)) then
            for _, nextGridIndex in ipairs(GridIndexFunctions.getAdjacentGrids(currentGridIndex)) do
                local nextMoveCost = moveCostGetter(nextGridIndex)
                if ((nextMoveCost) and (nextMoveCost + totalMoveCost <= maxMoveCost)) then
                    pushBackToAvailableGridList(availableGridList, nextGridIndex, currentGridIndex, nextMoveCost + totalMoveCost)
                end
            end
        end

        listIndex = listIndex + 1
    end

    return area
end

return ReachableAreaFunctions
