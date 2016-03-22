
local GridIndexFunctions = {}

local GRID_SIZE = require("res.data.GameConstant").GridSize
local ADJACENT_GRIDS_OFFSET = {{x = -1, y = 0}, {x = 1, y = 0}, {x = 0, y = -1}, {x = 0, y =1}}

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

function GridIndexFunctions.isWithinMap(index, mapSize)
    return (index.x >= 1) and (index.y >= 1)
        and (index.x <= mapSize.width) and (index.y <= mapSize.height)
end

function GridIndexFunctions.add(index1, index2)
    return {x = index1.x + index2.x, y = index1.y + index2.y}
end

function GridIndexFunctions.getAdjacentGrids(index)
    local grids = {}
    for _, offset in ipairs(ADJACENT_GRIDS_OFFSET) do
        grids[#grids + 1] = GridIndexFunctions.add(index, offset)
    end

    return grids
end

return GridIndexFunctions
