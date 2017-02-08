
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

local SingletonGetters = requireBW("src.app.utilities.SingletonGetters")

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtPlayerIndexUpdated(self, event)
    local playerIndex = event.playerIndex
    self.m_PlayerIndex = playerIndex

    if (self.m_View) then
        self.m_View:updateWithModelPlayer(event.modelPlayer, playerIndex)
            :updateWithPlayerIndex(playerIndex)
    end
end

local function onEvtModelPlayerUpdated(self, event)
    if ((self.m_PlayerIndex == event.playerIndex) and (self.m_View)) then
        self.m_View:updateWithModelPlayer(event.modelPlayer, event.playerIndex)
    end
end

local function onEvtWarCommandMenuUpdated(self, event)
    if (self.m_View) then
        self.m_View:setVisible(not event.modelWarCommandMenu:isEnabled())
    end
end

local function onEvtHideUI(self, event)
    if (self.m_View) then
        self.m_View:setVisible(false)
    end
end

local function onEvtGridSelected(self, event)
    if (self.m_View) then
        self.m_View:setVisible(true)
    end
end

local function onEvtMapCursorMoved(self, event)
    if (self.m_View) then
        self.m_View:setVisible(true)
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:ctor(param)
    return self
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:onStartRunning(modelSceneWar)
    self.m_ModelSceneWar = modelSceneWar
    SingletonGetters.getScriptEventDispatcher(modelSceneWar)
        :addEventListener("EvtPlayerIndexUpdated",    self)
        :addEventListener("EvtModelPlayerUpdated",    self)
        :addEventListener("EvtWarCommandMenuUpdated", self)
        :addEventListener("EvtHideUI",                self)
        :addEventListener("EvtGridSelected",          self)
        :addEventListener("EvtMapCursorMoved",        self)

    local playerIndex  = SingletonGetters.getModelTurnManager(modelSceneWar):getPlayerIndex()
    self.m_PlayerIndex = playerIndex
    if (self.m_View) then
        self.m_View:setModelSceneWar(modelSceneWar)
            :updateWithModelPlayer(SingletonGetters.getModelPlayerManager(modelSceneWar):getModelPlayer(playerIndex), playerIndex)
            :updateWithPlayerIndex(playerIndex)
    end

    return self
end

function ModelMoneyEnergyInfo:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtPlayerIndexUpdated")    then onEvtPlayerIndexUpdated(   self, event)
    elseif (eventName == "EvtModelPlayerUpdated")    then onEvtModelPlayerUpdated(   self, event)
    elseif (eventName == "EvtWarCommandMenuUpdated") then onEvtWarCommandMenuUpdated(self, event)
    elseif (eventName == "EvtHideUI")                then onEvtHideUI(               self, event)
    elseif (eventName == "EvtGridSelected")          then onEvtGridSelected(         self, event)
    elseif (eventName == "EvtMapCursorMoved")        then onEvtMapCursorMoved(       self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:onPlayerTouch()
    local modelSceneWar = self.m_ModelSceneWar
    if ((modelSceneWar:isTotalReplay()) and (modelSceneWar:isAutoReplay())) then
        modelSceneWar:setAutoReplay(false)
        SingletonGetters.getModelReplayController(modelSceneWar):setButtonPlayVisible(true)
    end
    SingletonGetters.getModelWarCommandMenu(modelSceneWar):setEnabled(true)

    return self
end

function ModelMoneyEnergyInfo:adjustPositionOnTouch(touch)
    if (self.m_View) then
        self.m_View:adjustPositionOnTouch(touch)
    end

    return self
end

return ModelMoneyEnergyInfo
