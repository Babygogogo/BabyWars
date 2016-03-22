
local ModelMoneyEnergyInfo = class("ModelMoneyEnergyInfo")

local WAR_COMMAND_MENU_Z_ORDER = 2

local Actor = require("global.actors.Actor")

--------------------------------------------------------------------------------
-- The war command menu actor.
--------------------------------------------------------------------------------
local function createWarCommandMenuActor()
    return Actor.createWithModelAndViewName("ModelWarCommandMenu", nil, "ViewWarCommandMenu")
end

local function initWithWarCommandMenuActor(model, actor)
    model.m_WarCommandMenuActor = actor
    actor:getModel():setEnabled(false)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:ctor(param)
    initWithWarCommandMenuActor(self, createWarCommandMenuActor())

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelMoneyEnergyInfo:initView()
    local view = self.m_View
    assert(view, "ModelMoneyEnergyInfo:initView() no view is attached to the owner actor of the model.")

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtPlayerSwitched", self)

    rootActor:getView():addChild(self.m_WarCommandMenuActor:getView(), WAR_COMMAND_MENU_Z_ORDER)

    self.m_WarCommandMenuActor:onEnter(rootActor)

    return self
end

function ModelMoneyEnergyInfo:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtPlayerSwitched", self)
    self.m_RootScriptEventDispatcher = nil

    self.m_WarCommandMenuActor:onCleanup(rootActor)

    return self
end

function ModelMoneyEnergyInfo:onEvent(event)
    if (event.name == "EvtPlayerSwitched") then
        if (self.m_View) then
            self.m_View:setFund(event.player:getFund())
                :setEnergy(event.player:getCOEnergy())
        end
    end
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:onPlayerTouch()
    self.m_WarCommandMenuActor:getModel():setEnabled(true)

    return self
end

function ModelMoneyEnergyInfo:adjustPositionOnTouch(touch)
    if (self.m_View) then
        self.m_View:adjustPositionOnTouch(touch)
    end

    return self
end

return ModelMoneyEnergyInfo
