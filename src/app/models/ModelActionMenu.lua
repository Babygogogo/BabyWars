
local ModelActionMenu = class("ModelActionMenu")

--------------------------------------------------------------------------------
-- The callback functions on EvtActionPlannerChoosingAction.
--------------------------------------------------------------------------------
local function onEvtActionPlannerChoosingAction(self, event)
    self:setEnabled(true)
    print("ModelActionMenu-onEvent() EvtActionPlannerChoosingAction")
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

    return self
end

function ModelActionMenu:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtActionPlannerChoosingAction", self)
        :removeEventListener("EvtActionPlannerMakingMovePath", self)
        :removeEventListener("EvtActionPlannerIdle", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelActionMenu:onEvent(event)
    if (event.name == "EvtActionPlannerIdle") then
        self:setEnabled(false)
        print("ModelActionMenu-onEvent() EvtActionPlannerIdle")
    elseif(event.name == "EvtActionPlannerMakingMovePath") then
        self:setEnabled(false)
        print("ModelActionMenu-onEvent() EvtActionPlannerMakingMovePath")
    elseif(event.name == "EvtActionPlannerChoosingAction") then
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
