
--[[--------------------------------------------------------------------------------
-- ModelActionMenu是战局中unit的操作菜单，同时也是工厂建造单位的菜单。
--
-- 主要职责及使用场景：
--   在玩家点击特定单位或地形时，显示相应的操作菜单
--
-- 其他：
--   - 本类只负责根据传入的参数构造菜单，不参与生成菜单内容本身（也就是说，本类并不知道生成的菜单到底是什么）。
--]]--------------------------------------------------------------------------------

local ModelActionMenu = class("ModelActionMenu")

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtActionPlannerChoosingAction(self, event)
    self:setEnabled(true)

    local view = self.m_View
    if (view) then
        view:removeAllItems()
            :showActionList(event.list)
    end
end

local function onEvtActionPlannerChoosingProductionTarget(self, event)
    self:setEnabled(true)

    local view = self.m_View
    if (view) then
        view:removeAllItems()
            :showProductionList(event.productionList)
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelActionMenu:ctor(param)
    return self
end

function ModelActionMenu:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelActionMenu:setRootScriptEventDispatcher() the dispatcher has been set already.")

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtActionPlannerIdle",               self)
        :addEventListener("EvtActionPlannerChoosingProductionTarget", self)
        :addEventListener("EvtActionPlannerMakingMovePath",           self)
        :addEventListener("EvtActionPlannerChoosingAction",           self)
        :addEventListener("EvtActionPlannerChoosingAttackTarget",     self)

    return self
end

function ModelActionMenu:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelActionMenu:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtActionPlannerChoosingAttackTarget", self)
        :removeEventListener("EvtActionPlannerChoosingAction",           self)
        :removeEventListener("EvtActionPlannerMakingMovePath",           self)
        :removeEventListener("EvtActionPlannerChoosingProductionTarget", self)
        :removeEventListener("EvtActionPlannerIdle",                     self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelActionMenu:onEvent(event)
    local eventName = event.name
    if ((eventName == "EvtActionPlannerIdle") or
        (eventName == "EvtActionPlannerMakingMovePath") or
        (eventName == "EvtActionPlannerChoosingAttackTarget")) then
        self:setEnabled(false)
    elseif (eventName == "EvtActionPlannerChoosingProductionTarget") then
        onEvtActionPlannerChoosingProductionTarget(self, event)
    elseif (eventName == "EvtActionPlannerChoosingAction") then
        onEvtActionPlannerChoosingAction(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelActionMenu:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setEnabled(enabled)
    end

    return self
end

return ModelActionMenu
