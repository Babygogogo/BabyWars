
local ModelBattleInfo = class("ModelBattleInfo")

--------------------------------------------------------------------------------
-- The callback functions on EvtPlayerPreviewAttackTarget/EvtPlayerPreviewNoAttackTarget and so on.
--------------------------------------------------------------------------------
local function onEvtPlayerPreviewAttackTarget(self, event)
    if (self.m_View) then
        self.m_View:setVisible(true)
            :updateWithAttackAndCounterDamage(event.attackDamage, event.counterDamage)
    end
end

local function onEvtPlayerPreviewNoAttackTarget(self, event)
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

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelBattleInfo:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtPlayerPreviewAttackTarget", self)
        :addEventListener("EvtPlayerPreviewNoAttackTarget", self)
        :addEventListener("EvtActionPlannerIdle",           self)
        :addEventListener("EvtActionPlannerMakingMovePath", self)
        :addEventListener("EvtActionPlannerChoosingAction", self)

    return self
end

function ModelBattleInfo:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtActionPlannerChoosingAction", self)
        :removeEventListener("EvtActionPlannerMakingMovePath", self)
        :removeEventListener("EvtActionPlannerIdle",           self)
        :removeEventListener("EvtPlayerPreviewNoAttackTarget", self)
        :removeEventListener("EvtPlayerPreviewAttackTarget",   self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelBattleInfo:onEvent(event)
    local eventName = event.name
    if ((eventName == "EvtActionPlannerIdle") or
        (eventName == "EvtActionPlannerMakingMovePath") or
        (eventName == "EvtActionPlannerChoosingAction") or
        (eventName == "EvtPlayerPreviewNoAttackTarget")) then
        onEvtPlayerPreviewNoAttackTarget(self, event)
    elseif (eventName == "EvtPlayerPreviewAttackTarget") then
        onEvtPlayerPreviewAttackTarget(self, event)
    end

    return self
end

return ModelBattleInfo
