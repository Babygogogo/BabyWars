
local ModelMoneyEnergyInfo = class("ModelMoneyEnergyInfo")

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseBeginning(self, event)
    self.m_PlayerIndex = event.playerIndex

    if (self.m_View) then
        self.m_View:setFund(event.player:getFund())
            :setEnergy(event.player:getCOEnergy())
    end
end

local function onEvtModelPlayerUpdated(self, event)
    if ((self.m_PlayerIndex == event.playerIndex) and (self.m_View)) then
        self.m_View:setFund(event.modelPlayer:getFund())
            :setEnergy(event.modelPlayer:getCOEnergy())
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:ctor(param)
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

function ModelMoneyEnergyInfo:setModelWarCommandMenu(model)
    model:setEnabled(false)
    self.m_WarCommandMenuModel = model

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtTurnPhaseBeginning", self)
        :addEventListener("EvtModelPlayerUpdated", self)

    return self
end

function ModelMoneyEnergyInfo:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtModelPlayerUpdated", self)
        :removeEventListener("EvtTurnPhaseBeginning", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelMoneyEnergyInfo:onEvent(event)
    local eventName = event.name
    if (eventName == "EvtTurnPhaseBeginning") then
        onEvtTurnPhaseBeginning(self, event)
    elseif (eventName == "EvtModelPlayerUpdated") then
        onEvtModelPlayerUpdated(self, event)
    end
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:onPlayerTouch()
    self.m_WarCommandMenuModel:setEnabled(true)

    return self
end

function ModelMoneyEnergyInfo:adjustPositionOnTouch(touch)
    if (self.m_View) then
        self.m_View:adjustPositionOnTouch(touch)
    end

    return self
end

return ModelMoneyEnergyInfo
