
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

local WebSocketManager      = require("src.app.utilities.WebSocketManager")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local Actor                 = require("src.global.actors.Actor")
local ActorManager          = require("src.global.actors.ActorManager")

local getLocalizedText = LocalizationFunctions.getLocalizedText

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function dispatchEvtActivateSkillGroup(self, skillGroupID)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name         = "EvtPlayerRequestDoAction",
        actionName   = "ActivateSkillGroup",
        skillGroupID = skillGroupID,
    })
end

local function createItemActivateSkill(self, skillGroupID)
    return {
        name     = string.format("%s %d", getLocalizedText(65, "ActivateSkill"), skillGroupID),
        callback = function()
            dispatchEvtActivateSkillGroup(self, skillGroupID)
        end,
    }
end

local function getEmptyProducersCount(self)
    local modelUnitMap = self.m_ModelWarField:getModelUnitMap()
    local count        = 0
    local playerIndex  = self.m_PlayerIndex

    self.m_ModelWarField:getModelTileMap():forEachModelTile(function(modelTile)
        if ((modelTile.getProductionList) and
            (modelTile:getPlayerIndex() == self.m_PlayerIndex) and
            (modelUnitMap:getModelUnit(modelTile:getGridIndex()) == nil)) then
            count = count + 1
        end
    end)

    return count
end

local function getIdleUnitsCount(self)
    local count       = 0
    local playerIndex = self.m_PlayerIndex
    self.m_ModelWarField:getModelUnitMap():forEachModelUnitOnMap(function(modelUnit)
        if ((modelUnit:getPlayerIndex() == playerIndex) and (modelUnit:getState() == "idle")) then
            count = count + 1
        end
    end)

    return count
end

