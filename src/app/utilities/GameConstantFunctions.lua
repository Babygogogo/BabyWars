
local GameConstantFunctions = {}

local GAME_CONSTANT        = require("res.data.GameConstant")
local GRID_SIZE            = GAME_CONSTANT.GridSize
local TILE_UNIT_INDEXES    = GAME_CONSTANT.indexesForTileOrUnit
local TEMPLATE_MODEL_TILES = GAME_CONSTANT.templateModelTiles
local TEMPLATE_MODEL_UNITS = GAME_CONSTANT.templateModelUnits

function GameConstantFunctions.getGridSize()
    return GRID_SIZE
end

function GameConstantFunctions.getTiledIdWithTileOrUnitName(name)
    for id, index in ipairs(TILE_UNIT_INDEXES) do
        if (index.n == name) then
            return id
        end
    end

    error("GameConstantFunctions.getTiledIdWithTileOrUnitName() failed to find the Tiled ID.")
end

function GameConstantFunctions.getPlayerIndexWithTiledId(tiledID)
    return TILE_UNIT_INDEXES[tiledID].p
end

function GameConstantFunctions.getTemplateModelTileWithTiledId(tiledID)
    return TEMPLATE_MODEL_TILES[TILE_UNIT_INDEXES[tiledID].n]
end

function GameConstantFunctions.getTemplateModelUnitWithTiledId(tiledID)
    return TEMPLATE_MODEL_UNITS[TILE_UNIT_INDEXES[tiledID].n]
end

return GameConstantFunctions
