
local CModelWarHUD = class("CModelWarHUD")

local Actor = requireBW("src.global.actors.Actor")

--------------------------------------------------------------------------------
-- The composition actors.
--------------------------------------------------------------------------------
local function initActorWarCommandMenu(self)
    self.m_ActorWarCommandMenu = Actor.createWithModelAndViewName("sceneCampaign.CModelWarCommandMenu", nil, "sceneWar.ViewWarCommandMenu")
end

local function initActorMoneyEnergyInfo(self)
    self.m_ActorMoneyEnergyInfo = Actor.createWithModelAndViewName("sceneWar.ModelMoneyEnergyInfo", nil, "sceneWar.ViewMoneyEnergyInfo")
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
function CModelWarHUD:ctor(isReplay)
    initActorWarCommandMenu( self)
    initActorMoneyEnergyInfo(self)
    initActorActionMenu(     self)
    initActorUnitDetail(     self)
    initActorUnitInfo(       self)
    initActorTileDetail(     self)
    initActorTileInfo(       self)
    initActorBattleInfo(     self)

    return self
end

function CModelWarHUD:initView()
    local view = self.m_View
    assert(view, "CModelWarHUD:initView() no view is attached to the actor of the model.")

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
function CModelWarHUD:onStartRunning(modelSceneWar)
    self.m_ActorActionMenu     :getModel():onStartRunning(modelSceneWar)
    self.m_ActorBattleInfo     :getModel():onStartRunning(modelSceneWar)
    self.m_ActorMoneyEnergyInfo:getModel():onStartRunning(modelSceneWar)
    self.m_ActorTileInfo       :getModel():onStartRunning(modelSceneWar)
    self.m_ActorUnitInfo       :getModel():onStartRunning(modelSceneWar)
    self.m_ActorWarCommandMenu :getModel():onStartRunning(modelSceneWar)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function CModelWarHUD:getModelWarCommandMenu()
    return self.m_ActorWarCommandMenu:getModel()
end

return CModelWarHUD
