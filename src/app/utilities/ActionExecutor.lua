
local ActionExecutor = {}

local Destroyers             = require("src.app.utilities.Destroyers")
local GameConstantFunctions  = require("src.app.utilities.GameConstantFunctions")
local GridIndexFunctions     = require("src.app.utilities.GridIndexFunctions")
local InstantSkillExecutor   = require("src.app.utilities.InstantSkillExecutor")
local LocalizationFunctions  = require("src.app.utilities.LocalizationFunctions")
local SerializationFunctions = require("src.app.utilities.SerializationFunctions")
local SingletonGetters       = require("src.app.utilities.SingletonGetters")
local SkillModifierFunctions = require("src.app.utilities.SkillModifierFunctions")
local Actor                  = require("src.global.actors.Actor")

local UNIT_MAX_HP           = GameConstantFunctions.getUnitMaxHP()
local IS_SERVER             = GameConstantFunctions.isServer()
local WebSocketManager      = (not IS_SERVER) and (require("src.app.utilities.WebSocketManager")) or (nil)
local ActorManager          = (not IS_SERVER) and (require("src.global.actors.ActorManager"))     or (nil)

local getLocalizedText         = LocalizationFunctions.getLocalizedText
local getModelGridEffect       = SingletonGetters.getModelGridEffect
local getModelMessageIndicator = SingletonGetters.getModelMessageIndicator
local getModelPlayerManager    = SingletonGetters.getModelPlayerManager
local getModelScene            = SingletonGetters.getModelScene
local getModelTileMap          = SingletonGetters.getModelTileMap
local getModelTurnManager      = SingletonGetters.getModelTurnManager
local getModelUnitMap          = SingletonGetters.getModelUnitMap
local getSceneWarFileName      = SingletonGetters.getSceneWarFileName
local getScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher
local toErrorMessage           = SerializationFunctions.toErrorMessage

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

local function dispatchEvtDestroyViewUnit(sceneWarFileName, gridIndex)
    getScriptEventDispatcher(sceneWarFileName):dispatchEvent({
        name      = "EvtDestroyViewUnit",
        gridIndex = gridIndex,
    })
end

local function dispatchEvtDestroyViewTile(sceneWarFileName, gridIndex)
    getScriptEventDispatcher(sceneWarFileName):dispatchEvent({
        name      = "EvtDestroyViewTile",
        gridIndex = gridIndex,
    })
end

local function dispatchEvtAttackViewUnit(sceneWarFileName, gridIndex)
    getScriptEventDispatcher(sceneWarFileName):dispatchEvent({
        name      = "EvtAttackViewUnit",
        gridIndex = gridIndex,
    })
end

local function dispatchEvtAttackViewTile(sceneWarFileName, gridIndex)
    getScriptEventDispatcher(sceneWarFileName):dispatchEvent({
        name      = "EvtAttackViewTile",
        gridIndex = gridIndex,
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
        actionName = "ReloadSceneWar",
        fileName   = getSceneWarFileName(),
    })
end

local function addActorUnitsOnMapWithRevealedUnits(revealedUnits, visible)
    if ((not IS_SERVER) and (revealedUnits)) then
        local modelUnitMap = getModelUnitMap()
        for unitID, data in pairs(revealedUnits) do
            local actorUnit = Actor.createWithModelAndViewName("sceneWar.ModelUnit", data, "sceneWar.ViewUnit")
            actorUnit:getModel():onStartRunning(sceneWarFileName)
                :updateView()
                :setViewVisible(visible)

            modelUnitMap:addActorUnitOnMap(actorUnit)
        end
    end
end

local function setRevealedUnitsVisible(revealedUnits, visible)
    if ((not IS_SERVER) and (revealedUnits)) then
        local modelUnitMap = getModelUnitMap()
        for _, data in pairs(revealedUnits) do
            modelUnitMap:getModelUnit(data.GridIndexable.gridIndex):setViewVisible(visible)
        end
    end
end

local function moveModelUnitWithAction(action)
    local path       = action.path
    local pathLength = #path
    if (pathLength <= 1) then
        return
    end

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

    addActorUnitsOnMapWithRevealedUnits(path.revealedUnits, false)
end

