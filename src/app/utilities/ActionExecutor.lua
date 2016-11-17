
local ActionExecutor = {}

local Destroyers             = require("src.app.utilities.Destroyers")
local GameConstantFunctions  = require("src.app.utilities.GameConstantFunctions")
local GridIndexFunctions     = require("src.app.utilities.GridIndexFunctions")
local InstantSkillExecutor   = require("src.app.utilities.InstantSkillExecutor")
local LocalizationFunctions  = require("src.app.utilities.LocalizationFunctions")
local SerializationFunctions = require("src.app.utilities.SerializationFunctions")
local SingletonGetters       = require("src.app.utilities.SingletonGetters")
local SkillModifierFunctions = require("src.app.utilities.SkillModifierFunctions")
local TableFunctions         = require("src.app.utilities.TableFunctions")
local VisibilityFunctions    = require("src.app.utilities.VisibilityFunctions")
local Actor                  = require("src.global.actors.Actor")

local UNIT_MAX_HP           = GameConstantFunctions.getUnitMaxHP()
local IS_SERVER             = GameConstantFunctions.isServer()
local WebSocketManager      = (not IS_SERVER) and (require("src.app.utilities.WebSocketManager")) or (nil)
local ActorManager          = (not IS_SERVER) and (require("src.global.actors.ActorManager"))     or (nil)

local appendList               = TableFunctions.appendList
local destroyActorUnitLoaded   = Destroyers.destroyActorUnitLoaded
local destroyActorUnitOnMap    = Destroyers.destroyActorUnitOnMap
local getAdjacentGrids         = GridIndexFunctions.getAdjacentGrids
local getGridsWithinDistance   = GridIndexFunctions.getGridsWithinDistance
local getLocalizedText         = LocalizationFunctions.getLocalizedText
local getModelFogMap           = SingletonGetters.getModelFogMap
local getModelGridEffect       = SingletonGetters.getModelGridEffect
local getModelMessageIndicator = SingletonGetters.getModelMessageIndicator
local getModelPlayerManager    = SingletonGetters.getModelPlayerManager
local getModelScene            = SingletonGetters.getModelScene
local getModelTileMap          = SingletonGetters.getModelTileMap
local getModelTurnManager      = SingletonGetters.getModelTurnManager
local getModelUnitMap          = SingletonGetters.getModelUnitMap
local getPlayerIndexLoggedIn   = SingletonGetters.getPlayerIndexLoggedIn
local getSceneWarFileName      = SingletonGetters.getSceneWarFileName
local getScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher
local isTileVisible            = VisibilityFunctions.isTileVisibleToPlayerIndex
local isUnitVisible            = VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex
local toErrorMessage           = SerializationFunctions.toErrorMessage

--------------------------------------------------------------------------------
-- The functions for dispatching events.
--------------------------------------------------------------------------------
local function dispatchEvtModelPlayerUpdated(sceneWarFileName, modelPlayer, playerIndex)
    getScriptEventDispatcher(sceneWarFileName):dispatchEvent({
        name        = "EvtModelPlayerUpdated",
        modelPlayer = modelPlayer,
        playerIndex = playerIndex,
    })
end

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
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
        actionName = "ReloadSceneWar",
        fileName   = getSceneWarFileName(),
    })
end

local function isModelUnitDiving(modelUnit)
    return (modelUnit.isDiving) and (modelUnit:isDiving())
end

local function promoteModelUnitOnProduce(modelUnit, sceneWarFileName)
    local modelPlayer = getModelPlayerManager(sceneWarFileName):getModelPlayer(modelUnit:getPlayerIndex())
    local modifier    = SkillModifierFunctions.getPassivePromotionModifier(modelPlayer:getModelSkillConfiguration())
    if ((modifier > 0) and (modelUnit.setCurrentPromotion)) then
        modelUnit:setCurrentPromotion(modifier)
    end
end

local function updateFundWithCost(sceneWarFileName, playerIndex, cost)
    local modelPlayer = getModelPlayerManager(sceneWarFileName):getModelPlayer(playerIndex)
    modelPlayer:setFund(modelPlayer:getFund() - cost)
    dispatchEvtModelPlayerUpdated(sceneWarFileName, modelPlayer, playerIndex)
end

local function produceActorUnit(sceneWarFileName, tiledID, unitID, gridIndex)
    local actorData = {
        tiledID       = tiledID,
        unitID        = unitID,
        GridIndexable = {gridIndex = gridIndex},
    }
    local actorUnit = Actor.createWithModelAndViewName("sceneWar.ModelUnit", actorData, "sceneWar.ViewUnit")
    local modelUnit = actorUnit:getModel()
    promoteModelUnitOnProduce(modelUnit, sceneWarFileName)
    modelUnit:setStateActioned()
        :onStartRunning(sceneWarFileName)

    return actorUnit
end

