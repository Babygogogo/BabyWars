
local ModelMoneyEnergyInfo = class("ModelMoneyEnergyInfo")

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
    self.m_RootScriptEventDispatcher:addEventListener("EvtTurnStarted", self)

    return self
end

function ModelMoneyEnergyInfo:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnStarted", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelMoneyEnergyInfo:onEvent(event)
    if (event.name == "EvtTurnStarted") then
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
