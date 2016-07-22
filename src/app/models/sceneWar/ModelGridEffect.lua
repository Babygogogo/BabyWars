
--[[--------------------------------------------------------------------------------
-- ModelGridEffect用于显示一个格子上的爆炸效果。
--
-- 主要职责及使用场景举例：
--   当有unit或tile爆炸时，显示爆炸效果（通过event来获知爆炸事件）。
--
-- 其他：
--   - 本类能够同时显示多处爆炸，因此也可以用于显示导弹爆炸的效果。
--]]--------------------------------------------------------------------------------

local ModelGridEffect = class("ModelGridEffect")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function showAnimationExplosion(self, gridIndex, callbackOnFinish)
    if (self.m_View) then
        self.m_View:showAnimationExplosion(gridIndex, callbackOnFinish)
    elseif (callbackOnFinish) then
        callbackOnFinish()
    end
end

local function showAnimationDamage(self, gridIndex, callbackOnFinish)
    if (self.m_View) then
        self.m_View:showAnimationDamage(gridIndex, callbackOnFinish)
    elseif (callbackOnFinish) then
        callbackOnFinish()
    end
end

local function showAnimationSupply(self, gridIndex)
    if (self.m_View) then
        self.m_View:showAnimationSupply(gridIndex)
    end
end

local function showAnimationRepair(self, gridIndex)
    if (self.m_View) then
        self.m_View:showAnimationRepair(gridIndex)
    end
end

local function showAnimationSiloAttack(self, gridIndex)
    if (self.m_View) then
        self.m_View:showAnimationSiloAttack(gridIndex)
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelGridEffect:ctor()
    return self
end

function ModelGridEffect:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelGridEffect:setRootScriptEventDispatcher() the dispatcher has been set.")

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtDestroyViewUnit", self)
        :addEventListener("EvtDestroyViewTile", self)
        :addEventListener("EvtAttackViewUnit",  self)
        :addEventListener("EvtAttackViewTile",  self)
        :addEventListener("EvtSupplyViewUnit",  self)
        :addEventListener("EvtRepairViewUnit",  self)
        :addEventListener("EvtSiloAttackGrid",  self)

    return self
end

function ModelGridEffect:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelGridEffect:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtSiloAttackGrid", self)
        :removeEventListener("EvtRepairViewUnit", self)
        :removeEventListener("EvtSupplyViewUnit", self)
        :removeEventListener("EvtAttackViewTile",  self)
        :removeEventListener("EvtAttackViewUnit",  self)
        :removeEventListener("EvtDestroyViewTile", self)
        :removeEventListener("EvtDestroyViewUnit", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelGridEffect:onEvent(event)
    local name      = event.name
    local gridIndex = event.gridIndex
    if     (name == "EvtDestroyViewUnit") then showAnimationExplosion( self, gridIndex)
    elseif (name == "EvtDestroyViewTile") then showAnimationExplosion( self, gridIndex)
    elseif (name == "EvtAttackViewUnit")  then showAnimationDamage(    self, gridIndex)
    elseif (name == "EvtAttackViewTile")  then showAnimationDamage(    self, gridIndex)
    elseif (name == "EvtSupplyViewUnit")  then showAnimationSupply(    self, gridIndex)
    elseif (name == "EvtRepairViewUnit")  then showAnimationRepair(    self, gridIndex)
    elseif (name == "EvtSiloAttackGrid")  then showAnimationSiloAttack(self, gridIndex)
    end

    return self
end

return ModelGridEffect
