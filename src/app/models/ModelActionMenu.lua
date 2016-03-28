
local ModelActionMenu = class("ModelActionMenu")

--------------------------------------------------------------------------------
-- The callback functions on EvtActionPlannerChoosingAction.
--------------------------------------------------------------------------------
local function onEvtActionPlannerChoosingAction(self, event)
    print("ModelActionMenu-onEvent() EvtActionPlannerChoosingAction")
    self:setEnabled(true)

    local view = self.m_View
    if (view) then
        view:removeAllItems()
        for _, item in ipairs(event.list) do
            view:createAndPushBackItemView(item)
        end
    end
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelActionMenu:ctor(param)
    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelActionMenu:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtActionPlannerIdle", self)
        :addEventListener("EvtActionPlannerMakingMovePath", self)
        :addEventListener("EvtActionPlannerChoosingAction", self)
        :addEventListener("EvtActionPlannerChoosingAttackTarget", self)

    return self
end

function ModelActionMenu:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtActionPlannerChoosingAttackTarget", self)
        :removeEventListener("EvtActionPlannerChoosingAction", self)
        :removeEventListener("EvtActionPlannerMakingMovePath", self)
        :removeEventListener("EvtActionPlannerIdle", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelActionMenu:onEvent(event)
    if (event.name == "EvtActionPlannerIdle") then
        self:setEnabled(false)
        print("ModelActionMenu-onEvent() EvtActionPlannerIdle")
    elseif (event.name == "EvtActionPlannerMakingMovePath") then
        self:setEnabled(false)
        print("ModelActionMenu-onEvent() EvtActionPlannerMakingMovePath")
    elseif (event.name == "EvtActionPlannerChoosingAction") then
        onEvtActionPlannerChoosingAction(self, event)
    elseif (event.name == "EvtActionPlannerChoosingAttackTarget") then
        print("ModelActionMenu-onEvent() EvtActionPlannerChoosingAttackTarget")
        self:setEnabled(false)
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
