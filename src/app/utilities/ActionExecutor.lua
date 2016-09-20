
local ActionExecutor = {}

local GameConstantFunctions  = require("src.app.utilities.GameConstantFunctions")
local GridIndexFunctions     = require("src.app.utilities.GridIndexFunctions")
local InstantSkillExecutor   = require("src.app.utilities.InstantSkillExecutor")
local LocalizationFunctions  = require("src.app.utilities.LocalizationFunctions")
local SingletonGetters       = require("src.app.utilities.SingletonGetters")
local SkillModifierFunctions = require("src.app.utilities.SkillModifierFunctions")
local Actor                  = require("src.global.actors.Actor")

local UNIT_MAX_HP           = GameConstantFunctions.getUnitMaxHP()
local IS_SERVER             = GameConstantFunctions.isServer()
local WebSocketManager      = (not IS_SERVER) and (require("src.app.utilities.WebSocketManager")) or (nil)
local ActorManager          = (not IS_SERVER) and (require("src.global.actors.ActorManager"))     or (nil)

local getLocalizedText         = LocalizationFunctions.getLocalizedText
local getModelMessageIndicator = SingletonGetters.getModelMessageIndicator
local getModelPlayerManager    = SingletonGetters.getModelPlayerManager
local getModelTileMap          = SingletonGetters.getModelTileMap
local getModelTurnManager      = SingletonGetters.getModelTurnManager
local getModelUnitMap          = SingletonGetters.getModelUnitMap
local getSceneWarFileName      = SingletonGetters.getSceneWarFileName
local getScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function dispatchEvtModelPlayerUpdated(sceneWarFileName, modelPlayer, playerIndex)
    getScriptEventDispatcher(sceneWarFileName):dispatchEvent({
        name        = "EvtModelPlayerUpdated",
        modelPlayer = modelPlayer,
        playerIndex = playerIndex,
    })
end

local function runSceneMain(modelSceneMainParam, playerAccount, playerPassword)
    assert(not IS_SERVER, "ActionExecutor-runSceneMain() the main scene can't be run on the server.")

    local modelSceneMain = Actor.createModel("sceneMain.ModelSceneMain", modelSceneMainParam)
    local viewSceneMain  = Actor.createView( "sceneMain.ViewSceneMain")

    WebSocketManager.setLoggedInAccountAndPassword(playerAccount, playerPassword)
    ActorManager.setAndRunRootActor(Actor.createWithModelAndViewInstance(modelSceneMain, viewSceneMain), "FADE", 1)
end

local function requestReloadSceneWar(message)
    assert(not IS_SERVER, "ActionExecutor-requestReloadSceneWar() the server shouldn't request reload.")

    getModelMessageIndicator():showMessage(message or "")
        :showPersistentMessage(getLocalizedText(80, "TransferingData"))
    getScriptEventDispatcher():dispatchEvent({
        name    = "EvtIsWaitingForServerResponse",
        waiting = true,
    })

    WebSocketManager.sendAction({
        actionName = "GetSceneWarData",
        fileName   = getSceneWarFileName(),
    })
end

local function moveModelUnitWithAction(action)
    local path       = action.path
    local pathLength = #path

    if (pathLength > 1) then
        local sceneWarFileName   = action.fileName
        local modelUnitMap       = getModelUnitMap(sceneWarFileName)
        local beginningGridIndex = path[1]
        local endingGridIndex    = path[pathLength]
        local launchUnitID       = action.launchUnitID
        local focusModelUnit     = modelUnitMap:getFocusModelUnit(beginningGridIndex, launchUnitID)

        if (focusModelUnit.setCapturingModelTile) then
            focusModelUnit:setCapturingModelTile(false)
        end
        if (focusModelUnit.setCurrentFuel) then
            focusModelUnit:setCurrentFuel(focusModelUnit:getCurrentFuel() - path.fuelConsumption)
        end
        if (focusModelUnit.setBuildingModelTile) then
            focusModelUnit:setBuildingModelTile(false)
        end
        if (focusModelUnit.getLoadUnitIdList) then
            for _, loadedModelUnit in pairs(modelUnitMap:getLoadedModelUnitsWithLoader(focusModelUnit, true)) do
                loadedModelUnit:setGridIndex(endingGridIndex, false)
            end
        end

        focusModelUnit:setGridIndex(endingGridIndex, false)
        if (launchUnitID) then
            modelUnitMap:getModelUnit(beginningGridIndex):removeLoadUnitId(launchUnitID)
                :updateView()
                :showNormalAnimation()

            if (action.actionName ~= "LoadModelUnit") then
                modelUnitMap:setActorUnitUnloaded(launchUnitID, endingGridIndex)
            end
        else
            if (action.actionName == "LoadModelUnit") then
                modelUnitMap:setActorUnitLoaded(beginningGridIndex)
            else
                modelUnitMap:swapActorUnit(beginningGridIndex, endingGridIndex)
            end

            local modelTile = getModelTileMap(sceneWarFileName):getModelTile(beginningGridIndex)
            if (modelTile.setCurrentBuildPoint) then
                modelTile:setCurrentBuildPoint(modelTile:getMaxBuildPoint())
            end
            if (modelTile.setCurrentCapturePoint) then
                modelTile:setCurrentCapturePoint(modelTile:getMaxCapturePoint())
            end
        end
    end
