
--[[--------------------------------------------------------------------------------
-- ModelGridExplosion用于显示一个格子上的爆炸效果。
--
-- 主要职责及使用场景举例：
--   当有unit或tile爆炸时，显示爆炸效果（通过event来获知爆炸事件）。
--
-- 其他：
--   - 本类能够同时显示多处爆炸，因此也可以用于显示导弹爆炸的效果。
--]]--------------------------------------------------------------------------------

local ModelGridExplosion = class("ModelGridExplosion")

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelGridExplosion:ctor()
    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelGridExplosion:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtDestroyViewUnit", self)
        :addEventListener("EvtDestroyViewTile", self)

    return self
end

function ModelGridExplosion:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtDestroyViewTile", self)
        :removeEventListener("EvtDestroyViewUnit", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelGridExplosion:onEvent(event)
    local name = event.name
    if ((name == "EvtDestroyViewUnit") or (name == "EvtDestroyViewTile")) then
        self:showExplosion(event.gridIndex)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelGridExplosion:showExplosion(gridIndex, callbackOnFinish)
    if (self.m_View) then
        self.m_View:showExplosion(gridIndex, callbackOnFinish)
    elseif (callbackOnFinish) then
        callbackOnFinish()
    end

    return self
end

return ModelGridExplosion
