
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
local function createQuitWarItem(model)
    local item = {}

    item.onPlayerTouch = function(self)
        model.m_ConfirmBoxModel:setConfirmText("You are quitting the war (you may reenter it later).\nAre you sure?")

            :setOnConfirmYes(function()
                local mainSceneActor = Actor.createWithModelAndViewName("ModelSceneMain", nil, "ViewSceneMain")
                assert(mainSceneActor, "ModelWarCommandMenu-onQuitWarItemConfirmYes() failed to create a main scene actor.")
                require("global.actors.ActorManager").setAndRunRootActor(mainSceneActor, "FADE", 1)
            end)

            :setEnabled(true)
    end

    item.getTitleText = function(self)
        return "Quit"
    end

    return item
end

local function initWithQuitWarItem(model, item)
    model.m_QuitWarItem = item
end

--------------------------------------------------------------------------------
-- The end turn menu item.
--------------------------------------------------------------------------------
local function createEndTurnItem(model)
    local item = {}

    item.onPlayerTouch = function(self)
        model.m_ConfirmBoxModel:setConfirmText("You are ending your turn, with some units unactioned.\nAre you sure?")

            :setOnConfirmYes(function()
                model.m_ConfirmBoxModel:setEnabled(false)
                model:setEnabled(false)
                model.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerRequestDoAction", actionName = "EndTurn"})
            end)

            :setEnabled(true)
    end

    item.getTitleText = function(self)
        return "End Turn"
    end

    return item
end

local function initWithEndTurnItem(model, item)
    model.m_EndTurnItem = item
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:ctor(param)
    initWithQuitWarItem(self, createQuitWarItem(self))
    initWithEndTurnItem(self, createEndTurnItem(self))

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelWarCommandMenu:initView()
    local view = self.m_View
    assert(view, "ModelWarCommandMenu:initView() no view is attached to the actor of the model.")

    view:removeAllItems()
        :createAndPushBackItemView(self.m_QuitWarItem)
        :createAndPushBackItemView(self.m_EndTurnItem)

    return self
end

function ModelWarCommandMenu:setModelConfirmBox(model)
    model:setEnabled(false)
    self.m_ConfirmBoxModel = model

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
end

function ModelWarCommandMenu:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher = nil
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
