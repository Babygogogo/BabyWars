
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

local AudioManager              = require("src.app.utilities.AudioManager")
local LocalizationFunctions     = require("src.app.utilities.LocalizationFunctions")
local GameConstantFunctions     = require("src.app.utilities.GameConstantFunctions")
local GridIndexFunctions        = require("src.app.utilities.GridIndexFunctions")
local SingletonGetters          = require("src.app.utilities.SingletonGetters")
local SkillDescriptionFunctions = require("src.app.utilities.SkillDescriptionFunctions")
local WebSocketManager          = require("src.app.utilities.WebSocketManager")
local Actor                     = require("src.global.actors.Actor")
local ActorManager              = require("src.global.actors.ActorManager")

local getLocalizedText = LocalizationFunctions.getLocalizedText

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function updateStringWarInfo(self)
    local modelPlayerManager = SingletonGetters.getModelPlayerManager()
    local data               = {}

    modelPlayerManager:forEachModelPlayer(function(modelPlayer, playerIndex)
        if (modelPlayer:isAlive()) then
            local energy, req1, req2 = modelPlayer:getEnergy()
            data[playerIndex] = {
                nickname   = modelPlayer:getNickname(),
                fund       = modelPlayer:getFund(),
                energy     = energy,
                req1       = req1,
                req2       = req2,
                unitsCount = 0,
                tilesCount = 0,
                income     = 0,
            }
        end
    end)

    SingletonGetters.getModelUnitMap():forEachModelUnitOnMap(function(modelUnit)
        local unitsCount = 1
        if (modelUnit.getCurrentLoadCount) then
            unitsCount = unitsCount + modelUnit:getCurrentLoadCount()
        end

        local playerIndex = modelUnit:getPlayerIndex()
        data[playerIndex].unitsCount = data[playerIndex].unitsCount + unitsCount
    end)

    SingletonGetters.getModelTileMap():forEachModelTile(function(modelTile)
        local playerIndex = modelTile:getPlayerIndex()
        if (playerIndex ~= 0) then
            data[playerIndex].tilesCount = data[playerIndex].tilesCount + 1
            if (modelTile.getIncomeAmount) then
                data[playerIndex].income = data[playerIndex].income + (modelTile:getIncomeAmount() or 0)
            end
        end
    end)

    local playersCount = modelPlayerManager:getPlayersCount()
    local stringList   = {}
    for i = 1, playersCount do
        if (not data[i]) then
            stringList[i] = string.format("%s %d: %s", getLocalizedText(65, "Player"), i, getLocalizedText(65, "Lost"))
        else
            local d = data[i]
            stringList[i] = string.format("%s %d:\n%s: %s\n%s: %d\n%s: %d\n%s: %.2f / %s / %s\n%s: %d\n%s: %d",
                getLocalizedText(65, "Player"),     i,
                getLocalizedText(65, "Nickname"),   d.nickname,
                getLocalizedText(65, "Fund"),       d.fund,
                getLocalizedText(65, "Income"),     d.income,
                getLocalizedText(65, "Energy"),     d.energy,    "" .. (d.req1 or "--"), "" .. (d.req2 or "--"),
                getLocalizedText(65, "UnitsCount"), d.unitsCount,
                getLocalizedText(65, "TilesCount"), d.tilesCount
            )
        end
    end

    self.m_StringWarInfo = table.concat(stringList, "\n--------------------\n")
end

local function updateStringSkillInfo(self)
    local stringList = {}
    SingletonGetters.getModelPlayerManager():forEachModelPlayer(function(modelPlayer, playerIndex)
        stringList[#stringList + 1] = string.format("%s %d: %s",
            getLocalizedText(65, "Player"), playerIndex,
            SkillDescriptionFunctions.getDescription(modelPlayer:getModelSkillConfiguration())
        )
    end)

    self.m_StringSkillInfo = table.concat(stringList, "\n--------------------\n")
end

