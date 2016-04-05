
local ModelUnitInfo = class("ModelUnitInfo")

local function onEvtPlayerTouchUnit(model, event)
    model.m_ModelUnit = event.unitModel

    if (model.m_View) then
        model.m_View:updateWithModelUnit(event.unitModel)
        model.m_View:setVisible(true)
    end
end

local function onEvtPlayerTouchNoUnit(model, event)
    if (model.m_View) then
        model.m_View:setVisible(false)
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializer.
--------------------------------------------------------------------------------
function ModelUnitInfo:ctor(param)
    return self
end

function ModelUnitInfo:setModelUnitDetail(model)
    self.m_UnitDetailModel = model

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelUnitInfo:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtPlayerTouchUnit",   self)
                                    :addEventListener("EvtPlayerTouchNoUnit", self)

    return self
end

function ModelUnitInfo:onCleanup(rootActor)
    -- removeEventListener can be commented out because the dispatcher itself is being destroyed.
    self.m_RootScriptEventDispatcher:removeEventListener("EvtPlayerTouchUnit",   self)
                                    :removeEventListener("EvtPlayerTouchNoUnit", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelUnitInfo:onEvent(event)
    if (event.name == "EvtPlayerTouchNoUnit") then
        onEvtPlayerTouchNoUnit(self, event)
    elseif (event.name == "EvtPlayerTouchUnit") then
        onEvtPlayerTouchUnit(self, event)
    end

    return self
end

function ModelUnitInfo:onPlayerTouch()
    if (self.m_UnitDetailModel) then
        self.m_UnitDetailModel:updateWithModelUnit(self.m_ModelUnit)
            :setEnabled(true)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelUnitInfo:adjustPositionOnTouch(touch)
    if (self.m_View) then
        self.m_View:adjustPositionOnTouch(touch)
    end

    return self
end

return ModelUnitInfo
