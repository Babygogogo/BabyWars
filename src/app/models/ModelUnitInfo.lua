
local ModelUnitInfo = class("ModelUnitInfo")

local function createDetailActor()
    return require("global.actors.Actor").createWithModelAndViewName("ModelUnitDetail", nil, "ViewUnitDetail")
end

local function createEventListenerPlayerTouchUnit(model)
    local callback = function(event)
        if (model.m_View) then
            model.m_View:updateWithModelUnit(event.m_UnitModel)
            model.m_View:setVisible(true)
        end
    end

    return cc.EventListenerCustom:create("EvtPlayerTouchUnit", callback)
end

local function initWithEventListenerPlayerTouchUnit(model, listener)
    model.m_PlayerTouchUnitListener = listener
    display.getRunningScene():getEventDispatcher():addEventListenerWithFixedPriority(listener, 1)
end

local function createEventListenerPlayerTouchNoUnit(model)
    local callback = function(event)
        if (model.m_View) then
            model.m_View:setVisible(false)
        end
    end
    
    return cc.EventListenerCustom:create("EvtPlayerTouchNoUnit", callback)
end

local function initWithEventListenerPlayerTouchNoUnit(model, listener)
    model.m_PlayerTouchNoUnitListener = listener
    display.getRunningScene():getEventDispatcher():addEventListenerWithFixedPriority(listener, 1)
end    

function ModelUnitInfo:ctor(param)
    initWithEventListenerPlayerTouchUnit(self, createEventListenerPlayerTouchUnit(self))
    initWithEventListenerPlayerTouchNoUnit(self, createEventListenerPlayerTouchNoUnit(self))

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

function ModelUnitInfo:onPlayerTouch()
    if (self.m_DetailActor) then
        self.m_DetailActor:getModel():setEnabled(true)
    else
        self.m_DetailActor = createDetailActor()
        self.m_View:getScene():addChild(self.m_DetailActor:getView())
    end
    
    return self
end

return ModelUnitInfo