local function promoteModelUnitOnProduce(modelUnit, sceneWarFileName)
    local modelPlayer = getModelPlayerManager(sceneWarFileName):getModelPlayer(modelUnit:getPlayerIndex())
    local modifier    = SkillModifierFunctions.getPassivePromotionModifier(modelPlayer:getModelSkillConfiguration())
    if ((modifier > 0) and (modelUnit.setCurrentPromotion)) then
        modelUnit:setCurrentPromotion(modifier)
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
        for _, adjacentGridIndex in ipairs(GridIndexFunctions.getAdjacentGrids(indexes[i], mapSize)) do
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
    local path               = action.path
    local sceneWarFileName   = action.fileName
    local attackDamage       = action.attackDamage
    local counterDamage      = action.counterDamage
    local attackerGridIndex  = path[#path]
    local targetGridIndex    = action.targetGridIndex
    local modelUnitMap       = getModelUnitMap(sceneWarFileName)
    local modelTileMap       = getModelTileMap(sceneWarFileName)
    local attacker           = modelUnitMap:getFocusModelUnit(path[1], action.launchUnitID)
    local attackTarget       = modelUnitMap:getModelUnit(targetGridIndex) or modelTileMap:getModelTile(targetGridIndex)

    moveModelUnitWithAction(action)
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
        local attackerModelPlayer = modelPlayerManager:getModelPlayer(attacker    :getPlayerIndex())
        local targetModelPlayer   = modelPlayerManager:getModelPlayer(attackTarget:getPlayerIndex())

        attackerModelPlayer:addDamageCost(getSkillModifiedDamageCost(attackerDamageCost * 2 + targetDamageCost,     attackerModelPlayer))
        targetModelPlayer  :addDamageCost(getSkillModifiedDamageCost(attackerDamageCost     + targetDamageCost * 2, targetModelPlayer))
        attackerModelPlayer:setFund(attackerModelPlayer:getFund() + getIncomeWithDamageCost(targetDamageCost,   attackerModelPlayer))
        targetModelPlayer  :setFund(targetModelPlayer  :getFund() + getIncomeWithDamageCost(attackerDamageCost, targetModelPlayer))

        dispatchEvtModelPlayerUpdated(sceneWarFileName, attackerModelPlayer, attacker:getPlayerIndex())
    end

    local attackerNewHP = math.max(0, attacker:getCurrentHP() - (counterDamage or 0))
    attacker:setCurrentHP(attackerNewHP)
    if (attackerNewHP == 0) then
        attackTarget:setCurrentPromotion(math.min(attackTarget:getMaxPromotion(), attackTarget:getCurrentPromotion() + 1))
        Destroyers.destroyModelUnitWithGridIndex(sceneWarFileName, attackerGridIndex)
    end

    local plasmaGridIndexes
    local targetNewHP = math.max(0, attackTarget:getCurrentHP() - attackDamage)
    attackTarget:setCurrentHP(targetNewHP)
    if (targetNewHP == 0) then
        if (attackTarget.getUnitType) then
            attacker:setCurrentPromotion(math.min(attacker:getMaxPromotion(), attacker:getCurrentPromotion() + 1))
            Destroyers.destroyModelUnitWithGridIndex(sceneWarFileName, targetGridIndex)
        else
            attackTarget:updateWithObjectAndBaseId(0)
            plasmaGridIndexes = getAdjacentPlasmaGridIndexes(targetGridIndex, modelTileMap)
            for _, gridIndex in ipairs(plasmaGridIndexes) do
                modelTileMap:getModelTile(gridIndex):updateWithObjectAndBaseId(0)
            end
        end
    end

    attacker:setStateActioned()

    local callbackAfterMoveAnimation = function()
        attacker:updateView()
            :showNormalAnimation()
        attackTarget:updateView()

        if (attackerNewHP == 0) then
            dispatchEvtDestroyViewUnit(sceneWarFileName, attackerGridIndex)
            attacker:removeViewFromParent()
        elseif ((counterDamage) and (targetNewHP > 0)) then
            dispatchEvtAttackViewUnit(sceneWarFileName, attackerGridIndex)
        end

        if (targetNewHP == 0) then
            if (attackTarget.getUnitType) then
                dispatchEvtDestroyViewUnit(sceneWarFileName, targetGridIndex)
                attackTarget:removeViewFromParent()
            else
                dispatchEvtDestroyViewTile(sceneWarFileName, targetGridIndex)
                attackTarget:updateView()
                for _, gridIndex in ipairs(plasmaGridIndexes) do
                    modelTileMap:getModelTile(gridIndex):updateView()
                end
            end
        else
            if (attackTarget.getUnitType) then
                dispatchEvtAttackViewUnit(sceneWarFileName, targetGridIndex)
            else
                dispatchEvtAttackViewTile(sceneWarFileName, targetGridIndex)
            end
        end
    end

    local modelSceneWar   = getModelScene(sceneWarFileName)
    local lostPlayerIndex = action.lostPlayerIndex
    if (not lostPlayerIndex) then
        attacker:moveViewAlongPathAndFocusOnTarget(path, targetGridIndex, function()
            callbackAfterMoveAnimation()
            modelSceneWar:setExecutingAction(false)
        end)
    else
        local modelTurnManager   = getModelTurnManager(sceneWarFileName)
        local isInTurnPlayerLost = (lostPlayerIndex == modelTurnManager:getPlayerIndex())
        if (IS_SERVER) then
            Destroyers.destroyPlayerForce(sceneWarFileName, lostPlayerIndex)
            if (modelPlayerManager:getAlivePlayersCount() <= 1) then
                modelSceneWar:setEnded(true)
            elseif (isInTurnPlayerLost) then
                modelTurnManager:endTurnPhaseMain()
            end
            modelSceneWar:setExecutingAction(false)
        else
            local lostModelPlayer      = modelPlayerManager:getModelPlayer(lostPlayerIndex)
            local isLoggedInPlayerLost = lostModelPlayer:getAccount() == WebSocketManager.getLoggedInAccountAndPassword()
            modelSceneWar:setEnded((isLoggedInPlayerLost) or (modelPlayerManager:getAlivePlayersCount() <= 2))

            attacker:moveViewAlongPathAndFocusOnTarget(path, targetGridIndex, function()
                callbackAfterMoveAnimation()
                Destroyers.destroyPlayerForce(sceneWarFileName, lostPlayerIndex)
                getModelMessageIndicator(sceneWarFileName):showMessage(getLocalizedText(76, lostModelPlayer:getNickname()))

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
    local sceneWarFileName = action.fileName
    local modelSceneWar    = getModelScene(sceneWarFileName)
    local modelTurnManager = getModelTurnManager(sceneWarFileName)
    local playerIndex      = modelTurnManager:getPlayerIndex()
    local lostPlayerIndex  = action.lostPlayerIndex

    if (not lostPlayerIndex) then
        modelTurnManager:beginTurnPhaseBeginning(function()
            modelSceneWar:setExecutingAction(false)
        end)
    else
        local modelPlayerManager = getModelPlayerManager(sceneWarFileName)
        local lostModelPlayer    = modelPlayerManager:getModelPlayer(lostPlayerIndex)

        if (IS_SERVER) then
            modelSceneWar:setEnded(modelPlayerManager:getAlivePlayersCount() <= 2)
            modelTurnManager:beginTurnPhaseBeginning(function()
                Destroyers.destroyPlayerForce(sceneWarFileName, lostPlayerIndex)
                if (not modelSceneWar:isEnded()) then
                    modelTurnManager:endTurnPhaseMain()
                end
                modelSceneWar:setExecutingAction(false)
            end)
        else
            local isLoggedInPlayerLost = lostModelPlayer:getAccount() == WebSocketManager.getLoggedInAccountAndPassword()
            modelSceneWar:setEnded((isLoggedInPlayerLost) or (modelPlayerManager:getAlivePlayersCount() <= 2))

            modelTurnManager:beginTurnPhaseBeginning(function()
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

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
end

local function executeCaptureModelTile(action)
    local path             = action.path
    local sceneWarFileName = action.fileName
    local focusModelUnit   = getModelUnitMap(sceneWarFileName):getFocusModelUnit(path[1], action.launchUnitID)
    local modelTile        = getModelTileMap(sceneWarFileName):getModelTile(path[#path])
    local capturePoint     = modelTile:getCurrentCapturePoint() - focusModelUnit:getCaptureAmount()

    moveModelUnitWithAction(action)
    if (capturePoint > 0) then
        focusModelUnit:setCapturingModelTile(true)
        modelTile:setCurrentCapturePoint(capturePoint)
    else
        focusModelUnit:setCapturingModelTile(false)
        modelTile:setCurrentCapturePoint(modelTile:getMaxCapturePoint())
            :updateWithPlayerIndex(focusModelUnit:getPlayerIndex())
    end
    focusModelUnit:setStateActioned()

    local modelSceneWar   = getModelScene(sceneWarFileName)
    local lostPlayerIndex = action.lostPlayerIndex
    if (not lostPlayerIndex) then
        focusModelUnit:moveViewAlongPath(path, function()
            focusModelUnit:updateView()
                :showNormalAnimation()
            modelTile:updateView()

            modelSceneWar:setExecutingAction(false)
        end)
    else
        local modelPlayerManager = getModelPlayerManager(sceneWarFileName)
        if (IS_SERVER) then
            Destroyers.destroyPlayerForce(sceneWarFileName, lostPlayerIndex)
            modelSceneWar:setEnded(modelPlayerManager:getAlivePlayersCount() < 2)
                :setExecutingAction(false)
        else
            local lostModelPlayer      = modelPlayerManager:getModelPlayer(lostPlayerIndex)
            local isLoggedInPlayerLost = lostModelPlayer:getAccount() == WebSocketManager.getLoggedInAccountAndPassword()
            modelSceneWar:setEnded((isLoggedInPlayerLost) or (modelPlayerManager:getAlivePlayersCount() <= 2))

            focusModelUnit:moveViewAlongPath(path, function()
                focusModelUnit:updateView()
                    :showNormalAnimation()
                modelTile:updateView()

                getModelMessageIndicator(sceneWarFileName):showMessage(getLocalizedText(76, lostModelPlayer:getNickname()))
                Destroyers.destroyPlayerForce(sceneWarFileName, lostPlayerIndex)

                if (isLoggedInPlayerLost) then
                    modelSceneWar:showEffectLose(callbackOnWarEndedForClient)
                elseif (modelSceneWar:isEnded()) then
                    modelSceneWar:showEffectWin(callbackOnWarEndedForClient)
                end

                modelSceneWar:setExecutingAction(false)
            end)
        end
    end
end

local function executeDropModelUnit(action)
    local path             = action.path
    local sceneWarFileName = action.fileName
    local modelUnitMap     = getModelUnitMap(sceneWarFileName)
    local focusModelUnit   = modelUnitMap:getFocusModelUnit(path[1], action.launchUnitID)
    moveModelUnitWithAction(action)

    local dropModelUnits = {}
    for _, dropDestination in ipairs(action.dropDestinations) do
        local gridIndex = dropDestination.gridIndex
        local unitID    = dropDestination.unitID
        modelUnitMap:setActorUnitUnloaded(unitID, gridIndex)
        focusModelUnit:removeLoadUnitId(unitID)

        local dropModelUnit = modelUnitMap:getModelUnit(gridIndex)
        dropModelUnit:setGridIndex(gridIndex, false)
            :setStateActioned()
        dropModelUnits[#dropModelUnits + 1] = dropModelUnit
    end

    focusModelUnit:setStateActioned()
        :moveViewAlongPath(path, function()
            focusModelUnit:updateView()
                :showNormalAnimation()

            local loaderEndingGridIndex = path[#path]
            for _, dropModelUnit in ipairs(dropModelUnits) do
                dropModelUnit:moveViewAlongPath({
                        loaderEndingGridIndex,
                        dropModelUnit:getGridIndex(),
                    }, function()
                        dropModelUnit:updateView()
                            :showNormalAnimation()
                    end
                )
            end

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
end

local function executeEndTurn(action)
    local sceneWarFileName = action.fileName
    getModelTurnManager(sceneWarFileName):endTurnPhaseMain()
    getModelScene(sceneWarFileName):setExecutingAction(false)
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
    if (focusModelUnit.setCapturingModelTile) then
        focusModelUnit:setCapturingModelTile(targetModelUnit:isCapturingModelTile())
    end

    focusModelUnit:setStateActioned()
        :moveViewAlongPath(path, function()
            focusModelUnit:updateView()
                :showNormalAnimation()
            targetModelUnit:removeViewFromParent()

            getModelScene(sceneWarFileName):setExecutingAction(false)
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

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
end

local function executeLoadModelUnit(action)
    local path             = action.path
    local sceneWarFileName = action.fileName
    local modelUnitMap     = getModelUnitMap(sceneWarFileName)
    local focusModelUnit   = modelUnitMap:getFocusModelUnit(path[1], action.launchUnitID)
    local loaderModelUnit  = modelUnitMap:getModelUnit(path[#path])

    moveModelUnitWithAction(action)
    loaderModelUnit:addLoadUnitId(focusModelUnit:getUnitId())

    focusModelUnit:setStateActioned()
        :moveViewAlongPath(path, function()
            focusModelUnit:updateView()
                :showNormalAnimation()
                :setViewVisible(false)
            loaderModelUnit:updateView()

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
end

local function executeProduceModelUnitOnTile(action)
    local sceneWarFileName = action.fileName
    local modelUnitMap     = getModelUnitMap(sceneWarFileName)
    local availableUnitID  = modelUnitMap:getAvailableUnitId()

    if (action.tiledID) then
        local actorData = {
            tiledID       = action.tiledID,
            unitID        = availableUnitID,
            GridIndexable = {gridIndex = action.gridIndex},
        }
        local actorUnit = Actor.createWithModelAndViewName("sceneWar.ModelUnit", actorData, "sceneWar.ViewUnit")
        local modelUnit = actorUnit:getModel()

        promoteModelUnitOnProduce(modelUnit, sceneWarFileName)
        modelUnit:setStateActioned()
            :onStartRunning(sceneWarFileName)

        modelUnitMap:addActorUnitOnMap(actorUnit)
        addActorUnitsOnMapWithRevealedUnits(action.revealedUnits, true)
    end

    local playerIndex = getModelTurnManager(sceneWarFileName):getPlayerIndex()
    local modelPlayer = getModelPlayerManager(sceneWarFileName):getModelPlayer(playerIndex)
    modelPlayer:setFund(modelPlayer:getFund() - action.cost)
    dispatchEvtModelPlayerUpdated(sceneWarFileName, modelPlayer, playerIndex)

    modelUnitMap:setAvailableUnitId(availableUnitID + 1)
    getModelScene(sceneWarFileName):setExecutingAction(false)
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
    modelUnit:setStateActioned()
        :onStartRunning(sceneWarFileName)

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

            getModelScene(sceneWarFileName):setExecutingAction(false)
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

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
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

local function executeWait(action)
    local path             = action.path
    local sceneWarFileName = action.fileName
    local focusModelUnit   = getModelUnitMap(sceneWarFileName):getFocusModelUnit(path[1], action.launchUnitID)
    moveModelUnitWithAction(action)
    focusModelUnit:setStateActioned()

    if (IS_SERVER) then
        getModelScene(sceneWarFileName):setExecutingAction(false)
    else
        focusModelUnit:moveViewAlongPath(path, function()
            focusModelUnit:updateView()
                :showNormalAnimation()

            setRevealedUnitsVisible(path.revealedUnits, true)
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
    elseif (actionName == "DropModelUnit")          then executeDropModelUnit(         action)
    elseif (actionName == "EndTurn")                then executeEndTurn(               action)
    elseif (actionName == "JoinModelUnit")          then executeJoinModelUnit(         action)
    elseif (actionName == "LaunchSilo")             then executeLaunchSilo(            action)
    elseif (actionName == "LoadModelUnit")          then executeLoadModelUnit(         action)
    elseif (actionName == "ProduceModelUnitOnTile") then executeProduceModelUnitOnTile(action)
    elseif (actionName == "ProduceModelUnitOnUnit") then executeProduceModelUnitOnUnit(action)
    elseif (actionName == "SupplyModelUnit")        then executeSupplyModelUnit(       action)
    elseif (actionName == "Surrender")              then executeSurrender(             action)
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
