
local GridIndexFunctions = {}

local GRID_SIZE = require("res.data.GameConstant").GridSize
local ADJACENT_GRIDS_OFFSET = {
    {x = -1, y =  0, direction = "left",  clockwiseOffset = {x =  1, y =  1},},
    {x =  1, y =  0, direction = "right", clockwiseOffset = {x = -1, y = -1},},
    {x =  0, y = -1, direction = "down",  clockwiseOffset = {x = -1, y =  1},},
    {x =  0, y =  1, direction = "up",    clockwiseOffset = {x =  1, y = -1},},
}

function GridIndexFunctions.toGridIndex(pos)
    return {x = math.ceil(pos.x / (GRID_SIZE.width )),
            y = math.ceil(pos.y / (GRID_SIZE.height))
    }
end

function GridIndexFunctions.toPosition(gridIndex)
    return	(gridIndex.x - 1) * GRID_SIZE.width,
            (gridIndex.y - 1) * GRID_SIZE.height
end

function GridIndexFunctions.worldPosToGridIndexInNode(worldPos, node)
    return GridIndexFunctions.toGridIndex(node:convertToNodeSpace(worldPos))
end

function GridIndexFunctions.isEqual(index1, index2)
    return (index1.x == index2.x) and (index1.y == index2.y)
end

function GridIndexFunctions.isAdjacent(index1, index2)
    local offset = GridIndexFunctions.sub(index1, index2)
    for _, o in ipairs(ADJACENT_GRIDS_OFFSET) do
        if (GridIndexFunctions.isEqual(offset, o)) then
            return true
        end
    end

    return false
end

function GridIndexFunctions.isWithinMap(index, mapSize)
    return (index.x >= 1) and (index.y >= 1)
        and (index.x <= mapSize.width) and (index.y <= mapSize.height)
end

function GridIndexFunctions.add(index1, index2)
    return {x = index1.x + index2.x, y = index1.y + index2.y}
end

function GridIndexFunctions.sub(index1, index2)
    return {x = index1.x - index2.x, y = index1.y - index2.y}
end

function GridIndexFunctions.scale(index, scale)
    return {x = index.x * scale, y = index.y * scale}
end

function GridIndexFunctions.getAdjacentGrids(index)
    local grids = {}
    for _, offset in ipairs(ADJACENT_GRIDS_OFFSET) do
        grids[#grids + 1] = GridIndexFunctions.add(index, offset)
    end

    return grids
end

-- If index1 is at the right side of index2, then "right" is returned.
function GridIndexFunctions.getAdjacentDirection(index1, index2)
    if (not index1) or (not index2) then
        return "invalid"
    end

    local offset = GridIndexFunctions.sub(index1, index2)
    for i, item in ipairs(ADJACENT_GRIDS_OFFSET) do
        if (GridIndexFunctions.isEqual(offset, item)) then
            return item.direction
        end
    end

    return "invalid"
end

function GridIndexFunctions.getDistance(index1, index2)
    local offset = GridIndexFunctions.sub(index1, index2)
    return math.abs(offset.x) + math.abs(offset.y)
end

function GridIndexFunctions.getGridsWithinDistance(origin, minDistance, maxDistance, predicate)
    local grids = {}
    if (minDistance == 0) and (minDistance <= maxDistance) then
        grids[1] = {x = origin.x, y = origin.y}
    end

    for distance = minDistance, maxDistance do
        for _, offsetItem in ipairs(ADJACENT_GRIDS_OFFSET) do
            local gridIndex = GridIndexFunctions.add(origin, GridIndexFunctions.sub(GridIndexFunctions.scale(offsetItem, distance), offsetItem.clockwiseOffset))
            for i = 1, distance do
                gridIndex = GridIndexFunctions.add(gridIndex, offsetItem.clockwiseOffset)
                if (not predicate) or (predicate(gridIndex)) then
                    grids[#grids + 1] = gridIndex
                end
            end
        end
    end

    return grids
end

return GridIndexFunctions
