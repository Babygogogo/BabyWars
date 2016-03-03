
local EventDispatcher = class("EventDispatcher")

local function hasListener(listenersForName, listener)
    if (listenersForName) then
        for i, l in ipairs(listenersForName) do
            if (l == listener) then
                return true, i
            end
        end
    end
    
    return false
end

local function forceAddEventListener(listenerCollection, eventName, listener)
    if (not listenerCollection[eventName]) then
        listenerCollection[eventName] = {}
    end
    
    local listenersForName = listenerCollection[eventName]
    if (hasListener(listenersForName, listener)) then
        error("EventDispatcher-forceAddEventListener() the listener already exists.")
    else
        listenersForName[#listenersForName + 1] = listener
    end
end

local function forceRemoveEventListener(listenerCollection, eventName, listener)
    local has, index = hasListener(listenerCollection[eventName], listener)
    if (has) then
        table.remove(listenerCollection[eventName], index)
    end
end

local function doCachedOperations(operations)
    for _, op in ipairs(operations) do
        op()
    end    
end

function EventDispatcher:ctor(param)
    self.m_Listeners = {}
    self.m_NestLevelOfDispatch = 0
    self.m_OperationCache = {}

    if (param) then
        self:load(param)
    end
    
    return self
end

function EventDispatcher:load(param)
    return self
end

function EventDispatcher.createInstance(param)
    local dispatcher = EventDispatcher:create():load(param)
    assert(dispatcher, "EventDispatcher.createInstance() failed.")
    
    return dispatcher
end

-- You must remove listeners that you added, or the listeners will live forever.
-- If you try to add/remove listeners during dispatch, the add/remove operations will be cached and be done when the dispatch ends.
function EventDispatcher:addEventListener(eventName, listener)
    assert(type(eventName) == "string", "EventDispatcher:addEventListener() the param eventName is not a string.")
    assert(type(listener.onEvent) == "function", "EventDispatcher:addEventListener() the param listener.onEvent is not a function.")
    assert(self.m_NestLevelOfDispatch >= 0, "EventDispatcher:addEventListener() the nesting level of dispatch is less than 0, which is illegal.")

    if (self.m_NestLevelOfDispatch == 0) then
        forceAddEventListener(self.m_Listeners, eventName, listener)
    else
        self.m_OperationCache[#self.m_OperationCache + 1] = function()
            self:addEventListener(eventName, listener)
        end
    end
    
    return self
end

-- If you try to add/remove listeners during dispatch, the add/remove operations will be cached and be done when the dispatch ends.
function EventDispatcher:removeEventListener(eventName, listener)
    assert(type(eventName) == "string", "EventDispatcher:removeEventListener() the param eventName is not a string.")
    assert(self.m_NestLevelOfDispatch >= 0, "EventDispatcher:removeEventListener() the nesting level of dispatch is less than 0, which is illegal.")

    if (self.m_NestLevelOfDispatch == 0) then
        forceRemoveEventListener(self.m_Listeners, eventName, listener)
    else
        self.m_OperationCache[#self.m_OperationCache + 1] = function()
            self:removeEventListener(eventName, listener)
        end
    end
    
    return self
end

function EventDispatcher:hasEventListener(eventName, listener)
    return hasListener(self.m_Listeners[eventName], listener)
end

-- The dispatch can be nested.
-- If you try to add/remove listeners during dispatch, the add/remove operations will be cached and be done when the dispatch ends.
function EventDispatcher:dispatchEvent(eventObj)
    assert(self.m_NestLevelOfDispatch >= 0, "EventDispatcher:dispatchEvent() the nesting level of dispatch is less than 0, which is illegal.")
    
    self.m_NestLevelOfDispatch = self.m_NestLevelOfDispatch + 1
    if (self.m_NestLevelOfDispatch >= 2) then
        print("EventDispatcher:dispatcher() the nesting level of dispatch is growing to: " .. self.m_NestLevelOfDispatch)
    end
    
    local name = eventObj.name
    assert(type(name) == "string", "EventDispatcher:dispatchEvent() the param eventObj.name is not a string.")

    for _, listener in ipairs(self.m_Listeners[name]) do
        listener:onEvent(eventObj)
    end
    
    self.m_NestLevelOfDispatch = self.m_NestLevelOfDispatch - 1
    
    if (self.m_NestLevelOfDispatch == 0) then
        doCachedOperations(self.m_OperationCache)
        self.m_OperationCache = {}
    end

    return self
end

return EventDispatcher
