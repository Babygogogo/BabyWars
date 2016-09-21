
local Destroyers = {}

local SingletonGetters = require("src.app.utilities.SingletonGetters")

local getModelUnitMap = SingletonGetters.getModelUnitMap
local getModelTileMap = SingletonGetters.getModelTileMap

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function Destroyers.destroyModelUnitWithGridIndex(sceneWarFileName, gridIndex)
    local modelUnitMap = getModelUnitMap(sceneWarFileName)
    local modelUnit    = modelUnitMap:getModelUnit(gridIndex)
    for _, loadedModelUnit in ipairs(modelUnitMap:getLoadedModelUnitsWithLoader(modelUnit, true) or {}) do
        modelUnitMap:removeActorUnitLoaded(loadedModelUnit:getUnitId())
    end
    modelUnitMap:removeActorUnitOnMap(gridIndex)

    local modelTile = getModelTileMap(sceneWarFileName):getModelTile(gridIndex)
    if (modelTile.setCurrentBuildPoint) then
        modelTile:setCurrentBuildPoint(modelTile:getMaxBuildPoint())
    end
    if (modelTile.setCurrentCapturePoint) then
        modelTile:setCurrentCapturePoint(modelTile:getMaxCapturePoint())
    end

    return Destroyers
end

return Destroyers
