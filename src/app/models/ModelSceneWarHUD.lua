
local ModelSceneWarHUD = class("ModelSceneWarHUD")

local function createChildrenActors(param)
    local Actor = require("global.actors.Actor")

    local moneyEnergyInfoActor = Actor.createWithModelAndViewName("ModelMoneyEnergyInfo", nil, "ViewMoneyEnergyInfo")
    assert(moneyEnergyInfoActor, "ModelSceneWarHUD-createChildrenActors() failed to create a MoneyEnergyInfo actor.")

    local unitInfoActor = Actor.createWithModelAndViewName("ModelUnitInfo", nil, "ViewUnitInfo")
    assert(unitInfoActor, "ModelSceneWarHUD-createChildrenActors() failed to create a UnitInfo actor.")

    local tileInfoActor = Actor.createWithModelAndViewName("ModelTileInfo", nil, "ViewTileInfo")
    assert(tileInfoActor, "ModelSceneWarHUD-createChildrenActors() failed to create a TileInfo actor.")

    return {moneyEnergyInfoActor = moneyEnergyInfoActor,
            unitInfoActor        = unitInfoActor,
            tileInfoActor        = tileInfoActor}
end

local function initWithChildrenActors(model, actors)
    model.m_MoneyEnergyInfoActor = actors.moneyEnergyInfoActor
    assert(model.m_MoneyEnergyInfoActor, "ModelSceneWarHUD-initWithChildrenActors() failed to retrieve a MoneyEnergyInfo actor.")

    model.m_UnitInfoActor = actors.unitInfoActor
    assert(model.m_UnitInfoActor, "ModelSceneWarHUD-initWithChildrenActors() failed to retrieve a UnitInfo actor.")

    model.m_TileInfoActor = actors.tileInfoActor
    assert(model.m_TileInfoActor, "ModelSceneWarHUD-initWithChildrenActors() failed to retrieve a TileInfo actor.")
end

--------------------------------------------------------------------------------
-- The contructor.
--------------------------------------------------------------------------------
function ModelSceneWarHUD:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function ModelSceneWarHUD:load(param)
    initWithChildrenActors(self, createChildrenActors(param))

    return self
end

function ModelSceneWarHUD.createInstance(param)
    local model = ModelSceneWarHUD.new():load(param)
    assert(model, "ModelSceneWarHUD.createInstance() failed.")

    return model
end

function ModelSceneWarHUD:initView()
    local view = self.m_View
    assert(view, "ModelSceneWarHUD:initView() no view is attached to the actor of the model.")

    view:setViewMoneyEnergyInfo(self.m_MoneyEnergyInfoActor:getView())
        :setViewTileInfo(       self.m_TileInfoActor:getView())
        :setViewUnitInfo(       self.m_UnitInfoActor:getView())

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

return ModelSceneWarHUD