local function getAndSupplyAdjacentModelUnits(sceneWarFileName, supplierGridIndex, playerIndex)
    assert(type(playerIndex) == "number", "ActionExecutor-getAndSupplyAdjacentModelUnits() invalid playerIndex: " .. (playerIndex or ""))

    local modelUnitMap = getModelUnitMap(sceneWarFileName)
    local targets      = {}
    for _, adjacentGridIndex in pairs(getAdjacentGrids(supplierGridIndex, modelUnitMap:getMapSize())) do
        local target = modelUnitMap:getModelUnit(adjacentGridIndex)
        if ((target) and (target:getPlayerIndex() == playerIndex)) then
            local isSupplied = false
            if (target:getCurrentFuel() < target:getMaxFuel()) then
                target:setCurrentFuel(target:getMaxFuel())
                isSupplied = true
            end
            if ((target.hasPrimaryWeapon)                                                  and
                (target:hasPrimaryWeapon())                                                and
                (target:getPrimaryWeaponCurrentAmmo() < target:getPrimaryWeaponMaxAmmo())) then
                target:setPrimaryWeaponCurrentAmmo(target:getPrimaryWeaponMaxAmmo())
                isSupplied = true
            end
            if (isSupplied) then
                targets[#targets + 1] = target
            end
        end
    end

    return targets
end

local function addActorUnitsWithUnitsData(unitsData, isViewVisible)
    assert(not IS_SERVER, "Action-addActorUnitsWithUnitsData() this should not be called on the server.")
    if (unitsData) then
        local sceneWarFileName = getSceneWarFileName()
        local modelUnitMap     = getModelUnitMap()
        for unitID, unitData in pairs(unitsData) do
            local actorUnit = Actor.createWithModelAndViewName("sceneWar.ModelUnit", unitData, "sceneWar.ViewUnit")
            actorUnit:getModel():onStartRunning(sceneWarFileName)
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

local function updateModelTilesWithTilesData(tilesData)
    assert(not IS_SERVER, "ActionExecutor-updateModelTilesWithTilesData() this shouldn't be called on the server.")
    if (tilesData) then
        local modelTileMap = getModelTileMap()
        for _, tileData in pairs(tilesData) do
            local modelTile = modelTileMap:getModelTile(tileData.GridIndexable.gridIndex)
            assert(modelTile:isFogEnabledOnClient(), "ActionExecutor-updateModelTilesWithTilesData() the tile has no fog.")
            modelTile:updateAsFogDisabled(tileData)
        end
    end
end

local function updateTileAndUnitMapOnVisibilityChanged()
    assert(not IS_SERVER, "ActionExecutor-updateTileAndUnitMapOnVisibilityChanged() this shouldn't be called on the server.")
    local sceneWarFileName = getSceneWarFileName()
    local playerIndex      = getPlayerIndexLoggedIn()
    getModelTileMap():forEachModelTile(function(modelTile)
        if (isTileVisible(sceneWarFileName, modelTile:getGridIndex(), playerIndex)) then
            modelTile:updateAsFogDisabled()
        else
            modelTile:updateAsFogEnabled()
        end
        modelTile:updateView()
    end)
    getModelUnitMap():forEachModelUnitOnMap(function(modelUnit)
        local gridIndex = modelUnit:getGridIndex()
        if (isUnitVisible(sceneWarFileName, gridIndex, modelUnit:getUnitType(), isModelUnitDiving(modelUnit), modelUnit:getPlayerIndex(), playerIndex)) then
            modelUnit:setViewVisible(true)
        else
            destroyActorUnitOnMap(sceneWarFileName, gridIndex, true)
        end
    end)
end

local function updateTilesAndUnitsBeforeExecutingAction(action)
    if (not IS_SERVER) then
        addActorUnitsWithUnitsData(action.actingUnitsData, false)
        addActorUnitsWithUnitsData(action.revealedUnits,   false)
        updateModelTilesWithTilesData(action.actingTilesData, false)
        updateModelTilesWithTilesData(action.revealedTiles,   false)
    end
end

local function removeHiddenActorUnitsAfterAction(action)
    -- 本函数负责处理移动所引起的单位隐藏。某些action可能引起额外的单位隐藏（如attack可能涉及单位的损毁并引起视野变化），约定它们各自的处理函数已经处理了这些额外的单位隐藏。
    assert(not IS_SERVER, "ActionExecutor-removeHiddenActorUnitsAfterAction() this should not be called on the server.")
    local path                = action.path
    assert(path, "ActionExecutor-removeHiddenActorUnitsAfterAction() action.path is expected.")
    local launchUnitID        = action.launchUnitID
    local sceneWarFileName    = getSceneWarFileName()
    local modelUnitMap        = getModelUnitMap()
    local playerIndexActing   = getModelTurnManager():getPlayerIndex()
    local playerIndexLoggedIn = getPlayerIndexLoggedIn()

    if (playerIndexLoggedIn == playerIndexActing) then
        -- 登录的玩家是行动玩家，那么需要清除行动单位在行动前可见、行动后不可见的部队。这些部队只可能在行动单位移动前的位置的四个临近格子中。
        if (launchUnitID) then
            -- 有部队被弹射，则装载者还留在原地，因此不会有部队需要隐藏，因此直接返回。
            return {}
        else
            -- 没有部队被弹射，则行动部队可能离开了其原先所在的位置，由此可能导致行动前紧邻的部队变为不可见。因此需要轮询这几个格子。
            local removedModelUnits = {}
            for _, adjacentGridIndex in ipairs(getAdjacentGrids(path[1], modelUnitMap:getMapSize())) do
                local adjacentModelUnit = modelUnitMap:getModelUnit(adjacentGridIndex)
                if ((adjacentModelUnit)                                                                                                                                      and
                    (not isUnitVisible(sceneWarFileName, adjacentGridIndex, adjacentModelUnit:getUnitType(), isModelUnitDiving(adjacentModelUnit), adjacentModelUnit:getPlayerIndex(), playerIndexLoggedIn))) then
                    appendList(removedModelUnits, destroyActorUnitOnMap(sceneWarFileName, adjacentGridIndex, false))
                end
            end
            return removedModelUnits
        end
    else
        -- 登录的玩家不是行动玩家，那么唯一可能需要隐藏的就是行动单位本身。
        local endingGridIndex = path[#path]
        local modelUnit       = modelUnitMap:getFocusModelUnit(endingGridIndex, launchUnitID)
        if (not modelUnit) then
            -- 无法找到行动部队，则唯一可能性是行动部队被消灭了（主动发起进攻并被反击摧毁）。直接返回即可。
            assert(action.actionName == "Attack", "ActionExecutor-removeHiddenActorUnitsAfterAction() action Attack expected.")
            return {}
        elseif (isUnitVisible(sceneWarFileName, endingGridIndex, modelUnit:getUnitType(), isModelUnitDiving(modelUnit), playerIndexActing, playerIndexLoggedIn)) then
            -- 该部队可见，所以直接返回即可。
            return {}
        elseif (modelUnitMap:getModelUnit(endingGridIndex)) then
            return destroyActorUnitOnMap(sceneWarFileName, endingGridIndex, false)
        else
            return destroyActorUnitLoaded(sceneWarFileName, launchUnitID, false)
        end
    end
end

local function removeViewUnits(modelUnits)
    assert(not IS_SERVER, "ActionExecutor-removeViewUnits() this should not be called on the server.")
    if (modelUnits) then
        for _, modelUnit in pairs(modelUnits) do
            modelUnit:removeViewFromParent()
        end
    end
end

local function moveModelUnitWithAction(action)
    local path               = action.path
    local sceneWarFileName   = action.fileName
    local beginningGridIndex = path[1]
    local modelFogMap        = getModelFogMap(sceneWarFileName)
    local modelUnitMap       = getModelUnitMap(sceneWarFileName)
    local launchUnitID       = action.launchUnitID
    local focusModelUnit     = modelUnitMap:getFocusModelUnit(beginningGridIndex, launchUnitID)
    local playerIndex        = focusModelUnit:getPlayerIndex()
    local shouldUpdateFogMap = (IS_SERVER) or (playerIndex == getPlayerIndexLoggedIn())
    if (shouldUpdateFogMap) then
        modelFogMap:updateMapForPathsWithModelUnitAndPath(focusModelUnit, path)
    end

    local pathLength = #path
    if (pathLength <= 1) then
        return
    end

    local actionName         = action.actionName
    local endingGridIndex    = path[pathLength]
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
    if ((shouldUpdateFogMap) and (actionName ~= "LoadModelUnit")) then
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

        if (actionName ~= "LoadModelUnit") then
            modelUnitMap:setActorUnitUnloaded(launchUnitID, endingGridIndex)
        end
    else
        if (actionName == "LoadModelUnit") then
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
    runSceneMain({isPlayerLoggedIn = true}, WebSocketManager.getLoggedInAccountAndPassword())
end

--------------------------------------------------------------------------------
-- The private executors.
--------------------------------------------------------------------------------
local function executeLogout(action)
    assert(not IS_SERVER, "ActionExecutor-executeLogout() should not be invoked on the server.")
    runSceneMain({confirmText = action.message})
end

local function executeError(action)
    assert(not IS_SERVER, "ActionExecutor-executeError() should not be invoked on the server.")
    error("ActionExecutor-executeError() " .. (action.error or ""))
end

local function executeMessage(action)
    assert(not IS_SERVER, "ActionExecutor-executeMessage() should not be invoked on the server.")
    getModelMessageIndicator():showMessage(action.message)
end

local function executeGetSceneWarActionId(action)
    assert(not IS_SERVER, "ActionExecutor-executeGetSceneWarActionId() should not be invoked on the server.")
    local actionID = action.sceneWarActionID
    if (not actionID) then
        runSceneMain({
            isPlayerLoggedIn = true,
            confirmText      = getLocalizedText(81, "InvalidWarFileName"),
        }, WebSocketManager.getLoggedInAccountAndPassword())
    elseif (actionID > getModelScene():getActionId()) then
        requestReloadSceneWar(getLocalizedText(81, "OutOfSync"))
    end
end

local function executeGetSceneWarData(action)
    -- The "GetSceneWarData" action is now ignored when a war scene is running. Use the "ReloadSceneWar" action instead.
end

local function executeReloadSceneWar(action)
    assert(not IS_SERVER, "ActionExecutor-executeReloadSceneWar() should not be invoked on the server.")
    if (action.data.actionID >= getModelScene():getActionId()) then
        if (action.message) then
            getModelMessageIndicator():showPersistentMessage(action.message)
        end

        local actorSceneWar = Actor.createWithModelAndViewName("sceneWar.ModelSceneWar", action.data, "sceneWar.ViewSceneWar")
        ActorManager.setAndRunRootActor(actorSceneWar, "FADE", 1)
    end
end

local function executeRunSceneMain(action)
    assert(not IS_SERVER, "ActionExecutor-executeRunSceneMain() should not be invoked on the server.")
    local param = {
        isPlayerLoggedIn = true,
        confirmText      = action.message,
    }
    runSceneMain(param, WebSocketManager.getLoggedInAccountAndPassword())
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

    if (not IS_SERVER) then
        local modelGridEffect = getModelGridEffect()
        local func = function(modelUnit)
            if (modelUnit:getPlayerIndex() == playerIndex) then
                modelGridEffect:showAnimationSkillActivation(modelUnit:getGridIndex())
                modelUnit:updateView()
            end
        end
        getModelUnitMap(sceneWarFileName):forEachModelUnitOnMap(func)
            :forEachModelUnitLoaded(func)
    end

    dispatchEvtModelPlayerUpdated(sceneWarFileName, modelPlayer, playerIndex)
    getModelScene(sceneWarFileName):setExecutingAction(false)
end

local function executeAttack(action)
    updateTilesAndUnitsBeforeExecutingAction(action)

    local path                = action.path
    local sceneWarFileName    = action.fileName
    local attackDamage        = action.attackDamage
    local counterDamage       = action.counterDamage
    local attackerGridIndex   = path[#path]
    local targetGridIndex     = action.targetGridIndex
    local modelUnitMap        = getModelUnitMap(sceneWarFileName)
    local modelTileMap        = getModelTileMap(sceneWarFileName)
    local attacker            = modelUnitMap:getFocusModelUnit(path[1], action.launchUnitID)
    local attackTarget        = modelUnitMap:getModelUnit(targetGridIndex) or modelTileMap:getModelTile(targetGridIndex)
    local attackerPlayerIndex = attacker:getPlayerIndex()
    local targetPlayerIndex   = attackTarget:getPlayerIndex()
    moveModelUnitWithAction(action)
    attacker:setStateActioned()

    if (attacker:getPrimaryWeaponBaseDamage(attackTarget:getDefenseType())) then
        attacker:setPrimaryWeaponCurrentAmmo(attacker:getPrimaryWeaponCurrentAmmo() - 1)
    end
    if ((counterDamage) and (attackTarget:getPrimaryWeaponBaseDamage(attacker:getDefenseType()))) then
        attackTarget:setPrimaryWeaponCurrentAmmo(attackTarget:getPrimaryWeaponCurrentAmmo() - 1)
    end

    local modelPlayerManager = getModelPlayerManager(sceneWarFileName)
    if (attackTarget.getUnitType) then
        local attackerDamageCost  = getBaseDamageCostWithTargetAndDamage(attacker,     counterDamage or 0)
        local targetDamageCost    = getBaseDamageCostWithTargetAndDamage(attackTarget, attackDamage)
        local attackerModelPlayer = modelPlayerManager:getModelPlayer(attackerPlayerIndex)
        local targetModelPlayer   = modelPlayerManager:getModelPlayer(targetPlayerIndex)

        attackerModelPlayer:addDamageCost(getSkillModifiedDamageCost(attackerDamageCost * 2 + targetDamageCost,     attackerModelPlayer))
        targetModelPlayer  :addDamageCost(getSkillModifiedDamageCost(attackerDamageCost     + targetDamageCost * 2, targetModelPlayer))
        attackerModelPlayer:setFund(attackerModelPlayer:getFund() + getIncomeWithDamageCost(targetDamageCost,   attackerModelPlayer))
        targetModelPlayer  :setFund(targetModelPlayer  :getFund() + getIncomeWithDamageCost(attackerDamageCost, targetModelPlayer))

        dispatchEvtModelPlayerUpdated(sceneWarFileName, attackerModelPlayer, attackerPlayerIndex)
    end

    local attackerNewHP = math.max(0, attacker:getCurrentHP() - (counterDamage or 0))
    attacker:setCurrentHP(attackerNewHP)
    if (attackerNewHP == 0) then
        attackTarget:setCurrentPromotion(math.min(attackTarget:getMaxPromotion(), attackTarget:getCurrentPromotion() + 1))
        destroyActorUnitOnMap(sceneWarFileName, attackerGridIndex, false)
    end

    local targetNewHP = math.max(0, attackTarget:getCurrentHP() - attackDamage)
    local targetVision, plasmaGridIndexes
    attackTarget:setCurrentHP(targetNewHP)
    if (targetNewHP == 0) then
        if (attackTarget.getUnitType) then
            targetVision = attackTarget:getVisionForPlayerIndex(targetPlayerIndex)

            attacker:setCurrentPromotion(math.min(attacker:getMaxPromotion(), attacker:getCurrentPromotion() + 1))
            destroyActorUnitOnMap(sceneWarFileName, targetGridIndex, false, true)
        else
            attackTarget:updateWithObjectAndBaseId(0)
            plasmaGridIndexes = getAdjacentPlasmaGridIndexes(targetGridIndex, modelTileMap)
            for _, gridIndex in ipairs(plasmaGridIndexes) do
                modelTileMap:getModelTile(gridIndex):updateWithObjectAndBaseId(0)
            end
        end
    end

    local modelSceneWar      = getModelScene(sceneWarFileName)
    local modelTurnManager   = getModelTurnManager(sceneWarFileName)
    local lostPlayerIndex    = action.lostPlayerIndex
    local isInTurnPlayerLost = (lostPlayerIndex == attackerPlayerIndex)
    if (IS_SERVER) then
        if (not lostPlayerIndex) then
            if (targetVision) then
                getModelFogMap(sceneWarFileName):updateMapForUnitsForPlayerIndexOnUnitLeave(targetPlayerIndex, targetGridIndex, targetVision)
            end
        else
            Destroyers.destroyPlayerForce(sceneWarFileName, lostPlayerIndex)
            if (modelPlayerManager:getAlivePlayersCount() <= 1) then
                modelSceneWar:setEnded(true)
            elseif (isInTurnPlayerLost) then
                modelTurnManager:endTurnPhaseMain()
            end
        end
        modelSceneWar:setExecutingAction(false)
    else
        local playerIndexLoggedIn = getPlayerIndexLoggedIn()
        local callbackAfterMoveAnimation = function()
            attacker:updateView()
                :showNormalAnimation()
            attackTarget:updateView()
            if (attackerNewHP == 0) then
                attacker:removeViewFromParent()
            elseif ((targetNewHP == 0) and (attackTarget.getUnitType)) then
                attackTarget:removeViewFromParent()
            end

            if ((targetVision) and (targetPlayerIndex == playerIndexLoggedIn) and (not lostPlayerIndex)) then
                getModelFogMap(sceneWarFileName):updateMapForUnitsForPlayerIndexOnUnitLeave(targetPlayerIndex, targetGridIndex, targetVision)
            end
            updateTileAndUnitMapOnVisibilityChanged()

            local modelGridEffect = getModelGridEffect()
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
        end

        if (not lostPlayerIndex) then
            attacker:moveViewAlongPathAndFocusOnTarget(path, isModelUnitDiving(attacker), targetGridIndex, function()
                callbackAfterMoveAnimation()
                modelSceneWar:setExecutingAction(false)
            end)
        else
            local lostModelPlayer      = modelPlayerManager:getModelPlayer(lostPlayerIndex)
            local isLoggedInPlayerLost = (lostPlayerIndex == playerIndexLoggedIn)
            modelSceneWar:setEnded((isLoggedInPlayerLost) or (modelPlayerManager:getAlivePlayersCount() <= 2))

            attacker:moveViewAlongPathAndFocusOnTarget(path, isModelUnitDiving(attacker), targetGridIndex, function()
                Destroyers.destroyPlayerForce(sceneWarFileName, lostPlayerIndex)
                callbackAfterMoveAnimation()

                getModelMessageIndicator():showMessage(getLocalizedText(76, lostModelPlayer:getNickname()))

                if (isLoggedInPlayerLost) then
                    modelSceneWar:showEffectLose(callbackOnWarEndedForClient)
                elseif (modelSceneWar:isEnded()) then
                    modelSceneWar:showEffectWin(callbackOnWarEndedForClient)
                elseif (isInTurnPlayerLost) then
                    modelTurnManager:endTurnPhaseMain()
                end

                modelSceneWar:setExecutingAction(false)
            end)
        end
    end
end

local function executeBeginTurn(action)
    local sceneWarFileName   = action.fileName
    local modelSceneWar      = getModelScene(sceneWarFileName)
    local modelTurnManager   = getModelTurnManager(sceneWarFileName)
    local lostPlayerIndex    = action.lostPlayerIndex
    local modelPlayerManager = getModelPlayerManager(sceneWarFileName)

    if (IS_SERVER) then
        if (not lostPlayerIndex) then
            modelTurnManager:beginTurnPhaseBeginning(action.income, action.repairData, function()
                modelSceneWar:setExecutingAction(false)
            end)
        else
            modelSceneWar:setEnded(modelPlayerManager:getAlivePlayersCount() <= 2)
            modelTurnManager:beginTurnPhaseBeginning(action.income, action.repairData, function()
                Destroyers.destroyPlayerForce(sceneWarFileName, lostPlayerIndex)
                if (not modelSceneWar:isEnded()) then
                    modelTurnManager:endTurnPhaseMain()
                end
                modelSceneWar:setExecutingAction(false)
            end)
        end
    else
        if (not lostPlayerIndex) then
            modelTurnManager:beginTurnPhaseBeginning(action.income, action.repairData, function()
                modelSceneWar:setExecutingAction(false)
            end)
        else
            local lostModelPlayer      = modelPlayerManager:getModelPlayer(lostPlayerIndex)
            local isLoggedInPlayerLost = lostModelPlayer:getAccount() == WebSocketManager.getLoggedInAccountAndPassword()
            modelSceneWar:setEnded((isLoggedInPlayerLost) or (modelPlayerManager:getAlivePlayersCount() <= 2))
            modelTurnManager:beginTurnPhaseBeginning(action.income, action.repairData, function()
                getModelMessageIndicator(sceneWarFileName):showMessage(getLocalizedText(76, lostModelPlayer:getNickname()))
                Destroyers.destroyPlayerForce(sceneWarFileName, lostPlayerIndex)

                if (isLoggedInPlayerLost) then
                    modelSceneWar:showEffectLose(callbackOnWarEndedForClient)
                elseif (modelSceneWar:isEnded()) then
                    modelSceneWar:showEffectWin(callbackOnWarEndedForClient)
                else
                    modelTurnManager:endTurnPhaseMain()
                end
                modelSceneWar:setExecutingAction(false)
            end)
        end
    end
end

local function executeBuildModelTile(action)
    updateTilesAndUnitsBeforeExecutingAction(action)

    local path             = action.path
    local sceneWarFileName = action.fileName
    local endingGridIndex  = path[#path]
    local focusModelUnit   = getModelUnitMap(sceneWarFileName):getFocusModelUnit(path[1], action.launchUnitID)
    local modelTile        = getModelTileMap(sceneWarFileName):getModelTile(endingGridIndex)
    local buildPoint       = modelTile:getCurrentBuildPoint() - focusModelUnit:getBuildAmount()
    if ((not IS_SERVER) and (modelTile:isFogEnabledOnClient())) then
        modelTile:updateAsFogDisabled()
    end
    moveModelUnitWithAction(action)
    focusModelUnit:setStateActioned()

    if (buildPoint > 0) then
        focusModelUnit:setBuildingModelTile(true)
        modelTile:setCurrentBuildPoint(buildPoint)
    else
        focusModelUnit:setBuildingModelTile(false)
            :setCurrentMaterial(focusModelUnit:getCurrentMaterial() - 1)
        modelTile:updateWithObjectAndBaseId(focusModelUnit:getBuildTiledIdWithTileType(modelTile:getTileType()))

        local playerIndex = focusModelUnit:getPlayerIndex()
        if ((IS_SERVER) or (playerIndex == getPlayerIndexLoggedIn())) then
            getModelFogMap(sceneWarFileName):updateMapForTilesForPlayerIndexOnGettingOwnership(playerIndex, endingGridIndex, modelTile:getVisionForPlayerIndex(playerIndex))
        end
    end

    if (IS_SERVER) then
        getModelScene(sceneWarFileName):setExecutingAction(false)
    else
        focusModelUnit:moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()

            updateTileAndUnitMapOnVisibilityChanged()

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
    end
end

local function executeCaptureModelTile(action)
    updateTilesAndUnitsBeforeExecutingAction(action)

    local path                = action.path
    local sceneWarFileName    = action.fileName
    local endingGridIndex     = path[#path]
    local modelTile           = getModelTileMap(sceneWarFileName):getModelTile(endingGridIndex)
    local playerIndexLoggedIn = (not IS_SERVER) and (getPlayerIndexLoggedIn()) or (nil)
    local focusModelUnit      = getModelUnitMap(sceneWarFileName):getFocusModelUnit(path[1], action.launchUnitID)
    local capturePoint        = modelTile:getCurrentCapturePoint() - focusModelUnit:getCaptureAmount()
    local modelFogMap, previousVision, previousPlayerIndex
    if ((not IS_SERVER) and (modelTile:isFogEnabledOnClient())) then
        modelTile:updateAsFogDisabled()
    end
    moveModelUnitWithAction(action)
    focusModelUnit:setStateActioned()

    if (capturePoint > 0) then
        focusModelUnit:setCapturingModelTile(true)
        modelTile:setCurrentCapturePoint(capturePoint)
    else
        modelFogMap         = getModelFogMap(sceneWarFileName)
        previousPlayerIndex = modelTile:getPlayerIndex()
        previousVision      = (previousPlayerIndex > 0) and (modelTile:getVisionForPlayerIndex(previousPlayerIndex)) or (nil)

        local playerIndexActing = focusModelUnit:getPlayerIndex()
        focusModelUnit:setCapturingModelTile(false)
        modelTile:setCurrentCapturePoint(modelTile:getMaxCapturePoint())
            :updateWithPlayerIndex(playerIndexActing)

        if ((IS_SERVER) or (playerIndexActing == playerIndexLoggedIn)) then
            modelFogMap:updateMapForTilesForPlayerIndexOnGettingOwnership(playerIndexActing, endingGridIndex, modelTile:getVisionForPlayerIndex(playerIndexActing))
        end
    end

    local modelSceneWar      = getModelScene(sceneWarFileName)
    local modelPlayerManager = getModelPlayerManager(sceneWarFileName)
    local lostPlayerIndex    = action.lostPlayerIndex
    if (IS_SERVER) then
        if (previousVision) then
            modelFogMap:updateMapForTilesForPlayerIndexOnLosingOwnership(previousPlayerIndex, endingGridIndex, previousVision)
        end
        if (lostPlayerIndex) then
            Destroyers.destroyPlayerForce(sceneWarFileName, lostPlayerIndex)
            modelSceneWar:setEnded(modelPlayerManager:getAlivePlayersCount() < 2)
        end
        modelSceneWar:setExecutingAction(false)
    else
        if (not lostPlayerIndex) then
            focusModelUnit:moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
                focusModelUnit:updateView()
                    :showNormalAnimation()

                if (previousPlayerIndex == playerIndexLoggedIn) then
                    modelFogMap:updateMapForTilesForPlayerIndexOnLosingOwnership(previousPlayerIndex, endingGridIndex, previousVision)
                end
                updateTileAndUnitMapOnVisibilityChanged()

                modelSceneWar:setExecutingAction(false)
            end)
        else
            local lostModelPlayer      = modelPlayerManager:getModelPlayer(lostPlayerIndex)
            local isLoggedInPlayerLost = lostModelPlayer:getAccount() == WebSocketManager.getLoggedInAccountAndPassword()
            modelSceneWar:setEnded((isLoggedInPlayerLost) or (modelPlayerManager:getAlivePlayersCount() <= 2))

            focusModelUnit:moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
                focusModelUnit:updateView()
                    :showNormalAnimation()

                getModelMessageIndicator(sceneWarFileName):showMessage(getLocalizedText(76, lostModelPlayer:getNickname()))
                Destroyers.destroyPlayerForce(sceneWarFileName, lostPlayerIndex)

                if (isLoggedInPlayerLost) then
                    modelSceneWar:showEffectLose(callbackOnWarEndedForClient)
                elseif (modelSceneWar:isEnded()) then
                    modelSceneWar:showEffectWin(callbackOnWarEndedForClient)
                end

                updateTileAndUnitMapOnVisibilityChanged()

                modelSceneWar:setExecutingAction(false)
            end)
        end
    end
end

local function executeDive(action)
    updateTilesAndUnitsBeforeExecutingAction(action)

    local sceneWarFileName = action.fileName
    local launchUnitID     = action.launchUnitID
    local path             = action.path
    local focusModelUnit   = getModelUnitMap(sceneWarFileName):getFocusModelUnit(path[1], launchUnitID)
    moveModelUnitWithAction(action)
    focusModelUnit:setStateActioned()
        :setDiving(true)

    if (IS_SERVER) then
        getModelScene(sceneWarFileName):setExecutingAction(false)
    else
        focusModelUnit:moveViewAlongPath(path, false, function()
            local endingGridIndex = path[#path]
            local isVisible       =
            focusModelUnit:updateView()
                :showNormalAnimation()
                :setViewVisible(isUnitVisible(sceneWarFileName, endingGridIndex, focusModelUnit:getUnitType(), true, focusModelUnit:getPlayerIndex(), getPlayerIndexLoggedIn()))

            if (isUnitVisible(sceneWarFileName, endingGridIndex, focusModelUnit:getUnitType(), false, focusModelUnit:getPlayerIndex(), getPlayerIndexLoggedIn())) then
                getModelGridEffect():showAnimationDive(endingGridIndex)
            end

            updateTileAndUnitMapOnVisibilityChanged()

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
    end
end

local function executeDropModelUnit(action)
    updateTilesAndUnitsBeforeExecutingAction(action)

    local path             = action.path
    local sceneWarFileName = action.fileName
    local modelUnitMap     = getModelUnitMap(sceneWarFileName)
    local endingGridIndex  = path[#path]
    local focusModelUnit   = modelUnitMap:getFocusModelUnit(path[1], action.launchUnitID)
    moveModelUnitWithAction(action)
    focusModelUnit:setStateActioned()

    local playerIndex        = focusModelUnit:getPlayerIndex()
    local shouldUpdateFogMap = (IS_SERVER) or (playerIndex == getPlayerIndexLoggedIn())
    local modelFogMap        = getModelFogMap(sceneWarFileName)
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

    if (IS_SERVER) then
        getModelScene(sceneWarFileName):setExecutingAction(false)
    else
        focusModelUnit:moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()

            local playerIndexLoggedIn = getPlayerIndexLoggedIn()
            for _, dropModelUnit in ipairs(dropModelUnits) do
                local isDiving  = isModelUnitDiving(dropModelUnit)
                local gridIndex = dropModelUnit:getGridIndex()
                local isVisible = isUnitVisible(sceneWarFileName, gridIndex, dropModelUnit:getUnitType(), isDiving, playerIndex, playerIndexLoggedIn)
                if (not isVisible) then
                    destroyActorUnitOnMap(sceneWarFileName, gridIndex, false)
                end

                dropModelUnit:moveViewAlongPath({endingGridIndex, gridIndex}, isDiving, function()
                    dropModelUnit:updateView()
                        :showNormalAnimation()

                    if (not isVisible) then
                        dropModelUnit:removeViewFromParent()
                    end
                end)
            end

            updateTileAndUnitMapOnVisibilityChanged()

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
    end
end

local function executeEndTurn(action)
    local sceneWarFileName = action.fileName
    getModelTurnManager(sceneWarFileName):endTurnPhaseMain()
    getModelScene(sceneWarFileName):setExecutingAction(false)
end

local function executeJoinModelUnit(action)
    updateTilesAndUnitsBeforeExecutingAction(action)

    local sceneWarFileName = action.fileName
    local launchUnitID     = action.launchUnitID
    local path             = action.path
    local endingGridIndex  = path[#path]
    local modelUnitMap     = getModelUnitMap(sceneWarFileName)
    local focusModelUnit   = modelUnitMap:getFocusModelUnit(path[1], launchUnitID)
    local targetModelUnit  = modelUnitMap:getModelUnit(endingGridIndex)
    modelUnitMap:removeActorUnitOnMap(endingGridIndex)
    moveModelUnitWithAction(action)
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
    if (focusModelUnit.setCapturingModelTile) then
        focusModelUnit:setCapturingModelTile(targetModelUnit:isCapturingModelTile())
    end

    if (IS_SERVER) then
        getModelScene(sceneWarFileName):setExecutingAction(false)
    else
        focusModelUnit:moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()
            targetModelUnit:removeViewFromParent()

            updateTileAndUnitMapOnVisibilityChanged()

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
    end
end

local function executeLaunchFlare(action)
    updateTilesAndUnitsBeforeExecutingAction(action)

    local path                = action.path
    local sceneWarFileName    = action.fileName
    local targetGridIndex     = action.targetGridIndex
    local modelUnitMap        = getModelUnitMap(sceneWarFileName)
    local focusModelUnit      = modelUnitMap:getFocusModelUnit(path[1], action.launchUnitID)
    local playerIndexActing   = focusModelUnit:getPlayerIndex()
    local flareAreaRadius     = focusModelUnit:getFlareAreaRadius()
    local playerIndexLoggedIn = (not IS_SERVER) and (getPlayerIndexLoggedIn()) or (nil)
    moveModelUnitWithAction(action)
    focusModelUnit:setStateActioned()
        :setCurrentFlareAmmo(focusModelUnit:getCurrentFlareAmmo() - 1)

    if ((IS_SERVER) or (playerIndexActing == playerIndexLoggedIn)) then
        getModelFogMap(sceneWarFileName):updateMapForPathsForPlayerIndexWithFlare(playerIndexActing, targetGridIndex, flareAreaRadius)
    end

    if (IS_SERVER) then
        getModelScene(sceneWarFileName):setExecutingAction(false)
    else
        focusModelUnit:moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()

            if (playerIndexActing == playerIndexLoggedIn) then
                local modelGridEffect = getModelGridEffect()
                for _, gridIndex in pairs(getGridsWithinDistance(targetGridIndex, 0, flareAreaRadius, modelUnitMap:getMapSize())) do
                    modelGridEffect:showAnimationFlare(gridIndex)
                end
            end

            updateTileAndUnitMapOnVisibilityChanged()

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
    end
end

local function executeLaunchSilo(action)
    updateTilesAndUnitsBeforeExecutingAction(action)

    local path              = action.path
    local sceneWarFileName  = action.fileName
    local modelUnitMap      = getModelUnitMap(sceneWarFileName)
    local focusModelUnit    = modelUnitMap:getFocusModelUnit(path[1], action.launchUnitID)
    local modelTile         = getModelTileMap(sceneWarFileName):getModelTile(path[#path])
    local targetModelUnits  = {}
    local targetGridIndexes = {}
    moveModelUnitWithAction(action)
    focusModelUnit:setStateActioned()

    modelTile:updateWithObjectAndBaseId(focusModelUnit:getTileObjectIdAfterLaunch())
    for _, gridIndex in pairs(getGridsWithinDistance(action.targetGridIndex, 0, 2, modelUnitMap:getMapSize())) do
        targetGridIndexes[#targetGridIndexes + 1] = gridIndex

        local modelUnit = modelUnitMap:getModelUnit(gridIndex)
        if ((modelUnit) and (modelUnit.setCurrentHP)) then
            modelUnit:setCurrentHP(math.max(1, modelUnit:getCurrentHP() - 30))
            targetModelUnits[#targetModelUnits + 1] = modelUnit
        end
    end

    if (IS_SERVER) then
        getModelScene(sceneWarFileName):setExecutingAction(false)
    else
        focusModelUnit:moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()
            modelTile:updateView()
            for _, modelUnit in ipairs(targetModelUnits) do
                modelUnit:updateView()
            end

            local modelGridEffect = getModelGridEffect()
            for _, gridIndex in ipairs(targetGridIndexes) do
                modelGridEffect:showAnimationSiloAttack(gridIndex)
            end

            updateTileAndUnitMapOnVisibilityChanged()

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
    end
end

local function executeLoadModelUnit(action)
    updateTilesAndUnitsBeforeExecutingAction(action)

    local sceneWarFileName = action.fileName
    local path             = action.path
    local modelUnitMap     = getModelUnitMap(sceneWarFileName)
    local focusModelUnit   = modelUnitMap:getFocusModelUnit(path[1], action.launchUnitID)
    local loaderModelUnit  = modelUnitMap:getModelUnit(path[#path])
    moveModelUnitWithAction(action)
    focusModelUnit:setStateActioned()
    if (loaderModelUnit) then
        loaderModelUnit:addLoadUnitId(focusModelUnit:getUnitId())
    else
        assert(not IS_SERVER, "ActionExecutor-executeLoadModelUnit() failed to get the target loader on the server.")
    end

    if (IS_SERVER) then
        getModelScene(sceneWarFileName):setExecutingAction(false)
    else
        focusModelUnit:moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()
                :setViewVisible(false)
            if (loaderModelUnit) then
                loaderModelUnit:updateView()
            end

            updateTileAndUnitMapOnVisibilityChanged()

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
    end
end

local function executeProduceModelUnitOnTile(action)
    updateTilesAndUnitsBeforeExecutingAction(action)

    local sceneWarFileName = action.fileName
    local modelUnitMap     = getModelUnitMap(sceneWarFileName)
    local producedUnitID   = modelUnitMap:getAvailableUnitId()
    local playerIndex      = getModelTurnManager(sceneWarFileName):getPlayerIndex()

    if (action.tiledID) then
        local gridIndex         = action.gridIndex
        local producedActorUnit = produceActorUnit(sceneWarFileName, action.tiledID, producedUnitID, gridIndex)
        modelUnitMap:addActorUnitOnMap(producedActorUnit)

        if ((IS_SERVER) or (playerIndex == getPlayerIndexLoggedIn())) then
            getModelFogMap(sceneWarFileName):updateMapForUnitsForPlayerIndexOnUnitArrive(playerIndex, gridIndex, producedActorUnit:getModel():getVisionForPlayerIndex(playerIndex))
        end
    end

    modelUnitMap:setAvailableUnitId(producedUnitID + 1)
    updateFundWithCost(sceneWarFileName, playerIndex, action.cost)

    if (IS_SERVER) then
        getModelScene(sceneWarFileName):setExecutingAction(false)
    else
        updateTileAndUnitMapOnVisibilityChanged()

        getModelScene(sceneWarFileName):setExecutingAction(false)
    end
end

local function executeProduceModelUnitOnUnit(action)
    updateTilesAndUnitsBeforeExecutingAction(action)

    local sceneWarFileName = action.fileName
    local path             = action.path
    local modelUnitMap     = getModelUnitMap(sceneWarFileName)
    local producer         = modelUnitMap:getFocusModelUnit(path[1], action.launchUnitID)
    moveModelUnitWithAction(action)
    producer:setStateActioned()

    local producedUnitID    = modelUnitMap:getAvailableUnitId()
    local producedActorUnit = produceActorUnit(sceneWarFileName, producer:getMovableProductionTiledId(), producedUnitID, path[#path])
    modelUnitMap:addActorUnitLoaded(producedActorUnit)
        :setAvailableUnitId(producedUnitID + 1)
    producer:addLoadUnitId(producedUnitID)
    if (producer.setCurrentMaterial) then
        producer:setCurrentMaterial(producer:getCurrentMaterial() - 1)
    end
    updateFundWithCost(sceneWarFileName, producer:getPlayerIndex(), action.cost)

    if (IS_SERVER) then
        getModelScene(sceneWarFileName):setExecutingAction(false)
    else
        producer:moveViewAlongPath(path, isModelUnitDiving(producer), function()
            producer:updateView()
                :showNormalAnimation()

            updateTileAndUnitMapOnVisibilityChanged()

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
    end
end

local function executeSupplyModelUnit(action)
    updateTilesAndUnitsBeforeExecutingAction(action)

    local sceneWarFileName = action.fileName
    local launchUnitID     = action.launchUnitID
    local path             = action.path
    local focusModelUnit   = getModelUnitMap(sceneWarFileName):getFocusModelUnit(path[1], launchUnitID)
    local targetModelUnits = getAndSupplyAdjacentModelUnits(sceneWarFileName, path[#path], focusModelUnit:getPlayerIndex())
    moveModelUnitWithAction(action)
    focusModelUnit:setStateActioned()

    if (IS_SERVER) then
        getModelScene(sceneWarFileName):setExecutingAction(false)
    else
        focusModelUnit:moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()

            updateTileAndUnitMapOnVisibilityChanged()

            local modelGridEffect = getModelGridEffect()
            for _, targetModelUnit in pairs(targetModelUnits) do
                targetModelUnit:updateView()
                modelGridEffect:showAnimationSupply(targetModelUnit:getGridIndex())
            end

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
    end
end

local function executeSurface(action)
    updateTilesAndUnitsBeforeExecutingAction(action)

    local sceneWarFileName = action.fileName
    local launchUnitID     = action.launchUnitID
    local path             = action.path
    local focusModelUnit   = getModelUnitMap(sceneWarFileName):getFocusModelUnit(path[1], launchUnitID)
    moveModelUnitWithAction(action)
    focusModelUnit:setStateActioned()
        :setDiving(false)

    if (IS_SERVER) then
        getModelScene(sceneWarFileName):setExecutingAction(false)
    else
        focusModelUnit:moveViewAlongPath(path, true, function()
            local endingGridIndex = path[#path]
            local isVisible       = isUnitVisible(sceneWarFileName, endingGridIndex, focusModelUnit:getUnitType(), false, focusModelUnit:getPlayerIndex(), getPlayerIndexLoggedIn())
            focusModelUnit:updateView()
                :showNormalAnimation()
                :setViewVisible(isVisible)

            updateTileAndUnitMapOnVisibilityChanged()

            if (isVisible) then
                getModelGridEffect():showAnimationSurface(endingGridIndex)
            end

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
    end
end

local function executeSurrender(action)
    local sceneWarFileName   = action.fileName
    local modelSceneWar      = getModelScene(sceneWarFileName)
    local modelPlayerManager = getModelPlayerManager(sceneWarFileName)
    local modelTurnManager   = getModelTurnManager(sceneWarFileName)
    local playerIndex        = modelTurnManager:getPlayerIndex()
    local modelPlayer        = modelPlayerManager:getModelPlayer(playerIndex)

    Destroyers.destroyPlayerForce(sceneWarFileName, playerIndex)
    if (IS_SERVER) then
        if (modelPlayerManager:getAlivePlayersCount() <= 1) then
            modelSceneWar:setEnded(true)
        else
            modelTurnManager:endTurnPhaseMain()
        end
    else
        updateTileAndUnitMapOnVisibilityChanged()

        getModelMessageIndicator(sceneWarFileName):showMessage(getLocalizedText(77, modelPlayer:getNickname()))
        if (modelPlayer:getAccount() == WebSocketManager.getLoggedInAccountAndPassword()) then
            modelSceneWar:setEnded(true)
                :showEffectSurrender(callbackOnWarEndedForClient)
        else
            if (modelPlayerManager:getAlivePlayersCount() <= 1) then
                modelSceneWar:setEnded(true)
                    :showEffectWin(callbackOnWarEndedForClient)
            else
                modelTurnManager:endTurnPhaseMain()
            end
        end
    end
    modelSceneWar:setExecutingAction(false)
end

local function executeTickActionId(action)
    assert(not IS_SERVER, "ActionExecutor-executeTickActionId() this should not be called on the server.")
    getModelScene():setExecutingAction(false)
end

local function executeWait(action)
    updateTilesAndUnitsBeforeExecutingAction(action)

    local sceneWarFileName = action.fileName
    local path             = action.path
    local focusModelUnit   = getModelUnitMap(sceneWarFileName):getFocusModelUnit(path[1], action.launchUnitID)
    moveModelUnitWithAction(action)
    focusModelUnit:setStateActioned()

    if (IS_SERVER) then
        getModelScene(sceneWarFileName):setExecutingAction(false)
    else
        focusModelUnit:moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()

            updateTileAndUnitMapOnVisibilityChanged()

            if (path.isBlocked) then
                getModelGridEffect():showAnimationBlock(path[#path])
            end

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
    end
end

--------------------------------------------------------------------------------
-- The public function.
--------------------------------------------------------------------------------
function ActionExecutor.execute(action)
    local actionName = action.actionName
    if (actionName == "Logout") then
        executeLogout(action)
        return
    end

    local sceneWarFileName = action.fileName
    local modelSceneWar    = getModelScene(sceneWarFileName)
    if ((not modelSceneWar)                                or
        (not modelSceneWar.getFileName)                    or
        (modelSceneWar:getFileName() ~= sceneWarFileName)) then
        return
    end

    local actionID = action.actionID
    if (not actionID) then
        assert(not IS_SERVER, "ActionExecutor.execute() invalid action for the server: " .. toErrorMessage(action))
        if     (actionName == "Error")               then executeError(              action)
        elseif (actionName == "Message")             then executeMessage(            action)
        elseif (actionName == "GetSceneWarActionId") then executeGetSceneWarActionId(action)
        elseif (actionName == "GetSceneWarData")     then executeGetSceneWarData(    action)
        elseif (actionName == "ReloadSceneWar")      then executeReloadSceneWar(     action)
        elseif (actionName == "RunSceneMain")        then executeRunSceneMain(       action)
        else
            local account, password = WebSocketManager.getLoggedInAccountAndPassword()
            runSceneMain({
                    isPlayerLoggedIn = (account ~= nil),
                    confirmText      = "InvalidAction: " .. toErrorMessage(action)
                }, account, password)
        end
        return
    end

    if (modelSceneWar:isEnded()) then
        return
    elseif (modelSceneWar:isExecutingAction()) then
        modelSceneWar:cacheAction(action)
        return
    end

    modelSceneWar:setExecutingAction(true)
    if (actionID == modelSceneWar:getActionId() + 1) then
        modelSceneWar:setActionId(actionID)
    else
        assert(not IS_SERVER, "ActionExecutor.execute() the actionID is invalid on the server: " .. (actionID or ""))
        getModelMessageIndicator():showPersistentMessage(getLocalizedText(81, "OutOfSync"))
        requestReloadSceneWar()
        return
    end

    if     (actionName == "ActivateSkillGroup")     then executeActivateSkillGroup(    action)
    elseif (actionName == "Attack")                 then executeAttack(                action)
    elseif (actionName == "BeginTurn")              then executeBeginTurn(             action)
    elseif (actionName == "BuildModelTile")         then executeBuildModelTile(        action)
    elseif (actionName == "CaptureModelTile")       then executeCaptureModelTile(      action)
    elseif (actionName == "Dive")                   then executeDive(                  action)
    elseif (actionName == "DropModelUnit")          then executeDropModelUnit(         action)
    elseif (actionName == "EndTurn")                then executeEndTurn(               action)
    elseif (actionName == "JoinModelUnit")          then executeJoinModelUnit(         action)
    elseif (actionName == "LaunchFlare")            then executeLaunchFlare(           action)
    elseif (actionName == "LaunchSilo")             then executeLaunchSilo(            action)
    elseif (actionName == "LoadModelUnit")          then executeLoadModelUnit(         action)
    elseif (actionName == "ProduceModelUnitOnTile") then executeProduceModelUnitOnTile(action)
    elseif (actionName == "ProduceModelUnitOnUnit") then executeProduceModelUnitOnUnit(action)
    elseif (actionName == "SupplyModelUnit")        then executeSupplyModelUnit(       action)
    elseif (actionName == "Surface")                then executeSurface(               action)
    elseif (actionName == "Surrender")              then executeSurrender(             action)
    elseif (actionName == "TickActionId")           then executeTickActionId(          action)
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
