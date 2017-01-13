
--[[--------------------------------------------------------------------------------
-- ModelWarCommandMenu是战局中的命令菜单（与单位操作菜单不同），在玩家点击MoneyEnergyInfo时呼出。
--
-- 主要职责和使用场景举例：
--   同上
--
-- 其他：
--   - ModelWarCommandMenu将包括以下菜单项（可能有遗漏）：
--     - 离开战局（回退到主画面，而不是投降）
--     - 发动co技能
--     - 发动super技能
--     - 游戏设定（声音等）
--     - 投降
--     - 求和
--     - 结束回合
--]]--------------------------------------------------------------------------------

local ModelWarCommandMenu = class("ModelWarCommandMenu")

local ActionCodeFunctions       = require("src.app.utilities.ActionCodeFunctions")
local AudioManager              = require("src.app.utilities.AudioManager")
local LocalizationFunctions     = require("src.app.utilities.LocalizationFunctions")
local GameConstantFunctions     = require("src.app.utilities.GameConstantFunctions")
local GridIndexFunctions        = require("src.app.utilities.GridIndexFunctions")
local SingletonGetters          = require("src.app.utilities.SingletonGetters")
local SkillDescriptionFunctions = require("src.app.utilities.SkillDescriptionFunctions")
local WebSocketManager          = require("src.app.utilities.WebSocketManager")
local Actor                     = require("src.global.actors.Actor")
local ActorManager              = require("src.global.actors.ActorManager")

local getActionId              = SingletonGetters.getActionId
local getLocalizedText         = LocalizationFunctions.getLocalizedText
local getModelConfirmBox       = SingletonGetters.getModelConfirmBox
local getModelFogMap           = SingletonGetters.getModelFogMap
local getModelMessageIndicator = SingletonGetters.getModelMessageIndicator
local getModelPlayerManager    = SingletonGetters.getModelPlayerManager
local getModelTileMap          = SingletonGetters.getModelTileMap
local getModelTurnManager      = SingletonGetters.getModelTurnManager
local getModelUnitMap          = SingletonGetters.getModelUnitMap
local getPlayerIndexLoggedIn   = SingletonGetters.getPlayerIndexLoggedIn
local getScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher
local isTotalReplay            = SingletonGetters.isTotalReplay
local round                    = require("src.global.functions.round")
local string, ipairs, pairs    = string, ipairs, pairs

local ACTION_CODE_ACTIVATE_SKILL_GROUP = ActionCodeFunctions.getActionCode("ActionActivateSkillGroup")
local ACTION_CODE_DESTROY_OWNED_UNIT   = ActionCodeFunctions.getActionCode("ActionDestroyOwnedModelUnit")
local ACTION_CODE_END_TURN             = ActionCodeFunctions.getActionCode("ActionEndTurn")
local ACTION_CODE_RELOAD_SCENE_WAR     = ActionCodeFunctions.getActionCode("ActionReloadSceneWar")
local ACTION_CODE_SURRENDER            = ActionCodeFunctions.getActionCode("ActionSurrender")
local ACTION_CODE_VOTE_FOR_DRAW        = ActionCodeFunctions.getActionCode("ActionVoteForDraw")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function generateEmptyDataForEachPlayer(self)
    local modelSceneWar      = self.m_ModelSceneWar
    local modelPlayerManager = getModelPlayerManager(modelSceneWar)
    local dataForEachPlayer  = {}
    local isReplay           = isTotalReplay(modelSceneWar)
    local modelFogMap        = getModelFogMap(modelSceneWar)

    modelPlayerManager:forEachModelPlayer(function(modelPlayer, playerIndex)
        if (modelPlayer:isAlive()) then
            local energy, req1, req2 = modelPlayer:getEnergy()
            dataForEachPlayer[playerIndex] = {
                nickname            = modelPlayer:getNickname(),
                fund                = ((not isReplay) and (modelFogMap:isFogOfWarCurrently()) and ((playerIndex ~= getPlayerIndexLoggedIn(modelSceneWar)))) and ("--") or (modelPlayer:getFund()),
                energy              = energy,
                req1                = req1,
                req2                = req2,
                damageCostPerEnergy = modelPlayer:getCurrentDamageCostPerEnergyRequirement(),
                idleUnitsCount      = 0,
                unitsCount          = 0,
                unitsValue          = 0,
                tilesCount          = 0,
                income              = 0,

                Headquarters        = 0,
                City                = 0,
                Factory             = 0,
                idleFactoriesCount  = 0,
                Airport             = 0,
                idleAirportsCount   = 0,
                Seaport             = 0,
                idleSeaportsCount   = 0,
                TempAirport         = 0,
                TempSeaport         = 0,
                CommandTower        = 0,
                Radar               = 0,
            }
        end
    end)

    return dataForEachPlayer
end

local function updateUnitsData(self, dataForEachPlayer)
    local updateUnitCountAndValue = function(modelUnit)
        local data          = dataForEachPlayer[modelUnit:getPlayerIndex()]
        data.unitsCount     = data.unitsCount + 1
        data.idleUnitsCount = data.idleUnitsCount + (modelUnit:isStateIdle() and 1 or 0)
        data.unitsValue     = data.unitsValue + round(modelUnit:getNormalizedCurrentHP() * modelUnit:getBaseProductionCost() / 10)
    end

    getModelUnitMap(self.m_ModelSceneWar):forEachModelUnitOnMap(updateUnitCountAndValue)
        :forEachModelUnitLoaded(updateUnitCountAndValue)
