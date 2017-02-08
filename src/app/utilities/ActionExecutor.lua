
local ActionExecutor = {}

local ActionCodeFunctions    = requireBW("src.app.utilities.ActionCodeFunctions")
local AuxiliaryFunctions     = requireBW("src.app.utilities.AuxiliaryFunctions")
local Destroyers             = requireBW("src.app.utilities.Destroyers")
local GameConstantFunctions  = requireBW("src.app.utilities.GameConstantFunctions")
local GridIndexFunctions     = requireBW("src.app.utilities.GridIndexFunctions")
local InstantSkillExecutor   = requireBW("src.app.utilities.InstantSkillExecutor")
local LocalizationFunctions  = requireBW("src.app.utilities.LocalizationFunctions")
local SerializationFunctions = requireBW("src.app.utilities.SerializationFunctions")
local SingletonGetters       = requireBW("src.app.utilities.SingletonGetters")
local SkillModifierFunctions = requireBW("src.app.utilities.SkillModifierFunctions")
local SupplyFunctions        = requireBW("src.app.utilities.SupplyFunctions")
local TableFunctions         = requireBW("src.app.utilities.TableFunctions")
local VisibilityFunctions    = requireBW("src.app.utilities.VisibilityFunctions")
local Actor                  = requireBW("src.global.actors.Actor")

local ACTION_CODES         = ActionCodeFunctions.getFullList()
local UNIT_MAX_HP          = GameConstantFunctions.getUnitMaxHP()
local IS_SERVER            = GameConstantFunctions.isServer()
local PlayerProfileManager = (    IS_SERVER) and (requireBW("src.app.utilities.PlayerProfileManager")) or (nil)
local SceneWarManager      = (    IS_SERVER) and (requireBW("src.app.utilities.SceneWarManager"))      or (nil)
local WebSocketManager     = (not IS_SERVER) and (requireBW("src.app.utilities.WebSocketManager"))     or (nil)
local ActorManager         = (not IS_SERVER) and (requireBW("src.global.actors.ActorManager"))         or (nil)

local appendList                    = TableFunctions.appendList
local destroyActorUnitLoaded        = Destroyers.destroyActorUnitLoaded
local destroyActorUnitOnMap         = Destroyers.destroyActorUnitOnMap
local getAdjacentGrids              = GridIndexFunctions.getAdjacentGrids
local getGridsWithinDistance        = GridIndexFunctions.getGridsWithinDistance
local getLocalizedText              = LocalizationFunctions.getLocalizedText
local getLoggedInAccountAndPassword = (WebSocketManager) and (WebSocketManager.getLoggedInAccountAndPassword) or (nil)
local getModelFogMap                = SingletonGetters.getModelFogMap
local getModelGridEffect            = SingletonGetters.getModelGridEffect
local getModelMessageIndicator      = SingletonGetters.getModelMessageIndicator
local getModelPlayerManager         = SingletonGetters.getModelPlayerManager
local getModelTileMap               = SingletonGetters.getModelTileMap
local getModelTurnManager           = SingletonGetters.getModelTurnManager
local getModelUnitMap               = SingletonGetters.getModelUnitMap
local getPlayerIndexLoggedIn        = SingletonGetters.getPlayerIndexLoggedIn
local getScriptEventDispatcher      = SingletonGetters.getScriptEventDispatcher
local isTotalReplay                 = SingletonGetters.isTotalReplay
local isTileVisible                 = VisibilityFunctions.isTileVisibleToPlayerIndex
local isUnitVisible                 = VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex
local next, pairs, ipairs, unpack   = next, pairs, ipairs, unpack
local supplyWithAmmoAndFuel         = SupplyFunctions.supplyWithAmmoAndFuel

--------------------------------------------------------------------------------
-- The functions for dispatching events.
--------------------------------------------------------------------------------
local function dispatchEvtModelPlayerUpdated(modelSceneWar, playerIndex)
    getScriptEventDispatcher(modelSceneWar):dispatchEvent({
        name        = "EvtModelPlayerUpdated",
        modelPlayer = getModelPlayerManager(modelSceneWar):getModelPlayer(playerIndex),
        playerIndex = playerIndex,
    })
end

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function runSceneMain(isPlayerLoggedIn, confirmText)
    assert(not IS_SERVER, "ActionExecutor-runSceneMain() the main scene can't be run on the server.")

    local modelSceneMain = Actor.createModel("sceneMain.ModelSceneMain", {
        isPlayerLoggedIn = isPlayerLoggedIn,
        confirmText      = confirmText,
    })
    local viewSceneMain  = Actor.createView( "sceneMain.ViewSceneMain")

    ActorManager.setAndRunRootActor(Actor.createWithModelAndViewInstance(modelSceneMain, viewSceneMain), "FADE", 1)
end

local function isModelUnitDiving(modelUnit)
    return (modelUnit.isDiving) and (modelUnit:isDiving())
end

local function updateFundWithCost(modelSceneWar, playerIndex, cost)
    local modelPlayer = getModelPlayerManager(modelSceneWar):getModelPlayer(playerIndex)
    modelPlayer:setFund(modelPlayer:getFund() - cost)
    dispatchEvtModelPlayerUpdated(modelSceneWar, playerIndex)
end

local function promoteModelUnitOnProduce(modelUnit, modelSceneWar)
    local modelPlayer = getModelPlayerManager(modelSceneWar):getModelPlayer(modelUnit:getPlayerIndex())
    local modifier    = SkillModifierFunctions.getPassivePromotionModifier(modelPlayer:getModelSkillConfiguration())
    if ((modifier > 0) and (modelUnit.setCurrentPromotion)) then
        modelUnit:setCurrentPromotion(modifier)
    end
end

local function produceActorUnit(modelSceneWar, tiledID, unitID, gridIndex)
    local actorData = {
        tiledID       = tiledID,
        unitID        = unitID,
        GridIndexable = {x = gridIndex.x, y = gridIndex.y},
    }
    local actorUnit = Actor.createWithModelAndViewName("sceneWar.ModelUnit", actorData, "sceneWar.ViewUnit")
    local modelUnit = actorUnit:getModel()
    promoteModelUnitOnProduce(modelUnit, modelSceneWar)
    modelUnit:setStateActioned()
        :onStartRunning(modelSceneWar)

    return actorUnit
end

local function getAndSupplyAdjacentModelUnits(modelSceneWar, supplierGridIndex, playerIndex)
    assert(type(playerIndex) == "number", "ActionExecutor-getAndSupplyAdjacentModelUnits() invalid playerIndex: " .. (playerIndex or ""))

    local modelUnitMap = getModelUnitMap(modelSceneWar)
    local targets      = {}
    for _, adjacentGridIndex in pairs(getAdjacentGrids(supplierGridIndex, modelUnitMap:getMapSize())) do
        local target = modelUnitMap:getModelUnit(adjacentGridIndex)
        if ((target) and (target:getPlayerIndex() == playerIndex) and (supplyWithAmmoAndFuel(target))) then
            targets[#targets + 1] = target
        end
    end

    return targets
end

local function addActorUnitsWithUnitsData(modelSceneWar, unitsData, isViewVisible)
    assert(not IS_SERVER,                    "ActionExecutor-addActorUnitsWithUnitsData() this should not be called on the server.")
    assert(not isTotalReplay(modelSceneWar), "ActionExecutor-addActorUnitsWithUnitsData() this shouldn't be called in the replay mode.")

    if (unitsData) then
        local modelUnitMap = getModelUnitMap(modelSceneWar)
        for unitID, unitData in pairs(unitsData) do
            local actorUnit = Actor.createWithModelAndViewName("sceneWar.ModelUnit", unitData, "sceneWar.ViewUnit")
            actorUnit:getModel():onStartRunning(modelSceneWar)
                :updateView()
                :setViewVisible(isViewVisible)

            if (unitData.isLoaded) then
                modelUnitMap:addActorUnitLoaded(actorUnit)
            else
                modelUnitMap:addActorUnitOnMap(actorUnit)
            end
        end
    end
end

local function updateModelTilesWithTilesData(modelSceneWar, tilesData)
    assert(not IS_SERVER,                    "ActionExecutor-updateModelTilesWithTilesData() this shouldn't be called on the server.")
    assert(not isTotalReplay(modelSceneWar), "ActionExecutor-updateModelTilesWithTilesData() this shouldn't be called in the replay mode.")

    if (tilesData) then
        local modelTileMap = getModelTileMap(modelSceneWar)
        for _, tileData in pairs(tilesData) do
            local modelTile = modelTileMap:getModelTileWithPositionIndex(tileData.positionIndex)
            assert(modelTile:isFogEnabledOnClient(), "ActionExecutor-updateModelTilesWithTilesData() the tile has no fog.")
            modelTile:updateAsFogDisabled(tileData)
        end
    end
end

local function updateTilesAndUnitsBeforeExecutingAction(action, modelSceneWar)
    if ((not IS_SERVER) and (not isTotalReplay(modelSceneWar))) then
        addActorUnitsWithUnitsData(   modelSceneWar, action.actingUnitsData, false)
        addActorUnitsWithUnitsData(   modelSceneWar, action.revealedUnits,   false)
        updateModelTilesWithTilesData(modelSceneWar, action.actingTilesData)
        updateModelTilesWithTilesData(modelSceneWar, action.revealedTiles)
    end
end

local function updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)
    assert(not IS_SERVER, "ActionExecutor-updateTileAndUnitMapOnVisibilityChanged(modelSceneWar) this shouldn't be called on the server.")
    if (isTotalReplay(modelSceneWar)) then
        getModelFogMap(modelSceneWar):updateView()
    else
        local playerIndex      = getPlayerIndexLoggedIn(modelSceneWar)
        getModelTileMap(modelSceneWar):forEachModelTile(function(modelTile)
            if (isTileVisible(modelSceneWar, modelTile:getGridIndex(), playerIndex)) then
                modelTile:updateAsFogDisabled()
            else
                modelTile:updateAsFogEnabled()
            end
            modelTile:updateView()
        end)
        getModelUnitMap(modelSceneWar):forEachModelUnitOnMap(function(modelUnit)
            local gridIndex = modelUnit:getGridIndex()
            if (isUnitVisible(modelSceneWar, gridIndex, modelUnit:getUnitType(), isModelUnitDiving(modelUnit), modelUnit:getPlayerIndex(), playerIndex)) then
                modelUnit:setViewVisible(true)
            else
                destroyActorUnitOnMap(modelSceneWar, gridIndex, true)
            end
        end)
    end

    getScriptEventDispatcher(modelSceneWar)
        :dispatchEvent({name = "EvtModelTileMapUpdated"})
        :dispatchEvent({name = "EvtModelUnitMapUpdated"})
