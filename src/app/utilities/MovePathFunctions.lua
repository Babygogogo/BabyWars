
--[[--------------------------------------------------------------------------------
-- MovePathFunctions是和MovePath相关的函数集合。
-- 所谓MovePath就是玩家操作unit时，在地图上绘制的移动路线。
-- 主要职责：
--   计算及访问MovePath
-- 使用场景举例：
--   玩家操作单位绘制移动路线时，需要调用这里的函数
-- 其他：
--   这些函数原本都是在ModelActionPlanner内的，由于planner日益臃肿，因此独立出来。
--]]--------------------------------------------------------------------------------

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

function MovePathFunctions.createPathForDispatch(path)
    local newPath = {}
    for i, node in ipairs(path) do
        newPath[i] = GridIndex.clone(path[i].gridIndex)
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
    local totalMoveCost = path[length].totalMoveCost + nextMoveCost

    if ((totalMoveCost > maxMoveCost) or
        (not GridIndexFunctions.isAdjacent(path[length].gridIndex, gridIndex)) or
        (MovePathFunctions.hasGridIndex(path, gridIndex))) then
        return false
    else
        path[length + 1] = {
            gridIndex     = GridIndexFunctions.clone(gridIndex),
            totalMoveCost = totalMoveCost,
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
            gridIndex     = GridIndexFunctions.clone(gridIndex),
            totalMoveCost = areaNode.totalMoveCost
        }

        gridIndex = areaNode.prevGridIndex
        areaNode  = ReachableAreaFunctions.getAreaNode(reachableArea, gridIndex)
    end

    return MovePathFunctions.createReversedPath(reversedPath)
end

return MovePathFunctions
