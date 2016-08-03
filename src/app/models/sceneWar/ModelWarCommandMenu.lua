
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

local Actor                 = require("src.global.actors.Actor")
local ActorManager          = require("src.global.actors.ActorManager")
local WebSocketManager      = require("src.app.utilities.WebSocketManager")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

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

--------------------------------------------------------------------------------
-- The composition items.
--------------------------------------------------------------------------------
local function initItemQuit(self)
    local item = {
        name     = LocalizationFunctions.getLocalizedText(65, "QuitWar"),
        callback = function()
            self.m_ModelConfirmBox:setConfirmText(LocalizationFunctions.getLocalizedText(66, "QuitWar"))
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

local function initItemReload(self)
    local item = {
        name     = LocalizationFunctions.getLocalizedText(65, "ReloadWar"),
        callback = function()
            self.m_ModelConfirmBox:setConfirmText(LocalizationFunctions.getLocalizedText(66, "ReloadWar"))
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
        name     = LocalizationFunctions.getLocalizedText(65, "Surrender"),
        callback = function()
            self.m_ModelConfirmBox:setConfirmText(LocalizationFunctions.getLocalizedText(66, "Surrender"))
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
        name     = LocalizationFunctions.getLocalizedText(65, "EndTurn"),
        callback = function()
            self.m_ModelConfirmBox:setConfirmText(LocalizationFunctions.getLocalizedText(70, getEmptyProducersCount(self), getIdleUnitsCount(self)))
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

local function generateItems(self)
    local items = {
        self.m_ItemQuit,
        self.m_ItemReload,
    }
    if ((self.m_IsPlayerInTurn) and (not self.m_IsWaitingForServerResponse)) then
        items[#items + 1] = self.m_ItemSurrender
        items[#items + 1] = self.m_ItemEndTurn
    end

    return items
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:ctor(param)
    self.m_IsWaitingForServerResponse = false

    initItemQuit(     self)
    initItemReload(   self)
    initItemSurrender(self)
    initItemEndTurn(  self)

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
    if (self.m_View) then
        if (enabled) then
            self.m_View:setItems(generateItems(self))
        end

        self.m_View:setEnabled(enabled)
    end

    return self
end

return ModelWarCommandMenu
