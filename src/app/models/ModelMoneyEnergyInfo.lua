
local ModelMoneyEnergyInfo = class("ModelMoneyEnergyInfo")

local WAR_COMMAND_MENU_Z_ORDER = 2

local Actor = require("global.actors.Actor")

local function createWarCommandMenuActor()
    return Actor.createWithModelAndViewName("ModelWarCommandMenu", nil, "ViewWarCommandMenu")
end

--------------------------------------------------------------------------------
-- The touch listener for view.
--------------------------------------------------------------------------------
local function createTouchListener(model)
    local touchListener = cc.EventListenerTouchOneByOne:create()

    local function onTouchBegan(touch, event)
        if (model.m_View) then
            model.m_View:adjustPositionOnTouch(touch)
        end

        return true
    end

    local function onTouchMoved(touch, event)
        if (model.m_View) then
            model.m_View:adjustPositionOnTouch(touch)
        end
    end

    local function onTouchCancelled(touch, event)
    end

    local function onTouchEnded(touch, event)
        if (model.m_View) then
            model.m_View:adjustPositionOnTouch(touch)
        end
    end

    touchListener:registerScriptHandler(onTouchBegan,     cc.Handler.EVENT_TOUCH_BEGAN)
    touchListener:registerScriptHandler(onTouchMoved,     cc.Handler.EVENT_TOUCH_MOVED)
    touchListener:registerScriptHandler(onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED)
    touchListener:registerScriptHandler(onTouchEnded,     cc.Handler.EVENT_TOUCH_ENDED)

    return touchListener
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function ModelMoneyEnergyInfo:load(param)
    return self
end

function ModelMoneyEnergyInfo.createInstance(param)
    local model = ModelMoneyEnergyInfo.new():load(param)
    assert(model, "ModelMoneyEnergyInfo.createInstance() failed.")

    return model
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:initView()
    local view = self.m_View
    assert(view, "ModelMoneyEnergyInfo:initView() no view is attached to the owner actor of the model.")

    view:setTouchListener(createTouchListener(self))

    return self
end

function ModelMoneyEnergyInfo:onPlayerTouch()
    if (self.m_WarCommandMenuActor) then
        self.m_WarCommandMenuActor:getModel():setEnabled(true)
    else
        self.m_WarCommandMenuActor = createWarCommandMenuActor()
        self.m_View:getScene():addChild(self.m_WarCommandMenuActor:getView(), WAR_COMMAND_MENU_Z_ORDER)
    end

    return self
end

return ModelMoneyEnergyInfo
