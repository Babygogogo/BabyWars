
--[[--------------------------------------------------------------------------------
-- ModelBattleInfo用于在战局中显示预估的进攻/反击伤害值。
--
-- 主要职责及使用场景：
--   在玩家为单位预选进攻目标时，显示预估的进攻/反击伤害值。
--
-- 其他：
--   - 本类不负责计算预估伤害，该数值由ModelActionPlanner计算。
--     这是因为ModelActionPlanner在生成单位可攻击目标列表时已经计算了预估伤害，所以这里没必要再算一次，直接利用算好的数值就行。
--
--   - ModelBattleInfo是ModelWarHUD的子model，与ModelActionPlanner没有直接联系，因此需要通过event来传递参数。
--]]--------------------------------------------------------------------------------

local ModelBattleInfo = class("ModelBattleInfo")

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtPreviewBattleDamage(self, event)
    if (self.m_View) then
        self.m_View:setVisible(true)
            :updateWithAttackAndCounterDamage(event.attackDamage, event.counterDamage)
    end
end

local function onEvtPreviewNoBattleDamage(self, event)
    if (self.m_View) then
        self.m_View:setVisible(false)
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelBattleInfo:ctor(param)
    return self
end

function ModelBattleInfo:initView()
    local view = self.m_View
    assert(view, "ModelBattleInfo:initView() thers's no view attached to the owner actor of the model.")

    view:setVisible(false)

    return self
end

function ModelBattleInfo:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelBattleInfo:setRootScriptEventDispatcher() the dispatcher has been set.")

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtPreviewBattleDamage",   self)
        :addEventListener("EvtPreviewNoBattleDamage",       self)
        :addEventListener("EvtActionPlannerIdle",           self)
        :addEventListener("EvtActionPlannerMakingMovePath", self)
        :addEventListener("EvtActionPlannerChoosingAction", self)

    return self
end

function ModelBattleInfo:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelBattleInfo:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtActionPlannerChoosingAction", self)
        :removeEventListener("EvtActionPlannerMakingMovePath", self)
        :removeEventListener("EvtActionPlannerIdle",           self)
        :removeEventListener("EvtPreviewNoBattleDamage",       self)
        :removeEventListener("EvtPreviewBattleDamage",         self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelBattleInfo:onEvent(event)
    local eventName = event.name
    if ((eventName == "EvtActionPlannerIdle") or
        (eventName == "EvtActionPlannerMakingMovePath") or
        (eventName == "EvtActionPlannerChoosingAction") or
        (eventName == "EvtPreviewNoBattleDamage")) then
        onEvtPreviewNoBattleDamage(self, event)
    elseif (eventName == "EvtPreviewBattleDamage") then
        onEvtPreviewBattleDamage(self, event)
    end

    return self
end

return ModelBattleInfo
