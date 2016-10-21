
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
local getAdjacentGrids         = GridIndexFunctions.getAdjacentGrids
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

local function getPlayerIndexLoggedIn()
    assert(not IS_SERVER, "ActionExecutor-getPlayerIndexLoggedIn() this should not be called on the server.")
    local _, playerIndex = getModelPlayerManager():getModelPlayerWithAccount(WebSocketManager.getLoggedInAccountAndPassword())
    return playerIndex
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

local function addActorUnitsOnMapWithRevealedUnits(revealedUnits, visible)
    assert(not IS_SERVER, "ActionExecutor-addActorUnitsOnMapWithRevealedUnits() this should not be called on the server.")
    if (revealedUnits) then
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

local function isModelUnitDiving(modelUnit)
    return (modelUnit.isDiving) and (modelUnit:isDiving())
end

local function setRevealedUnitsVisible(revealedUnits, visible)
    assert(not IS_SERVER, "ActionExecutor-setRevealedUnitsVisible() this should not be called on the server.")
    if (revealedUnits) then
        local modelUnitMap = getModelUnitMap()
        for _, data in pairs(revealedUnits) do
            modelUnitMap:getModelUnit(data.GridIndexable.gridIndex):setViewVisible(visible)
        end
    end
end

local function removeHiddenActorUnitOnMapAfterAction(beginningGridIndex, endingGridIndex)
    assert(not IS_SERVER, "ActionExecutor-setRevealedUnitsVisible() this should not be called on the server.")
    local sceneWarFileName    = getSceneWarFileName()
    local playerIndexLoggedIn = getPlayerIndexLoggedIn()
    local modelUnitMap        = getModelUnitMap()
    local modelUnit           = modelUnitMap:getModelUnit(endingGridIndex)
    local playerIndexActing   = modelUnit:getPlayerIndex()

    if (playerIndexLoggedIn ~= playerIndexActing) then
        -- 如果登录的玩家不是行动玩家，那么判断行动单位在行动后是否可见，如果不可见则清除行动单位。
        if (not isUnitVisible(sceneWarFileName, endingGridIndex, isModelUnitDiving(modelUnit), playerIndexActing, playerIndexLoggedIn)) then
            modelUnitMap:removeActorUnitOnMap(endingGridIndex)
            return {modelUnit}
        end
    else
        -- 如果登录的玩家是行动玩家，那么需要清除行动单位在行动前可见、行动后不可见的部队。
        local removedModelUnits = {}
        for _, adjacentGridIndex in ipairs(getAdjacentGrids(beginningGridIndex, modelUnitMap:getMapSize())) do
            local adjacentModelUnit = modelUnitMap:getModelUnit(adjacentGridIndex)
            if ((adjacentModelUnit)                                                                                                                                      and
                (not isUnitVisible(sceneWarFileName, adjacentGridIndex, isModelUnitDiving(adjacentModelUnit), adjacentModelUnit:getPlayerIndex(), playerIndexLoggedIn))) then
                modelUnitMap:removeActorUnitOnMap(adjacentGridIndex)
                removedModelUnits[#removedModelUnits + 1] = adjacentModelUnit
            end
        end
        return removedModelUnits
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
        local loaderModelUnit = modelUnitMap:getModelUnit(beginningGridIndex)
        if (loaderModelUnit) then
            loaderModelUnit:removeLoadUnitId(launchUnitID)
                :updateView()
                :showNormalAnimation()
        else
            assert(not IS_SERVER, "ActionExecutor-moveModelUnitWithAction() failed to get the loader for the launching unit, on the server.")
        end

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

    local destroyedModelUnits = {}
    local attackerNewHP       = math.max(0, attacker:getCurrentHP() - (counterDamage or 0))
    attacker:setCurrentHP(attackerNewHP)
    if (attackerNewHP == 0) then
        attackTarget:setCurrentPromotion(math.min(attackTarget:getMaxPromotion(), attackTarget:getCurrentPromotion() + 1))
        appendList(destroyedModelUnits, Destroyers.destroyActorUnitOnMap(sceneWarFileName, attackerGridIndex, false))
    end

    local plasmaGridIndexes
    local targetNewHP = math.max(0, attackTarget:getCurrentHP() - attackDamage)
    attackTarget:setCurrentHP(targetNewHP)
    if (targetNewHP == 0) then
        if (attackTarget.getUnitType) then
            attacker:setCurrentPromotion(math.min(attacker:getMaxPromotion(), attacker:getCurrentPromotion() + 1))
            appendList(destroyedModelUnits, Destroyers.destroyActorUnitOnMap(sceneWarFileName, targetGridIndex, false))
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

        if (not IS_SERVER) then
            for _, destroyedModelUnit in pairs(destroyedModelUnits) do
                destroyedModelUnit:removeViewFromParent()
            end
        end

        if (attackerNewHP == 0) then
            dispatchEvtDestroyViewUnit(sceneWarFileName, attackerGridIndex)
        elseif ((counterDamage) and (targetNewHP > 0)) then
            dispatchEvtAttackViewUnit(sceneWarFileName, attackerGridIndex)
        end

        if (targetNewHP == 0) then
            if (attackTarget.getUnitType) then
                dispatchEvtDestroyViewUnit(sceneWarFileName, targetGridIndex)
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
        attacker:moveViewAlongPathAndFocusOnTarget(path, isModelUnitDiving(attacker), targetGridIndex, function()
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

            attacker:moveViewAlongPathAndFocusOnTarget(path, isModelUnitDiving(attacker), targetGridIndex, function()
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
        :moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
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
        focusModelUnit:moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
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

            focusModelUnit:moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
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

local function executeDive(action)
    if (not IS_SERVER) then
        addActorUnitsWithUnitsData(action.actingUnitsData, false)
    end

    local sceneWarFileName   = action.fileName
    local launchUnitID       = action.launchUnitID
    local path               = action.path
    local beginningGridIndex = path[1]
    local endingGridIndex    = path[#path]
    local focusModelUnit     = getModelUnitMap(sceneWarFileName):getFocusModelUnit(beginningGridIndex, launchUnitID)
    moveModelUnitWithAction(action)
    focusModelUnit:setStateActioned()
        :setDiving(true)

    if (IS_SERVER) then
        getModelScene(sceneWarFileName):setExecutingAction(false)
    else
        local revealedUnits = action.revealedUnits
        addActorUnitsOnMapWithRevealedUnits(revealedUnits, false)
        local removedModelUnits = removeHiddenActorUnitOnMapAfterAction(beginningGridIndex, endingGridIndex)

        focusModelUnit:moveViewAlongPath(path, false, function()
            focusModelUnit:updateView()
                :showNormalAnimation()
                :setViewVisible(isUnitVisible(sceneWarFileName, endingGridIndex, true, focusModelUnit:getPlayerIndex(), getPlayerIndexLoggedIn()))

            setRevealedUnitsVisible(revealedUnits, true)
            for _, removedModelUnit in pairs(removedModelUnits or {}) do
                removedModelUnit:removeViewFromParent()
            end

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
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
        :moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()

            local loaderEndingGridIndex = path[#path]
            for _, dropModelUnit in ipairs(dropModelUnits) do
                dropModelUnit:moveViewAlongPath({
                        loaderEndingGridIndex,
                        dropModelUnit:getGridIndex(),
                    },
                    isModelUnitDiving(dropModelUnit),
                    function()
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
    if (not IS_SERVER) then
        addActorUnitsWithUnitsData(action.actingUnitsData, false)
    end

    local sceneWarFileName   = action.fileName
    local launchUnitID       = action.launchUnitID
    local path               = action.path
    local beginningGridIndex = path[1]
    local endingGridIndex    = path[#path]
    local modelUnitMap       = getModelUnitMap(sceneWarFileName)
    local focusModelUnit     = modelUnitMap:getFocusModelUnit(beginningGridIndex, launchUnitID)
    local targetModelUnit    = modelUnitMap:getModelUnit(endingGridIndex)

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
        local revealedUnits = action.revealedUnits
        addActorUnitsOnMapWithRevealedUnits(revealedUnits, false)
        local removedModelUnits = removeHiddenActorUnitOnMapAfterAction(beginningGridIndex, endingGridIndex)

        focusModelUnit:moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()
            setRevealedUnitsVisible(revealedUnits, true)

            targetModelUnit:removeViewFromParent()
            for _, removedModelUnit in pairs(removedModelUnits or {}) do
                removedModelUnit:removeViewFromParent()
            end

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
    end
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
        :moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
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
    if (not IS_SERVER) then
        addActorUnitsWithUnitsData(action.actingUnitsData, false)
    end

    local sceneWarFileName   = action.fileName
    local path               = action.path
    local beginningGridIndex = path[1]
    local endingGridIndex    = path[#path]
    local modelUnitMap       = getModelUnitMap(sceneWarFileName)
    local focusModelUnit     = modelUnitMap:getFocusModelUnit(beginningGridIndex, action.launchUnitID)
    local loaderModelUnit    = modelUnitMap:getModelUnit(endingGridIndex)

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
        local revealedUnits = action.revealedUnits
        addActorUnitsOnMapWithRevealedUnits(revealedUnits, false)
        local removedModelUnits = removeHiddenActorUnitOnMapAfterAction(beginningGridIndex, endingGridIndex)

        focusModelUnit:moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()
                :setViewVisible(false)
            if (loaderModelUnit) then
                loaderModelUnit:updateView()
            end

            setRevealedUnitsVisible(revealedUnits, true)
            for _, removedModelUnit in pairs(removedModelUnits or {}) do
                removedModelUnit:removeViewFromParent()
            end

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
    end
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
        if (not IS_SERVER) then
            addActorUnitsOnMapWithRevealedUnits(action.revealedUnits, true)
        end
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
        :moveViewAlongPath(path, isModelUnitDiving(producer), function()
            producer:updateView()
                :showNormalAnimation()

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
end

local function executeSupplyModelUnit(action)
    if (not IS_SERVER) then
        addActorUnitsWithUnitsData(action.actingUnitsData, false)
    end

    local sceneWarFileName   = action.fileName
    local launchUnitID       = action.launchUnitID
    local path               = action.path
    local beginningGridIndex = path[1]
    local endingGridIndex    = path[#path]
    local focusModelUnit     = getModelUnitMap(sceneWarFileName):getFocusModelUnit(beginningGridIndex, launchUnitID)

    moveModelUnitWithAction(action)
    focusModelUnit:setStateActioned()
    local targetModelUnits = getAndSupplyAdjacentModelUnits(sceneWarFileName, endingGridIndex, focusModelUnit:getPlayerIndex())

    if (IS_SERVER) then
        getModelScene(sceneWarFileName):setExecutingAction(false)
    else
        local revealedUnits = action.revealedUnits
        addActorUnitsOnMapWithRevealedUnits(revealedUnits, false)
        local removedModelUnits = removeHiddenActorUnitOnMapAfterAction(beginningGridIndex, endingGridIndex)

        focusModelUnit:moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()
            setRevealedUnitsVisible(revealedUnits, true)

            local modelGridEffect = getModelGridEffect()
            for _, targetModelUnit in pairs(targetModelUnits) do
                targetModelUnit:updateView()
                modelGridEffect:showAnimationSupply(targetModelUnit:getGridIndex())
            end

            for _, removedModelUnit in pairs(removedModelUnits or {}) do
                removedModelUnit:removeViewFromParent()
            end

            getModelScene(sceneWarFileName):setExecutingAction(false)
        end)
    end
end

local function executeSurface(action)
    if (not IS_SERVER) then
        addActorUnitsWithUnitsData(action.actingUnitsData, false)
    end

    local sceneWarFileName   = action.fileName
    local launchUnitID       = action.launchUnitID
    local path               = action.path
    local beginningGridIndex = path[1]
    local endingGridIndex    = path[#path]
    local focusModelUnit     = getModelUnitMap(sceneWarFileName):getFocusModelUnit(beginningGridIndex, launchUnitID)
    moveModelUnitWithAction(action)
    focusModelUnit:setStateActioned()
        :setDiving(false)

    if (IS_SERVER) then
        getModelScene(sceneWarFileName):setExecutingAction(false)
    else
        local revealedUnits = action.revealedUnits
        addActorUnitsOnMapWithRevealedUnits(revealedUnits, false)
        local removedModelUnits = removeHiddenActorUnitOnMapAfterAction(beginningGridIndex, endingGridIndex)

        focusModelUnit:moveViewAlongPath(path, true, function()
            focusModelUnit:updateView()
                :showNormalAnimation()
                :setViewVisible(isUnitVisible(sceneWarFileName, endingGridIndex, false, focusModelUnit:getPlayerIndex(), getPlayerIndexLoggedIn()))

            setRevealedUnitsVisible(revealedUnits, true)
            for _, removedModelUnit in pairs(removedModelUnits or {}) do
                removedModelUnit:removeViewFromParent()
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
    if (not IS_SERVER) then
        addActorUnitsWithUnitsData(action.actingUnitsData, false)
    end

    local sceneWarFileName   = action.fileName
    local path               = action.path
    local beginningGridIndex = path[1]
    local endingGridIndex    = path[#path]
    local focusModelUnit     = getModelUnitMap(sceneWarFileName):getFocusModelUnit(beginningGridIndex, action.launchUnitID)
    moveModelUnitWithAction(action)
    focusModelUnit:setStateActioned()

    if (IS_SERVER) then
        getModelScene(sceneWarFileName):setExecutingAction(false)
    else
        local revealedUnits = action.revealedUnits
        addActorUnitsOnMapWithRevealedUnits(revealedUnits, false)
        local removedModelUnits = removeHiddenActorUnitOnMapAfterAction(beginningGridIndex, endingGridIndex)

        focusModelUnit:moveViewAlongPath(path, isModelUnitDiving(focusModelUnit), function()
            focusModelUnit:updateView()
                :showNormalAnimation()

            setRevealedUnitsVisible(revealedUnits, true)
            for _, removedModelUnit in pairs(removedModelUnits or {}) do
                removedModelUnit:removeViewFromParent()
            end

            if (path.isBlocked) then
                getModelGridEffect():showAnimationBlock(endingGridIndex)
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
