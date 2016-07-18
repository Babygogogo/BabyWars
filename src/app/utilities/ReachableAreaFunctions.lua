
--[[--------------------------------------------------------------------------------
-- ReachableAreaFunctions是和ReachableArea相关的函数集合。
-- 所谓ReachableArea就是玩家操作unit时，在地图上绘制的可移动范围。
-- 主要职责：
--   计算及访问ReachableArea
-- 使用场景举例：
--   玩家操作单时，需要调用这里的函数
-- 其他：
--   这些函数原本都是在ModelActionPlanner内的，由于planner日益臃肿，因此独立出来。
--   计算ReachableArea时，势必会顺便计算出各个格子的最短移动路径，因此把这些路径都记录下来，方便MovePath二次利用
--]]--------------------------------------------------------------------------------

local ReachableAreaFunctions = {}

local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")

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
    if ((areaNode.totalMoveCost) and (areaNode.totalMoveCost <= totalMoveCost)) then
        return false
    else
        areaNode.prevGridIndex = (prevGridIndex) and (GridIndexFunctions.clone(prevGridIndex)) or nil
        areaNode.totalMoveCost = totalMoveCost

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
