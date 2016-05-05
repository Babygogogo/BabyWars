
--[[--------------------------------------------------------------------------------
-- ModelSceneWarHUD是战局场景上的各个UI的集合。
--
-- 主要职责和使用场景举例：
--   构造和显示各个UI。
--
-- 其他：
--  - ModelSceneWarHUD目前由以下子actor组成：
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

local ModelSceneWarHUD = class("ModelSceneWarHUD")

local Actor = require("global.actors.Actor")

--------------------------------------------------------------------------------
-- The callback function on EvtTurnPhaseBeginning.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseBeginning(self, event)
    if (self.m_View) then
        self.m_View:showBeginTurnEffect(event.turnIndex, event.player:getName(), event.callbackOnBeginTurnEffectDisappear)
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
    self.m_WarCommandMenuActor = actors.warCommandMenuActor
    self.m_WarCommandMenuActor:getModel():setModelConfirmBox(self.m_ConfirmBoxActor:getModel())

    self.m_ActionMenuActor = actors.actionMenuActor

    self.m_MoneyEnergyInfoActor = actors.moneyEnergyInfoActor
    self.m_MoneyEnergyInfoActor:getModel():setModelWarCommandMenu(self.m_WarCommandMenuActor:getModel())

    self.m_UnitDetailActor = actors.unitDetailActor
    self.m_UnitInfoActor   = actors.unitInfoActor
    self.m_UnitInfoActor:getModel():setModelUnitDetail(self.m_UnitDetailActor:getModel())

    self.m_TileDetailActor = actors.tileDetailActor
    self.m_TileInfoActor   = actors.tileInfoActor
    self.m_TileInfoActor:getModel():setModelTileDetail(self.m_TileDetailActor:getModel())

    self.m_BattleInfoActor = actors.battleInfoActor
end

--------------------------------------------------------------------------------
-- The contructor.
--------------------------------------------------------------------------------
function ModelSceneWarHUD:ctor(param)
    initWithCompositionActors(self, createCompositionActors())

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelSceneWarHUD:initView()
    local view = self.m_View
    assert(view, "ModelSceneWarHUD:initView() no view is attached to the actor of the model.")

    view:setViewConfirmBox(     self.m_ConfirmBoxActor:getView())
        :setViewMoneyEnergyInfo(self.m_MoneyEnergyInfoActor:getView())
        :setViewWarCommandMenu( self.m_WarCommandMenuActor:getView())
        :setViewActionMenu(     self.m_ActionMenuActor:getView())
        :setViewTileInfo(       self.m_TileInfoActor:getView())
        :setViewTileDetail(     self.m_TileDetailActor:getView())
        :setViewUnitInfo(       self.m_UnitInfoActor:getView())
        :setViewUnitDetail(     self.m_UnitDetailActor:getView())
        :setViewBattleInfo(     self.m_BattleInfoActor:getView())

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelSceneWarHUD:onEnter(rootActor)
    self.m_ActionMenuActor:onEnter(rootActor)
    self.m_WarCommandMenuActor:onEnter(rootActor)
    self.m_MoneyEnergyInfoActor:onEnter(rootActor)
    self.m_TileInfoActor:onEnter(rootActor)
    self.m_UnitInfoActor:onEnter(rootActor)
    self.m_BattleInfoActor:onEnter(rootActor)

    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtTurnPhaseBeginning", self)

    return self
end

function ModelSceneWarHUD:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseBeginning", self)
    self.m_RootScriptEventDispatcher = nil

    self.m_ActionMenuActor:onCleanup(rootActor)
    self.m_WarCommandMenuActor:onCleanup(rootActor)
    self.m_MoneyEnergyInfoActor:onCleanup(rootActor)
    self.m_TileInfoActor:onCleanup(rootActor)
    self.m_UnitInfoActor:onCleanup(rootActor)
    self.m_BattleInfoActor:onCleanup(rootActor)

    return self
end

function ModelSceneWarHUD:onEvent(event)
    if (event.name == "EvtTurnPhaseBeginning") then
        onEvtTurnPhaseBeginning(self, event)
    end

    return self
end

return ModelSceneWarHUD