end

local function promoteModelUnitOnProduce(modelUnit, sceneWarFileName)
    local modelPlayer = getModelPlayerManager(sceneWarFileName):getModelPlayer(modelUnit:getPlayerIndex())
    local modifier    = SkillModifierFunctions.getPassivePromotionModifier(modelPlayer:getModelSkillConfiguration())
    if ((modifier > 0) and (modelUnit.setCurrentPromotion)) then
        modelUnit:setCurrentPromotion(modifier)
    end
end

--------------------------------------------------------------------------------
-- The private executors.
--------------------------------------------------------------------------------
local function executeLogout(action)
    if (not IS_SERVER) then
        runSceneMain({confirmText = action.message})
    end
end

local function executeMessage(action)
    if (not IS_SERVER) then
        getModelMessageIndicator():showMessage(action.message)
    end
end

local function executeError(action)
    if (not IS_SERVER) then
        error("ActionExecutor-executeError() " .. (action.error or ""))
    end
end

local function executeRunSceneMain(action)
    if (not IS_SERVER) then
        local param = {
            isPlayerLoggedIn = true,
            confirmText      = action.message,
        }
        runSceneMain(param, WebSocketManager.getLoggedInAccountAndPassword())
    end
end

local function executeGetSceneWarData(action)
    if (not IS_SERVER) then
        if (action.message) then
            getModelMessageIndicator():showPersistentMessage(action.message)
        end

        local actorSceneWar = Actor.createWithModelAndViewName("sceneWar.ModelSceneWar", action.data, "sceneWar.ViewSceneWar")
        ActorManager.setAndRunRootActor(actorSceneWar, "FADE", 1)
    end
end

local function executeReloadCurrentScene(action)
    if (not IS_SERVER) then
        requestReloadSceneWar(action.message)
    end
end

local function executeActivateSkillGroup(action)
    local skillGroupID     = action.skillGroupID
    local sceneWarFileName = action.fileName
    InstantSkillExecutor.activateSkillGroup(skillGroupID, sceneWarFileName)

    local playerIndex = getModelTurnManager(sceneWarFileName):getPlayerIndex()
    local modelPlayer = getModelPlayerManager(sceneWarFileName):getModelPlayer(playerIndex)
    modelPlayer:getModelSkillConfiguration():setActivatingSkillGroupId(skillGroupID)
    modelPlayer:setDamageCost(modelPlayer:getDamageCost() - modelPlayer:getDamageCostForSkillGroupId(skillGroupID))
        :setSkillActivatedCount(modelPlayer:getSkillActivatedCount() + 1)

    dispatchEvtModelPlayerUpdated(sceneWarFileName, modelPlayer, playerIndex)
    getScriptEventDispatcher(sceneWarFileName):dispatchEvent({
        name         = "EvtSkillGroupActivated",
        playerIndex  = playerIndex,
        skillGroupID = skillGroupID,
    })
end