end

local function moveModelUnitWithAction(action, modelSceneWar)
    local path               = action.path
    local pathNodes          = path.pathNodes
    local beginningGridIndex = pathNodes[1]
    local modelFogMap        = getModelFogMap(modelSceneWar)
    local modelUnitMap       = getModelUnitMap(modelSceneWar)
    local launchUnitID       = action.launchUnitID
    local focusModelUnit     = modelUnitMap:getFocusModelUnit(beginningGridIndex, launchUnitID)
    local playerIndex        = focusModelUnit:getPlayerIndex()
    local shouldUpdateFogMap = (IS_SERVER) or (isTotalReplay(modelSceneWar)) or (playerIndex == getPlayerIndexLoggedIn(modelSceneWar))
    if (shouldUpdateFogMap) then
        modelFogMap:updateMapForPathsWithModelUnitAndPath(focusModelUnit, pathNodes)
    end

    local pathLength = #pathNodes
    if (pathLength <= 1) then
        return
    end

    local actionCode      = action.actionCode
    local endingGridIndex = pathNodes[pathLength]
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
    if ((shouldUpdateFogMap) and (not launchUnitID)) then
        modelFogMap:updateMapForUnitsForPlayerIndexOnUnitLeave(playerIndex, beginningGridIndex, focusModelUnit:getVisionForPlayerIndex(playerIndex))
    end
    focusModelUnit:setGridIndex(endingGridIndex, false)
    if ((shouldUpdateFogMap) and (actionCode ~= ACTION_CODES.ActionLoadModelUnit)) then
        modelFogMap:updateMapForUnitsForPlayerIndexOnUnitArrive(playerIndex, endingGridIndex, focusModelUnit:getVisionForPlayerIndex(playerIndex))
    end

    if (launchUnitID) then
        local loaderModelUnit = modelUnitMap:getModelUnit(beginningGridIndex)
        if (loaderModelUnit) then
            loaderModelUnit:removeLoadUnitId(launchUnitID)
                :updateView()
                :showNormalAnimation()
        else
            assert(not IS_SERVER, "ActionExecutor-moveModelUnitWithAction() failed to get the loader for the launching unit, on the server.")
        end

        if (actionCode ~= ACTION_CODES.ActionLoadModelUnit) then
            modelUnitMap:setActorUnitUnloaded(launchUnitID, endingGridIndex)
        end
    else
        if (actionCode == ACTION_CODES.ActionLoadModelUnit) then
            modelUnitMap:setActorUnitLoaded(beginningGridIndex)
        else
            modelUnitMap:swapActorUnit(beginningGridIndex, endingGridIndex)
        end

        local modelTile = getModelTileMap(modelSceneWar):getModelTile(beginningGridIndex)
        if (modelTile.setCurrentBuildPoint) then
            modelTile:setCurrentBuildPoint(modelTile:getMaxBuildPoint())
        end
        if (modelTile.setCurrentCapturePoint) then
            modelTile:setCurrentCapturePoint(modelTile:getMaxCapturePoint())
        end
    end
end

local function getBaseDamageCostWithTargetAndDamage(target, damage)
    if (not target.getBaseProductionCost) then
        return 0
    else
        local normalizedRemainingHP = math.ceil(math.max(0, target:getCurrentHP() - damage) / 10)
        return math.floor(target:getBaseProductionCost() * (target:getNormalizedCurrentHP() - normalizedRemainingHP) / 10)
    end
end

local function getSkillModifiedDamageCost(cost, modelPlayer)
    local modifier = SkillModifierFunctions.getEnergyGrowthRateModifier(modelPlayer:getModelSkillConfiguration())
    return math.floor(cost * (100 + modifier) / 100)
end

local function getIncomeWithDamageCost(targetDamageCost, modelPlayer)
    local modifier = SkillModifierFunctions.getAttackDamageCostToFundModifier(modelPlayer:getModelSkillConfiguration())
    return math.floor(targetDamageCost * modifier / 100)
end

