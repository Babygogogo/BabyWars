
--[[--------------------------------------------------------------------------------
-- ModelMoneyEnergyInfo用于显示玩家的金钱和能量，同时也负责在被点击时弹出战场操作菜单（ModelWarCommandMenu）。
--
-- 主要职责及使用场景举例：
--   同上
--
-- 其他：
--   点击时弹出战场操作菜单本来与本类没有关系，但为了节省屏幕空间，所以就这么设定了。
--]]--------------------------------------------------------------------------------

local ModelMoneyEnergyInfo = class("ModelMoneyEnergyInfo")

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseBeginning(self, event)
    self.m_PlayerIndex = event.playerIndex

    if (self.m_View) then
        self.m_View:setFund(event.modelPlayer:getFund())
            :setEnergy(event.modelPlayer:getEnergy())
    end
end

local function onEvtModelPlayerUpdated(self, event)
    if ((self.m_PlayerIndex == event.playerIndex) and (self.m_View)) then
        self.m_View:setFund(event.modelPlayer:getFund())
            :setEnergy(event.modelPlayer:getEnergy())
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:ctor(param)
    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelMoneyEnergyInfo:initView()
    local view = self.m_View
    assert(view, "ModelMoneyEnergyInfo:initView() no view is attached to the owner actor of the model.")

    return self
end

function ModelMoneyEnergyInfo:setModelWarCommandMenu(model)
    assert(self.m_ModelWarCommandMenu == nil, "ModelMoneyEnergyInfo:setModelWarCommandMenu() the model has been set.")

    model:setEnabled(false)
    self.m_ModelWarCommandMenu = model

    return self
end

function ModelMoneyEnergyInfo:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelMoneyEnergyInfo:setRootScriptEventDispatcher() the dispatcher has been set.")

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtTurnPhaseBeginning", self)
        :addEventListener("EvtTurnPhaseMain",      self)
        :addEventListener("EvtModelPlayerUpdated", self)

    return self
end

function ModelMoneyEnergyInfo:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelMoneyEnergyInfo:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtModelPlayerUpdated", self)
        :removeEventListener("EvtTurnPhaseMain",      self)
        :removeEventListener("EvtTurnPhaseBeginning", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:onEvent(event)
    local eventName = event.name
    if ((eventName == "EvtTurnPhaseBeginning") or
        (eventName == "EvtTurnPhaseMain")) then
        onEvtTurnPhaseBeginning(self, event)
    elseif (eventName == "EvtModelPlayerUpdated") then
        onEvtModelPlayerUpdated(self, event)
    end
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:onPlayerTouch()
    self.m_ModelWarCommandMenu:setEnabled(true)

    return self
end

function ModelMoneyEnergyInfo:adjustPositionOnTouch(touch)
    if (self.m_View) then
        self.m_View:adjustPositionOnTouch(touch)
    end

    return self
end

return ModelMoneyEnergyInfo
