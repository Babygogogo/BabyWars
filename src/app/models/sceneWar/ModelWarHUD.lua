
--[[--------------------------------------------------------------------------------
-- ModelWarHUD是战局场景上的各个UI的集合。
--
-- 主要职责和使用场景举例：
--   构造和显示各个UI。
--
-- 其他：
--  - ModelWarHUD目前由以下子actor组成：
--    - ConfirmBox
--    - WarCommandMenu
--    - MoneyEnergyInfo
--    - ActionMenu
--    - UnitDetail
--    - UnitInfo
--    - TileDetail
--    - TileInfo
--    - BattleInfo
--]]--------------------------------------------------------------------------------

local ModelWarHUD = class("ModelWarHUD")

local Actor = require("src.global.actors.Actor")

--------------------------------------------------------------------------------
-- The composition actors.
--------------------------------------------------------------------------------
local function initActorConfirmBox(self)
    self.m_ActorConfirmBox = Actor.createWithModelAndViewName("common.ModelConfirmBox", nil, "common.ViewConfirmBox")
end

local function initActorWarCommandMenu(self)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelWarCommandMenu", nil, "sceneWar.ViewWarCommandMenu")
    actor:getModel():setModelConfirmBox(self.m_ActorConfirmBox:getModel())

    self.m_ActorWarCommandMenu = actor
end

local function initActorMoneyEnergyInfo(self)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelMoneyEnergyInfo", nil, "sceneWar.ViewMoneyEnergyInfo")
    actor:getModel():setModelWarCommandMenu(self.m_ActorWarCommandMenu:getModel())

    self.m_ActorMoneyEnergyInfo = actor
end

local function initActorActionMenu(self)
    self.m_ActorActionMenu = Actor.createWithModelAndViewName("sceneWar.ModelActionMenu", nil, "sceneWar.ViewActionMenu")
end

local function initActorUnitDetail(self)
    self.m_ActorUnitDetail = Actor.createWithModelAndViewName("sceneWar.ModelUnitDetail", nil, "sceneWar.ViewUnitDetail")
end

local function initActorUnitInfo(self)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelUnitInfo", nil, "sceneWar.ViewUnitInfo")
    actor:getModel():setModelUnitDetail(self.m_ActorUnitDetail:getModel())

    self.m_ActorUnitInfo = actor
end

local function initActorTileDetail(self)
    self.m_ActorTileDetail = Actor.createWithModelAndViewName("sceneWar.ModelTileDetail", nil, "sceneWar.ViewTileDetail")
end

local function initActorTileInfo(self)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelTileInfo", nil, "sceneWar.ViewTileInfo")
    actor:getModel():setModelTileDetail(self.m_ActorTileDetail:getModel())

    self.m_ActorTileInfo = actor
end

local function initActorBattleInfo(self)
    self.m_ActorBattleInfo = Actor.createWithModelAndViewName("sceneWar.ModelBattleInfo", nil, "sceneWar.ViewBattleInfo")
end

--------------------------------------------------------------------------------
-- The contructor and initializers.
--------------------------------------------------------------------------------
function ModelWarHUD:ctor(param)
    initActorConfirmBox(     self)
    initActorWarCommandMenu( self)
    initActorMoneyEnergyInfo(self)
    initActorActionMenu(     self)
    initActorUnitDetail(     self)
    initActorUnitInfo(       self)
    initActorTileDetail(     self)
    initActorTileInfo(       self)
    initActorBattleInfo(     self)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelWarHUD:initView()
    local view = self.m_View
    assert(view, "ModelWarHUD:initView() no view is attached to the actor of the model.")

    view:setViewConfirmBox(     self.m_ActorConfirmBox:getView())
        :setViewMoneyEnergyInfo(self.m_ActorMoneyEnergyInfo:getView())
        :setViewWarCommandMenu( self.m_ActorWarCommandMenu:getView())
        :setViewActionMenu(     self.m_ActorActionMenu:getView())
        :setViewTileInfo(       self.m_ActorTileInfo:getView())
        :setViewTileDetail(     self.m_ActorTileDetail:getView())
        :setViewUnitInfo(       self.m_ActorUnitInfo:getView())
        :setViewUnitDetail(     self.m_ActorUnitDetail:getView())
        :setViewBattleInfo(     self.m_ActorBattleInfo:getView())

    return self
end

function ModelWarHUD:setModelWarField(model)
    assert(self.m_ModelWarField == nil, "ModelWarHUD:setModelWarField() the model has been set.")
    self.m_ActorWarCommandMenu:getModel():setModelWarField(model)
    self.m_ActorUnitInfo:getModel():setModelUnitMap(model:getModelUnitMap())
    self.m_ActorTileInfo:getModel():setModelTileMap(model:getModelTileMap())

    return self
end

function ModelWarHUD:setModelPlayerManager(model)
    self.m_ActorWarCommandMenu:getModel():setModelPlayerManager(model)

    return self
end

function ModelWarHUD:setModelMessageIndicator(model)
    self.m_ActorWarCommandMenu:getModel():setModelMessageIndicator(model)

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

    return self
end

function ModelWarHUD:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelWarHUD:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher = nil

    self.m_ActorActionMenu     :getModel():unsetRootScriptEventDispatcher()
    self.m_ActorWarCommandMenu :getModel():unsetRootScriptEventDispatcher()
    self.m_ActorMoneyEnergyInfo:getModel():unsetRootScriptEventDispatcher()
    self.m_ActorTileInfo       :getModel():unsetRootScriptEventDispatcher()
    self.m_ActorUnitInfo       :getModel():unsetRootScriptEventDispatcher()
    self.m_ActorBattleInfo     :getModel():unsetRootScriptEventDispatcher()

    return self
end

return ModelWarHUD