local function getAdjacentPlasmaGridIndexes(gridIndex, modelTileMap)
    local mapSize     = modelTileMap:getMapSize()
    local indexes     = {[0] = gridIndex}
    local searchedMap = {[gridIndex.x] = {[gridIndex.y] = true}}

    local i = 0
    while (i <= #indexes) do
        for _, adjacentGridIndex in ipairs(getAdjacentGrids(indexes[i], mapSize)) do
            if (modelTileMap:getModelTile(adjacentGridIndex):getTileType() == "Plasma") then
                local x, y = adjacentGridIndex.x, adjacentGridIndex.y
                searchedMap[x] = searchedMap[x] or {}
                if (not searchedMap[x][y]) then
                    indexes[#indexes + 1] = adjacentGridIndex
                    searchedMap[x][y] = true
                end
            end
        end
        i = i + 1
    end

    indexes[0] = nil
    return indexes
end

local function callbackOnWarEndedForClient()
    runSceneMain(getLoggedInAccountAndPassword() ~= nil)
end

local function cleanupOnReceivingResponseFromServer(modelSceneWar)
    assert(not IS_SERVER, "ActionExecutor-cleanupOnReceivingResponseFromServer() this shouldn't be invoked on the server.")
    assert(not isTotalReplay(modelSceneWar), "ActionExecutor-cleanupOnReceivingResponseFromServer() this shouldn't be invoked in replay mode.")

    getModelMessageIndicator(modelSceneWar):hidePersistentMessage(getLocalizedText(80, "TransferingData"))
    getScriptEventDispatcher(modelSceneWar):dispatchEvent({
        name    = "EvtIsWaitingForServerResponse",
        waiting = false,
    })
end

--------------------------------------------------------------------------------
-- The executors for non-war actions.
--------------------------------------------------------------------------------
local function executeDownloadReplayData(action, modelScene)
    assert(not IS_SERVER, "ActionExecutor-executeDownloadReplayData() should not be invoked on the server.")
    if (modelScene.isModelSceneWar) then
        return
    end

    local modelReplayManager = modelScene:getModelMainMenu():getModelReplayManager()
    if (modelReplayManager:isRetrievingEncodedReplayData()) then
        modelReplayManager:updateWithEncodedReplayData(action.encodedReplayData)
    end
end

local function executeExitWar(action, modelScene)
    local warID = action.warID
    if (IS_SERVER) then
        SceneWarManager.exitWar(action.playerAccount, warID)
    else
        getModelMessageIndicator(modelScene):showMessage(getLocalizedText(56, "ExitWarSuccessfully", AuxiliaryFunctions.getWarNameWithWarId(warID)))
        if (not modelScene.isModelSceneWar) then
            local modelMainMenu        = modelScene:getModelMainMenu()
            local modelExitWarSelector = modelMainMenu:getModelExitWarSelector()
            if (modelExitWarSelector:isRetrievingExitWarResult(warID)) then
                modelExitWarSelector:setEnabled(false)
                modelMainMenu:setMenuEnabled(true)
            end
        end
    end
end

local function executeGetReplayConfigurations(action, modelScene)
    assert(not IS_SERVER, "ActionExecutor-executeGetReplayConfigurations() should not be invoked on the server.")
    if (modelScene.isModelSceneWar) then
        return
    end

    local modelReplayManager = modelScene:getModelMainMenu():getModelReplayManager()
    if (modelReplayManager:isRetrievingReplayConfigurations()) then
        modelReplayManager:updateWithReplayConfigurations(action.replayConfigurations, action.pageIndex)
    end
end

local function executeGetJoinableWarConfigurations(action, modelScene)
    assert(not IS_SERVER, "ActionExecutor-executeGetJoinableWarConfigurations() should not be invoked on the server.")

    if (modelScene.isModelSceneWar) then
        return
    end

    local modelJoinWarSelector = modelScene:getModelMainMenu():getModelJoinWarSelector()
    if (modelJoinWarSelector:isRetrievingJoinableWarConfigurations()) then
        modelJoinWarSelector:updateWithJoinableWarConfigurations(action.warConfigurations)
    end
end

local function executeGetOngoingWarConfigurations(action, modelScene)
    assert(not IS_SERVER, "ActionExecutor-executeGetOngoingWarConfigurations() should not be invoked on the server.")
    if (modelScene.isModelSceneWar) then
        return
    end

    local modelContinueWarSelector = modelScene:getModelMainMenu():getModelContinueWarSelector()
    if (modelContinueWarSelector:isRetrievingOngoingWarConfigurations()) then
        modelContinueWarSelector:updateWithOngoingWarConfigurations(action.warConfigurations)
    end
end

local function executeGetPlayerProfile(action, modelScene)
    assert(not IS_SERVER, "ActionExecutor-executeGetPlayerProfile() should not be invoked on the server.")
    if (modelScene.isModelSceneWar) then
        return
    end

    local modelGameRecordViewer = modelScene:getModelMainMenu():getModelGameRecordViewer()
    if (modelGameRecordViewer:isRetrievingPlayerProfile()) then
        modelGameRecordViewer:updateWithPlayerProfile(action.playerProfile)
    end
end

local function executeGetRankingList(action, modelScene)
    assert(not IS_SERVER, "ActionExecutor-executeGetRankingList() should not be invoked on the server.")
    if (modelScene.isModelSceneWar) then
        return
    end

    local modelGameRecordViewer = modelScene:getModelMainMenu():getModelGameRecordViewer()
    if (modelGameRecordViewer:isRetrievingRankingList(action.rankingListIndex)) then
        modelGameRecordViewer:updateWithRankingList(action.rankingList, action.rankingListIndex)
    end
end

local function executeGetSkillConfiguration(action, modelScene)
    assert(not IS_SERVER, "ActionExecutor-executeGetSkillConfiguration() should not be invoked on the server.")

    local skillConfigurationID   = action.skillConfigurationID
    local skillConfiguration     = action.skillConfiguration
    local modelMainMenu          = modelScene:getModelMainMenu()
    local modelSkillConfigurator = modelMainMenu:getModelSkillConfigurator()
    local modelNewWarCreator     = modelMainMenu:getModelNewWarCreator()
    local modelJoinWarSelector   = modelMainMenu:getModelJoinWarSelector()

    if (modelSkillConfigurator:isRetrievingSkillConfiguration(skillConfigurationID)) then
        modelSkillConfigurator:updateWithSkillConfiguration(skillConfiguration)
    elseif (modelNewWarCreator:isRetrievingSkillConfiguration(skillConfigurationID)) then
        modelNewWarCreator:updateWithSkillConfiguration(skillConfiguration, skillConfigurationID)
    elseif (modelJoinWarSelector:isRetrievingSkillConfiguration(skillConfigurationID)) then
        modelJoinWarSelector:updateWithSkillConfiguration(skillConfiguration, skillConfigurationID)
    end
end

local function executeGetWaitingWarConfigurations(action, modelScene)
    assert(not IS_SERVER, "ActionExecutor-executeGetWaitingWarConfigurations() should not be invoked on the server.")
    if (modelScene.isModelSceneWar) then
        return
    end

    local modelExitWarSelector = modelScene:getModelMainMenu():getModelExitWarSelector()
    if (modelExitWarSelector:isRetrievingWaitingWarConfigurations()) then
        modelExitWarSelector:updateWithWaitingWarConfigurations(action.warConfigurations)
    end
end

local function executeJoinWar(action, modelScene)
    if (IS_SERVER) then
        SceneWarManager.joinWar(action)
    else
        local warID = action.warID
        getModelMessageIndicator(modelScene):showMessage(getLocalizedText(56, "JoinWarSuccessfully", AuxiliaryFunctions.getWarNameWithWarId(warID)))
            :showMessage(getLocalizedText(56, (action.isWarStarted) and ("JoinWarStarted") or ("JoinWarNotStarted")))
        if (not modelScene.isModelSceneWar) then
            local modelMainMenu        = modelScene:getModelMainMenu()
            local modelJoinWarSelector = modelMainMenu:getModelJoinWarSelector()
            if (modelJoinWarSelector:isRetrievingJoinWarResult(warID)) then
                modelJoinWarSelector:setEnabled(false)
                modelMainMenu:setMenuEnabled(true)
            end
        end
    end
end

local function executeLogin(action, modelScene)
    assert(not IS_SERVER, "ActionExecutor-executeLogin() should not be invoked on the server.")
    local account, password = action.loginAccount, action.loginPassword
    if (account ~= getLoggedInAccountAndPassword()) then
        WebSocketManager.setLoggedInAccountAndPassword(account, password)
        SerializationFunctions.serializeAccountAndPassword(account, password)

        if (modelScene.isModelSceneWar) then
            runSceneMain(true)
        else
            local modelMainMenu   = SingletonGetters.getModelMainMenu(modelScene)
            local modelLoginPanel = modelMainMenu:getModelLoginPanel()
            if (not modelLoginPanel:isEnabled()) then
                runSceneMain(true)
            else
                modelLoginPanel:setEnabled(false)
                modelMainMenu:updateWithIsPlayerLoggedIn(true)
                    :setMenuEnabled(true)
            end
        end

        getModelMessageIndicator(modelScene):showMessage(getLocalizedText(26, account))
    end
end

local function executeLogout(action)
    assert(not IS_SERVER, "ActionExecutor-executeLogout() should not be invoked on the server.")
    WebSocketManager.setLoggedInAccountAndPassword(nil, nil)
    runSceneMain(false, getLocalizedText(action.messageCode, unpack(action.messageParams or {})))
end

local function executeMessage(action, modelScene)
    assert(not IS_SERVER, "ActionExecutor-executeMessage() should not be invoked on the server.")
    local message = getLocalizedText(action.messageCode, unpack(action.messageParams or {}))
    getModelMessageIndicator(modelScene):showMessage(message)
end

local function executeNewWar(action, modelScene)
    if (IS_SERVER) then
        SceneWarManager.createNewWar(action)
    else
        getModelMessageIndicator(modelScene):showMessage(getLocalizedText(51, "NewWarCreated", AuxiliaryFunctions.getWarNameWithWarId(action.warID)))
        if (not modelScene.isModelSceneWar) then
            local modelMainMenu      = modelScene:getModelMainMenu()
            local modelNewWarCreator = modelMainMenu:getModelNewWarCreator()
            if (modelNewWarCreator:isEnabled()) then
                modelNewWarCreator:setEnabled(false)
                modelMainMenu:setMenuEnabled(true)
            end
        end
    end
end

local function executeRegister(action, modelScene)
    local account, password = action.registerAccount, action.registerPassword
    if (IS_SERVER) then
        PlayerProfileManager.createPlayerProfile(account, password)
    elseif (account ~= getLoggedInAccountAndPassword()) then
        WebSocketManager.setLoggedInAccountAndPassword(account, password)
        SerializationFunctions.serializeAccountAndPassword(account, password)

        if (modelScene.isModelSceneWar) then
            runSceneMain(true)
        else
            local modelMainMenu   = modelScene:getModelMainMenu()
            local modelLoginPanel = modelMainMenu:getModelLoginPanel()
            if (not modelLoginPanel:isEnabled()) then
                runSceneMain(true)
            else
                modelLoginPanel:setEnabled(false)
                modelMainMenu:updateWithIsPlayerLoggedIn(true)
                    :setMenuEnabled(true)
            end
        end

        getModelMessageIndicator(modelScene):showMessage(getLocalizedText(27, account))
    end
end

local function executeRunSceneMain(action)
    assert(not IS_SERVER, "ActionExecutor-executeRunSceneMain() should not be invoked on the server.")
    local message = (action.messageCode) and (getLocalizedText(action.messageCode, unpack(action.messageParams or {}))) or (nil)
    runSceneMain(getLoggedInAccountAndPassword() ~= nil, message)
end

local function executeRunSceneWar(action, modelScene)
    assert(not IS_SERVER, "ActionExecutor-executeRunSceneWar() this shouldn't be invoked on the server.")
    if (not modelScene.isModelSceneWar) then
        local modelContinueWarSelector = modelScene:getModelMainMenu():getModelContinueWarSelector()
        if (modelContinueWarSelector:isRetrievingOngoingWarData()) then
            modelContinueWarSelector:updateWithOngoingWarData(action.warData)
        end
    end
end

local function executeReloadSceneWar(action, modelScene)
    assert(not IS_SERVER, "ActionExecutor-executeReloadSceneWar() should not be invoked on the server.")

    local warData = action.warData
    if ((modelScene.isModelSceneWar)                    and
        (modelScene:getWarId() == warData.warID)        and
        (modelScene:getActionId() <= warData.actionID)) then
        if (action.messageCode) then
            getModelMessageIndicator(modelScene):showPersistentMessage(getLocalizedText(action.messageCode, unpack(action.messageParams or {})))
        end

        local actorSceneWar = Actor.createWithModelAndViewName("sceneWar.ModelSceneWar", warData, "sceneWar.ViewSceneWar")
        ActorManager.setAndRunRootActor(actorSceneWar, "FADE", 1)
    end
end

local function executeSetSkillConfiguration(action, modelScene)
    if (IS_SERVER) then
        PlayerProfileManager.setSkillConfiguration(action.playerAccount, action.skillConfigurationID, action.skillConfiguration)
    else
        getModelMessageIndicator(modelScene):showMessage(getLocalizedText(81, "SucceedToSetSkillConfiguration"))
    end
end

local function executeSyncSceneWar(action, modelScene)
    assert(not IS_SERVER, "ActionExecutor-executeSyncSceneWar() should not be invoked on the server.")
    -- Nothing to do.
end

--------------------------------------------------------------------------------
-- The executors for war actions.
--------------------------------------------------------------------------------
local function executeActivateSkillGroup(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)
    updateTilesAndUnitsBeforeExecutingAction(action, modelSceneWar)

    local skillGroupID = action.skillGroupID
    local playerIndex  = getModelTurnManager(modelSceneWar):getPlayerIndex()
    local modelPlayer  = getModelPlayerManager(modelSceneWar):getModelPlayer(playerIndex)
    modelPlayer:getModelSkillConfiguration():setActivatingSkillGroupId(skillGroupID)
    modelPlayer:setDamageCost(modelPlayer:getDamageCost() - modelPlayer:getDamageCostForSkillGroupId(skillGroupID))
        :setSkillActivatedCount(modelPlayer:getSkillActivatedCount() + 1)
    InstantSkillExecutor.activateSkillGroup(modelSceneWar, skillGroupID)

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        modelSceneWar:setExecutingAction(false)
    else
        if (not isTotalReplay(modelSceneWar)) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end

        local modelGridEffect = getModelGridEffect(modelSceneWar)
        local func            = function(modelUnit)
            if (modelUnit:getPlayerIndex() == playerIndex) then
                modelGridEffect:showAnimationSkillActivation(modelUnit:getGridIndex())
                modelUnit:updateView()
            end
        end
        getModelUnitMap(modelSceneWar):forEachModelUnitOnMap(func)
            :forEachModelUnitLoaded(func)

        updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)
        dispatchEvtModelPlayerUpdated(modelSceneWar, playerIndex)

        modelSceneWar:setExecutingAction(false)
    end
end

local function executeAttack(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)
    updateTilesAndUnitsBeforeExecutingAction(action, modelSceneWar)

    local pathNodes           = action.path.pathNodes
    local attackDamage        = action.attackDamage
    local counterDamage       = action.counterDamage
    local attackerGridIndex   = pathNodes[#pathNodes]
    local targetGridIndex     = action.targetGridIndex
    local modelUnitMap        = getModelUnitMap(modelSceneWar)
    local modelTileMap        = getModelTileMap(modelSceneWar)
    local attacker            = modelUnitMap:getFocusModelUnit(pathNodes[1], action.launchUnitID)
    local attackTarget        = modelUnitMap:getModelUnit(targetGridIndex) or modelTileMap:getModelTile(targetGridIndex)
    local attackerPlayerIndex = attacker:getPlayerIndex()
    local targetPlayerIndex   = attackTarget:getPlayerIndex()
    moveModelUnitWithAction(action, modelSceneWar)
    attacker:setStateActioned()

    if (attacker:getPrimaryWeaponBaseDamage(attackTarget:getDefenseType())) then
        attacker:setPrimaryWeaponCurrentAmmo(attacker:getPrimaryWeaponCurrentAmmo() - 1)
    end
    if ((counterDamage) and (attackTarget:getPrimaryWeaponBaseDamage(attacker:getDefenseType()))) then
        attackTarget:setPrimaryWeaponCurrentAmmo(attackTarget:getPrimaryWeaponCurrentAmmo() - 1)
    end

    local modelPlayerManager = getModelPlayerManager(modelSceneWar)
    if (attackTarget.getUnitType) then
        local attackerDamageCost  = getBaseDamageCostWithTargetAndDamage(attacker,     counterDamage or 0)
        local targetDamageCost    = getBaseDamageCostWithTargetAndDamage(attackTarget, attackDamage)
        local attackerModelPlayer = modelPlayerManager:getModelPlayer(attackerPlayerIndex)
        local targetModelPlayer   = modelPlayerManager:getModelPlayer(targetPlayerIndex)

        attackerModelPlayer:addDamageCost(getSkillModifiedDamageCost(attackerDamageCost * 2 + targetDamageCost,     attackerModelPlayer))
        targetModelPlayer  :addDamageCost(getSkillModifiedDamageCost(attackerDamageCost     + targetDamageCost * 2, targetModelPlayer))
        attackerModelPlayer:setFund(attackerModelPlayer:getFund() + getIncomeWithDamageCost(targetDamageCost,   attackerModelPlayer))
        targetModelPlayer  :setFund(targetModelPlayer  :getFund() + getIncomeWithDamageCost(attackerDamageCost, targetModelPlayer))

        dispatchEvtModelPlayerUpdated(modelSceneWar, attackerPlayerIndex)
    end

    local attackerNewHP = math.max(0, attacker:getCurrentHP() - (counterDamage or 0))
    attacker:setCurrentHP(attackerNewHP)
    if (attackerNewHP == 0) then
        attackTarget:setCurrentPromotion(math.min(attackTarget:getMaxPromotion(), attackTarget:getCurrentPromotion() + 1))
        destroyActorUnitOnMap(modelSceneWar, attackerGridIndex, false)
    end

    local targetNewHP = math.max(0, attackTarget:getCurrentHP() - attackDamage)
    local targetVision, plasmaGridIndexes
    attackTarget:setCurrentHP(targetNewHP)
    if (targetNewHP == 0) then
        if (attackTarget.getUnitType) then
            targetVision = attackTarget:getVisionForPlayerIndex(targetPlayerIndex)

            attacker:setCurrentPromotion(math.min(attacker:getMaxPromotion(), attacker:getCurrentPromotion() + 1))
            destroyActorUnitOnMap(modelSceneWar, targetGridIndex, false, true)
        else
            if ((not IS_SERVER) and (not isTotalReplay(modelSceneWar)) and (attackTarget:isFogEnabledOnClient())) then
                attackTarget:updateAsFogDisabled()
            end
            attackTarget:updateWithObjectAndBaseId(0)

            plasmaGridIndexes = getAdjacentPlasmaGridIndexes(targetGridIndex, modelTileMap)
            for _, gridIndex in ipairs(plasmaGridIndexes) do
                local modelTile = modelTileMap:getModelTile(gridIndex)
                if ((not IS_SERVER) and (not isTotalReplay(modelSceneWar)) and (modelTile:isFogEnabledOnClient())) then
                    modelTile:updateAsFogDisabled()
                end
                modelTile:updateWithObjectAndBaseId(0)
            end
        end
    end

    local modelTurnManager   = getModelTurnManager(modelSceneWar)
    local lostPlayerIndex    = action.lostPlayerIndex
    local isInTurnPlayerLost = (lostPlayerIndex == attackerPlayerIndex)
    if (lostPlayerIndex) then
        modelSceneWar:setRemainingVotesForDraw(nil)
    end

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        if (targetVision) then
            getModelFogMap(modelSceneWar):updateMapForUnitsForPlayerIndexOnUnitLeave(targetPlayerIndex, targetGridIndex, targetVision)
        end
        if (lostPlayerIndex) then
            Destroyers.destroyPlayerForce(modelSceneWar, lostPlayerIndex)
            if (modelPlayerManager:getAlivePlayersCount() <= 1) then
                modelSceneWar:setEnded(true)
            elseif (isInTurnPlayerLost) then
                modelTurnManager:endTurnPhaseMain()
            end
        end
        modelSceneWar:setExecutingAction(false)

    else
        local isReplay             = isTotalReplay(modelSceneWar)
        local playerIndexLoggedIn  = (not isReplay) and (getPlayerIndexLoggedIn(modelSceneWar)) or (nil)
        local isLoggedInPlayerLost = (lostPlayerIndex) and (lostPlayerIndex == playerIndexLoggedIn)
        if (not isReplay) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end
        if ((isLoggedInPlayerLost)                                                    or
            ((lostPlayerIndex) and (modelPlayerManager:getAlivePlayersCount() <= 2))) then
            modelSceneWar:setEnded(true)
        end

        attacker:moveViewAlongPathAndFocusOnTarget(pathNodes, isModelUnitDiving(attacker), targetGridIndex, function()
            attacker:updateView()
                :showNormalAnimation()
            attackTarget:updateView()
            if (attackerNewHP == 0) then
                attacker:removeViewFromParent()
            elseif ((targetNewHP == 0) and (attackTarget.getUnitType)) then
                attackTarget:removeViewFromParent()
            end

            local modelGridEffect = getModelGridEffect(modelSceneWar)
            if (attackerNewHP == 0) then
                modelGridEffect:showAnimationExplosion(attackerGridIndex)
            elseif ((counterDamage) and (targetNewHP > 0)) then
                modelGridEffect:showAnimationDamage(attackerGridIndex)
            end

            if (targetNewHP > 0) then
                modelGridEffect:showAnimationDamage(targetGridIndex)
            else
                modelGridEffect:showAnimationExplosion(targetGridIndex)
                if (not attackTarget.getUnitType) then
                    for _, gridIndex in ipairs(plasmaGridIndexes) do
                        modelTileMap:getModelTile(gridIndex):updateView()
                    end
                end
            end

            if ((targetVision)                                              and
                ((isReplay) or (targetPlayerIndex == playerIndexLoggedIn))) then
                getModelFogMap(modelSceneWar):updateMapForUnitsForPlayerIndexOnUnitLeave(targetPlayerIndex, targetGridIndex, targetVision)
            end
            if (lostPlayerIndex) then
                Destroyers.destroyPlayerForce(modelSceneWar, lostPlayerIndex)
                getModelMessageIndicator(modelSceneWar):showMessage(getLocalizedText(74, "Lose", modelPlayerManager:getModelPlayer(lostPlayerIndex):getNickname()))
            end

            updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)

            if (modelSceneWar:isEnded()) then
                if     (isReplay)             then modelSceneWar:showEffectReplayEnd(callbackOnWarEndedForClient)
                elseif (isLoggedInPlayerLost) then modelSceneWar:showEffectLose(     callbackOnWarEndedForClient)
                else                               modelSceneWar:showEffectWin(      callbackOnWarEndedForClient)
                end
            elseif (isInTurnPlayerLost) then
                modelTurnManager:endTurnPhaseMain()
            end

            modelSceneWar:setExecutingAction(false)
        end)
    end
end

local function executeBeginTurn(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)

    local modelTurnManager   = getModelTurnManager(modelSceneWar)
    local lostPlayerIndex    = action.lostPlayerIndex
    local modelPlayerManager = getModelPlayerManager(modelSceneWar)
    if (lostPlayerIndex) then
        modelSceneWar:setRemainingVotesForDraw(nil)
    end

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        if (not lostPlayerIndex) then
            modelTurnManager:beginTurnPhaseBeginning(action.income, action.repairData, action.supplyData, function()
                modelSceneWar:setExecutingAction(false)
            end)
        else
            modelSceneWar:setEnded(modelPlayerManager:getAlivePlayersCount() <= 2)
            modelTurnManager:beginTurnPhaseBeginning(action.income, action.repairData, action.supplyData, function()
                Destroyers.destroyPlayerForce(modelSceneWar, lostPlayerIndex)
                if (not modelSceneWar:isEnded()) then
                    modelTurnManager:endTurnPhaseMain()
                end
                modelSceneWar:setExecutingAction(false)
            end)
        end
    else
        local isReplay = isTotalReplay(modelSceneWar)
        if (not isReplay) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end

        if (not lostPlayerIndex) then
            modelTurnManager:beginTurnPhaseBeginning(action.income, action.repairData, action.supplyData, function()
                modelSceneWar:setExecutingAction(false)
            end)
        else
            local lostModelPlayer      = modelPlayerManager:getModelPlayer(lostPlayerIndex)
            local isLoggedInPlayerLost = (not isReplay) and (lostModelPlayer:getAccount() == getLoggedInAccountAndPassword(modelSceneWar))
            if ((modelPlayerManager:getAlivePlayersCount() <= 2) or (isLoggedInPlayerLost)) then
                modelSceneWar:setEnded(true)
            end

            modelTurnManager:beginTurnPhaseBeginning(action.income, action.repairData, action.supplyData, function()
                getModelMessageIndicator(modelSceneWar):showMessage(getLocalizedText(74, "Lose", lostModelPlayer:getNickname()))
                Destroyers.destroyPlayerForce(modelSceneWar, lostPlayerIndex)
                updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)

                if (not modelSceneWar:isEnded()) then
                    modelTurnManager:endTurnPhaseMain()
                elseif (isReplay) then
                    modelSceneWar:showEffectReplayEnd(callbackOnWarEndedForClient)
                elseif (isLoggedInPlayerLost) then
                    modelSceneWar:showEffectLose(callbackOnWarEndedForClient)
                else
                    modelSceneWar:showEffectWin(callbackOnWarEndedForClient)
                end

                modelSceneWar:setExecutingAction(false)
            end)
        end
    end
