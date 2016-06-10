
local ModelWarFieldPreviewer = class("ModelWarFieldPreviewer")

local Actor = require("global.actors.Actor")

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtPlayerDragField(self, event)
    if (self.m_View) then
        self.m_View:setPositionOnDrag(event.previousPosition, event.currentPosition)
    end
end

local function onEvtPlayerZoomField(self, event)
    if (self.m_View) then
        local scrollEvent = event.scrollEvent
        self.m_View:setZoomWithScroll(cc.Director:getInstance():convertToGL(scrollEvent:getLocation()), scrollEvent:getScrollY())
    end
end

local function onEvtPlayerZoomFieldWithTouches(self, event)
    if (self.m_View) then
        self.m_View:setZoomWithTouches(event.touches)
    end
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initActorTileMap(self, tileMapData)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelTileMap", tileMapData, "sceneWar.ViewTileMap")

    self.m_ActorTileMap = actor
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelWarFieldPreviewer:ctor(param)
    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelWarFieldPreviewer:onEvent(event)
    local eventName = event.name
    if (eventName == "EvtPlayerDragField") then
        onEvtPlayerDragField(self, event)
    elseif (eventName == "EvtPlayerZoomField") then
        onEvtPlayerZoomField(self, event)
    elseif (eventName == "EvtPlayerZoomFieldWithTouches") then
        onEvtPlayerZoomFieldWithTouches(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelWarFieldPreviewer:showWarField(warFieldFileName)
    if (self.m_WarFieldFileName ~= warFieldFileName) then
        self.m_WarFieldFileName = warFieldFileName

        initActorTileMap(self, {template = warFieldFileName})
        if (self.m_View) then
            self.m_View:setViewTileMap(self.m_ActorTileMap:getView(), self.m_ActorTileMap:getModel():getMapSize())
        end
    end

    if (self.m_View) then
        self.m_View:setEnabled(true)
    end

    return self
end

function ModelWarFieldPreviewer:hideWarField()
    if (self.m_View) then
        self.m_View:setEnabled(false)
    end

    return self
end

return ModelWarFieldPreviewer
