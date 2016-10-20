
local VisibilityFunctions = {}

local GridIndexFunctions      = require("src.app.utilities.GridIndexFunctions")
local SingletonGetters        = require("src.app.utilities.SingletonGetters")

local getAdjacentGrids = GridIndexFunctions.getAdjacentGrids
local getModelUnitMap  = SingletonGetters.getModelUnitMap

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
        for _, adjacentGridIndex in ipairs(getAdjacentGrids(modelUnit:getGridIndex(), modelUnitMap:getMapSize())) do
            local adjacentModelUnit = modelUnitMap:getModelUnit(adjacentGridIndex)
            if ((adjacentModelUnit) and (adjacentModelUnit:getPlayerIndex() == playerIndex)) then
                return true
            end
        end

        return false
    end
end

function VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex(sceneWarFileName, gridIndex, isDiving, unitPlayerIndex, opponentPlayerIndex)
    assert(type(unitPlayerIndex)     == "number", "VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex() invalid unitPlayerIndex: " .. (unitPlayerIndex or ""))
    assert(type(opponentPlayerIndex) == "number", "VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex() invalid opponentPlayerIndex: " .. (opponentPlayerIndex or ""))
    -- TODO: deal with the fog of war.
    if ((unitPlayerIndex == opponentPlayerIndex) or (not isDiving)) then
        return true
    else
        local modelUnitMap = getModelUnitMap(sceneWarFileName)
        for _, adjacentGridIndex in ipairs(getAdjacentGrids(gridIndex, modelUnitMap:getMapSize())) do
            local adjacentModelUnit = modelUnitMap:getModelUnit(adjacentGridIndex)
            if ((adjacentModelUnit) and (adjacentModelUnit:getPlayerIndex() == opponentPlayerIndex)) then
                return true
            end
        end

        return false
    end
end

function VisibilityFunctions.getRevealedUnitsDataWithPath(sceneWarFileName, path, modelUnit)
    -- TODO: deal with fog of war.
    local modelUnitMap  = getModelUnitMap(sceneWarFileName)
    local gridIndex     = path[#path]
    local playerIndex   = modelUnit:getPlayerIndex()
    local revealedUnits
    for _, adjacentGridIndex in ipairs(getAdjacentGrids(gridIndex, modelUnitMap:getMapSize())) do
        local modelUnit = modelUnitMap:getModelUnit(adjacentGridIndex)
        local isDiving  = (modelUnit) and (modelUnit.isDiving) and (modelUnit:isDiving())
        if ((modelUnit)                                                                                                                                        and
            (not VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex(sceneWarFileName, adjacentGridIndex, isDiving, modelUnit:getPlayerIndex(), playerIndex))) then
            revealedUnits = revealedUnits or {}
            revealedUnits[modelUnit:getUnitId()] = modelUnit:toSerializableTable()
        end
    end

    return revealedUnits
end

return VisibilityFunctions
