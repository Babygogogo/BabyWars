
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

local Actor            = require("global.actors.Actor")
local TypeChecker      = require("app.utilities.TypeChecker")

--------------------------------------------------------------------------------
-- The quit war menu item.
--------------------------------------------------------------------------------
local function createItemQuitWar(self)
    return {
        name     = "Quit",
        callback = function()
            self.m_ModelConfirmBox:setConfirmText("You are quitting the war (you may reenter it later).\nAre you sure?")
                :setOnConfirmYes(function()
                    local actorSceneMain = Actor.createWithModelAndViewName("sceneMain.ModelSceneMain", {isPlayerLoggedIn = true}, "sceneMain.ViewSceneMain")
                    require("app.utilities.WebSocketManager").setOwner(actorSceneMain:getModel())
                    require("global.actors.ActorManager").setAndRunRootActor(actorSceneMain, "FADE", 1)
                end)
                :setEnabled(true)
        end,
    }
end

local function initWithItemQuitWar(model, item)
    model.m_ItemQuitWar = item
end

--------------------------------------------------------------------------------
-- The end turn menu item.
--------------------------------------------------------------------------------
local function createItemEndTurn(self)
    return {
        name     = "End Turn",
        callback = function()
            self.m_ModelConfirmBox:setConfirmText("You are ending your turn, with some units unactioned.\nAre you sure?")
                :setOnConfirmYes(function()
                    self.m_ModelConfirmBox:setEnabled(false)
                    self:setEnabled(false)
                    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerRequestDoAction", actionName = "EndTurn"})
                end)
                :setEnabled(true)
        end,
    }
end

local function initWithItemEndTurn(model, item)
    model.m_ItemEndTurn = item
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:ctor(param)
    initWithItemQuitWar(self, createItemQuitWar(self))
    initWithItemEndTurn(self, createItemEndTurn(self))

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelWarCommandMenu:initView()
    local view = self.m_View
    assert(view, "ModelWarCommandMenu:initView() no view is attached to the actor of the model.")

    view:removeAllItems()
        :createAndPushBackViewItem(self.m_ItemQuitWar)
        :createAndPushBackViewItem(self.m_ItemEndTurn)

    return self
end

function ModelWarCommandMenu:setModelConfirmBox(model)
    assert(self.m_ModelConfirmBox == nil, "ModelWarCommandMenu:setModelConfirmBox() the model has been set.")
    self.m_ModelConfirmBox = model
    model:setEnabled(false)

    return self
end

function ModelWarCommandMenu:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelWarCommandMenu:setRootScriptEventDispatcher() the dispatcher has been set.")
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

function ModelWarCommandMenu:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelWarCommandMenu:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setEnabled(enabled)
    end

    return self
end

return ModelWarCommandMenu
