
local ModelSceneWarHUD = class("ModelSceneWarHUD")

local Actor = require("global.actors.Actor")

--------------------------------------------------------------------------------
-- The composition actors.
--------------------------------------------------------------------------------
local function createCompositionActors(param)
    local moneyEnergyInfoActor = Actor.createWithModelAndViewName("ModelMoneyEnergyInfo", nil, "ViewMoneyEnergyInfo")
    local unitInfoActor        = Actor.createWithModelAndViewName("ModelUnitInfo",        nil, "ViewUnitInfo")
    local unitDetailActor      = Actor.createWithModelAndViewName("ModelUnitDetail",      nil, "ViewUnitDetail")
    local tileInfoActor        = Actor.createWithModelAndViewName("ModelTileInfo",        nil, "ViewTileInfo")
    local tileDetailActor      = Actor.createWithModelAndViewName("ModelTileDetail",      nil, "ViewTileDetail")

    return {
        moneyEnergyInfoActor = moneyEnergyInfoActor,
        unitInfoActor        = unitInfoActor,
        unitDetailActor      = unitDetailActor,
        tileInfoActor        = tileInfoActor,
        tileDetailActor      = tileDetailActor
    }
end

local function initWithCompositionActors(model, actors)
    model.m_MoneyEnergyInfoActor = actors.moneyEnergyInfoActor

    model.m_UnitDetailActor = actors.unitDetailActor
    model.m_UnitInfoActor   = actors.unitInfoActor
    model.m_UnitInfoActor:getModel():setModelUnitDetail(model.m_UnitDetailActor:getModel())

    model.m_TileDetailActor = actors.tileDetailActor
    model.m_TileInfoActor   = actors.tileInfoActor
    model.m_TileInfoActor:getModel():setModelTileDetail(model.m_TileDetailActor:getModel())
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

    view:setViewMoneyEnergyInfo(self.m_MoneyEnergyInfoActor:getView())
        :setViewTileInfo(       self.m_TileInfoActor:getView())
        :setViewTileDetail(     self.m_TileDetailActor:getView())
        :setViewUnitInfo(       self.m_UnitInfoActor:getView())
        :setViewUnitDetail(     self.m_UnitDetailActor:getView())

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelSceneWarHUD:onEnter(rootActor)
    self.m_MoneyEnergyInfoActor:onEnter(rootActor)
    self.m_TileInfoActor:onEnter(rootActor)
    self.m_UnitInfoActor:onEnter(rootActor)

    return self
end

function ModelSceneWarHUD:onCleanup(rootActor)
    self.m_MoneyEnergyInfoActor:onCleanup(rootActor)
    self.m_TileInfoActor:onCleanup(rootActor)
    self.m_UnitInfoActor:onCleanup(rootActor)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelSceneWarHUD:showBeginTurnEffect(turnIndex, playerName, callbackOnDisappear)
    if (self.m_View) then
        self.m_View:showBeginTurnEffect(turnIndex, playerName, callbackOnDisappear)
    else
        callbackOnDisappear()
    end

    return self
end

return ModelSceneWarHUD
