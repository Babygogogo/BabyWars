
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

local LocalizationFunctions = requireBW("src.app.utilities.LocalizationFunctions")
local SingletonGetters      = requireBW("src.app.utilities.SingletonGetters")

local getLocalizedText = LocalizationFunctions.getLocalizedText
local string           = string

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function generateInfoText(self)
    local playerIndex        = self.m_PlayerIndexInTurn
    local modelPlayerManager = self.m_ModelPlayerManager
    local shouldShowFund     = (self.m_IsWarReplay)                                   or
        (not self.m_ModelFogManager:isFogOfWarCurrently())                            or
        (modelPlayerManager:isSameTeamIndex(playerIndex, self.m_PlayerIndexLoggedIn))

    local modelPlayer        = modelPlayerManager:getModelPlayer(playerIndex)
    local energy, req1, req2 = modelPlayer:getEnergy()
    return string.format("%s: %s\n%s: %s\n%s: %.2f / %s / %s",
        getLocalizedText(25, "Player"),  modelPlayer:getNickname(),
        getLocalizedText(25, "Fund"),    (shouldShowFund) and (modelPlayer:getFund()) or ("--"),
        getLocalizedText(25, "Energy"),  modelPlayer:getEnergy(), (req1) or ("--"), (req2) or ("--")
    )
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtChatManagerUpdated(self, event)
    self.m_View:setVisible(
        (not self.m_ModelWarCommandMenu:isEnabled())                                and
        (not self.m_ModelWarCommandMenu:isHiddenWithHideUI())                       and
        ((not self.m_ModelChatManager) or (not self.m_ModelChatManager:isEnabled()))
    )
end

local function onEvtPlayerIndexUpdated(self, event)
    local playerIndex = event.playerIndex
    self.m_PlayerIndexInTurn = playerIndex

    self.m_View:setInfoText(generateInfoText(self))
        :updateWithPlayerIndex(playerIndex)
end

local function onEvtModelPlayerUpdated(self, event)
    if (self.m_PlayerIndexInTurn == event.playerIndex) then
        self.m_View:setInfoText(generateInfoText(self))
    end
end

local function onEvtWarCommandMenuUpdated(self, event)
    self.m_View:setVisible(
        (not self.m_ModelWarCommandMenu:isEnabled())                                and
        (not self.m_ModelWarCommandMenu:isHiddenWithHideUI())                       and
        ((not self.m_ModelChatManager) or (not self.m_ModelChatManager:isEnabled()))
    )
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
function ModelMoneyEnergyInfo:onStartRunning(modelWar)
    self.m_ModelWar            = modelWar
    self.m_IsWarReplay         = SingletonGetters.isTotalReplay(         modelWar)
    self.m_ModelFogManager     = SingletonGetters.getModelFogMap(        modelWar)
    self.m_ModelWarCommandMenu = SingletonGetters.getModelWarCommandMenu(modelWar)
    self.m_PlayerIndexInTurn   = SingletonGetters.getModelTurnManager(   modelWar):getPlayerIndex()
    self.m_ModelPlayerManager  = SingletonGetters.getModelPlayerManager( modelWar)
    if (self.m_IsWarReplay) then
        self.m_ModelReplayController = SingletonGetters.getModelReplayController(modelWar)
    else
        self.m_ModelChatManager      = SingletonGetters.getModelChatManager(     modelWar)
        self.m_PlayerIndexLoggedIn   = SingletonGetters.getPlayerIndexLoggedIn(  modelWar)
    end

    SingletonGetters.getScriptEventDispatcher(modelWar)
        :addEventListener("EvtChatManagerUpdated",    self)
        :addEventListener("EvtModelPlayerUpdated",    self)
        :addEventListener("EvtPlayerIndexUpdated",    self)
        :addEventListener("EvtWarCommandMenuUpdated", self)

    self.m_View:setInfoText(generateInfoText(self))
        :updateWithPlayerIndex(self.m_PlayerIndexInTurn)

    return self
end

function ModelMoneyEnergyInfo:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtChatManagerUpdated")    then onEvtChatManagerUpdated(   self, event)
    elseif (eventName == "EvtModelPlayerUpdated")    then onEvtModelPlayerUpdated(   self, event)
    elseif (eventName == "EvtPlayerIndexUpdated")    then onEvtPlayerIndexUpdated(   self, event)
    elseif (eventName == "EvtWarCommandMenuUpdated") then onEvtWarCommandMenuUpdated(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:onPlayerTouch()
    if ((self.m_IsWarReplay) and (self.m_ModelWar:isAutoReplay())) then
        self.m_ModelWar:setAutoReplay(false)
        self.m_ModelReplayController:setButtonPlayVisible(true)
    end

    self.m_ModelWarCommandMenu:setEnabled(true)

    return self
end

function ModelMoneyEnergyInfo:adjustPositionOnTouch(touch)
    self.m_View:adjustPositionOnTouch(touch)

    return self
end

return ModelMoneyEnergyInfo