local function updateStringWarInfo(self)
    local modelPlayerManager = self.m_ModelPlayerManager
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
            }
        end
    end)

    self.m_ModelWarField:getModelUnitMap():forEachModelUnitOnMap(function(modelUnit)
        local unitsCount = 1
        if (modelUnit.getCurrentLoadCount) then
            unitsCount = unitsCount + modelUnit:getCurrentLoadCount()
        end

        local playerIndex = modelUnit:getPlayerIndex()
        data[playerIndex].unitsCount = data[playerIndex].unitsCount + unitsCount
    end)

    self.m_ModelWarField:getModelTileMap():forEachModelTile(function(modelTile)
        local playerIndex = modelTile:getPlayerIndex()
        if (playerIndex ~= 0) then
            data[playerIndex].tilesCount = data[playerIndex].tilesCount + 1
        end
    end)

    local playersCount = modelPlayerManager:getPlayersCount()
    local stringList   = {}
    for i = 1, playersCount do
        if (not data[i]) then
            stringList[i] = string.format("%s %d: %s", getLocalizedText(65, "Player"), i, getLocalizedText(65, "Lost"))
        else
            local d = data[i]
            stringList[i] = string.format("%s %d:\n%s: %s\n%s: %d\n%s: %.2f / %s / %s\n%s: %d\n%s: %d",
                getLocalizedText(65, "Player"),     i,
                getLocalizedText(65, "Nickname"),   d.nickname,
                getLocalizedText(65, "Fund"),       d.fund,
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
    self.m_ModelPlayerManager:forEachModelPlayer(function(modelPlayer, playerIndex)
        stringList[#stringList + 1] = string.format("%s %d: %s",
            getLocalizedText(65, "Player"), playerIndex,
            modelPlayer:getModelSkillConfiguration():getDescription()
        )
    end)

    self.m_StringSkillInfo = table.concat(stringList, "\n--------------------\n")
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtPlayerIndexUpdated(self, event)
    self.m_PlayerIndex    = event.playerIndex
    self.m_IsPlayerInTurn = (event.modelPlayer:getAccount() == WebSocketManager.getLoggedInAccountAndPassword())
end

local function onEvtIsWaitingForServerResponse(self, event)
    self:setEnabled(false)
    self.m_IsWaitingForServerResponse = event.waiting
end

--------------------------------------------------------------------------------
-- The composition items.
--------------------------------------------------------------------------------
local function initItemQuit(self)
    local item = {
        name     = getLocalizedText(65, "QuitWar"),
        callback = function()
            self.m_ModelConfirmBox:setConfirmText(getLocalizedText(66, "QuitWar"))
                :setOnConfirmYes(function()
                    local actorSceneMain = Actor.createWithModelAndViewName("sceneMain.ModelSceneMain", {isPlayerLoggedIn = true}, "sceneMain.ViewSceneMain")
                    WebSocketManager.setOwner(actorSceneMain:getModel())
                    ActorManager.setAndRunRootActor(actorSceneMain, "FADE", 1)
                end)
                :setEnabled(true)
        end,
    }

    self.m_ItemQuit = item
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

local function initItemHideUI(self)
    local item = {
        name     = getLocalizedText(65, "HideUI"),
        callback = function()
            if (self.m_View) then
                self.m_View:setEnabled(false)
            end
        end,
    }

    self.m_ItemHideUI = item
end

local function initItemReload(self)
    local item = {
        name     = getLocalizedText(65, "ReloadWar"),
        callback = function()
            self.m_ModelConfirmBox:setConfirmText(getLocalizedText(66, "ReloadWar"))
                :setOnConfirmYes(function()
                    self.m_ModelConfirmBox:setEnabled(false)
                    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtReloadSceneWar"})
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
            self.m_ModelConfirmBox:setConfirmText(getLocalizedText(66, "Surrender"))
                :setOnConfirmYes(function()
                    self.m_ModelConfirmBox:setEnabled(false)
                    self:setEnabled(false)
                    self.m_RootScriptEventDispatcher:dispatchEvent({
                        name       = "EvtPlayerRequestDoAction",
                        actionName = "Surrender",
                    })
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
            self.m_ModelConfirmBox:setConfirmText(getLocalizedText(70, getEmptyProducersCount(self), getIdleUnitsCount(self)))
                :setOnConfirmYes(function()
                    self.m_ModelConfirmBox:setEnabled(false)
                    self:setEnabled(false)
                    self.m_RootScriptEventDispatcher:dispatchEvent({
                        name       = "EvtPlayerRequestDoAction",
                        actionName = "EndTurn"
                    })
                end)
                :setEnabled(true)
        end,
    }

    self.m_ItemEndTurn = item
end

local function getAvailableItems(self)
    local items = {
        self.m_ItemQuit,
        self.m_ItemWarInfo,
        self.m_ItemSkillInfo,
        self.m_ItemHideUI,
    }

    local shouldAddActionItems = (self.m_IsPlayerInTurn) and (not self.m_IsWaitingForServerResponse)
    if (shouldAddActionItems) then
        items[#items + 1] = self.m_ItemSurrender
    end
    items[#items + 1] = self.m_ItemReload

    if (shouldAddActionItems) then
        local modelPlayer = self.m_ModelPlayerManager:getModelPlayer(self.m_PlayerIndex)
        if (modelPlayer:canActivateSkillGroup(1)) then
            items[#items + 1] = self.m_ItemActiveSkill1
        end
        if (modelPlayer:canActivateSkillGroup(2)) then
            items[#items + 1] = self.m_ItemActiveSkill2
        end

        items[#items + 1] = self.m_ItemEndTurn
    end

    return items
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:ctor(param)
    self.m_IsWaitingForServerResponse = false

    initItemQuit(          self)
    initItemWarInfo(       self)
    initItemSkillInfo(     self)
    initItemActivateSkill1(self)
    initItemActivateSkill2(self)
    initItemHideUI(        self)
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

function ModelWarCommandMenu:setModelConfirmBox(model)
    assert(self.m_ModelConfirmBox == nil, "ModelWarCommandMenu:setModelConfirmBox() the model has been set.")
    self.m_ModelConfirmBox = model
    model:setEnabled(false)

    return self
end

function ModelWarCommandMenu:setModelWarField(model)
    assert(self.m_ModelWarField == nil, "ModelWarCommandMenu:setModelWarField() the model has been set.")
    self.m_ModelWarField = model

    return self
end

function ModelWarCommandMenu:setModelPlayerManager(model)
    assert(self.m_ModelPlayerManager == nil, "ModelWarCommandMenu:setModelPlayerManager() the model has been set already.")
    self.m_ModelPlayerManager = model

    return self
end

function ModelWarCommandMenu:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelWarCommandMenu:setRootScriptEventDispatcher() the dispatcher has been set.")

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtPlayerIndexUpdated",   self)
        :addEventListener("EvtIsWaitingForServerResponse", self)

    return self
end

function ModelWarCommandMenu:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelWarCommandMenu:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtIsWaitingForServerResponse", self)
        :removeEventListener("EvtPlayerIndexUpdated", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The public callback function on script events.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtPlayerIndexUpdated")         then onEvtPlayerIndexUpdated(        self, event)
    elseif (eventName == "EvtIsWaitingForServerResponse") then onEvtIsWaitingForServerResponse(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:setEnabled(enabled)
    local dispatcher = self.m_RootScriptEventDispatcher
    if (dispatcher) then
        if (enabled) then
            dispatcher:dispatchEvent({name = "EvtWarCommandMenuActivated"})
        else
            dispatcher:dispatchEvent({name = "EvtWarCommandMenuDeactivated"})
        end
    end

    local view = self.m_View
    if (view) then
        if (enabled) then
            updateStringWarInfo(  self)
            updateStringSkillInfo(self)

            view:setItems(getAvailableItems(self))
                :setOverviewString(self.m_StringWarInfo)
        end

        view:setEnabled(enabled)
    end

    return self
end

function ModelWarCommandMenu:onButtonBackTouched()
    self:setEnabled(false)

    return self
end

return ModelWarCommandMenu
