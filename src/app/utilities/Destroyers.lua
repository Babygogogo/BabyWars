
local Destroyers = {}

local IS_SERVER           = require("src.app.utilities.GameConstantFunctions").isServer()
local GridIndexFunctions  = require("src.app.utilities.GridIndexFunctions")
local SingletonGetters    = require("src.app.utilities.SingletonGetters")
local TableFunctions      = require("src.app.utilities.TableFunctions")
local VisibilityFunctions = require("src.app.utilities.VisibilityFunctions")
local WebSocketManager    = (not IS_SERVER) and (require("src.app.utilities.WebSocketManager")) or (nil)

local appendList               = TableFunctions.appendList
local getAdjacentGrids         = GridIndexFunctions.getAdjacentGrids
local getModelFogMap           = SingletonGetters.getModelFogMap
local getModelGridEffect       = SingletonGetters.getModelGridEffect
local getModelPlayerManager    = SingletonGetters.getModelPlayerManager
local getModelTileMap          = SingletonGetters.getModelTileMap
local getModelUnitMap          = SingletonGetters.getModelUnitMap
local getPlayerIndexLoggedIn   = SingletonGetters.getPlayerIndexLoggedIn
local getScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher
local isUnitVisible            = VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function resetModelTile(sceneWarFileName, gridIndex)
    local modelTile = getModelTileMap(sceneWarFileName):getModelTile(gridIndex)
    if (modelTile.setCurrentBuildPoint) then
        modelTile:setCurrentBuildPoint(modelTile:getMaxBuildPoint())
    end
    if (modelTile.setCurrentCapturePoint) then
        modelTile:setCurrentCapturePoint(modelTile:getMaxCapturePoint())
    end
end

local function destroySingleActorUnitLoaded(modelUnitMap, modelUnitLoaded, shouldRemoveView)
    modelUnitMap:removeActorUnitLoaded(modelUnitLoaded:getUnitId())
    if (shouldRemoveView) then
        modelUnitLoaded:removeViewFromParent()
    end

    return modelUnitLoaded
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function Destroyers.destroyActorUnitLoaded(sceneWarFileName, unitID, shouldRemoveView)
    local modelUnitMap    = getModelUnitMap(sceneWarFileName)
    local modelUnitLoaded = modelUnitMap:getLoadedModelUnitWithUnitId(unitID)
    local destroyedUnits  = {}
    shouldRemoveView      = (not IS_SERVER) and (shouldRemoveView)

    destroyedUnits[#destroyedUnits + 1] = destroySingleActorUnitLoaded(modelUnitMap, modelUnitLoaded, shouldRemoveView)
    for _, subModelUnitLoaded in pairs(modelUnitMap:getLoadedModelUnitsWithLoader(modelUnitLoaded, true) or {}) do
        destroyedUnits[#destroyedUnits + 1] = destroySingleActorUnitLoaded(modelUnitMap, subModelUnitLoaded, shouldRemoveView)
    end

    return destroyedUnits
end

function Destroyers.destroyActorUnitOnMap(sceneWarFileName, gridIndex, shouldRemoveView, shouldRetainVisibility)
    resetModelTile(sceneWarFileName, gridIndex)

    local modelUnitMap   = getModelUnitMap(sceneWarFileName)
    local modelUnit      = modelUnitMap:getModelUnit(gridIndex)
    local destroyedUnits = {modelUnit}
    shouldRemoveView     = (not IS_SERVER) and (shouldRemoveView)

    modelUnitMap:removeActorUnitOnMap(gridIndex)
    if (shouldRemoveView) then
        modelUnit:removeViewFromParent()
    end
    for _, modelUnitLoaded in pairs(modelUnitMap:getLoadedModelUnitsWithLoader(modelUnit, true) or {}) do
        destroyedUnits[#destroyedUnits + 1] = destroySingleActorUnitLoaded(modelUnitMap, modelUnitLoaded, true)
    end

    if (not shouldRetainVisibility) then
        local playerIndex = modelUnit:getPlayerIndex()
        if ((IS_SERVER) or (playerIndex == getPlayerIndexLoggedIn())) then
            getModelFogMap(sceneWarFileName):updateMapForUnitsForPlayerIndexOnUnitLeave(playerIndex, gridIndex, modelUnit:getVisionForPlayerIndex(playerIndex))
        end
    end

    return destroyedUnits
end

function Destroyers.destroyPlayerForce(sceneWarFileName, playerIndex)
    local modelGridEffect = (not IS_SERVER) and (getModelGridEffect()) or (nil)
    getModelUnitMap(sceneWarFileName):forEachModelUnitOnMap(function(modelUnit)
        if (modelUnit:getPlayerIndex() == playerIndex) then
            local gridIndex = modelUnit:getGridIndex()
            Destroyers.destroyActorUnitOnMap(sceneWarFileName, gridIndex, true, true)

            if (not IS_SERVER) then
                modelGridEffect:showAnimationExplosion(gridIndex)
            end
        end
    end)

    getModelTileMap(sceneWarFileName):forEachModelTile(function(modelTile)
        if (modelTile:getPlayerIndex() == playerIndex) then
            modelTile:updateWithPlayerIndex(0)
                :updateView()
        end
    end)

    if ((IS_SERVER) or (playerIndex == getPlayerIndexLoggedIn())) then
        getModelFogMap(sceneWarFileName):resetMapForPathsForPlayerIndex(playerIndex)
            :resetMapForTilesForPlayerIndex(playerIndex)
            :resetMapForUnitsForPlayerIndex(playerIndex)
    end

    getModelPlayerManager(sceneWarFileName):getModelPlayer(playerIndex):setAlive(false)
end

return Destroyers