local function getAvailableMainItems(self)
    if ((not self.m_IsPlayerInTurn) or (self.m_IsWaitingForServerResponse)) then
        return {
            self.m_ItemQuit,
            self.m_ItemWarInfo,
            self.m_ItemSkillInfo,
            self.m_ItemHideUI,
            self.m_ItemSetMusic,
            self.m_ItemReload,
            self.m_ItemDamageChart,
        }
    else
        local modelPlayer = SingletonGetters.getModelPlayerManager():getModelPlayer(self.m_PlayerIndex)
        local items = {
            self.m_ItemQuit,
            self.m_ItemFindIdleUnit,
            self.m_ItemFindIdleTile,
            self.m_ItemSurrender,
            self.m_ItemWarInfo,
            self.m_ItemSkillInfo,
        }
        items[#items + 1] = (modelPlayer:canActivateSkillGroup(1)) and (self.m_ItemActiveSkill1) or (nil)
        items[#items + 1] = (modelPlayer:canActivateSkillGroup(2)) and (self.m_ItemActiveSkill2) or (nil)
        items[#items + 1] = self.m_ItemHideUI
        items[#items + 1] = self.m_ItemSetMusic
        items[#items + 1] = self.m_ItemReload
        items[#items + 1] = self.m_ItemDamageChart
        items[#items + 1] = self.m_ItemEndTurn

        return items
    end
end

local function setStateDisabled(self)
    self.m_State = "disabled"

    if (self.m_View) then
        self.m_View:setEnabled(false)
    end
end

local function setStateMain(self)
    self.m_State = "main"
    updateStringWarInfo(  self)
    updateStringSkillInfo(self)

    if (self.m_View) then
        self.m_View:setItems(getAvailableMainItems(self))
            :setOverviewString(self.m_StringWarInfo)
            :setEnabled(true)
    end
end

local function setStateDamageChart(self)
    self.m_State = "damageChart"

    if (self.m_View) then
        self.m_View:setItems(self.m_ItemsDamageDetail)
    end
end

local function createAndSendAction(rawAction)
    rawAction.actionID         = SingletonGetters.getActionId() + 1
    rawAction.sceneWarFileName = SingletonGetters.getSceneWarFileName()
    WebSocketManager.sendAction(rawAction)
    SingletonGetters.getModelMessageIndicator():showPersistentMessage(getLocalizedText(80, "TransferingData"))
    SingletonGetters.getScriptEventDispatcher():dispatchEvent({
        name    = "EvtIsWaitingForServerResponse",
        waiting = true,
    })
end

local function sendActionActivateSkillGroup(skillGroupID)
    createAndSendAction({
        actionName   = "ActivateSkillGroup",
        skillGroupID = skillGroupID,
    })
end

local function sendActionSurrender()
    createAndSendAction({actionName = "Surrender"})
end

local function sendActionEndTurn()
    createAndSendAction({actionName = "EndTurn"})
end

local function dispatchEvtWarCommandMenuUpdated(self, isEnabled, isVisible)
    SingletonGetters.getScriptEventDispatcher():dispatchEvent({
        name      = "EvtWarCommandMenuUpdated",
        isEnabled = isEnabled,
        isVisible = isVisible,
    })
end

local function dispatchEvtMapCursorMoved(self, gridIndex)
    SingletonGetters.getScriptEventDispatcher():dispatchEvent({
        name      = "EvtMapCursorMoved",
        gridIndex = gridIndex,
    })
end

local function createItemActivateSkill(self, skillGroupID)
    return {
        name     = string.format("%s %d", getLocalizedText(65, "ActivateSkill"), skillGroupID),
        callback = function()
            sendActionActivateSkillGroup(skillGroupID)
            self:setEnabled(false)
        end,
    }
end

local function getEmptyProducersCount(self)
    local modelUnitMap = SingletonGetters.getModelUnitMap()
    local count        = 0
    local playerIndex  = self.m_PlayerIndex

    SingletonGetters.getModelTileMap():forEachModelTile(function(modelTile)
        if ((modelTile.getProductionList)                                 and
            (modelTile:getPlayerIndex() == self.m_PlayerIndex)            and
            (modelUnitMap:getModelUnit(modelTile:getGridIndex()) == nil)) then
            count = count + 1
        end
    end)

    return count
end

local function getIdleUnitsCount(self)
    local count       = 0
    local playerIndex = self.m_PlayerIndex
    SingletonGetters.getModelUnitMap():forEachModelUnitOnMap(function(modelUnit)
        if ((modelUnit:getPlayerIndex() == playerIndex) and (modelUnit:getState() == "idle")) then
            count = count + 1
        end
    end)

    return count
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
        return string.format("%s : %s", getLocalizedText(113, unitType), getLocalizedText(3, "None"))
    else
        local subTexts  = {}
        local primary   = baseDamage.primary or {}
        local secondary = baseDamage.secondary  or {}
        for _, targetType in ipairs(GameConstantFunctions.getCategory("AllUnits")) do
            subTexts[#subTexts + 1] = createDamageSubText(targetType, primary, secondary)
        end
        subTexts[#subTexts + 1] = createDamageSubText("Meteor", primary, secondary)

        local unitTypeText = getLocalizedText(113, unitType)
        return string.format("%s%s%s          %s\n%s",
            unitTypeText, string.rep(" ", 28 - string.len(unitTypeText) / 3 * 4),
            getLocalizedText(65, "MainWeapon"), getLocalizedText(65, "SubWeapon"),
            table.concat(subTexts, "\n")
        )
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

local function onEvtPlayerIndexUpdated(self, event)
    self.m_PlayerIndex    = event.playerIndex
    self.m_IsPlayerInTurn = (event.modelPlayer:getAccount() == WebSocketManager.getLoggedInAccountAndPassword())
end

local function onEvtIsWaitingForServerResponse(self, event)
    self.m_IsWaitingForServerResponse = event.waiting
end

--------------------------------------------------------------------------------
-- The composition items.
--------------------------------------------------------------------------------
local function initItemQuit(self)
    local item = {
        name     = getLocalizedText(65, "QuitWar"),
        callback = function()
            SingletonGetters.getModelConfirmBox():setConfirmText(getLocalizedText(66, "QuitWar"))
                :setOnConfirmYes(function()
                    local actorSceneMain = Actor.createWithModelAndViewName("sceneMain.ModelSceneMain", {isPlayerLoggedIn = true}, "sceneMain.ViewSceneMain")
                    ActorManager.setAndRunRootActor(actorSceneMain, "FADE", 1)
                end)
                :setEnabled(true)
        end,
    }

    self.m_ItemQuit = item
end

local function initItemFindIdleUnit(self)
    local item = {
        name     = getLocalizedText(65, "FindIdleUnit"),
        callback = function()
            local modelUnitMap     = SingletonGetters.getModelUnitMap()
            local mapSize          = modelUnitMap:getMapSize()
            local cursorX, cursorY = self.m_MapCursorGridIndex.x, self.m_MapCursorGridIndex.y
            local firstGridIndex

            for y = 1, mapSize.height do
                for x = 1, mapSize.width do
                    local gridIndex = {x = x, y = y}
                    local modelUnit = modelUnitMap:getModelUnit(gridIndex)
                    if ((modelUnit)                                                and
                        (modelUnit:getPlayerIndex() == self.m_LoggedInPlayerIndex) and
                        (modelUnit:getState() == "idle"))                          then
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
                SingletonGetters.getModelMessageIndicator():showMessage(getLocalizedText(66, "NoIdleUnit"))
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
            local modelUnitMap     = SingletonGetters.getModelUnitMap()
            local modelTileMap     = SingletonGetters.getModelTileMap()
            local mapSize          = modelUnitMap:getMapSize()
            local cursorX, cursorY = self.m_MapCursorGridIndex.x, self.m_MapCursorGridIndex.y
            local firstGridIndex

            for y = 1, mapSize.height do
                for x = 1, mapSize.width do
                    local gridIndex = {x = x, y = y}
                    local modelTile = modelTileMap:getModelTile(gridIndex)
                    if ((modelTile.getProductionList)                              and
                        (modelTile:getPlayerIndex() == self.m_LoggedInPlayerIndex) and
                        (not modelUnitMap:getModelUnit(gridIndex)))                then
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
                SingletonGetters.getModelMessageIndicator():showMessage(getLocalizedText(66, "NoIdleTile"))
            end
            self:setEnabled(false)
        end,
    }

    self.m_ItemFindIdleTile = item
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

local function initItemActivateSkill1(self)
    self.m_ItemActiveSkill1 = createItemActivateSkill(self, 1)
end

local function initItemActivateSkill2(self)
    self.m_ItemActiveSkill2 = createItemActivateSkill(self, 2)
end

local function initItemDamageChart(self)
    local item = {
        name     = getLocalizedText(65, "DamageChart"),
        callback = function()
            setStateDamageChart(self)
        end,
    }

    self.m_ItemDamageChart = item
end

local function initItemsDamageDetail(self)
    local items    = {}
    local allUnits = GameConstantFunctions.getCategory("AllUnits")
    for _, unitType in ipairs(allUnits) do
        items[#items + 1] = {
            name     = getLocalizedText(113, unitType),
            callback = function()
                if (self.m_View) then
                    self.m_View:setOverviewString(createDamageText(unitType))
                end
            end,
        }
    end

    self.m_ItemsDamageDetail = items
end

local function initItemHideUI(self)
    local item = {
        name     = getLocalizedText(65, "HideUI"),
        callback = function()
            setStateDisabled(self)
            dispatchEvtWarCommandMenuUpdated(self, true, false)
        end,
    }

    self.m_ItemHideUI = item
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

local function initItemReload(self)
    local item = {
        name     = getLocalizedText(65, "ReloadWar"),
        callback = function()
            local modelConfirmBox = SingletonGetters.getModelConfirmBox()
            modelConfirmBox:setConfirmText(getLocalizedText(66, "ReloadWar"))
                :setOnConfirmYes(function()
                    modelConfirmBox:setEnabled(false)
                    SingletonGetters.getScriptEventDispatcher():dispatchEvent({name = "EvtReloadSceneWar"})
                end)
                :setEnabled(true)
        end,
    }

    self.m_ItemReload = item
end

local function initItemSurrender(self)
    local item = {
        name     = getLocalizedText(65, "Surrender"),
        callback = function()
            local modelConfirmBox = SingletonGetters.getModelConfirmBox()
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

local function initItemEndTurn(self)
    local item = {
        name     = getLocalizedText(65, "EndTurn"),
        callback = function()
            local modelConfirmBox = SingletonGetters.getModelConfirmBox()
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

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:ctor(param)
    self.m_IsWaitingForServerResponse = false

    initItemQuit(          self)
    initItemFindIdleUnit(  self)
    initItemFindIdleTile(  self)
    initItemWarInfo(       self)
    initItemSkillInfo(     self)
    initItemActivateSkill1(self)
    initItemActivateSkill2(self)
    initItemDamageChart(   self)
    initItemsDamageDetail( self)
    initItemHideUI(        self)
    initItemSetMusic(      self)
    initItemReload(        self)
    initItemSurrender(     self)
    initItemEndTurn(       self)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelWarCommandMenu:initView()
    local view = self.m_View
    assert(view, "ModelWarCommandMenu:initView() no view is attached to the actor of the model.")

    view:setItems(self.m_ItemQuit, self.m_ItemEndTurn)

    return self
end

--------------------------------------------------------------------------------
-- The public callback function on start running or script events.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:onStartRunning(sceneWarFileName)
    SingletonGetters.getScriptEventDispatcher()
        :addEventListener("EvtPlayerIndexUpdated",         self)
        :addEventListener("EvtIsWaitingForServerResponse", self)
        :addEventListener("EvtGridSelected",               self)
        :addEventListener("EvtMapCursorMoved",             self)

    SingletonGetters.getModelPlayerManager():forEachModelPlayer(function(modelPlayer, playerIndex)
        if (modelPlayer:getAccount() == WebSocketManager.getLoggedInAccountAndPassword()) then
            self.m_LoggedInPlayerIndex = playerIndex
        end
    end)
end

function ModelWarCommandMenu:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtGridSelected")               then onEvtGridSelected(              self, event)
    elseif (eventName == "EvtMapCursorMoved")             then onEvtMapCursorMoved(            self, event)
    elseif (eventName == "EvtPlayerIndexUpdated")         then onEvtPlayerIndexUpdated(        self, event)
    elseif (eventName == "EvtIsWaitingForServerResponse") then onEvtIsWaitingForServerResponse(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:setEnabled(enabled)
    if (not enabled) then
        setStateDisabled(self)
    else
        setStateMain(self)
    end
    dispatchEvtWarCommandMenuUpdated(self, enabled, true)

    return self
end

function ModelWarCommandMenu:onButtonBackTouched()
    local state = self.m_State
    if     (state == "main")        then self:setEnabled(false)
    elseif (state == "damageChart") then setStateMain(self)
    else                                 error("ModelWarCommandMenu:onButtonBackTouched() the state is invalid: " .. (state or ""))
    end

    return self
end

return ModelWarCommandMenu