end

local function executeBuildModelTile(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)
    updateTilesAndUnitsBeforeExecutingAction(action, modelSceneWar)

    local pathNodes       = action.path.pathNodes
    local endingGridIndex = pathNodes[#pathNodes]
    local focusModelUnit  = getModelUnitMap(modelSceneWar):getFocusModelUnit(pathNodes[1], action.launchUnitID)
    local modelTile       = getModelTileMap(modelSceneWar):getModelTile(endingGridIndex)
    local buildPoint      = modelTile:getCurrentBuildPoint() - focusModelUnit:getBuildAmount()
    if ((not IS_SERVER) and (not isTotalReplay(modelSceneWar)) and (modelTile:isFogEnabledOnClient())) then
        modelTile:updateAsFogDisabled()
    end
    moveModelUnitWithAction(action, modelSceneWar)
    focusModelUnit:setStateActioned()

    if (buildPoint > 0) then
        focusModelUnit:setBuildingModelTile(true)
        modelTile:setCurrentBuildPoint(buildPoint)
    else
        focusModelUnit:setBuildingModelTile(false)
            :setCurrentMaterial(focusModelUnit:getCurrentMaterial() - 1)
        modelTile:updateWithObjectAndBaseId(focusModelUnit:getBuildTiledIdWithTileType(modelTile:getTileType()))

        local playerIndex = focusModelUnit:getPlayerIndex()
        if ((IS_SERVER) or (isTotalReplay(modelSceneWar)) or (playerIndex == getPlayerIndexLoggedIn(modelSceneWar))) then
            getModelFogMap(modelSceneWar):updateMapForTilesForPlayerIndexOnGettingOwnership(playerIndex, endingGridIndex, modelTile:getVisionForPlayerIndex(playerIndex))
        end
    end

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        modelSceneWar:setExecutingAction(false)
    else
        if (not isTotalReplay(modelSceneWar)) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end

        focusModelUnit:moveViewAlongPath(pathNodes, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()
            modelTile:updateView()

            updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)

            modelSceneWar:setExecutingAction(false)
        end)
    end
