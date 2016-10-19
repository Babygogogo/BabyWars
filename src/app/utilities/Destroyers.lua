
local Destroyers = {}

local IS_SERVER           = require("src.app.utilities.GameConstantFunctions").isServer()
local GridIndexFunctions  = require("src.app.utilities.GridIndexFunctions")
local SingletonGetters    = require("src.app.utilities.SingletonGetters")
local VisibilityFunctions = require("src.app.utilities.VisibilityFunctions")
local WebSocketManager    = (not IS_SERVER) and (require("src.app.utilities.WebSocketManager")) or (nil)

local getModelPlayerManager    = SingletonGetters.getModelPlayerManager
local getModelTileMap          = SingletonGetters.getModelTileMap
local getModelUnitMap          = SingletonGetters.getModelUnitMap
local getScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher
local isUnitVisible            = VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function removeActorUnitOnMapAndLoaded(sceneWarFileName, gridIndex, shouldRemoveView)
    local modelUnitMap = getModelUnitMap(sceneWarFileName)
    local modelUnit    = modelUnitMap:getModelUnit(gridIndex)
    for _, loadedModelUnit in ipairs(modelUnitMap:getLoadedModelUnitsWithLoader(modelUnit, true) or {}) do
        modelUnitMap:removeActorUnitLoaded(loadedModelUnit:getUnitId())
    end
    modelUnitMap:removeActorUnitOnMap(gridIndex)

    if ((not IS_SERVER) and (shouldRemoveView)) then
        modelUnit:removeViewFromParent()
    end
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function Destroyers.destroyModelUnitWithGridIndex(sceneWarFileName, gridIndex, shouldRemoveView)
    removeActorUnitOnMapAndLoaded(sceneWarFileName, gridIndex, shouldRemoveView)

    local modelTile = getModelTileMap(sceneWarFileName):getModelTile(gridIndex)
    if (modelTile.setCurrentBuildPoint) then
        modelTile:setCurrentBuildPoint(modelTile:getMaxBuildPoint())
    end
    if (modelTile.setCurrentCapturePoint) then
        modelTile:setCurrentCapturePoint(modelTile:getMaxCapturePoint())
    end

    if (not IS_SERVER) then
        local modelUnitMap           = getModelUnitMap()
        local _, playerIndexLoggedIn = getModelPlayerManager():getModelPlayerWithAccount(WebSocketManager.getLoggedInAccountAndPassword())
        for _, adjacentGridIndex in pairs(GridIndexFunctions.getAdjacentGrids(gridIndex, modelUnitMap:getMapSize())) do
            local adjacentModelUnit = modelUnitMap:getModelUnit(adjacentGridIndex)
            if ((adjacentModelUnit)                                                                                                                                                                 and
                (not isUnitVisible(sceneWarFileName, adjacentGridIndex, (adjacentModelUnit.isDiving) and (adjacentModelUnit:isDiving()), adjacentModelUnit:getPlayerIndex(), playerIndexLoggedIn))) then
                removeActorUnitOnMapAndLoaded(sceneWarFileName, adjacentGridIndex, shouldRemoveView)
            end
        end
    end

    return Destroyers
end

function Destroyers.destroyPlayerForce(sceneWarFileName, playerIndex)
    local dispatcher = getScriptEventDispatcher(sceneWarFileName)
    getModelUnitMap(sceneWarFileName):forEachModelUnitOnMap(function(modelUnit)
        if (modelUnit:getPlayerIndex() == playerIndex) then
            local gridIndex = modelUnit:getGridIndex()
            Destroyers.destroyModelUnitWithGridIndex(sceneWarFileName, gridIndex, true)
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
