
--[[--------------------------------------------------------------------------------
-- ModelWarHUD是战局场景上的各个UI的集合。
--
-- 主要职责和使用场景举例：
--   构造和显示各个UI。
--
-- 其他：
--  - ModelWarHUD目前由以下子actor组成：
--    - ConfirmBox
--    - MoneyEnergyInfo
--    - WarCommandMenu
--    - ActionMenu
--    - UnitInfo
--    - UnitDetail
--    - TileInfo
--    - TileDetail
--    - BattleInfo
--]]--------------------------------------------------------------------------------

local ModelWarHUD = class("ModelWarHUD")

local Actor = require("global.actors.Actor")

--------------------------------------------------------------------------------
-- The callback function on EvtTurnPhaseBeginning.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseBeginning(self, event)
    if (self.m_View) then
        self.m_View:showBeginTurnEffect(event.turnIndex, event.modelPlayer:getName(), event.callbackOnBeginTurnEffectDisappear)
    else
        event.callbackOnBeginTurnEffect()
    end

    return self
end

--------------------------------------------------------------------------------
-- The composition actors.
--------------------------------------------------------------------------------
local function createCompositionActors(param)
    local confirmBoxActor      = Actor.createWithModelAndViewName("ModelConfirmBox",      nil, "ViewConfirmBox")
    local moneyEnergyInfoActor = Actor.createWithModelAndViewName("ModelMoneyEnergyInfo", nil, "ViewMoneyEnergyInfo")
    local warCommandMenuActor  = Actor.createWithModelAndViewName("ModelWarCommandMenu",  nil, "ViewWarCommandMenu")
    local actionMenuActor      = Actor.createWithModelAndViewName("ModelActionMenu",      nil, "ViewActionMenu")
    local unitInfoActor        = Actor.createWithModelAndViewName("ModelUnitInfo",        nil, "ViewUnitInfo")
    local unitDetailActor      = Actor.createWithModelAndViewName("ModelUnitDetail",      nil, "ViewUnitDetail")
    local tileInfoActor        = Actor.createWithModelAndViewName("ModelTileInfo",        nil, "ViewTileInfo")
    local tileDetailActor      = Actor.createWithModelAndViewName("ModelTileDetail",      nil, "ViewTileDetail")
    local battleInfoActor      = Actor.createWithModelAndViewName("ModelBattleInfo",      nil, "ViewBattleInfo")

    return {
        confirmBoxActor      = confirmBoxActor,
        moneyEnergyInfoActor = moneyEnergyInfoActor,
        warCommandMenuActor  = warCommandMenuActor,
        actionMenuActor      = actionMenuActor,
        unitInfoActor        = unitInfoActor,
        unitDetailActor      = unitDetailActor,
        tileInfoActor        = tileInfoActor,
        tileDetailActor      = tileDetailActor,
        battleInfoActor      = battleInfoActor,
    }
end

local function initWithCompositionActors(self, actors)
    self.m_ConfirmBoxActor     = actors.confirmBoxActor
    self.m_ActorWarCommandMenu = actors.warCommandMenuActor
    self.m_ActorWarCommandMenu:getModel():setModelConfirmBox(self.m_ConfirmBoxActor:getModel())

    self.m_ActorActionMenu = actors.actionMenuActor

    self.m_ActorMoneyEnergyInfo = actors.moneyEnergyInfoActor
    self.m_ActorMoneyEnergyInfo:getModel():setModelWarCommandMenu(self.m_ActorWarCommandMenu:getModel())

    self.m_UnitDetailActor = actors.unitDetailActor
    self.m_ActorUnitInfo   = actors.unitInfoActor
    self.m_ActorUnitInfo:getModel():setModelUnitDetail(self.m_UnitDetailActor:getModel())

    self.m_TileDetailActor = actors.tileDetailActor
    self.m_ActorTileInfo   = actors.tileInfoActor
    self.m_ActorTileInfo:getModel():setModelTileDetail(self.m_TileDetailActor:getModel())

    self.m_ActorBattleInfo = actors.battleInfoActor
end

--------------------------------------------------------------------------------
-- The contructor.
--------------------------------------------------------------------------------
function ModelWarHUD:ctor(param)
    initWithCompositionActors(self, createCompositionActors())

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelWarHUD:initView()
    local view = self.m_View
    assert(view, "ModelWarHUD:initView() no view is attached to the actor of the model.")

    view:setViewConfirmBox(     self.m_ConfirmBoxActor:getView())
        :setViewMoneyEnergyInfo(self.m_ActorMoneyEnergyInfo:getView())
        :setViewWarCommandMenu( self.m_ActorWarCommandMenu:getView())
        :setViewActionMenu(     self.m_ActorActionMenu:getView())
        :setViewTileInfo(       self.m_ActorTileInfo:getView())
        :setViewTileDetail(     self.m_TileDetailActor:getView())
        :setViewUnitInfo(       self.m_ActorUnitInfo:getView())
        :setViewUnitDetail(     self.m_UnitDetailActor:getView())
        :setViewBattleInfo(     self.m_ActorBattleInfo:getView())

    return self
end

function ModelWarHUD:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelWarHUD:setRootScriptEventDispatcher() the dispatcher has been set.")

    self.m_ActorActionMenu     :getModel():setRootScriptEventDispatcher(dispatcher)
    self.m_ActorWarCommandMenu :getModel():setRootScriptEventDispatcher(dispatcher)
    self.m_ActorMoneyEnergyInfo:getModel():setRootScriptEventDispatcher(dispatcher)
    self.m_ActorTileInfo       :getModel():setRootScriptEventDispatcher(dispatcher)
    self.m_ActorUnitInfo       :getModel():setRootScriptEventDispatcher(dispatcher)
    self.m_ActorBattleInfo     :getModel():setRootScriptEventDispatcher(dispatcher)

    self.m_RootScriptEventDispatcher = dispatcher
    self.m_RootScriptEventDispatcher:addEventListener("EvtTurnPhaseBeginning", self)

    return self
end

function ModelWarHUD:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelWarHUD:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseBeginning", self)
    self.m_RootScriptEventDispatcher = nil

    self.m_ActorActionMenu     :getModel():unsetRootScriptEventDispatcher()
    self.m_ActorWarCommandMenu :getModel():unsetRootScriptEventDispatcher()
    self.m_ActorMoneyEnergyInfo:getModel():unsetRootScriptEventDispatcher()
    self.m_ActorTileInfo       :getModel():unsetRootScriptEventDispatcher()
    self.m_ActorUnitInfo       :getModel():unsetRootScriptEventDispatcher()
    self.m_ActorBattleInfo     :getModel():unsetRootScriptEventDispatcher()

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelWarHUD:onEvent(event)
    if (event.name == "EvtTurnPhaseBeginning") then
        onEvtTurnPhaseBeginning(self, event)
    end

    return self
end

return ModelWarHUD