end

local function executeCaptureModelTile(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)
    updateTilesAndUnitsBeforeExecutingAction(action, modelSceneWar)

    local pathNodes       = action.path.pathNodes
    local endingGridIndex = pathNodes[#pathNodes]
    local modelTile       = getModelTileMap(modelSceneWar):getModelTile(endingGridIndex)
    local focusModelUnit  = getModelUnitMap(modelSceneWar):getFocusModelUnit(pathNodes[1], action.launchUnitID)
    local isReplay        = isTotalReplay(modelSceneWar)
    if ((not IS_SERVER) and (not isReplay) and (modelTile:isFogEnabledOnClient())) then
        modelTile:updateAsFogDisabled()
    end
    moveModelUnitWithAction(action, modelSceneWar)
    focusModelUnit:setStateActioned()

    local modelFogMap         = getModelFogMap(modelSceneWar)
    local playerIndexLoggedIn = ((not IS_SERVER) and (not isReplay)) and (getPlayerIndexLoggedIn(modelSceneWar)) or (nil)
    local capturePoint        = modelTile:getCurrentCapturePoint() - focusModelUnit:getCaptureAmount()
    local previousVision, previousPlayerIndex
    if (capturePoint > 0) then
        focusModelUnit:setCapturingModelTile(true)
        modelTile:setCurrentCapturePoint(capturePoint)
    else
        previousPlayerIndex = modelTile:getPlayerIndex()
        previousVision      = (previousPlayerIndex > 0) and (modelTile:getVisionForPlayerIndex(previousPlayerIndex)) or (nil)

        local playerIndexActing = focusModelUnit:getPlayerIndex()
        focusModelUnit:setCapturingModelTile(false)
        modelTile:setCurrentCapturePoint(modelTile:getMaxCapturePoint())
            :updateWithPlayerIndex(playerIndexActing)

        if ((IS_SERVER) or (isReplay) or (playerIndexActing == playerIndexLoggedIn)) then
            modelFogMap:updateMapForTilesForPlayerIndexOnGettingOwnership(playerIndexActing, endingGridIndex, modelTile:getVisionForPlayerIndex(playerIndexActing))
        end
    end

    local modelPlayerManager = getModelPlayerManager(modelSceneWar)
    local lostPlayerIndex    = action.lostPlayerIndex
    if (lostPlayerIndex) then
        modelSceneWar:setRemainingVotesForDraw(nil)
    end

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        if (capturePoint <= 0) then
            modelFogMap:updateMapForTilesForPlayerIndexOnLosingOwnership(previousPlayerIndex, endingGridIndex, previousVision)
        end
        if (lostPlayerIndex) then
            Destroyers.destroyPlayerForce(modelSceneWar, lostPlayerIndex)
            modelSceneWar:setEnded(modelPlayerManager:getAlivePlayersCount() <= 1)
        end
        modelSceneWar:setExecutingAction(false)
    else
        if (not isReplay) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end

        if (not lostPlayerIndex) then
            focusModelUnit:moveViewAlongPath(pathNodes, isModelUnitDiving(focusModelUnit), function()
                focusModelUnit:updateView()
                    :showNormalAnimation()
                modelTile:updateView()

                if ((capturePoint <= 0)                                           and
                    ((isReplay) or (previousPlayerIndex == playerIndexLoggedIn))) then
                    modelFogMap:updateMapForTilesForPlayerIndexOnLosingOwnership(previousPlayerIndex, endingGridIndex, previousVision)
                end
                updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)

                modelSceneWar:setExecutingAction(false)
            end)
        else
            local lostModelPlayer      = modelPlayerManager:getModelPlayer(lostPlayerIndex)
            local isLoggedInPlayerLost = (not isReplay) and (lostModelPlayer:getAccount() == getLoggedInAccountAndPassword())
            if ((isLoggedInPlayerLost) or (modelPlayerManager:getAlivePlayersCount() <= 2)) then
                modelSceneWar:setEnded(true)
            end

            focusModelUnit:moveViewAlongPath(pathNodes, isModelUnitDiving(focusModelUnit), function()
                focusModelUnit:updateView()
                    :showNormalAnimation()
                modelTile:updateView()

                getModelMessageIndicator(modelSceneWar):showMessage(getLocalizedText(74, "Lose", lostModelPlayer:getNickname()))
                Destroyers.destroyPlayerForce(modelSceneWar, lostPlayerIndex)
                updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)

                if     (not modelSceneWar:isEnded()) then -- do nothing.
                elseif (isReplay)                    then modelSceneWar:showEffectReplayEnd(callbackOnWarEndedForClient)
                elseif (isLoggedInPlayerLost)        then modelSceneWar:showEffectLose(     callbackOnWarEndedForClient)
                else                                      modelSceneWar:showEffectWin(      callbackOnWarEndedForClient)
                end

                modelSceneWar:setExecutingAction(false)
            end)
        end
    end
