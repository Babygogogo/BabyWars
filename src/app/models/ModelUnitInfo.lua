
local ModelUnitInfo = class("ModelUnitInfo")

local UNIT_DETAIL_Z_ORDER = 2

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

function ModelUnitInfo:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function ModelUnitInfo:load(param)
    return self
end

function ModelUnitInfo.createInstance(param)
    local model = ModelUnitInfo.new():load(param)
    assert(model, "ModelUnitInfo.createInstance() failed.")

    return model
end

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
    if (not self.m_DetailActor) then
        self.m_DetailActor = require("global.actors.Actor").createWithModelAndViewName("ModelUnitDetail", nil, "ViewUnitDetail")
        self.m_View:getScene():addChild(self.m_DetailActor:getView(), UNIT_DETAIL_Z_ORDER)
    end

    local modelDetail = self.m_DetailActor:getModel()
    modelDetail:updateWithModelUnit(self.m_ModelUnit)
        :setEnabled(true)

    return self
end

return ModelUnitInfo
