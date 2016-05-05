
--[[--------------------------------------------------------------------------------
-- EventDispatcher是一个简单的事件分发器。
--
-- 主要职责：
--   注册/反注册侦听器
--   分发事件
--
-- 使用场景举例：
--   代码中多处使用，由于概念与常规的没有什么不同，因此不细说。
--
-- 其他：
--   - EventDispatcher无法自动对失效的侦听器进行反注册，所以注册侦听器的代码必须同时负责反注册（类似c++中的new/delete必须配对）。
--
--   - 分发事件时，事件是立即分发的。也就是说，侦听器会马上被触发，而不会等到帧结束。
--     这衍生了无限事件连锁的问题，也就是如果事件的分发导致了新事件的分发，而且没有合适的终止，那么程序就会因此陷入死循环。
--     但即便如此，我也觉得立即分发比延迟分发有优势（延迟分发必须考虑侦听器在分发前死亡等的棘手问题，而如果立即分发导致了死循环，debug起来也不算难），因此还是使用了立即分发的模式。
--     另外，如果分发事件引起了侦听器的注册/反注册，那么这些注册/反注册操作将被缓存，等到整个事件（包括连锁事件）处理完毕后再自动进行。
--]]--------------------------------------------------------------------------------

local EventDispatcher = class("EventDispatcher")

local DISPATCH_NEST_INFORMING_LEVEL = 3

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
    self:reset()

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

function EventDispatcher:reset()
    assert(self.m_NestLevelOfDispatch == 0 or self.m_NestLevelOfDispatch == nil, "EventDispatcher:reset() an dispatch is currently running.")

    self.m_Listeners = {}
    self.m_NestLevelOfDispatch = 0
    self.m_OperationCache = {}

    return self
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
    if (self.m_NestLevelOfDispatch >= DISPATCH_NEST_INFORMING_LEVEL) then
        print("EventDispatcher:dispatcher() the nesting level of dispatch is growing to: " .. self.m_NestLevelOfDispatch)
    end

    local name = eventObj.name
    assert(type(name) == "string", "EventDispatcher:dispatchEvent() the param eventObj.name is not a string.")

    local listenersForName = self.m_Listeners[name]
    if (listenersForName) then
        for _, listener in ipairs(listenersForName) do
            listener:onEvent(eventObj)
        end
    end

    self.m_NestLevelOfDispatch = self.m_NestLevelOfDispatch - 1

    if (self.m_NestLevelOfDispatch == 0) then
        doCachedOperations(self.m_OperationCache)
        self.m_OperationCache = {}
    end

    return self
end

return EventDispatcher