end

local function updateTilesData(self, dataForEachPlayer)
    local modelUnitMap = getModelUnitMap(self.m_ModelSceneWar)
    getModelTileMap(self.m_ModelSceneWar):forEachModelTile(function(modelTile)
        local playerIndex = modelTile:getPlayerIndex()
        if (playerIndex ~= 0) then
            local data = dataForEachPlayer[playerIndex]
            data.tilesCount = data.tilesCount + 1

            local tileType = modelTile:getTileType()
            if (data[tileType]) then
                data[tileType] = data[tileType] + 1
                if (not modelUnitMap:getModelUnit(modelTile:getGridIndex())) then
                    if     (tileType == "Factory") then data.idleFactoriesCount = data.idleFactoriesCount + 1
                    elseif (tileType == "Airport") then data.idleAirportsCount  = data.idleAirportsCount  + 1
                    elseif (tileType == "Seaport") then data.idleSeaportsCount  = data.idleSeaportsCount  + 1
                    end
                end
            end

            if (modelTile.getIncomeAmount) then
                data.income = data.income + (modelTile:getIncomeAmount() or 0)
            end
        end
    end)
end

local function getTilesInfo(tileTypeCounters, showIdleTilesCount)
    return string.format("%s: %d        %s: %d        %s: %d%s        %s: %d%s        %s: %d%s\n%s: %d        %s: %d        %s: %d        %s: %d",
        getLocalizedText(116, "Headquarters"), tileTypeCounters.Headquarters,
        getLocalizedText(116, "City"),         tileTypeCounters.City,
        getLocalizedText(116, "Factory"),      tileTypeCounters.Factory,
        ((showIdleTilesCount) and (string.format(" (%d)", tileTypeCounters.idleFactoriesCount)) or ("")),
        getLocalizedText(116, "Airport"),      tileTypeCounters.Airport,
        ((showIdleTilesCount) and (string.format(" (%d)", tileTypeCounters.idleAirportsCount)) or ("")),
        getLocalizedText(116, "Seaport"),      tileTypeCounters.Seaport,
        ((showIdleTilesCount) and (string.format(" (%d)", tileTypeCounters.idleSeaportsCount)) or ("")),
        getLocalizedText(116, "CommandTower"), tileTypeCounters.CommandTower,
        getLocalizedText(116, "Radar"),        tileTypeCounters.Radar,
        getLocalizedText(116, "TempAirport"),  tileTypeCounters.TempAirport,
        getLocalizedText(116, "TempSeaport"),  tileTypeCounters.TempSeaport
    )
end

local function getMapInfo(self)
    local modelSceneWar = self.m_ModelSceneWar
    local modelWarField = SingletonGetters.getModelWarField(modelSceneWar)
    local modelTileMap  = getModelTileMap(modelSceneWar)
    local tileTypeCounters = {
        Headquarters = 0,
        City         = 0,
        Factory      = 0,
        Airport      = 0,
        Seaport      = 0,
        TempAirport  = 0,
        TempSeaport  = 0,
        CommandTower = 0,
        Radar        = 0,
    }
    modelTileMap:forEachModelTile(function(modelTile)
        local tileType = modelTile:getTileType()
        if (tileTypeCounters[tileType]) then
            tileTypeCounters[tileType] = tileTypeCounters[tileType] + 1
        end
    end)

    return string.format("%s: %s      %s: %s\n%s: %s      %s: %d      %s: %d\n%s",
        getLocalizedText(65, "MapName"),   modelWarField:getWarFieldDisplayName(),
        getLocalizedText(65, "Author"),    modelWarField:getWarFieldAuthorName(),
        getLocalizedText(65, "WarID"),     modelSceneWar:getFileName():sub(13),
        getLocalizedText(65, "TurnIndex"), getModelTurnManager(modelSceneWar):getTurnIndex(),
        getLocalizedText(65, "ActionID"),  getActionId(modelSceneWar),
        getTilesInfo(tileTypeCounters)
    )
end

