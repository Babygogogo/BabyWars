
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
local function onEvtPlayerIndexUpdated(self, event)
    self.m_PlayerIndex = event.playerIndex

    if (self.m_View) then
        self.m_View:updateWithModelPlayer(event.modelPlayer)
            :updateWithPlayerIndex(event.playerIndex)
    end
end

local function onEvtModelPlayerUpdated(self, event)
    if ((self.m_PlayerIndex == event.playerIndex) and (self.m_View)) then
        self.m_View:updateWithModelPlayer(event.modelPlayer)
    end
end

local function onEvtWarCommandMenuActivated(self, event)
    if (self.m_View) then
        self.m_View:setVisible(false)
    end
end

local function onEvtWarCommandMenuDeactivated(self, event)
    if (self.m_View) then
        self.m_View:setVisible(true)
    end
end

local function onEvtGridSelected(self, event)
    onEvtWarCommandMenuDeactivated(self)
end

local function onEvtMapCursorMoved(self, event)
    onEvtWarCommandMenuDeactivated(self)
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
    dispatcher:addEventListener("EvtPlayerIndexUpdated", self)
        :addEventListener("EvtModelPlayerUpdated",        self)
        :addEventListener("EvtWarCommandMenuActivated",   self)
        :addEventListener("EvtWarCommandMenuDeactivated", self)
        :addEventListener("EvtGridSelected",              self)
        :addEventListener("EvtMapCursorMoved",            self)

    return self
end

function ModelMoneyEnergyInfo:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelMoneyEnergyInfo:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtMapCursorMoved", self)
        :removeEventListener("EvtGridSelected",              self)
        :removeEventListener("EvtWarCommandMenuDeactivated", self)
        :removeEventListener("EvtWarCommandMenuActivated",   self)
        :removeEventListener("EvtModelPlayerUpdated",        self)
        :removeEventListener("EvtPlayerIndexUpdated",        self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtPlayerIndexUpdated")        then onEvtPlayerIndexUpdated(       self, event)
    elseif (eventName == "EvtModelPlayerUpdated")        then onEvtModelPlayerUpdated(       self, event)
    elseif (eventName == "EvtWarCommandMenuActivated")   then onEvtWarCommandMenuActivated(  self, event)
    elseif (eventName == "EvtWarCommandMenuDeactivated") then onEvtWarCommandMenuDeactivated(self, event)
    elseif (eventName == "EvtGridSelected")              then onEvtGridSelected(             self, event)
    elseif (eventName == "EvtMapCursorMoved")            then onEvtMapCursorMoved(           self, event)
    end

    return self
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
