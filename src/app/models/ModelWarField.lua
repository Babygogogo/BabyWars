
local ModelWarField = class("ModelWarField")

local Actor        = require("global.actors.Actor")
local TypeChecker  = require("app.utilities.TypeChecker")
local GameConstant = require("res.data.GameConstant")

local function requireFieldData(param)
    local t = type(param)
    if (t == "table") then
        return param
    elseif (t == "string") then
        return require("data.warField." .. param)
    else
        return nil
    end
end

local function createChildrenActors(param)
    local warFieldData = requireFieldData(param)
    assert(TypeChecker.isWarFieldData(warFieldData))

    local tileMapActor = Actor.createWithModelAndViewName("ModelTileMap", warFieldData.TileMap, "ViewTileMap")
    assert(tileMapActor, "ModelWarField-createChildrenActors() failed to create the TileMap actor.")
    local unitMapActor = Actor.createWithModelAndViewName("ModelUnitMap", warFieldData.UnitMap, "ViewUnitMap")
    assert(unitMapActor, "ModelWarField-createChildrenActors() failed to create the UnitMap actor.")
    local cursorActor = Actor.createWithModelAndViewName("ModelMapCursor", {mapSize = tileMapActor:getModel():getMapSize()}, "ViewMapCursor")
    assert(cursorActor, "ModelWarField-createChildrenActors() failed to create the cursor actor.")

    assert(TypeChecker.isSizeEqual(tileMapActor:getModel():getMapSize(), unitMapActor:getModel():getMapSize()))

    return {tileMapActor = tileMapActor, unitMapActor = unitMapActor, cursorActor = cursorActor}
end

local function initWithChildrenActors(model, actors)
    model.m_TileMapActor = actors.tileMapActor
    model.m_UnitMapActor = actors.unitMapActor
    model.m_CursorActor = actors.cursorActor
end

function ModelWarField:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function ModelWarField:load(param)
    initWithChildrenActors(self, createChildrenActors(param))

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelWarField.createInstance(param)
	local model = ModelWarField.new():load(param)
	assert(model, "ModelWarField.createInstance() failed.")

	return model
end

function ModelWarField:onEnter(rootActor)
    self.m_TileMapActor:onEnter(rootActor)
    self.m_UnitMapActor:onEnter(rootActor)
    self.m_CursorActor:onEnter(rootActor)

    self.m_ScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_ScriptEventDispatcher:addEventListener("EvtPlayerDragField", self)

    return self
end

function ModelWarField:onCleanup(rootActor)
    self.m_TileMapActor:onCleanup(rootActor)
    self.m_UnitMapActor:onCleanup(rootActor)
    self.m_CursorActor:onCleanup(rootActor)

    self.m_ScriptEventDispatcher:removeEventListener("EvtPlayerDragField", self)
    self.m_ScriptEventDispatcher = nil

    return self
end

function ModelWarField:onEvent(event)
    if (event.name == "EvtPlayerDragField") and (self.m_View) then    
        self.m_View:setPositionOnDrag(event.previousPosition, event.currentPosition)
    end
    
    return self
end

function ModelWarField:getTouchableChildrenViews()
    local views = {}
    views[#views + 1] = require("app.utilities.GetTouchableViewFromActor")(self.m_UnitMapActor)
    views[#views + 1] = require("app.utilities.GetTouchableViewFromActor")(self.m_TileMapActor)

    return views
end

function ModelWarField:initView()
    local view = self.m_View
    assert(TypeChecker.isView(view))

    view:removeAllChildren()
        :addChild(self.m_TileMapActor:getView())
        :addChild(self.m_UnitMapActor:getView())
        :addChild(self.m_CursorActor:getView())

        :setContentSizeWithMapSize(self.m_TileMapActor:getModel():getMapSize())

        :setTouchableChildrenViews(self:getTouchableChildrenViews())

    return self
end

return ModelWarField