end

local function executeDestroyOwnedModelUnit(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)
    updateTilesAndUnitsBeforeExecutingAction(action, modelSceneWar)

    local gridIndex           = action.gridIndex
    local modelUnitMap        = getModelUnitMap(modelSceneWar)
    local isReplay            = isTotalReplay(modelSceneWar)
    local playerIndexActing   = getModelTurnManager(modelSceneWar):getPlayerIndex()
    local playerIndexLoggedIn = ((not IS_SERVER) and (not isReplay)) and (getPlayerIndexLoggedIn(modelSceneWar)) or (nil)

    if (gridIndex) then
        if ((IS_SERVER) or (isReplay) or (playerIndexActing == playerIndexLoggedIn)) then
            getModelFogMap(modelSceneWar):updateMapForPathsWithModelUnitAndPath(modelUnitMap:getModelUnit(gridIndex), {gridIndex})
        end
        destroyActorUnitOnMap(modelSceneWar, gridIndex, true)
    else
        assert((not IS_SERVER) and (not isReplay), "ActionExecutor-executeDestroyOwnedModelUnit() the gridIndex must exist on server or in replay.")
    end

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        modelSceneWar:setExecutingAction(false)
    else
        if (not isReplay) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end

        if (gridIndex) then
            getModelGridEffect(modelSceneWar):showAnimationExplosion(gridIndex)

            if (playerIndexActing == playerIndexLoggedIn) then
                for _, adjacentGridIndex in pairs(GridIndexFunctions.getAdjacentGrids(gridIndex, modelUnitMap:getMapSize())) do
                    local adjacentModelUnit = modelUnitMap:getModelUnit(adjacentGridIndex)
                    if ((adjacentModelUnit)                                                                                                                                                                     and
                        (not isUnitVisible(modelSceneWar, adjacentGridIndex, adjacentModelUnit:getUnitType(), isModelUnitDiving(adjacentModelUnit), adjacentModelUnit:getPlayerIndex(), playerIndexActing))) then
                        destroyActorUnitOnMap(modelSceneWar, adjacentGridIndex, true)
                    end
                end
            end
        end

        modelSceneWar:setExecutingAction(false)
    end
end

local function executeDive(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)
    updateTilesAndUnitsBeforeExecutingAction(action, modelSceneWar)

    local launchUnitID     = action.launchUnitID
    local pathNodes        = action.path.pathNodes
    local focusModelUnit   = getModelUnitMap(modelSceneWar):getFocusModelUnit(pathNodes[1], launchUnitID)
    moveModelUnitWithAction(action, modelSceneWar)
    focusModelUnit:setStateActioned()
        :setDiving(true)

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        modelSceneWar:setExecutingAction(false)
    else
        local isReplay = isTotalReplay(modelSceneWar)
        if (not isReplay) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end

        focusModelUnit:moveViewAlongPath(pathNodes, false, function()
            focusModelUnit:updateView()
                :showNormalAnimation()

            local endingGridIndex = pathNodes[#pathNodes]
            if (isReplay) then
                getModelGridEffect(modelSceneWar):showAnimationDive(endingGridIndex)
            else
                local playerIndexLoggedIn = getPlayerIndexLoggedIn(modelSceneWar)
                local unitType            = focusModelUnit:getUnitType()
                local playerIndexActing   = focusModelUnit:getPlayerIndex()
                focusModelUnit:setViewVisible(isUnitVisible(modelSceneWar, endingGridIndex, unitType, true, playerIndexActing, playerIndexLoggedIn))

                if (isUnitVisible(modelSceneWar, endingGridIndex, unitType, false, playerIndexActing, playerIndexLoggedIn)) then
                    getModelGridEffect(modelSceneWar):showAnimationDive(endingGridIndex)
                end
            end

            updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)

            modelSceneWar:setExecutingAction(false)
        end)
    end
end

local function executeDropModelUnit(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)
    updateTilesAndUnitsBeforeExecutingAction(action, modelSceneWar)

    local pathNodes        = action.path.pathNodes
    local modelUnitMap     = getModelUnitMap(modelSceneWar)
    local endingGridIndex  = pathNodes[#pathNodes]
    local focusModelUnit   = modelUnitMap:getFocusModelUnit(pathNodes[1], action.launchUnitID)
    moveModelUnitWithAction(action, modelSceneWar)
    focusModelUnit:setStateActioned()

    local isReplay           = isTotalReplay(modelSceneWar)
    local playerIndex        = focusModelUnit:getPlayerIndex()
    local shouldUpdateFogMap = (IS_SERVER) or (isReplay) or (playerIndex == getPlayerIndexLoggedIn(modelSceneWar))
    local modelFogMap        = getModelFogMap(modelSceneWar)
    local dropModelUnits     = {}
    for _, dropDestination in ipairs(action.dropDestinations) do
        local gridIndex     = dropDestination.gridIndex
        local unitID        = dropDestination.unitID
        local dropModelUnit = modelUnitMap:getLoadedModelUnitWithUnitId(unitID)
        modelUnitMap:setActorUnitUnloaded(unitID, gridIndex)
        focusModelUnit:removeLoadUnitId(unitID)

        dropModelUnits[#dropModelUnits + 1] = dropModelUnit
        dropModelUnit:setGridIndex(gridIndex, false)
            :setStateActioned()
        if (dropModelUnit.getLoadUnitIdList) then
            for _, loadedModelUnit in pairs(modelUnitMap:getLoadedModelUnitsWithLoader(dropModelUnit, true)) do
                loadedModelUnit:setGridIndex(gridIndex, false)
            end
        end

        if (shouldUpdateFogMap) then
            modelFogMap:updateMapForPathsWithModelUnitAndPath(dropModelUnit, {endingGridIndex, gridIndex})
                :updateMapForUnitsForPlayerIndexOnUnitArrive(playerIndex, gridIndex, dropModelUnit:getVisionForPlayerIndex(playerIndex))
        end
    end

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        modelSceneWar:setExecutingAction(false)
    else
        if (not isReplay) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end

        focusModelUnit:moveViewAlongPath(pathNodes, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()
            if (action.isDropBlocked) then
                getModelGridEffect(modelSceneWar):showAnimationBlock(endingGridIndex)
            end

            if (isReplay) then
                for _, dropModelUnit in ipairs(dropModelUnits) do
                    dropModelUnit:moveViewAlongPath({endingGridIndex, dropModelUnit:getGridIndex()}, isModelUnitDiving(dropModelUnit), function()
                        dropModelUnit:updateView()
                            :showNormalAnimation()
                    end)
                end
            else
                local playerIndexLoggedIn = getPlayerIndexLoggedIn(modelSceneWar)
                for _, dropModelUnit in ipairs(dropModelUnits) do
                    local isDiving  = isModelUnitDiving(dropModelUnit)
                    local gridIndex = dropModelUnit:getGridIndex()
                    local isVisible = isUnitVisible(modelSceneWar, gridIndex, dropModelUnit:getUnitType(), isDiving, playerIndex, playerIndexLoggedIn)
                    if (not isVisible) then
                        destroyActorUnitOnMap(modelSceneWar, gridIndex, false)
                    end

                    dropModelUnit:moveViewAlongPath({endingGridIndex, gridIndex}, isDiving, function()
                        dropModelUnit:updateView()
                            :showNormalAnimation()

                        if (not isVisible) then
                            dropModelUnit:removeViewFromParent()
                        end
                    end)
                end
            end

            updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)

            modelSceneWar:setExecutingAction(false)
        end)
    end
end

local function executeEndTurn(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)

    if ((not IS_SERVER) and (not isTotalReplay(modelSceneWar))) then
        cleanupOnReceivingResponseFromServer(modelSceneWar)
    end

    getModelTurnManager(modelSceneWar):endTurnPhaseMain()
    modelSceneWar:setExecutingAction(false)
end

local function executeJoinModelUnit(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)
    updateTilesAndUnitsBeforeExecutingAction(action, modelSceneWar)

    local launchUnitID     = action.launchUnitID
    local pathNodes        = action.path.pathNodes
    local endingGridIndex  = pathNodes[#pathNodes]
    local modelUnitMap     = getModelUnitMap(modelSceneWar)
    local focusModelUnit   = modelUnitMap:getFocusModelUnit(pathNodes[1], launchUnitID)
    local targetModelUnit  = modelUnitMap:getModelUnit(endingGridIndex)
    modelUnitMap:removeActorUnitOnMap(endingGridIndex)
    moveModelUnitWithAction(action, modelSceneWar)
    focusModelUnit:setStateActioned()

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
            local modelPlayer = getModelPlayerManager(modelSceneWar):getModelPlayer(playerIndex)
            modelPlayer:setFund(modelPlayer:getFund() + joinIncome)
            dispatchEvtModelPlayerUpdated(modelSceneWar, playerIndex)
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
    if (focusModelUnit.setCapturingModelTile) then
        focusModelUnit:setCapturingModelTile(targetModelUnit:isCapturingModelTile())
    end

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        modelSceneWar:setExecutingAction(false)
    else
        if (not isTotalReplay(modelSceneWar)) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end

        focusModelUnit:moveViewAlongPath(pathNodes, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()
            targetModelUnit:removeViewFromParent()

            updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)

            modelSceneWar:setExecutingAction(false)
        end)
    end
end

local function executeLaunchFlare(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)
    updateTilesAndUnitsBeforeExecutingAction(action, modelSceneWar)

    local pathNodes           = action.path.pathNodes
    local targetGridIndex     = action.targetGridIndex
    local modelUnitMap        = getModelUnitMap(modelSceneWar)
    local focusModelUnit      = modelUnitMap:getFocusModelUnit(pathNodes[1], action.launchUnitID)
    local playerIndexActing   = focusModelUnit:getPlayerIndex()
    local flareAreaRadius     = focusModelUnit:getFlareAreaRadius()
    moveModelUnitWithAction(action, modelSceneWar)
    focusModelUnit:setStateActioned()
        :setCurrentFlareAmmo(focusModelUnit:getCurrentFlareAmmo() - 1)

    local isReplay            = isTotalReplay(modelSceneWar)
    local playerIndexLoggedIn = ((not IS_SERVER) and (not isReplay)) and (getPlayerIndexLoggedIn(modelSceneWar)) or (nil)
    if ((IS_SERVER) or (isReplay) or (playerIndexActing == playerIndexLoggedIn)) then
        getModelFogMap(modelSceneWar):updateMapForPathsForPlayerIndexWithFlare(playerIndexActing, targetGridIndex, flareAreaRadius)
    end

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        modelSceneWar:setExecutingAction(false)
    else
        if (not isReplay) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end

        focusModelUnit:moveViewAlongPath(pathNodes, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()

            if ((isReplay) or (playerIndexActing == playerIndexLoggedIn)) then
                local modelGridEffect = getModelGridEffect(modelSceneWar)
                for _, gridIndex in pairs(getGridsWithinDistance(targetGridIndex, 0, flareAreaRadius, modelUnitMap:getMapSize())) do
                    modelGridEffect:showAnimationFlare(gridIndex)
                end
            end

            updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)

            modelSceneWar:setExecutingAction(false)
        end)
    end
