
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

local GridIndexFunctions     = require("src.app.utilities.GridIndexFunctions")
local ReachableAreaFunctions = require("src.app.utilities.ReachableAreaFunctions")

--------------------------------------------------------------------------------
-- The private functions.
--------------------------------------------------------------------------------
local function createReversedPathNodes(pathNodes)
    local reversedPathNodes, length = {}, #pathNodes
    for i = 1, length do
        reversedPathNodes[i] = pathNodes[length - i + 1]
    end

    return reversedPathNodes
end

local function hasGridIndexInPathNodes(pathNodes, gridIndex)
    for i, node in ipairs(pathNodes) do
        if (GridIndexFunctions.isEqual(gridIndex, node)) then
            return true, i
        end
    end

    return false
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function MovePathFunctions.createPathForDispatch(pathNodes)
    local newPathNodes = {}
    for i, node in ipairs(pathNodes) do
        newPathNodes[i] = {
            x = node.x,
            y = node.y,
        }
    end

    return {pathNodes = newPathNodes}
end

function MovePathFunctions.truncateToGridIndex(pathNodes, gridIndex)
    local hasGridIndex, index = hasGridIndexInPathNodes(pathNodes, gridIndex)
    if (not hasGridIndex) then
        return false
    else
        for i = index + 1, #pathNodes do
            pathNodes[i] = nil
        end

        return true
    end
end

function MovePathFunctions.extendToGridIndex(pathNodes, gridIndex, nextMoveCost, maxMoveCost)
    local length        = #pathNodes
    local totalMoveCost = pathNodes[length].totalMoveCost + nextMoveCost
    if ((totalMoveCost > maxMoveCost)                                     or
        (not GridIndexFunctions.isAdjacent(pathNodes[length], gridIndex)) or
        (hasGridIndexInPathNodes(pathNodes, gridIndex)))                  then
        return false
    else
        pathNodes[length + 1] = {
            x             = gridIndex.x,
            y             = gridIndex.y,
            totalMoveCost = totalMoveCost,
        }

        return true
    end
end

function MovePathFunctions.createShortestPath(destination, reachableArea)
    local areaNode = ReachableAreaFunctions.getAreaNode(reachableArea, destination)
    assert(areaNode, "MovePathFunctions.createShortestPath() the destination is not reachable.")

    local reversedPathNodes, gridIndex = {}, destination
    while (areaNode) do
        reversedPathNodes[#reversedPathNodes + 1] = {
            x             = gridIndex.x,
            y             = gridIndex.y,
            totalMoveCost = areaNode.totalMoveCost,
        }

        gridIndex = areaNode.prevGridIndex
        areaNode  = ReachableAreaFunctions.getAreaNode(reachableArea, gridIndex)
    end

    return createReversedPathNodes(reversedPathNodes)
end

return MovePathFunctions
