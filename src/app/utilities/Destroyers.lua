
local Destroyers = {}

local SingletonGetters = require("src.app.utilities.SingletonGetters")

local getModelPlayerManager    = SingletonGetters.getModelPlayerManager
local getModelTileMap          = SingletonGetters.getModelTileMap
local getModelUnitMap          = SingletonGetters.getModelUnitMap
local getScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher

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

function Destroyers.destroyPlayerForce(sceneWarFileName, playerIndex)
    local dispatcher = getScriptEventDispatcher(sceneWarFileName)
    getModelUnitMap(sceneWarFileName):forEachModelUnitOnMap(function(modelUnit)
        if (modelUnit:getPlayerIndex() == playerIndex) then
            local gridIndex = modelUnit:getGridIndex()
            Destroyers.destroyModelUnitWithGridIndex(sceneWarFileName, gridIndex)
            modelUnit:removeViewFromParent()
            dispatcher:dispatchEvent({
                name      = "EvtDestroyViewUnit",
                gridIndex = gridIndex,
            })
        end
    end)
    getModelTileMap(sceneWarFileName):forEachModelTile(function(modelTile)
        if (modelTile:getPlayerIndex() == playerIndex) then
            modelTile:updateWithPlayerIndex(0)
                :updateView()
        end
    end)
    getModelPlayerManager(sceneWarFileName):getModelPlayer(playerIndex):setAlive(false)
end

return Destroyers
