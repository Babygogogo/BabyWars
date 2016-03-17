
local ModelSceneWarHUD = class("ModelSceneWarHUD")

local Actor = require("global.actors.Actor")

--------------------------------------------------------------------------------
-- The composition actors.
--------------------------------------------------------------------------------
local function createCompositionActors(param)
    local moneyEnergyInfoActor = Actor.createWithModelAndViewName("ModelMoneyEnergyInfo", nil, "ViewMoneyEnergyInfo")
    local unitInfoActor        = Actor.createWithModelAndViewName("ModelUnitInfo", nil, "ViewUnitInfo")
    local tileInfoActor        = Actor.createWithModelAndViewName("ModelTileInfo", nil, "ViewTileInfo")

    return {moneyEnergyInfoActor = moneyEnergyInfoActor,
            unitInfoActor        = unitInfoActor,
            tileInfoActor        = tileInfoActor}
end

local function initWithCompositionActors(model, actors)
    model.m_MoneyEnergyInfoActor = actors.moneyEnergyInfoActor
    model.m_UnitInfoActor        = actors.unitInfoActor
    model.m_TileInfoActor        = actors.tileInfoActor
end

--------------------------------------------------------------------------------
-- The touch listener for view.
--------------------------------------------------------------------------------
local function createTouchListener(model)
    local touchListener = cc.EventListenerTouchOneByOne:create()

    local function onTouchBegan(touch, event)
        model.m_MoneyEnergyInfoActor:getModel():adjustPositionOnTouch(touch)
        model.m_TileInfoActor:getModel():adjustPositionOnTouch(touch)
        model.m_UnitInfoActor:getModel():adjustPositionOnTouch(touch)

        return true
    end

    local function onTouchMoved(touch, event)
        model.m_MoneyEnergyInfoActor:getModel():adjustPositionOnTouch(touch)
        model.m_TileInfoActor:getModel():adjustPositionOnTouch(touch)
        model.m_UnitInfoActor:getModel():adjustPositionOnTouch(touch)
    end

    local function onTouchCancelled(touch, event)
    end

    local function onTouchEnded(touch, event)
        model.m_MoneyEnergyInfoActor:getModel():adjustPositionOnTouch(touch)
        model.m_TileInfoActor:getModel():adjustPositionOnTouch(touch)
        model.m_UnitInfoActor:getModel():adjustPositionOnTouch(touch)
    end

    touchListener:registerScriptHandler(onTouchBegan,     cc.Handler.EVENT_TOUCH_BEGAN)
    touchListener:registerScriptHandler(onTouchMoved,     cc.Handler.EVENT_TOUCH_MOVED)
    touchListener:registerScriptHandler(onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED)
    touchListener:registerScriptHandler(onTouchEnded,     cc.Handler.EVENT_TOUCH_ENDED)

    return touchListener
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
        :setViewUnitInfo(       self.m_UnitInfoActor:getView())

        :setTouchListener(createTouchListener(self))

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
