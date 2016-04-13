
local MovePathFunctions = {}

local GridIndexFunctions     = require("app.utilities.GridIndexFunctions")
local ReachableAreaFunctions = require("app.utilities.ReachableAreaFunctions")

function MovePathFunctions.createReversedPath(path)
    local newPath, length = {}, #path
    for i = 1, length do
        newPath[i] = path[length - i + 1]
    end

    return newPath
end

function MovePathFunctions.hasGridIndex(path, gridIndex)
    for i, pathNode in ipairs(path) do
        if (GridIndexFunctions.isEqual(gridIndex, pathNode.gridIndex)) then
            return true, i
        end
    end

    return false
end

function MovePathFunctions.truncateToGridIndex(path, gridIndex)
    local hasGridIndex, index = MovePathFunctions.hasGridIndex(path, gridIndex)
    if (not hasGridIndex) then
        return false
    else
        for i = index + 1, #path do
            path[i] = nil
        end

        return true
    end
end

function MovePathFunctions.extendToGridIndex(path, gridIndex, nextMoveCost, maxMoveCost)
    local length = #path
    local totalMoveCost = path[length].rangeConsumption + nextMoveCost

    if ((totalMoveCost > maxMoveCost) or
        (not GridIndexFunctions.isAdjacent(path[length].gridIndex, gridIndex)) or
        (MovePathFunctions.hasGridIndex(path, gridIndex))) then
        return false
    else
        path[length + 1] = {
            gridIndex        = GridIndexFunctions.clone(gridIndex),
            rangeConsumption = totalMoveCost,
        }

        return true
    end
end

function MovePathFunctions.createShortestPath(destination, reachableArea)
    local areaNode = ReachableAreaFunctions.getAreaNode(reachableArea, destination)
    assert(areaNode, "MovePathFunctions.createShortestPath() the destination is not reachable.")

    local reversedPath, gridIndex = {}, destination
    while (areaNode) do
        reversedPath[#reversedPath + 1] = {
            gridIndex        = GridIndexFunctions.clone(gridIndex),
            rangeConsumption = areaNode.rangeConsumption
        }

        gridIndex = areaNode.prevGridIndex
        areaNode = ReachableAreaFunctions.getAreaNode(reachableArea, gridIndex)
    end

    return MovePathFunctions.createReversedPath(reversedPath)
end

return MovePathFunctions