local function updateStringWarInfo(self)
    local dataForEachPlayer = generateEmptyDataForEachPlayer(self)
    updateUnitsData(self, dataForEachPlayer)
    updateTilesData(self, dataForEachPlayer)

    local stringList        = {getMapInfo(self)}
    local playerIndexInTurn = getModelTurnManager(self.m_ModelSceneWar):getPlayerIndex()
    for i = 1, getModelPlayerManager(self.m_ModelSceneWar):getPlayersCount() do
        if (not dataForEachPlayer[i]) then
            stringList[#stringList + 1] = string.format("%s %d: %s", getLocalizedText(65, "Player"), i, getLocalizedText(65, "Lost"))
        else
            local d              = dataForEachPlayer[i]
            local isPlayerInTurn = i == playerIndexInTurn
            stringList[#stringList + 1] = string.format("%s %d:    %s%s\n%s: %.2f / %s / %s      %s: %d\n%s: %s      %s: %d\n%s: %d%s      %s: %d\n%s: %d\n%s",
                getLocalizedText(65, "Player"),              i,           d.nickname,
                ((isPlayerInTurn) and (string.format(" (%s)", getLocalizedText(49))) or ("")),
                getLocalizedText(65, "Energy"),               d.energy,    "" .. (d.req1 or "--"), "" .. (d.req2 or "--"),
                getLocalizedText(65, "DamageCostPerEnergy"),  d.damageCostPerEnergy,
                getLocalizedText(65, "Fund"),                 "" .. d.fund,
                getLocalizedText(65, "Income"),               d.income,
                getLocalizedText(65, "UnitsCount"),           d.unitsCount,
                ((isPlayerInTurn) and (string.format(" (%d)", d.idleUnitsCount)) or ("")),
                getLocalizedText(65, "UnitsValue"),           d.unitsValue,
                getLocalizedText(65, "TilesCount"),           d.tilesCount,
                getTilesInfo(d, isPlayerInTurn)
            )
        end
    end

    self.m_StringWarInfo = table.concat(stringList, "\n--------------------\n")
end

local function updateStringSkillInfo(self)
    local stringList = {}
    getModelPlayerManager(self.m_ModelSceneWar):forEachModelPlayer(function(modelPlayer, playerIndex)
        stringList[#stringList + 1] = string.format("%s %d: %s\n%s",
            getLocalizedText(65, "Player"), playerIndex, modelPlayer:getNickname(),
            SkillDescriptionFunctions.getBriefDescription(modelPlayer:getModelSkillConfiguration())
        )
    end)

    self.m_StringSkillInfo = table.concat(stringList, "\n--------------------\n")
end

local function getAvailableMainItems(self)
    local modelSceneWar     = self.m_ModelSceneWar
    local playerIndexInTurn = getModelTurnManager(modelSceneWar):getPlayerIndex()
    if ((isTotalReplay(modelSceneWar))                               or
        (playerIndexInTurn ~= getPlayerIndexLoggedIn(modelSceneWar)) or
        (self.m_IsWaitingForServerResponse))                         then
        return {
            self.m_ItemQuit,
            self.m_ItemWarInfo,
            self.m_ItemSkillInfo,
            self.m_ItemAuxiliaryCommands,
            self.m_ItemHelp,
        }
    else
        local modelPlayer = getModelPlayerManager(modelSceneWar):getModelPlayer(playerIndexInTurn)
        local items = {
            self.m_ItemQuit,
            self.m_ItemDrawOrSurrender,
            self.m_ItemWarInfo,
            self.m_ItemSkillInfo,
        }
        items[#items + 1] = (modelPlayer:canActivateSkillGroup(1)) and (self.m_ItemActiveSkill1) or (nil)
        items[#items + 1] = (modelPlayer:canActivateSkillGroup(2)) and (self.m_ItemActiveSkill2) or (nil)
        items[#items + 1] = self.m_ItemAuxiliaryCommands
        items[#items + 1] = self.m_ItemHelp
        items[#items + 1] = self.m_ItemEndTurn

        return items
    end
end

local function dispatchEvtHideUI(self)
    getScriptEventDispatcher(self.m_ModelSceneWar):dispatchEvent({name = "EvtHideUI"})
end

local function dispatchEvtMapCursorMoved(self, gridIndex)
    getScriptEventDispatcher(self.m_ModelSceneWar):dispatchEvent({
        name      = "EvtMapCursorMoved",
        gridIndex = gridIndex,
    })
end

local function dispatchEvtWarCommandMenuUpdated(self)
    getScriptEventDispatcher(self.m_ModelSceneWar):dispatchEvent({
        name                = "EvtWarCommandMenuUpdated",
        modelWarCommandMenu = self,
    })
end

local function createWeaponPropertyText(unitType)
    local template   = GameConstantFunctions.getTemplateModelUnitWithName(unitType)
    local attackDoer = template.AttackDoer
    if (not attackDoer) then
        return ""
    else
        local maxAmmo = (attackDoer.primaryWeapon) and (attackDoer.primaryWeapon.maxAmmo) or (nil)
        return string.format("%s: %d - %d      %s: %s      %s: %s",
                getLocalizedText(9, "AttackRange"),        attackDoer.minAttackRange, attackDoer.maxAttackRange,
                getLocalizedText(9, "MaxAmmo"),            (maxAmmo) and ("" .. maxAmmo) or ("--"),
                getLocalizedText(9, "CanAttackAfterMove"), getLocalizedText(9, attackDoer.canAttackAfterMove)
            )
    end
end

local function createCommonPropertyText(unitType)
    local template   = GameConstantFunctions.getTemplateModelUnitWithName(unitType)
    local weaponText = createWeaponPropertyText(unitType)
    return string.format("%s: %d (%s)      %s: %d      %s: %d\n%s: %d      %s: %d      %s: %s%s",
        getLocalizedText(9, "Movement"),           template.MoveDoer.range, getLocalizedText(110, template.MoveDoer.type),
        getLocalizedText(9, "Vision"),             template.VisionOwner.vision,
        getLocalizedText(9, "ProductionCost"),     template.Producible.productionCost,
        getLocalizedText(9, "MaxFuel"),            template.FuelOwner.max,
        getLocalizedText(9, "ConsumptionPerTurn"), template.FuelOwner.consumptionPerTurn,
        getLocalizedText(9, "DestroyOnRunOut"),    getLocalizedText(9, template.FuelOwner.destroyOnOutOfFuel),
        ((string.len(weaponText) > 0) and ("\n" .. weaponText) or (weaponText))
    )
end

local function createDamageSubText(targetType, primaryDamage, secondaryDamage)
    local targetTypeText = getLocalizedText(113, targetType)
    local primaryText    = string.format("%s", primaryDamage[targetType]   or "--")
    local secondaryText  = string.format("%s", secondaryDamage[targetType] or "--")

    return string.format("%s:%s%s%s%s",
        targetTypeText, string.rep(" ", 30 - string.len(targetTypeText) / 3 * 4),
        primaryText,    string.rep(" ", 22 - string.len(primaryText) * 2),
        secondaryText
    )
end

local function createDamageText(unitType)
    local baseDamage = GameConstantFunctions.getBaseDamageForAttackerUnitType(unitType)
    if (not baseDamage) then
        return string.format("%s : %s", getLocalizedText(65, "DamageChart"), getLocalizedText(3, "None"))
    else
        local subTexts  = {}
        local primary   = baseDamage.primary or {}
        local secondary = baseDamage.secondary  or {}
        for _, targetType in ipairs(GameConstantFunctions.getCategory("AllUnits")) do
            subTexts[#subTexts + 1] = createDamageSubText(targetType, primary, secondary)
        end
        subTexts[#subTexts + 1] = createDamageSubText("Meteor", primary, secondary)

        local unitTypeText = getLocalizedText(65, "DamageChart")
        return string.format("%s%s%s          %s\n%s",
            unitTypeText, string.rep(" ", 28 - string.len(unitTypeText) / 3 * 4),
            getLocalizedText(65, "MainWeapon"), getLocalizedText(65, "SubWeapon"),
            table.concat(subTexts, "\n")
        )
    end
end

local function createUnitPropertyText(unitType)
    local template = GameConstantFunctions.getTemplateModelUnitWithName(unitType)
    return string.format("%s\n%s\n\n%s",
        getLocalizedText(114, unitType),
        createCommonPropertyText(unitType),
        createDamageText(unitType)
    )
end

local function getIdleTilesCount(self)
    local modelSceneWar = self.m_ModelSceneWar
    local modelUnitMap  = getModelUnitMap(modelSceneWar)
    local playerIndex   = getModelTurnManager(modelSceneWar):getPlayerIndex()
    local idleFactoriesCount, idleAirportsCount, idleSeaportsCount = 0, 0, 0

    getModelTileMap(modelSceneWar):forEachModelTile(function(modelTile)
        if ((modelTile:getPlayerIndex() == playerIndex) and (not modelUnitMap:getModelUnit(modelTile:getGridIndex()))) then
            local tileType = modelTile:getTileType()
            if     (tileType == "Airport") then idleAirportsCount  = idleAirportsCount  + 1
            elseif (tileType == "Factory") then idleFactoriesCount = idleFactoriesCount + 1
            elseif (tileType == "Seaport") then idleSeaportsCount  = idleSeaportsCount  + 1
            end
        end
    end)

    return idleFactoriesCount, idleAirportsCount, idleSeaportsCount
end

local function getIdleUnitsCount(self)
    local modelSceneWar = self.m_ModelSceneWar
    local playerIndex   = getModelTurnManager(modelSceneWar):getPlayerIndex()
    local count         = 0

    getModelUnitMap(modelSceneWar):forEachModelUnitOnMap(function(modelUnit)
        if ((modelUnit:getPlayerIndex() == playerIndex) and (modelUnit:isStateIdle())) then
            count = count + 1
        end
    end)

    return count
end

local function createEndTurnText(self)
    local idleFactoriesCount, idleAirportsCount, idleSeaportsCount = getIdleTilesCount(self)
    local idleUnitsCount                                           = getIdleUnitsCount(self)
    if (idleFactoriesCount + idleAirportsCount + idleSeaportsCount + idleUnitsCount == 0) then
        return string.format("%s\n%s", getLocalizedText(66, "NoIdleTilesOrUnits"), getLocalizedText(66, "EndTurnConfirmation"))
    else
        return string.format("%s: %d   %d   %d\n%s: %d\n%s",
            getLocalizedText(65, "IdleTiles"), idleFactoriesCount, idleAirportsCount, idleSeaportsCount,
            getLocalizedText(65, "IdleUnits"), idleUnitsCount,
            getLocalizedText(66, "EndTurnConfirmation")
        )
    end
end

--------------------------------------------------------------------------------
-- The functions for sending actions.
--------------------------------------------------------------------------------
local function createAndSendAction(self, rawAction, needActionID)
    local modelSceneWar = self.m_ModelSceneWar
    if (needActionID) then
        rawAction.actionID         = getActionId(modelSceneWar) + 1
        rawAction.sceneWarFileName = self.m_SceneWarFileName
    end

    WebSocketManager.sendAction(rawAction)
    getModelMessageIndicator(modelSceneWar):showPersistentMessage(getLocalizedText(80, "TransferingData"))
    getScriptEventDispatcher(modelSceneWar):dispatchEvent({
        name    = "EvtIsWaitingForServerResponse",
        waiting = true,
    })
end

local function sendActionActivateSkillGroup(self, skillGroupID)
    createAndSendAction(self, {
        actionCode   = ACTION_CODE_ACTIVATE_SKILL_GROUP,
        skillGroupID = skillGroupID,
    }, true)
end

local function sendActionDestroyOwnedModelUnit(self)
    createAndSendAction(self, {
        actionCode = ACTION_CODE_DESTROY_OWNED_UNIT,
        gridIndex  = self.m_MapCursorGridIndex,
    }, true)
end

local function sendActionEndTurn(self)
    createAndSendAction(self, {actionCode = ACTION_CODE_END_TURN}, true)
end

local function sendActionVoteForDraw(self, doesAgree)
    createAndSendAction(self, {
        actionCode = ACTION_CODE_VOTE_FOR_DRAW,
        doesAgree  = doesAgree,
    }, true)
end

local function sendActionReloadSceneWar(self)
    createAndSendAction(self, {
        actionCode       = ACTION_CODE_RELOAD_SCENE_WAR,
        sceneWarFileName = self.m_SceneWarFileName,
    }, false)
end

local function sendActionSurrender(self)
    createAndSendAction(self, {actionCode = ACTION_CODE_SURRENDER}, true)
end

--------------------------------------------------------------------------------
-- The state setters.
--------------------------------------------------------------------------------
local function setStateAuxiliaryCommands(self)
    self.m_State = "stateAuxiliaryCommands"

    if (self.m_View) then
        local modelSceneWar = self.m_ModelSceneWar
        local items         = {}
        if (not isTotalReplay(modelSceneWar)) then
            items[#items + 1] = self.m_ItemReload

            local playerIndexLoggedIn = getPlayerIndexLoggedIn(modelSceneWar)
            if ((playerIndexLoggedIn == getModelTurnManager(modelSceneWar):getPlayerIndex()) and
                (not self.m_IsWaitingForServerResponse))                                      then

                local gridIndex = self.m_MapCursorGridIndex
                local modelUnit = getModelUnitMap(modelSceneWar):getModelUnit(self.m_MapCursorGridIndex)
                if ((modelUnit) and (modelUnit:isStateIdle()) and (modelUnit:getPlayerIndex() == playerIndexLoggedIn)) then
                    items[#items + 1] = self.m_ItemDestroyOwnedUnit
                end

                items[#items + 1] = self.m_ItemFindIdleUnit
                items[#items + 1] = self.m_ItemFindIdleTile
            end
        end
        items[#items + 1] = self.m_ItemHideUI
        items[#items + 1] = self.m_ItemSetMusic

        self.m_View:setItems(items)
    end
end

local function setStateDisabled(self)
    self.m_State = "stateDisabled"

    if (self.m_View) then
        self.m_View:setEnabled(false)
    end
end

local function setStateDrawOrSurrender(self)
    self.m_State = "stateDrawOrSurrender"

    if (self.m_View) then
        local modelSceneWar     = self.m_ModelSceneWar
        local playerIndexInTurn = getModelTurnManager(modelSceneWar):getPlayerIndex()
        assert((not isTotalReplay(modelSceneWar)) and (getPlayerIndexLoggedIn(modelSceneWar) == playerIndexInTurn) and (not self.m_IsWaitingForServerResponse))

        local modelPlayer = getModelPlayerManager(modelSceneWar):getModelPlayer(playerIndexInTurn)
        local items       = {self.m_ItemSurrender}
        if (modelPlayer:hasVotedForDraw()) then
            -- do nothing.
        elseif (not modelSceneWar:getRemainingVotesForDraw()) then
            items[#items + 1] = self.m_ItemProposeDraw
        else
            items[#items + 1] = self.m_ItemAgreeDraw
            items[#items + 1] = self.m_ItemDisagreeDraw
        end
        self.m_View:setItems(items)
    end
end

local function setStateHelp(self)
    self.m_State = "stateHelp"

    if (self.m_View) then
        self.m_View:setItems({
            self.m_ItemUnitPropertyList,
            self.m_ItemGameFlow,
            self.m_ItemWarControl,
            self.m_ItemEssentialConcept,
            self.m_ItemSkillSystem,
            self.m_ItemAbout,
        })
    end
end

local function setStateMain(self)
    self.m_State = "stateMain"
    updateStringWarInfo(  self)
    updateStringSkillInfo(self)

    if (self.m_View) then
        self.m_View:setItems(getAvailableMainItems(self))
            :setOverviewString(self.m_StringWarInfo)
            :setEnabled(true)
    end
end

local function setStateUnitPropertyList(self)
    self.m_State = "stateUnitPropertyList"

    if (self.m_View) then
        self.m_View:setItems(self.m_ItemsUnitProperties)
    end
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtGridSelected(self, event)
    self.m_MapCursorGridIndex = GridIndexFunctions.clone(event.gridIndex)
end

local function onEvtMapCursorMoved(self, event)
    self.m_MapCursorGridIndex = GridIndexFunctions.clone(event.gridIndex)
end

local function onEvtIsWaitingForServerResponse(self, event)
    self.m_IsWaitingForServerResponse = event.waiting
end

--------------------------------------------------------------------------------
-- The composition items.
--------------------------------------------------------------------------------
local function initItemAbout(self)
    self.m_ItemAbout = {
        name     = getLocalizedText(1, "About"),
        callback = function()
            self.m_View:setOverviewString(getLocalizedText(2, 3))
        end,
    }
end

local function createItemActivateSkill(self, skillGroupID)
    return {
        name     = string.format("%s %d", getLocalizedText(65, "ActivateSkill"), skillGroupID),
        callback = function()
            sendActionActivateSkillGroup(self, skillGroupID)
            self:setEnabled(false)
        end,
    }
end

local function initItemActivateSkill1(self)
    self.m_ItemActiveSkill1 = createItemActivateSkill(self, 1)
end

local function initItemActivateSkill2(self)
    self.m_ItemActiveSkill2 = createItemActivateSkill(self, 2)
end

local function initItemAgreeDraw(self)
    self.m_ItemAgreeDraw = {
        name = getLocalizedText(65, "AgreeDraw"),
        callback = function()
            local modelConfirmBox = getModelConfirmBox(self.m_ModelSceneWar)
            modelConfirmBox:setConfirmText(getLocalizedText(66, "AgreeDraw"))
                :setOnConfirmYes(function()
                    sendActionVoteForDraw(self, true)
                    modelConfirmBox:setEnabled(false)
                    self:setEnabled(false)
                end)
                :setEnabled(true)
        end,
    }
end

local function initItemAuxiliaryCommands(self)
    self.m_ItemAuxiliaryCommands = {
        name     = getLocalizedText(65, "AuxiliaryCommands"),
        callback = function()
            setStateAuxiliaryCommands(self)
        end,
    }
end

local function initItemDestroyOwnedUnit(self)
    self.m_ItemDestroyOwnedUnit = {
        name     = getLocalizedText(65, "DestroyOwnedUnit"),
        callback = function()
            local modelConfirmBox = getModelConfirmBox(self.m_ModelSceneWar)
            modelConfirmBox:setConfirmText(getLocalizedText(66, "DestroyOwnedUnit"))
                :setOnConfirmYes(function()
                    modelConfirmBox:setEnabled(false)
                    self:setEnabled(false)
                    sendActionDestroyOwnedModelUnit(self)
                end)
                :setEnabled(true)
        end,
    }
end

local function initItemDisagreeDraw(self)
    self.m_ItemDisagreeDraw = {
        name = getLocalizedText(65, "DisagreeDraw"),
        callback = function()
            local modelConfirmBox = getModelConfirmBox(self.m_ModelSceneWar)
            modelConfirmBox:setConfirmText(getLocalizedText(66, "DisagreeDraw"))
                :setOnConfirmYes(function()
                    sendActionVoteForDraw(self, false)
                    modelConfirmBox:setEnabled(false)
                    self:setEnabled(false)
                end)
                :setEnabled(true)
        end,
    }
end

local function initItemDrawOrSurrender(self)
    self.m_ItemDrawOrSurrender = {
        name     = getLocalizedText(65, "DrawOrSurrender"),
        callback = function()
            setStateDrawOrSurrender(self)
        end
    }
end

local function initItemEndTurn(self)
    self.m_ItemEndTurn = {
        name     = getLocalizedText(65, "EndTurn"),
        callback = function()
            local modelSceneWar = self.m_ModelSceneWar
            if ((modelSceneWar:getRemainingVotesForDraw())                                                                                          and
                (not getModelPlayerManager(modelSceneWar):getModelPlayer(getModelTurnManager(modelSceneWar):getPlayerIndex()):hasVotedForDraw())) then
                getModelMessageIndicator(modelSceneWar):showMessage(getLocalizedText(66, "RequireVoteForDraw"))
            else
                local modelConfirmBox = getModelConfirmBox(modelSceneWar)
                modelConfirmBox:setConfirmText(createEndTurnText(self))
                    :setOnConfirmYes(function()
                        modelConfirmBox:setEnabled(false)
                        self:setEnabled(false)
                        sendActionEndTurn(self)
                    end)
                    :setEnabled(true)
            end
        end,
    }
end

local function initItemEssentialConcept(self)
    self.m_ItemEssentialConcept = {
        name     = getLocalizedText(1, "EssentialConcept"),
        callback = function()
            self.m_View:setOverviewString(getLocalizedText(2, 4))
        end,
    }
end

local function initItemFindIdleUnit(self)
    local item = {
        name     = getLocalizedText(65, "FindIdleUnit"),
        callback = function()
            local modelUnitMap        = getModelUnitMap(self.m_ModelSceneWar)
            local mapSize             = modelUnitMap:getMapSize()
            local cursorX, cursorY    = self.m_MapCursorGridIndex.x, self.m_MapCursorGridIndex.y
            local playerIndexLoggedIn = getPlayerIndexLoggedIn(self.m_ModelSceneWar)
            local firstGridIndex

            for y = 1, mapSize.height do
                for x = 1, mapSize.width do
                    local gridIndex = {x = x, y = y}
                    local modelUnit = modelUnitMap:getModelUnit(gridIndex)
                    if ((modelUnit)                                         and
                        (modelUnit:getPlayerIndex() == playerIndexLoggedIn) and
                        (modelUnit:isStateIdle()))                          then
                        if ((y > cursorY)                       or
                            ((y == cursorY) and (x > cursorX))) then
                            dispatchEvtMapCursorMoved(self, gridIndex)
                            self:setEnabled(false)
                            return
                        end

                        firstGridIndex = firstGridIndex or gridIndex
                    end
                end
            end

            if (firstGridIndex) then
                dispatchEvtMapCursorMoved(self, firstGridIndex)
            else
                getModelMessageIndicator(self.m_ModelSceneWar):showMessage(getLocalizedText(66, "NoIdleUnit"))
            end
            self:setEnabled(false)
        end,
    }

    self.m_ItemFindIdleUnit = item
end

local function initItemFindIdleTile(self)
    local item = {
        name     = getLocalizedText(65, "FindIdleTile"),
        callback = function()
            local modelSceneWar       = self.m_ModelSceneWar
            local playerIndexLoggedIn = getPlayerIndexLoggedIn(modelSceneWar)
            local modelUnitMap        = getModelUnitMap(modelSceneWar)
            local modelTileMap        = getModelTileMap(modelSceneWar)
            local mapSize             = modelUnitMap:getMapSize()
            local cursorX, cursorY    = self.m_MapCursorGridIndex.x, self.m_MapCursorGridIndex.y
            local firstGridIndex

            for y = 1, mapSize.height do
                for x = 1, mapSize.width do
                    local gridIndex = {x = x, y = y}
                    local modelTile = modelTileMap:getModelTile(gridIndex)
                    if ((modelTile.getProductionList)                       and
                        (modelTile:getPlayerIndex() == playerIndexLoggedIn) and
                        (not modelUnitMap:getModelUnit(gridIndex)))         then
                        if ((y > cursorY)                       or
                            ((y == cursorY) and (x > cursorX))) then
                            dispatchEvtMapCursorMoved(self, gridIndex)
                            self:setEnabled(false)
                            return
                        end

                        firstGridIndex = firstGridIndex or gridIndex
                    end
                end
            end

            if (firstGridIndex) then
                dispatchEvtMapCursorMoved(self, firstGridIndex)
            else
                getModelMessageIndicator(self.m_ModelSceneWar):showMessage(getLocalizedText(66, "NoIdleTile"))
            end
            self:setEnabled(false)
        end,
    }

    self.m_ItemFindIdleTile = item
end

local function initItemGameFlow(self)
    local item = {
        name     = getLocalizedText(1, "GameFlow"),
        callback = function()
            if (self.m_View) then
                self.m_View:setOverviewString(getLocalizedText(2, 1))
            end
        end,
    }

    self.m_ItemGameFlow = item
end

local function initItemHelp(self)
    local item = {
        name     = getLocalizedText(65, "Help"),
        callback = function()
            setStateHelp(self)
        end
    }

    self.m_ItemHelp = item
end

local function initItemHideUI(self)
    local item = {
        name     = getLocalizedText(65, "HideUI"),
        callback = function()
            setStateDisabled(self)

            dispatchEvtWarCommandMenuUpdated(self)
            dispatchEvtHideUI(self)
        end,
    }

    self.m_ItemHideUI = item
end

local function initItemProposeDraw(self)
    self.m_ItemProposeDraw = {
        name     = getLocalizedText(65, "ProposeDraw"),
        callback = function()
            local modelConfirmBox = getModelConfirmBox(self.m_ModelSceneWar)
            modelConfirmBox:setConfirmText(getLocalizedText(66, "ProposeDraw"))
                :setOnConfirmYes(function()
                    sendActionVoteForDraw(self, true)
                    modelConfirmBox:setEnabled(false)
                    self:setEnabled(false)
                end)
                :setEnabled(true)
        end,
    }
end

local function initItemSkillInfo(self)
    local item = {
        name     = getLocalizedText(65, "SkillInfo"),
        callback = function()
            if (self.m_View) then
                self.m_View:setOverviewString(self.m_StringSkillInfo)
            end
        end,
    }

    self.m_ItemSkillInfo = item
end

local function initItemSkillSystem(self)
    local item = {
        name     = getLocalizedText(1, "SkillSystem"),
        callback = function()
            self.m_View:setOverviewString(getLocalizedText(2, 5))
        end,
    }

    self.m_ItemSkillSystem = item
end

local function initItemUnitPropertyList(self)
    local item = {
        name     = getLocalizedText(65, "UnitPropertyList"),
        callback = function()
            setStateUnitPropertyList(self)
        end,
    }

    self.m_ItemUnitPropertyList = item
end

local function initItemsUnitProperties(self)
    local items    = {}
    local allUnits = GameConstantFunctions.getCategory("AllUnits")
    for _, unitType in ipairs(allUnits) do
        items[#items + 1] = {
            name     = getLocalizedText(113, unitType),
            callback = function()
                if (self.m_View) then
                    self.m_View:setOverviewString(createUnitPropertyText(unitType))
                end
            end,
        }
    end

    self.m_ItemsUnitProperties = items
end

local function initItemQuit(self)
    local item = {
        name     = getLocalizedText(65, "QuitWar"),
        callback = function()
            getModelConfirmBox(self.m_ModelSceneWar):setConfirmText(getLocalizedText(66, "QuitWar"))
                :setOnConfirmYes(function()
                    local modelSceneMain = Actor.createModel("sceneMain.ModelSceneMain", {isPlayerLoggedIn = WebSocketManager.getLoggedInAccountAndPassword() ~= nil})
                    local actorSceneMain = Actor.createWithModelAndViewInstance(modelSceneMain, Actor.createView("sceneMain.ViewSceneMain"))
                    ActorManager.setAndRunRootActor(actorSceneMain, "FADE", 1)
                end)
                :setEnabled(true)
        end,
    }

    self.m_ItemQuit = item
end

local function initItemReload(self)
    local item = {
        name     = getLocalizedText(65, "ReloadWar"),
        callback = function()
            local modelConfirmBox = getModelConfirmBox(self.m_ModelSceneWar)
            modelConfirmBox:setConfirmText(getLocalizedText(66, "ReloadWar"))
                :setOnConfirmYes(function()
                    modelConfirmBox:setEnabled(false)
                    self:setEnabled(false)
                    sendActionReloadSceneWar(self)
                end)
                :setEnabled(true)
        end,
    }

    self.m_ItemReload = item
end

local function initItemSetMusic(self)
    local item = {
        name     = getLocalizedText(1, "SetMusic"),
        callback = function()
            local isEnabled = not AudioManager.isEnabled()
            AudioManager.setEnabled(isEnabled)
            if (isEnabled) then
                AudioManager.playRandomWarMusic()
            end
        end,
    }

    self.m_ItemSetMusic = item
end

local function initItemSurrender(self)
    local item = {
        name     = getLocalizedText(65, "Surrender"),
        callback = function()
            local modelConfirmBox = getModelConfirmBox(self.m_ModelSceneWar)
            modelConfirmBox:setConfirmText(getLocalizedText(66, "Surrender"))
                :setOnConfirmYes(function()
                    modelConfirmBox:setEnabled(false)
                    self:setEnabled(false)
                    sendActionSurrender(self)
                end)
                :setEnabled(true)
        end,
    }

    self.m_ItemSurrender = item
end

local function initItemWarControl(self)
    local item = {
        name     = getLocalizedText(1, "WarControl"),
        callback = function()
            self.m_View:setOverviewString(getLocalizedText(2, 2))
        end,
    }

    self.m_ItemWarControl = item
end

local function initItemWarInfo(self)
    local item = {
        name     = getLocalizedText(65, "WarInfo"),
        callback = function()
            if (self.m_View) then
                self.m_View:setOverviewString(self.m_StringWarInfo)
            end
        end,
    }

    self.m_ItemWarInfo = item
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:ctor(param)
    self.m_IsWaitingForServerResponse = false
    self.m_State                      = "stateDisabled"

    initItemAbout(            self)
    initItemActivateSkill1(   self)
    initItemActivateSkill2(   self)
    initItemAgreeDraw(        self)
    initItemAuxiliaryCommands(self)
    initItemDestroyOwnedUnit( self)
    initItemDisagreeDraw(     self)
    initItemDrawOrSurrender(  self)
    initItemEndTurn(          self)
    initItemEssentialConcept( self)
    initItemFindIdleTile(     self)
    initItemFindIdleUnit(     self)
    initItemGameFlow(         self)
    initItemHelp(             self)
    initItemHideUI(           self)
    initItemProposeDraw(      self)
    initItemQuit(             self)
    initItemReload(           self)
    initItemSkillInfo(        self)
    initItemSkillSystem(      self)
    initItemSetMusic(         self)
    initItemSurrender(        self)
    initItemsUnitProperties(  self)
    initItemUnitPropertyList( self)
    initItemWarControl(       self)
    initItemWarInfo(          self)

    return self
end

--------------------------------------------------------------------------------
-- The public callback function on start running or script events.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:onStartRunning(modelSceneWar, sceneWarFileName)
    self.m_ModelSceneWar    = modelSceneWar
    self.m_SceneWarFileName = sceneWarFileName
    getScriptEventDispatcher(modelSceneWar)
        :addEventListener("EvtIsWaitingForServerResponse", self)
        :addEventListener("EvtGridSelected",               self)
        :addEventListener("EvtMapCursorMoved",             self)

    return self
end

function ModelWarCommandMenu:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtGridSelected")               then onEvtGridSelected(              self, event)
    elseif (eventName == "EvtMapCursorMoved")             then onEvtMapCursorMoved(            self, event)
    elseif (eventName == "EvtIsWaitingForServerResponse") then onEvtIsWaitingForServerResponse(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:isEnabled()
    return self.m_State ~= "stateDisabled"
end

function ModelWarCommandMenu:setEnabled(enabled)
    if (enabled) then
        setStateMain(self)
    else
        setStateDisabled(self)
    end
    dispatchEvtWarCommandMenuUpdated(self)

    return self
end

function ModelWarCommandMenu:onButtonBackTouched()
    local state = self.m_State
    if     (state == "stateAuxiliaryCommands") then setStateMain(self)
    elseif (state == "stateDrawOrSurrender")   then setStateMain(self)
    elseif (state == "stateHelp")              then setStateMain(self)
    elseif (state == "stateMain")              then self:setEnabled(false)
    elseif (state == "stateUnitPropertyList")  then setStateHelp(self)
    else                                       error("ModelWarCommandMenu:onButtonBackTouched() the state is invalid: " .. (state or ""))
    end

    return self
end

return ModelWarCommandMenu
