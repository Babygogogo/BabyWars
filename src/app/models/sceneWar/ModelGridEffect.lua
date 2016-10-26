
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

local SingletonGetters = require("src.app.utilities.SingletonGetters")

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

function ModelGridEffect:initView()
    return self
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelGridEffect:onStartRunning(sceneWarFileName)
    SingletonGetters.getScriptEventDispatcher()
        :addEventListener("EvtDestroyViewUnit", self)
        :addEventListener("EvtDestroyViewTile", self)
        :addEventListener("EvtAttackViewUnit",  self)
        :addEventListener("EvtAttackViewTile",  self)
        :addEventListener("EvtSupplyViewUnit",  self)
        :addEventListener("EvtRepairViewUnit",  self)
        :addEventListener("EvtSiloAttackGrid",  self)

    return self
end

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

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelGridEffect:showAnimationBlock(gridIndex)
    if (self.m_View) then
        self.m_View:showAnimationBlock(gridIndex)
    end

    return self
end

function ModelGridEffect:showAnimationExplosion(gridIndex)
    if (self.m_View) then
        self.m_View:showAnimationExplosion(gridIndex)
    end

    return self
end

function ModelGridEffect:showAnimationRepair(gridIndex)
    if (self.m_View) then
        self.m_View:showAnimationRepair(gridIndex)
    end

    return self
end

function ModelGridEffect:showAnimationSiloAttack(gridIndex)
    if (self.m_View) then
        self.m_View:showAnimationSiloAttack(gridIndex)
    end

    return self
end

function ModelGridEffect:showAnimationSkillActivation(gridIndex)
    if (self.m_View) then
        self.m_View:showAnimationSkillActivation(gridIndex)
    end

    return self
end

function ModelGridEffect:showAnimationSupply(gridIndex)
    if (self.m_View) then
        self.m_View:showAnimationSupply(gridIndex)
    end

    return self
end

return ModelGridEffect
