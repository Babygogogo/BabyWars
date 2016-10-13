
local VisibilityFunctions = {}

local GridIndexFunctions      = require("src.app.utilities.GridIndexFunctions")
local SingletonGetters        = require("src.app.utilities.SingletonGetters")

local getModelUnitMap = SingletonGetters.getModelUnitMap

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function VisibilityFunctions.isModelUnitVisibleToPlayerIndex(modelUnit, sceneWarFileName, playerIndex)
    -- TODO: deal with fog of war.
    if ((modelUnit:getPlayerIndex() == playerIndex) or
        (not modelUnit.isDiving)                    or
        (not modelUnit:isDiving()))                 then
        return true
    else
        local modelUnitMap = getModelUnitMap(sceneWarFileName)
        for _, adjacentGridIndex in ipairs(GridIndexFunctions.getAdjacentGrids(modelUnit:getGridIndex(), modelUnitMap:getMapSize())) do
            local adjacentModelUnit = modelUnitMap:getModelUnit(adjacentGridIndex)
            if ((adjacentModelUnit) and (adjacentModelUnit:getPlayerIndex() == playerIndex)) then
                return true
            end
        end

        return false
    end
end

return VisibilityFunctions
