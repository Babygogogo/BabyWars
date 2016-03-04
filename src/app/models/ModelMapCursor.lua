
local ModelMapCursor = class("ModelMapCursor")

local function createTouchListener(model)
    local isTouchMoved = false

    local function onTouchBegan(touch, event)
        isTouchMoved = false
        return true
    end

    local function onTouchMoved(touch, event)
        isTouchMoved = true
    end

    local function onTouchCancelled(touch, event)
    end
        
    local function onTouchEnded(touch, event)
        if (not isTouchMoved) then
            model:setGridIndex(model.m_View:convertWorldPosToGridIndex(touch:getLocation()))
        end
    end

    local touchListener = cc.EventListenerTouchOneByOne:create()
    touchListener:registerScriptHandler(onTouchBegan,     cc.Handler.EVENT_TOUCH_BEGAN)
    touchListener:registerScriptHandler(onTouchMoved,     cc.Handler.EVENT_TOUCH_MOVED)
    touchListener:registerScriptHandler(onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED)
    touchListener:registerScriptHandler(onTouchEnded,     cc.Handler.EVENT_TOUCH_ENDED)

    return touchListener
end

function ModelMapCursor:ctor(param)
    require("global.components.ComponentManager").bindComponent(self, "GridIndexable")
    self:setGridIndex({x = 1, y = 1})

    if (param) then
        self:load(param)
    end
    
    return self
end

function ModelMapCursor:load(param)
    if (param and param.gridIndex) then
        self:setGridIndex(param.gridIndex)
    end
    
    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelMapCursor.createInstance(param)
    local model = ModelMapCursor:create():load(param)
    assert(model, "ModelMapCursor.createInstance() failed.")
    
    return model
end

function ModelMapCursor:initView()
    local view = self.m_View
    assert(view, "ModelMapCursor:initView() no view is attached to the owner actor of the model.")
    
    self:setViewPositionWithGridIndex()
    view:initWithTouchListener(createTouchListener(self))
    
    return self
end

return ModelMapCursor
