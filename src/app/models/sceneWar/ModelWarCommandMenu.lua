
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
local getSceneWarFileName      = SingletonGetters.getSceneWarFileName
local getScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher
local isTotalReplay            = SingletonGetters.isTotalReplay
local round                    = require("src.global.functions.round")

local ACTION_CODE_ACTIVATE_SKILL_GROUP = ActionCodeFunctions.getActionCode("ActionActivateSkillGroup")
local ACTION_CODE_END_TURN             = ActionCodeFunctions.getActionCode("ActionEndTurn")
local ACTION_CODE_RELOAD_SCENE_WAR     = ActionCodeFunctions.getActionCode("ActionReloadSceneWar")
local ACTION_CODE_SURRENDER            = ActionCodeFunctions.getActionCode("ActionSurrender")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function generateEmptyDataForEachPlayer()
    local modelPlayerManager = getModelPlayerManager()
    local dataForEachPlayer  = {}
    local isTotalReplay      = isTotalReplay()

    modelPlayerManager:forEachModelPlayer(function(modelPlayer, playerIndex)
        if (modelPlayer:isAlive()) then
            local energy, req1, req2 = modelPlayer:getEnergy()
            dataForEachPlayer[playerIndex] = {
                nickname            = modelPlayer:getNickname(),
                fund                = ((not isTotalReplay) and (getModelFogMap():isFogOfWarCurrently()) and ((playerIndex ~= getPlayerIndexLoggedIn()))) and ("--") or (modelPlayer:getFund()),
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

local function updateUnitsData(dataForEachPlayer)
    local updateUnitCountAndValue = function(modelUnit)
        local data          = dataForEachPlayer[modelUnit:getPlayerIndex()]
        data.unitsCount     = data.unitsCount + 1
        data.idleUnitsCount = data.idleUnitsCount + (modelUnit:isStateIdle() and 1 or 0)
        data.unitsValue     = data.unitsValue + round(modelUnit:getNormalizedCurrentHP() * modelUnit:getBaseProductionCost() / 10)
    end

    getModelUnitMap():forEachModelUnitOnMap(updateUnitCountAndValue)
        :forEachModelUnitLoaded(updateUnitCountAndValue)
end

local function updateTilesData(dataForEachPlayer)
    local modelUnitMap = getModelUnitMap()
    getModelTileMap():forEachModelTile(function(modelTile)
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

local function getMapInfo()
    local modelWarField = SingletonGetters.getModelWarField()
    local modelTileMap  = modelWarField:getModelTileMap()
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

    return string.format("%s: %s      %s: %s\n%s: %s      %s: %d\n%s",
        getLocalizedText(65, "MapName"),   modelWarField:getWarFieldDisplayName(),
        getLocalizedText(65, "Author"),    modelWarField:getWarFieldAuthorName(),
        getLocalizedText(65, "WarID"),     getSceneWarFileName():sub(13),
        getLocalizedText(65, "TurnIndex"), getModelTurnManager():getTurnIndex(),
        getTilesInfo(tileTypeCounters)
    )
end

local function updateStringWarInfo(self)
    local dataForEachPlayer = generateEmptyDataForEachPlayer()
    updateUnitsData(dataForEachPlayer)
    updateTilesData(dataForEachPlayer)

    local stringList        = {getMapInfo()}
    local playerIndexInTurn = getModelTurnManager():getPlayerIndex()
    for i = 1, getModelPlayerManager():getPlayersCount() do
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
    getModelPlayerManager():forEachModelPlayer(function(modelPlayer, playerIndex)
        stringList[#stringList + 1] = string.format("%s %d: %s\n%s",
            getLocalizedText(65, "Player"), playerIndex, modelPlayer:getNickname(),
            SkillDescriptionFunctions.getBriefDescription(modelPlayer:getModelSkillConfiguration())
        )
    end)

    self.m_StringSkillInfo = table.concat(stringList, "\n--------------------\n")
end

local function getAvailableMainItems(self)
    local modelSceneWar     = SingletonGetters.getModelScene(self.m_SceneWarFileName)
    local playerIndexInTurn = getModelTurnManager(modelSceneWar):getPlayerIndex()
    if (isTotalReplay(modelSceneWar)) then
        return {
            self.m_ItemQuit,
            self.m_ItemWarInfo,
            self.m_ItemSkillInfo,
            self.m_ItemAuxiliaryCommands,
            self.m_ItemUnitPropertyList,
        }
    elseif ((playerIndexInTurn ~= getPlayerIndexLoggedIn(modelSceneWar)) or (self.m_IsWaitingForServerResponse)) then
        return {
            self.m_ItemQuit,
            self.m_ItemWarInfo,
            self.m_ItemSkillInfo,
            self.m_ItemAuxiliaryCommands,
            self.m_ItemUnitPropertyList,
        }
    else
        local modelPlayer = getModelPlayerManager():getModelPlayer(playerIndexInTurn)
        local items = {
            self.m_ItemQuit,
            self.m_ItemSurrender,
            self.m_ItemWarInfo,
            self.m_ItemSkillInfo,
        }
        items[#items + 1] = (modelPlayer:canActivateSkillGroup(1)) and (self.m_ItemActiveSkill1) or (nil)
        items[#items + 1] = (modelPlayer:canActivateSkillGroup(2)) and (self.m_ItemActiveSkill2) or (nil)
        items[#items + 1] = self.m_ItemAuxiliaryCommands
        items[#items + 1] = self.m_ItemUnitPropertyList
        items[#items + 1] = self.m_ItemEndTurn

        return items
    end
end

local function dispatchEvtHideUI()
    getScriptEventDispatcher():dispatchEvent({name = "EvtHideUI"})
end

local function dispatchEvtMapCursorMoved(self, gridIndex)
    getScriptEventDispatcher():dispatchEvent({
        name      = "EvtMapCursorMoved",
        gridIndex = gridIndex,
    })
end

local function dispatchEvtWarCommandMenuUpdated(self)
    getScriptEventDispatcher():dispatchEvent({
        name                = "EvtWarCommandMenuUpdated",
        modelWarCommandMenu = self,
    })
end

local function getEmptyProducersCount(self)
    local modelUnitMap = getModelUnitMap()
    local count        = 0
    local playerIndex  = getModelTurnManager():getPlayerIndex()

    getModelTileMap():forEachModelTile(function(modelTile)
        if ((modelTile.getProductionList)                                 and
            (modelTile:getPlayerIndex() == playerIndex)                   and
            (modelUnitMap:getModelUnit(modelTile:getGridIndex()) == nil)) then
            count = count + 1
        end
    end)

    return count
end

local function getIdleUnitsCount(self)
    local count       = 0
    local playerIndex = getModelTurnManager():getPlayerIndex()
    getModelUnitMap():forEachModelUnitOnMap(function(modelUnit)
        if ((modelUnit:getPlayerIndex() == playerIndex) and (modelUnit:isStateIdle())) then
            count = count + 1
        end
    end)

    return count
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

--------------------------------------------------------------------------------
-- The functions for sending actions.
--------------------------------------------------------------------------------
local function createAndSendAction(rawAction, needActionID)
    if (needActionID) then
        rawAction.actionID         = getActionId() + 1
        rawAction.sceneWarFileName = getSceneWarFileName()
    end

    WebSocketManager.sendAction(rawAction)
    getModelMessageIndicator():showPersistentMessage(getLocalizedText(80, "TransferingData"))
    getScriptEventDispatcher():dispatchEvent({
        name    = "EvtIsWaitingForServerResponse",
        waiting = true,
    })
end

local function sendActionActivateSkillGroup(skillGroupID)
    createAndSendAction({
        actionCode   = ACTION_CODE_ACTIVATE_SKILL_GROUP,
        skillGroupID = skillGroupID,
    }, true)
end

local function sendActionSurrender()
    createAndSendAction({actionCode = ACTION_CODE_SURRENDER}, true)
end

local function sendActionEndTurn()
    createAndSendAction({actionCode = ACTION_CODE_END_TURN}, true)
end

local function sendActionReloadSceneWar()
    createAndSendAction({
        actionCode       = ACTION_CODE_RELOAD_SCENE_WAR,
        sceneWarFileName = getSceneWarFileName(),
    }, false)
end

--------------------------------------------------------------------------------
-- The state setters.
--------------------------------------------------------------------------------
local function setStateAuxiliaryCommands(self)
    self.m_State = "AuxiliaryCommands"

    if (self.m_View) then
        local modelSceneWar = SingletonGetters.getModelScene(self.m_SceneWarFileName)
        local items         = {}
        if (not modelSceneWar:isTotalReplay()) then
            items[#items + 1] = self.m_ItemReload

            if (getPlayerIndexLoggedIn(modelSceneWar) == modelSceneWar:getModelTurnManager():getPlayerIndex()) then
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
    self.m_State = "Disabled"

    if (self.m_View) then
        self.m_View:setEnabled(false)
    end
end

local function setStateMain(self)
    self.m_State = "Main"
    updateStringWarInfo(  self)
    updateStringSkillInfo(self)

    if (self.m_View) then
        self.m_View:setItems(getAvailableMainItems(self))
            :setOverviewString(self.m_StringWarInfo)
            :setEnabled(true)
    end
end

local function setStateUnitPropertyList(self)
    self.m_State = "UnitPropertyList"

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
local function createItemActivateSkill(self, skillGroupID)
    return {
        name     = string.format("%s %d", getLocalizedText(65, "ActivateSkill"), skillGroupID),
        callback = function()
            sendActionActivateSkillGroup(skillGroupID)
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

local function initItemAuxiliaryCommands(self)
    local item = {
        name     = getLocalizedText(65, "AuxiliaryCommands"),
        callback = function()
            setStateAuxiliaryCommands(self)
        end,
    }

    self.m_ItemAuxiliaryCommands = item
end

local function initItemEndTurn(self)
    local item = {
        name     = getLocalizedText(65, "EndTurn"),
        callback = function()
            local modelConfirmBox = getModelConfirmBox()
            modelConfirmBox:setConfirmText(getLocalizedText(70, getEmptyProducersCount(self), getIdleUnitsCount(self)))
                :setOnConfirmYes(function()
                    modelConfirmBox:setEnabled(false)
                    self:setEnabled(false)
                    sendActionEndTurn()
                end)
                :setEnabled(true)
        end,
    }

    self.m_ItemEndTurn = item
end

local function initItemFindIdleUnit(self)
    local item = {
        name     = getLocalizedText(65, "FindIdleUnit"),
        callback = function()
            local modelUnitMap        = getModelUnitMap()
            local mapSize             = modelUnitMap:getMapSize()
            local cursorX, cursorY    = self.m_MapCursorGridIndex.x, self.m_MapCursorGridIndex.y
            local playerIndexLoggedIn = getPlayerIndexLoggedIn()
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
                getModelMessageIndicator():showMessage(getLocalizedText(66, "NoIdleUnit"))
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
            local playerIndexLoggedIn = getPlayerIndexLoggedIn()
            local modelUnitMap        = getModelUnitMap()
            local modelTileMap        = getModelTileMap()
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
                getModelMessageIndicator():showMessage(getLocalizedText(66, "NoIdleTile"))
            end
            self:setEnabled(false)
        end,
    }

    self.m_ItemFindIdleTile = item
end

local function initItemHideUI(self)
    local item = {
        name     = getLocalizedText(65, "HideUI"),
        callback = function()
            setStateDisabled(self)

            dispatchEvtWarCommandMenuUpdated(self)
            dispatchEvtHideUI()
        end,
    }

    self.m_ItemHideUI = item
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
            getModelConfirmBox():setConfirmText(getLocalizedText(66, "QuitWar"))
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
            local modelConfirmBox = getModelConfirmBox()
            modelConfirmBox:setConfirmText(getLocalizedText(66, "ReloadWar"))
                :setOnConfirmYes(function()
                    modelConfirmBox:setEnabled(false)
                    self:setEnabled(false)
                    sendActionReloadSceneWar()
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
            local modelConfirmBox = getModelConfirmBox()
            modelConfirmBox:setConfirmText(getLocalizedText(66, "Surrender"))
                :setOnConfirmYes(function()
                    modelConfirmBox:setEnabled(false)
                    self:setEnabled(false)
                    sendActionSurrender()
                end)
                :setEnabled(true)
        end,
    }

    self.m_ItemSurrender = item
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:ctor(param)
    self.m_IsWaitingForServerResponse = false

    initItemActivateSkill1(   self)
    initItemActivateSkill2(   self)
    initItemAuxiliaryCommands(self)
    initItemEndTurn(          self)
    initItemFindIdleUnit(     self)
    initItemFindIdleTile(     self)
    initItemHideUI(           self)
    initItemWarInfo(          self)
    initItemSkillInfo(        self)
    initItemUnitPropertyList( self)
    initItemsUnitProperties(  self)
    initItemQuit(             self)
    initItemReload(           self)
    initItemSetMusic(         self)
    initItemSurrender(        self)

    return self
end

--------------------------------------------------------------------------------
-- The public callback function on start running or script events.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:onStartRunning(modelSceneWar, sceneWarFileName)
    self.m_SceneWarFileName = sceneWarFileName
    getScriptEventDispatcher()
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
    return self.m_State ~= "Disabled"
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
    if     (state == "AuxiliaryCommands") then setStateMain(self)
    elseif (state == "Main")              then self:setEnabled(false)
    elseif (state == "UnitPropertyList")  then setStateMain(self)
    else                                  error("ModelWarCommandMenu:onButtonBackTouched() the state is invalid: " .. (state or ""))
    end

    return self
end

return ModelWarCommandMenu
