
local ModelReplayController = class("ModelReplayController")

local SingletonGetters = require("src.app.utilities.SingletonGetters")

local getModelScene            = SingletonGetters.getModelScene
local getScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtWarCommandMenuUpdated(self, event)
    if (self.m_View) then
        self.m_View:setVisible(not event.modelWarCommandMenu:isEnabled())
    end
end

local function onEvtHideUI(self, event)
    if (self.m_View) then
        self.m_View:setVisible(false)
    end
end

local function onEvtGridSelected(self, event)
    if (self.m_View) then
        self.m_View:setVisible(true)
    end
end

local function onEvtMapCursorMoved(self, event)
    if (self.m_View) then
        self.m_View:setVisible(true)
    end
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelReplayController:ctor(param)
    return self
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelReplayController:onStartRunning(sceneWarFileName)
    getScriptEventDispatcher()
        :addEventListener("EvtWarCommandMenuUpdated", self)
        :addEventListener("EvtHideUI",                self)
        :addEventListener("EvtGridSelected",          self)
        :addEventListener("EvtMapCursorMoved",        self)

    return self
end

function ModelReplayController:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtWarCommandMenuUpdated") then onEvtWarCommandMenuUpdated(self, event)
    elseif (eventName == "EvtHideUI")                then onEvtHideUI(               self, event)
    elseif (eventName == "EvtGridSelected")          then onEvtGridSelected(         self, event)
    elseif (eventName == "EvtMapCursorMoved")        then onEvtMapCursorMoved(       self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelReplayController:onButtonNextTurnTouched()
    print("ModelReplayController:onButtonNextTurnTouched() not implemented.")
    return self
end

function ModelReplayController:onButtonPreviousTurnTouched()
    print("ModelReplayController:onButtonPreviousTurnTouched() not implemented.")
    return self
end

function ModelReplayController:onButtonPlayTouched()
    local modelSceneWar = getModelScene()
    if (not modelSceneWar:isExecutingAction()) then
        modelSceneWar:executeReplayAction()
    end

    return self
end

function ModelReplayController:onButtonPauseTouched()
    return self
end

function ModelReplayController:setButtonPlayVisible(visible)
    if (self.m_View) then
        self.m_View:setButtonPlayVisible(visible)
            :setButtonPauseVisible(not visible)
    end

    return self
end

return ModelReplayController