local function executeBuildModelTile(action)
    local path             = action.path
    local sceneWarFileName = action.fileName
    local focusModelUnit   = getModelUnitMap(sceneWarFileName):getFocusModelUnit(path[1], action.launchUnitID)
    local modelTile        = getModelTileMap(sceneWarFileName):getModelTile(path[#path])
    local buildPoint       = modelTile:getCurrentBuildPoint() - focusModelUnit:getBuildAmount()

    moveModelUnitWithAction(action)
    if (buildPoint > 0) then
        focusModelUnit:setBuildingModelTile(true)
        modelTile:setCurrentBuildPoint(buildPoint)
    else
        focusModelUnit:setBuildingModelTile(false)
            :setCurrentMaterial(focusModelUnit:getCurrentMaterial() - 1)
        modelTile:updateWithObjectAndBaseId(focusModelUnit:getBuildTiledIdWithTileType(modelTile:getTileType()))
    end

    focusModelUnit:setStateActioned()
        :moveViewAlongPath(path, function()
            focusModelUnit:updateView()
                :showNormalAnimation()
            modelTile:updateView()
        end)
end

local function executeJoinModelUnit(action)
    local path             = action.path
    local endingGridIndex  = path[#path]
    local sceneWarFileName = action.fileName
    local modelUnitMap     = getModelUnitMap(sceneWarFileName)
    local focusModelUnit   = modelUnitMap:getFocusModelUnit(path[1], action.launchUnitID)
    local targetModelUnit  = modelUnitMap:getModelUnit(endingGridIndex)

    modelUnitMap:removeActorUnitOnMap(endingGridIndex)
    moveModelUnitWithAction(action)

    if ((focusModelUnit.hasPrimaryWeapon) and (focusModelUnit:hasPrimaryWeapon())) then
        focusModelUnit:setPrimaryWeaponCurrentAmmo(math.min(
            focusModelUnit:getPrimaryWeaponMaxAmmo(),
            focusModelUnit:getPrimaryWeaponCurrentAmmo() + targetModelUnit:getPrimaryWeaponCurrentAmmo()
        ))
    end
    if (focusModelUnit.getJoinIncome) then
        local joinIncome = focusModelUnit:getJoinIncome(targetModelUnit)
        if (joinIncome ~= 0) then
            local playerIndex = focusModelUnit:getPlayerIndex()
            local modelPlayer = getModelPlayerManager(sceneWarFileName):getModelPlayer(playerIndex)
            modelPlayer:setFund(modelPlayer:getFund() + joinIncome)
            dispatchEvtModelPlayerUpdated(sceneWarFileName, modelPlayer, playerIndex)
        end
    end
    if (focusModelUnit.setCurrentHP) then
        local joinedNormalizedHP = math.min(10, focusModelUnit:getNormalizedCurrentHP() + targetModelUnit:getNormalizedCurrentHP())
        focusModelUnit:setCurrentHP(math.max(
            (joinedNormalizedHP - 1) * 10 + 1,
            math.min(
                focusModelUnit:getCurrentHP() + targetModelUnit:getCurrentHP(),
                UNIT_MAX_HP
            )
        ))
    end
    if (focusModelUnit.setCurrentFuel) then
        focusModelUnit:setCurrentFuel(math.min(
            targetModelUnit:getMaxFuel(),
            focusModelUnit:getCurrentFuel() + targetModelUnit:getCurrentFuel()
        ))
    end
    if (focusModelUnit.setCurrentMaterial) then
        focusModelUnit:setCurrentMaterial(math.min(
            focusModelUnit:getMaxMaterial(),
            focusModelUnit:getCurrentMaterial() + targetModelUnit:getCurrentMaterial()
        ))
    end
    if (focusModelUnit.setCurrentPromotion) then
        focusModelUnit:setCurrentPromotion(math.max(
            focusModelUnit:getCurrentPromotion(),
            targetModelUnit:getCurrentPromotion()
        ))
    end

    focusModelUnit:setStateActioned()
        :moveViewAlongPath(path, function()
            focusModelUnit:updateView()
                :showNormalAnimation()
            targetModelUnit:removeViewFromParent()
        end)
end

local function executeLaunchSilo(action)
    local path              = action.path
    local sceneWarFileName  = action.fileName
    local modelUnitMap      = getModelUnitMap(sceneWarFileName)
    local mapSize           = modelUnitMap:getMapSize()
    local focusModelUnit    = modelUnitMap:getFocusModelUnit(path[1], action.launchUnitID)
    local modelTile         = getModelTileMap(sceneWarFileName):getModelTile(path[#path])
    local targetModelUnits  = {}
    local targetGridIndexes = {}

    moveModelUnitWithAction(action)
    modelTile:updateWithObjectAndBaseId(focusModelUnit:getTileObjectIdAfterLaunch())
    for _, gridIndex in pairs(GridIndexFunctions.getGridsWithinDistance(action.targetGridIndex, 0, 2)) do
        if (GridIndexFunctions.isWithinMap(gridIndex, mapSize)) then
            targetGridIndexes[#targetGridIndexes + 1] = gridIndex

            local modelUnit = modelUnitMap:getModelUnit(gridIndex)
            if ((modelUnit) and (modelUnit.setCurrentHP)) then
                modelUnit:setCurrentHP(math.max(1, modelUnit:getCurrentHP() - 30))
                targetModelUnits[#targetModelUnits + 1] = modelUnit
            end
        end
    end

    focusModelUnit:setStateActioned()
        :moveViewAlongPath(path, function()
            focusModelUnit:updateView()
                :showNormalAnimation()
            modelTile:updateView()

            for _, modelUnit in ipairs(targetModelUnits) do
                modelUnit:updateView()
            end

            local dispatcher = getScriptEventDispatcher(sceneWarFileName)
            for _, gridIndex in ipairs(targetGridIndexes) do
                dispatcher:dispatchEvent({
                    name      = "EvtSiloAttackGrid",
                    gridIndex = gridIndex,
                })
            end
        end)
end

local function executeLoadModelUnit(action)
    local path            = action.path
    local modelUnitMap    = getModelUnitMap(action.fileName)
    local focusModelUnit  = modelUnitMap:getFocusModelUnit(path[1], action.launchUnitID)
    local loaderModelUnit = modelUnitMap:getModelUnit(path[#path])

    moveModelUnitWithAction(action)
    loaderModelUnit:addLoadUnitId(focusModelUnit:getUnitId())

    focusModelUnit:setStateActioned()
        :moveViewAlongPath(path, function()
            focusModelUnit:updateView()
                :showNormalAnimation()
                :setViewVisible(false)
            loaderModelUnit:updateView()
        end)
end

local function executeProduceModelUnitOnTile(action)
    local sceneWarFileName = action.fileName
    local gridIndex        = action.gridIndex
    local modelUnitMap     = getModelUnitMap(sceneWarFileName)
    local availableUnitID  = modelUnitMap:getAvailableUnitId()
    local actorData        = {
        tiledID       = action.tiledID,
        unitID        = availableUnitID,
        GridIndexable = {gridIndex = gridIndex},
    }

    local actorUnit = Actor.createWithModelAndViewName("sceneWar.ModelUnit", actorData, "sceneWar.ViewUnit")
    local modelUnit = actorUnit:getModel()
    promoteModelUnitOnProduce(modelUnit, sceneWarFileName)
    modelUnit:onStartRunning(sceneWarFileName)
        :setStateActioned()
        :updateView()

    modelUnitMap:addActorUnitOnMap(actorUnit)
        :setAvailableUnitId(availableUnitID + 1)

    local playerIndex = modelUnit:getPlayerIndex()
    local modelPlayer = getModelPlayerManager(sceneWarFileName):getModelPlayer(playerIndex)
    modelPlayer:setFund(modelPlayer:getFund() - action.cost)
    dispatchEvtModelPlayerUpdated(sceneWarFileName, modelPlayer, playerIndex)
end

local function executeProduceModelUnitOnUnit(action)
    local sceneWarFileName = action.fileName
    local path             = action.path
    local modelUnitMap     = getModelUnitMap(sceneWarFileName)
    local availableUnitID  = modelUnitMap:getAvailableUnitId()
    local producer         = modelUnitMap:getFocusModelUnit(path[1], action.launchUnitID)
    local actorData        = {
        tiledID       = producer:getMovableProductionTiledId(),
        unitID        = availableUnitID,
        GridIndexable = {gridIndex = path[#path]},
    }
    moveModelUnitWithAction(action)

    local actorUnit = Actor.createWithModelAndViewName("sceneWar.ModelUnit", actorData, "sceneWar.ViewUnit")
    local modelUnit = actorUnit:getModel()
    promoteModelUnitOnProduce(modelUnit, sceneWarFileName)
    modelUnit:onStartRunning(sceneWarFileName)
        :setStateActioned()
        :updateView()

    modelUnitMap:addActorUnitLoaded(actorUnit)
        :setAvailableUnitId(availableUnitID + 1)

    producer:addLoadUnitId(availableUnitID)
    if (producer.setCurrentMaterial) then
        producer:setCurrentMaterial(producer:getCurrentMaterial() - 1)
    end

    local playerIndex = producer:getPlayerIndex()
    local modelPlayer = getModelPlayerManager(sceneWarFileName):getModelPlayer(playerIndex)
    modelPlayer:setFund(modelPlayer:getFund() - action.cost)
    dispatchEvtModelPlayerUpdated(sceneWarFileName, modelPlayer, playerIndex)

    producer:setStateActioned()
        :moveViewAlongPath(path, function()
            producer:updateView()
                :showNormalAnimation()
        end)
end

local function executeSupplyModelUnit(action)
    local sceneWarFileName = action.fileName
    local path             = action.path
    local endingGridIndex  = path[#path]
    local modelUnitMap     = getModelUnitMap(sceneWarFileName)
    local focusModelUnit   = modelUnitMap:getFocusModelUnit(path[1], action.launchUnitID)
    moveModelUnitWithAction(action)

    local targetModelUnits = {}
    for _, gridIndex in pairs(GridIndexFunctions.getAdjacentGrids(endingGridIndex, modelUnitMap:getMapSize())) do
        local targetModelUnit = modelUnitMap:getModelUnit(gridIndex)
        if ((targetModelUnit) and (focusModelUnit:canSupplyModelUnit(targetModelUnit))) then
            targetModelUnits[#targetModelUnits + 1] = targetModelUnit

            if (targetModelUnit.setCurrentFuel) then
                targetModelUnit:setCurrentFuel(targetModelUnit:getMaxFuel())
            end
            if ((targetModelUnit.hasPrimaryWeapon) and (targetModelUnit:hasPrimaryWeapon())) then
                targetModelUnit:setPrimaryWeaponCurrentAmmo(targetModelUnit:getPrimaryWeaponMaxAmmo())
            end
        end
    end

    focusModelUnit:setStateActioned()
        :moveViewAlongPath(path, function()
            focusModelUnit:updateView()
                :showNormalAnimation()

            local dispatcher = getScriptEventDispatcher(sceneWarFileName)
            for _, targetModelUnit in ipairs(targetModelUnits) do
                targetModelUnit:updateView()
                dispatcher:dispatchEvent({
                    name      = "EvtSupplyViewUnit",
                    gridIndex = targetModelUnit:getGridIndex(),
                })
            end
        end)
end

local function executeWait(action)
    local path           = action.path
    local focusModelUnit = getModelUnitMap(action.fileName):getFocusModelUnit(path[1], action.launchUnitID)
    moveModelUnitWithAction(action)

    focusModelUnit:setStateActioned()
        :moveViewAlongPath(path, function()
            focusModelUnit:updateView()
                :showNormalAnimation()
        end)
end

--------------------------------------------------------------------------------
-- The public function.
--------------------------------------------------------------------------------
function ActionExecutor.execute(action)
    local modelSceneWar = SingletonGetters.getModelScene(action.fileName)
    if ((not modelSceneWar) or (not modelSceneWar.getModelWarField)) then
        return
    end

    local actionName = action.actionName
    if     (actionName == "Logout")             then return executeLogout(            action)
    elseif (actionName == "Message")            then return executeMessage(           action)
    elseif (actionName == "Error")              then return executeError(             action)
    elseif (actionName == "RunSceneMain")       then return executeRunSceneMain(      action)
    elseif (actionName == "GetSceneWarData")    then return executeGetSceneWarData(   action)
    elseif (actionName == "ReloadCurrentScene") then return executeReloadCurrentScene(action)
    end

    local actionID = action.actionID
    if (actionID ~= modelSceneWar:getActionId() + 1) then
        assert(not IS_SERVER, "ActionExecutor.execute() the actionID is invalid on the server: " .. (actionID or ""))
        getModelMessageIndicator():showPersistentMessage(getLocalizedText(81, "OutOfSync"))
        requestReloadSceneWar()
        return
    end
    modelSceneWar:setActionId(actionID)

    if     (actionName == "ActivateSkillGroup")     then executeActivateSkillGroup(    action)
    elseif (actionName == "BuildModelTile")         then executeBuildModelTile(        action)
    elseif (actionName == "JoinModelUnit")          then executeJoinModelUnit(         action)
    elseif (actionName == "LaunchSilo")             then executeLaunchSilo(            action)
    elseif (actionName == "LoadModelUnit")          then executeLoadModelUnit(         action)
    elseif (actionName == "ProduceModelUnitOnTile") then executeProduceModelUnitOnTile(action)
    elseif (actionName == "ProduceModelUnitOnUnit") then executeProduceModelUnitOnUnit(action)
    elseif (actionName == "SupplyModelUnit")        then executeSupplyModelUnit(       action)
    elseif (actionName == "Wait")                   then executeWait(                  action)
    end

    if (not IS_SERVER) then
        getModelMessageIndicator():hidePersistentMessage(getLocalizedText(80, "TransferingData"))
        getScriptEventDispatcher():dispatchEvent({
                name    = "EvtIsWaitingForServerResponse",
                waiting = false,
            })
            :dispatchEvent({name = "EvtModelTileMapUpdated"})
            :dispatchEvent({name = "EvtModelUnitMapUpdated"})
    end
end

return ActionExecutor
