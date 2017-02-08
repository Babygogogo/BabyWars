
local Destroyers = {}

local IS_SERVER           = requireBW("src.app.utilities.GameConstantFunctions").isServer()
local GridIndexFunctions  = requireBW("src.app.utilities.GridIndexFunctions")
local SingletonGetters    = requireBW("src.app.utilities.SingletonGetters")
local TableFunctions      = requireBW("src.app.utilities.TableFunctions")
local VisibilityFunctions = requireBW("src.app.utilities.VisibilityFunctions")
local WebSocketManager    = (not IS_SERVER) and (requireBW("src.app.utilities.WebSocketManager")) or (nil)

local appendList               = TableFunctions.appendList
local getAdjacentGrids         = GridIndexFunctions.getAdjacentGrids
local getModelFogMap           = SingletonGetters.getModelFogMap
local getModelGridEffect       = SingletonGetters.getModelGridEffect
local getModelPlayerManager    = SingletonGetters.getModelPlayerManager
local getModelTileMap          = SingletonGetters.getModelTileMap
local getModelUnitMap          = SingletonGetters.getModelUnitMap
local getPlayerIndexLoggedIn   = SingletonGetters.getPlayerIndexLoggedIn
local getScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher
local isTotalReplay            = SingletonGetters.isTotalReplay
local isUnitVisible            = VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function resetModelTile(modelSceneWar, gridIndex)
    local modelTile = getModelTileMap(modelSceneWar):getModelTile(gridIndex)
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
function Destroyers.destroyActorUnitLoaded(modelSceneWar, unitID, shouldRemoveView)
    local modelUnitMap    = getModelUnitMap(modelSceneWar)
    local modelUnitLoaded = modelUnitMap:getLoadedModelUnitWithUnitId(unitID)
    local destroyedUnits  = {}
    shouldRemoveView      = (not IS_SERVER) and (shouldRemoveView)

    destroyedUnits[#destroyedUnits + 1] = destroySingleActorUnitLoaded(modelUnitMap, modelUnitLoaded, shouldRemoveView)
    for _, subModelUnitLoaded in pairs(modelUnitMap:getLoadedModelUnitsWithLoader(modelUnitLoaded, true) or {}) do
        destroyedUnits[#destroyedUnits + 1] = destroySingleActorUnitLoaded(modelUnitMap, subModelUnitLoaded, shouldRemoveView)
    end

    return destroyedUnits
end

function Destroyers.destroyActorUnitOnMap(modelSceneWar, gridIndex, shouldRemoveView, shouldRetainVisibility)
    resetModelTile(modelSceneWar, gridIndex)

    local modelUnitMap   = getModelUnitMap(modelSceneWar)
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
        if ((IS_SERVER) or (isTotalReplay(modelSceneWar)) or (playerIndex == getPlayerIndexLoggedIn(modelSceneWar))) then
            getModelFogMap(modelSceneWar):updateMapForUnitsForPlayerIndexOnUnitLeave(playerIndex, gridIndex, modelUnit:getVisionForPlayerIndex(playerIndex))
        end
    end

    return destroyedUnits
end

function Destroyers.destroyPlayerForce(modelSceneWar, playerIndex)
    local modelGridEffect = ((not IS_SERVER) and (not modelSceneWar:isFastExecutingActions())) and (getModelGridEffect(modelSceneWar)) or (nil)
    getModelUnitMap(modelSceneWar):forEachModelUnitOnMap(function(modelUnit)
        if (modelUnit:getPlayerIndex() == playerIndex) then
            local gridIndex = modelUnit:getGridIndex()
            Destroyers.destroyActorUnitOnMap(modelSceneWar, gridIndex, true, true)

            if (modelGridEffect) then
                modelGridEffect:showAnimationExplosion(gridIndex)
            end
        end
    end)

    getModelTileMap(modelSceneWar):forEachModelTile(function(modelTile)
        if (modelTile:getPlayerIndex() == playerIndex) then
            modelTile:updateWithPlayerIndex(0)
                :updateView()
        end
    end)

    if ((IS_SERVER) or (isTotalReplay(modelSceneWar)) or (playerIndex == getPlayerIndexLoggedIn(modelSceneWar))) then
        getModelFogMap(modelSceneWar):resetMapForPathsForPlayerIndex(playerIndex)
            :resetMapForTilesForPlayerIndex(playerIndex)
            :resetMapForUnitsForPlayerIndex(playerIndex)
    end

    getModelPlayerManager(modelSceneWar):getModelPlayer(playerIndex):setAlive(false)
end

return Destroyers
