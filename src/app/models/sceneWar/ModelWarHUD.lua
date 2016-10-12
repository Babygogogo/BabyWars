
--[[--------------------------------------------------------------------------------
-- ModelWarHUD是战局场景上的各个UI的集合。
--
-- 主要职责和使用场景举例：
--   构造和显示各个UI。
--
-- 其他：
--  - ModelWarHUD目前由以下子actor组成：
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
local function initActorWarCommandMenu(self)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelWarCommandMenu", nil, "sceneWar.ViewWarCommandMenu")
    actor:getModel():setEnabled(false)

    self.m_ActorWarCommandMenu = actor
end

local function initActorMoneyEnergyInfo(self)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelMoneyEnergyInfo", nil, "sceneWar.ViewMoneyEnergyInfo")

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

    view:setViewActionMenu(     self.m_ActorActionMenu:     getView())
        :setViewBattleInfo(     self.m_ActorBattleInfo:     getView())
        :setViewMoneyEnergyInfo(self.m_ActorMoneyEnergyInfo:getView())
        :setViewTileDetail(     self.m_ActorTileDetail:     getView())
        :setViewTileInfo(       self.m_ActorTileInfo:       getView())
        :setViewUnitDetail(     self.m_ActorUnitDetail:     getView())
        :setViewUnitInfo(       self.m_ActorUnitInfo:       getView())
        :setViewWarCommandMenu( self.m_ActorWarCommandMenu: getView())

    return self
end

--------------------------------------------------------------------------------
-- The public callback function on start running.
--------------------------------------------------------------------------------
function ModelWarHUD:onStartRunning(sceneWarFileName)
    self.m_ActorActionMenu     :getModel():onStartRunning(sceneWarFileName)
    self.m_ActorBattleInfo     :getModel():onStartRunning(sceneWarFileName)
    self.m_ActorMoneyEnergyInfo:getModel():onStartRunning(sceneWarFileName)
    self.m_ActorTileInfo       :getModel():onStartRunning(sceneWarFileName)
    self.m_ActorUnitInfo       :getModel():onStartRunning(sceneWarFileName)
    self.m_ActorWarCommandMenu :getModel():onStartRunning(sceneWarFileName)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelWarHUD:getModelWarCommandMenu()
    return self.m_ActorWarCommandMenu:getModel()
end

return ModelWarHUD
