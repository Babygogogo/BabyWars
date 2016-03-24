
local ModelActionMenu = class("ModelActionMenu")

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

    return self
end

function ModelActionMenu:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtActionPlannerIdle", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelActionMenu:onEvent(event)
    if (event.name == "EvtActionPlannerIdle") then
        print("EvtActionPlannerIdle")
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