end

local function executeLaunchSilo(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)
    updateTilesAndUnitsBeforeExecutingAction(action, modelSceneWar)

    local pathNodes      = action.path.pathNodes
    local modelUnitMap   = getModelUnitMap(modelSceneWar)
    local focusModelUnit = modelUnitMap:getFocusModelUnit(pathNodes[1], action.launchUnitID)
    local modelTile      = getModelTileMap(modelSceneWar):getModelTile(pathNodes[#pathNodes])
    local isReplay       = isTotalReplay(modelSceneWar)
    if ((not IS_SERVER) and (not isReplay) and (modelTile:isFogEnabledOnClient())) then
        modelTile:updateAsFogDisabled()
    end
    moveModelUnitWithAction(action, modelSceneWar)
    focusModelUnit:setStateActioned()
    modelTile:updateWithObjectAndBaseId(focusModelUnit:getTileObjectIdAfterLaunch())

    local targetGridIndexes, targetModelUnits = {}, {}
    for _, gridIndex in pairs(getGridsWithinDistance(action.targetGridIndex, 0, 2, modelUnitMap:getMapSize())) do
        targetGridIndexes[#targetGridIndexes + 1] = gridIndex

        local modelUnit = modelUnitMap:getModelUnit(gridIndex)
        if ((modelUnit) and (modelUnit.setCurrentHP)) then
            modelUnit:setCurrentHP(math.max(1, modelUnit:getCurrentHP() - 30))
            targetModelUnits[#targetModelUnits + 1] = modelUnit
        end
    end

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        modelSceneWar:setExecutingAction(false)
    else
        if (not isReplay) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end

        focusModelUnit:moveViewAlongPath(pathNodes, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()
            modelTile:updateView()
            for _, modelUnit in ipairs(targetModelUnits) do
                modelUnit:updateView()
            end

            local modelGridEffect = getModelGridEffect(modelSceneWar)
            for _, gridIndex in ipairs(targetGridIndexes) do
                modelGridEffect:showAnimationSiloAttack(gridIndex)
            end

            updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)

            modelSceneWar:setExecutingAction(false)
        end)
    end
end

local function executeLoadModelUnit(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)
    updateTilesAndUnitsBeforeExecutingAction(action, modelSceneWar)

    local pathNodes      = action.path.pathNodes
    local modelUnitMap   = getModelUnitMap(modelSceneWar)
    local focusModelUnit = modelUnitMap:getFocusModelUnit(pathNodes[1], action.launchUnitID)
    moveModelUnitWithAction(action, modelSceneWar)
    focusModelUnit:setStateActioned()

    local isReplay        = isTotalReplay(modelSceneWar)
    local loaderModelUnit = modelUnitMap:getModelUnit(pathNodes[#pathNodes])
    if (loaderModelUnit) then
        loaderModelUnit:addLoadUnitId(focusModelUnit:getUnitId())
    else
        assert((not IS_SERVER) and (not isReplay), "ActionExecutor-executeLoadModelUnit() failed to get the target loader on the server or in replay.")
    end

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        modelSceneWar:setExecutingAction(false)
    else
        if (not isReplay) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end

        focusModelUnit:moveViewAlongPath(pathNodes, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()
                :setViewVisible(false)
            if (loaderModelUnit) then
                loaderModelUnit:updateView()
            end

            updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)

            modelSceneWar:setExecutingAction(false)
        end)
    end
end

local function executeProduceModelUnitOnTile(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)
    updateTilesAndUnitsBeforeExecutingAction(action, modelSceneWar)

    local modelUnitMap     = getModelUnitMap(modelSceneWar)
    local producedUnitID   = modelUnitMap:getAvailableUnitId()
    local playerIndex      = getModelTurnManager(modelSceneWar):getPlayerIndex()

    if (action.tiledID) then
        local gridIndex         = action.gridIndex
        local producedActorUnit = produceActorUnit(modelSceneWar, action.tiledID, producedUnitID, gridIndex)
        modelUnitMap:addActorUnitOnMap(producedActorUnit)

        if ((IS_SERVER) or (isTotalReplay(modelSceneWar)) or (playerIndex == getPlayerIndexLoggedIn(modelSceneWar))) then
            getModelFogMap(modelSceneWar):updateMapForUnitsForPlayerIndexOnUnitArrive(playerIndex, gridIndex, producedActorUnit:getModel():getVisionForPlayerIndex(playerIndex))
        end
    end

    modelUnitMap:setAvailableUnitId(producedUnitID + 1)
    updateFundWithCost(modelSceneWar, playerIndex, action.cost)

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        modelSceneWar:setExecutingAction(false)
    else
        if (not isTotalReplay(modelSceneWar)) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end

        updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)

        modelSceneWar:setExecutingAction(false)
    end
end

local function executeProduceModelUnitOnUnit(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)
    updateTilesAndUnitsBeforeExecutingAction(action, modelSceneWar)

    local pathNodes    = action.path.pathNodes
    local modelUnitMap = getModelUnitMap(modelSceneWar)
    local producer     = modelUnitMap:getFocusModelUnit(pathNodes[1], action.launchUnitID)
    moveModelUnitWithAction(action, modelSceneWar)
    producer:setStateActioned()

    local producedUnitID    = modelUnitMap:getAvailableUnitId()
    local producedActorUnit = produceActorUnit(modelSceneWar, producer:getMovableProductionTiledId(), producedUnitID, pathNodes[#pathNodes])
    modelUnitMap:addActorUnitLoaded(producedActorUnit)
        :setAvailableUnitId(producedUnitID + 1)
    producer:addLoadUnitId(producedUnitID)
    if (producer.setCurrentMaterial) then
        producer:setCurrentMaterial(producer:getCurrentMaterial() - 1)
    end
    updateFundWithCost(modelSceneWar, producer:getPlayerIndex(), action.cost)

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        modelSceneWar:setExecutingAction(false)
    else
        if (not isTotalReplay(modelSceneWar)) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end

        producer:moveViewAlongPath(pathNodes, isModelUnitDiving(producer), function()
            producer:updateView()
                :showNormalAnimation()

            updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)

            modelSceneWar:setExecutingAction(false)
        end)
    end
end

local function executeSupplyModelUnit(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)
    updateTilesAndUnitsBeforeExecutingAction(action, modelSceneWar)

    local launchUnitID     = action.launchUnitID
    local pathNodes        = action.path.pathNodes
    local focusModelUnit   = getModelUnitMap(modelSceneWar):getFocusModelUnit(pathNodes[1], launchUnitID)
    moveModelUnitWithAction(action, modelSceneWar)
    focusModelUnit:setStateActioned()
    local targetModelUnits = getAndSupplyAdjacentModelUnits(modelSceneWar, pathNodes[#pathNodes], focusModelUnit:getPlayerIndex())

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        modelSceneWar:setExecutingAction(false)
    else
        if (not isTotalReplay(modelSceneWar)) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end

        focusModelUnit:moveViewAlongPath(pathNodes, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()

            local modelGridEffect = getModelGridEffect(modelSceneWar)
            for _, targetModelUnit in pairs(targetModelUnits) do
                targetModelUnit:updateView()
                modelGridEffect:showAnimationSupply(targetModelUnit:getGridIndex())
            end

            updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)

            modelSceneWar:setExecutingAction(false)
        end)
    end
end

local function executeSurface(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)
    updateTilesAndUnitsBeforeExecutingAction(action, modelSceneWar)

    local launchUnitID     = action.launchUnitID
    local pathNodes        = action.path.pathNodes
    local focusModelUnit   = getModelUnitMap(modelSceneWar):getFocusModelUnit(pathNodes[1], launchUnitID)
    moveModelUnitWithAction(action, modelSceneWar)
    focusModelUnit:setStateActioned()
        :setDiving(false)

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        modelSceneWar:setExecutingAction(false)
    else
        local isReplay = isTotalReplay(modelSceneWar)
        if (not isReplay) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end

        focusModelUnit:moveViewAlongPath(pathNodes, true, function()
            focusModelUnit:updateView()
                :showNormalAnimation()

            local endingGridIndex = pathNodes[#pathNodes]
            if (isReplay) then
                getModelGridEffect(modelSceneWar):showAnimationSurface(endingGridIndex)
            else
                local isVisible = isUnitVisible(modelSceneWar, endingGridIndex, focusModelUnit:getUnitType(), false, focusModelUnit:getPlayerIndex(), getPlayerIndexLoggedIn(modelSceneWar))
                focusModelUnit:setViewVisible(isVisible)
                if (isVisible) then
                    getModelGridEffect(modelSceneWar):showAnimationSurface(endingGridIndex)
                end
            end

            updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)

            modelSceneWar:setExecutingAction(false)
        end)
    end
end

local function executeSurrender(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)

    local modelPlayerManager = getModelPlayerManager(modelSceneWar)
    local modelTurnManager   = getModelTurnManager(modelSceneWar)
    local playerIndex        = modelTurnManager:getPlayerIndex()
    local modelPlayer        = modelPlayerManager:getModelPlayer(playerIndex)
    modelSceneWar:setRemainingVotesForDraw(nil)
    Destroyers.destroyPlayerForce(modelSceneWar, playerIndex)

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        if (modelPlayerManager:getAlivePlayersCount() <= 1) then
            modelSceneWar:setEnded(true)
        else
            modelTurnManager:endTurnPhaseMain()
        end
        modelSceneWar:setExecutingAction(false)
    else
        local isReplay = isTotalReplay(modelSceneWar)
        if (not isReplay) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end

        local isLoggedInPlayerLost = (not isReplay) and (modelPlayer:getAccount() == getLoggedInAccountAndPassword(modelSceneWar))
        if ((modelPlayerManager:getAlivePlayersCount() <= 1) or (isLoggedInPlayerLost)) then
            modelSceneWar:setEnded(true)
        end

        updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)
        getModelMessageIndicator(modelSceneWar):showMessage(getLocalizedText(74, "Surrender", modelPlayer:getNickname()))

        if (not modelSceneWar:isEnded()) then
            modelTurnManager:endTurnPhaseMain()
        elseif (isReplay) then
            modelSceneWar:showEffectReplayEnd(callbackOnWarEndedForClient)
        elseif (isLoggedInPlayerLost) then
            modelSceneWar:showEffectSurrender(callbackOnWarEndedForClient)
        else
            modelSceneWar:showEffectWin(callbackOnWarEndedForClient)
        end

        modelSceneWar:setExecutingAction(false)
    end
end

local function executeVoteForDraw(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)

    local doesAgree          = action.doesAgree
    local modelPlayerManager = getModelPlayerManager(modelSceneWar)
    local modelPlayer        = modelPlayerManager:getModelPlayer(getModelTurnManager(modelSceneWar):getPlayerIndex())
    if (not doesAgree) then
        modelSceneWar:setRemainingVotesForDraw(nil)
    else
        local remainingVotes = (modelSceneWar:getRemainingVotesForDraw() or modelPlayerManager:getAlivePlayersCount()) - 1
        modelSceneWar:setRemainingVotesForDraw(remainingVotes)
        if (remainingVotes == 0) then
            modelSceneWar:setEnded(true)
        end
    end
    modelPlayer:setVotedForDraw(true)

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        modelSceneWar:setExecutingAction(false)
    else
        if (not isTotalReplay(modelSceneWar)) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end

        if (not doesAgree) then
            getModelMessageIndicator(modelSceneWar):showMessage(getLocalizedText(74, "DisagreeDraw", modelPlayer:getNickname()))
        else
            local modelMessageIndicator = getModelMessageIndicator(modelSceneWar)
            modelMessageIndicator:showMessage(getLocalizedText(74, "AgreeDraw", modelPlayer:getNickname()))
            if (modelSceneWar:isEnded()) then
                modelMessageIndicator:showMessage(getLocalizedText(74, "EndWithDraw"))
            end
        end

        if     (not modelSceneWar:isEnded())   then -- do nothing.
        elseif (isTotalReplay(modelSceneWar)) then modelSceneWar:showEffectReplayEnd(  callbackOnWarEndedForClient)
        else                                        modelSceneWar:showEffectEndWithDraw(callbackOnWarEndedForClient)
        end

        modelSceneWar:setExecutingAction(false)
    end
end

local function executeWait(action, modelSceneWar)
    if (not modelSceneWar.isModelSceneWar) then
        return
    end
    modelSceneWar:setExecutingAction(true)
    updateTilesAndUnitsBeforeExecutingAction(action, modelSceneWar)

    local path             = action.path
    local pathNodes        = path.pathNodes
    local focusModelUnit   = getModelUnitMap(modelSceneWar):getFocusModelUnit(pathNodes[1], action.launchUnitID)
    moveModelUnitWithAction(action, modelSceneWar)
    focusModelUnit:setStateActioned()

    if ((IS_SERVER) or (modelSceneWar:isFastExecutingActions())) then
        modelSceneWar:setExecutingAction(false)
    else
        if (not isTotalReplay(modelSceneWar)) then
            cleanupOnReceivingResponseFromServer(modelSceneWar)
        end

        focusModelUnit:moveViewAlongPath(pathNodes, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()

            updateTileAndUnitMapOnVisibilityChanged(modelSceneWar)

            if (path.isBlocked) then
                getModelGridEffect(modelSceneWar):showAnimationBlock(pathNodes[#pathNodes])
            end

            modelSceneWar:setExecutingAction(false)
        end)
    end
end

--------------------------------------------------------------------------------
-- The public function.
--------------------------------------------------------------------------------
function ActionExecutor.execute(action, modelScene)
    local actionCode = action.actionCode
    assert(ActionCodeFunctions.getActionName(actionCode), "ActionExecutor.execute() invalid actionCode: " .. (actionCode or ""))

    if     (actionCode == ACTION_CODES.ActionDownloadReplayData)           then executeDownloadReplayData(          action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionExitWar)                      then executeExitWar(                     action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionGetJoinableWarConfigurations) then executeGetJoinableWarConfigurations(action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionGetOngoingWarConfigurations)  then executeGetOngoingWarConfigurations( action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionGetPlayerProfile)             then executeGetPlayerProfile(            action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionGetRankingList)               then executeGetRankingList(              action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionGetReplayConfigurations)      then executeGetReplayConfigurations(     action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionGetSkillConfiguration)        then executeGetSkillConfiguration(       action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionGetWaitingWarConfigurations)  then executeGetWaitingWarConfigurations( action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionJoinWar)                      then executeJoinWar(                     action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionLogin)                        then executeLogin(                       action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionLogout)                       then executeLogout(                      action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionMessage)                      then executeMessage(                     action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionNewWar)                       then executeNewWar(                      action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionRegister)                     then executeRegister(                    action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionReloadSceneWar)               then executeReloadSceneWar(              action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionRunSceneMain)                 then executeRunSceneMain(                action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionRunSceneWar)                  then executeRunSceneWar(                 action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionSetSkillConfiguration)        then executeSetSkillConfiguration(       action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionSyncSceneWar)                 then executeSyncSceneWar(                action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionActivateSkillGroup)           then executeActivateSkillGroup(          action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionAttack)                       then executeAttack(                      action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionBeginTurn)                    then executeBeginTurn(                   action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionBuildModelTile)               then executeBuildModelTile(              action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionCaptureModelTile)             then executeCaptureModelTile(            action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionDestroyOwnedModelUnit)        then executeDestroyOwnedModelUnit(       action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionDive)                         then executeDive(                        action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionDropModelUnit)                then executeDropModelUnit(               action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionEndTurn)                      then executeEndTurn(                     action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionJoinModelUnit)                then executeJoinModelUnit(               action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionLaunchFlare)                  then executeLaunchFlare(                 action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionLaunchSilo)                   then executeLaunchSilo(                  action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionLoadModelUnit)                then executeLoadModelUnit(               action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionProduceModelUnitOnTile)       then executeProduceModelUnitOnTile(      action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionProduceModelUnitOnUnit)       then executeProduceModelUnitOnUnit(      action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionSupplyModelUnit)              then executeSupplyModelUnit(             action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionSurface)                      then executeSurface(                     action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionSurrender)                    then executeSurrender(                   action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionVoteForDraw)                  then executeVoteForDraw(                 action, modelScene)
    elseif (actionCode == ACTION_CODES.ActionWait)                         then executeWait(                        action, modelScene)
    else                                                                        error("ActionExecutor.execute() invalid action: " .. SerializationFunctions.toString(action))
    end
end

return ActionExecutor
