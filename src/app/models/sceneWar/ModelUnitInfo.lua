
--[[--------------------------------------------------------------------------------
-- ModelUnitInfo是战局场景里的unit的简要属性框（即场景下方的小框）。
--
-- 主要职责和使用场景举例：
--   - 构造和显示unit的简要属性框。
--   - 自身被点击时，呼出unit的详细属性页面。
--
-- 其他：
--  - 本类所显示的是光标所指向的unit的信息（通过event获知光标指向的是哪个unit）
--]]--------------------------------------------------------------------------------

local ModelUnitInfo = class("ModelUnitInfo")

local GridIndexFunctions  = requireBW("src.app.utilities.GridIndexFunctions")
local VisibilityFunctions = requireBW("src.app.utilities.VisibilityFunctions")
local SingletonGetters    = requireBW("src.app.utilities.SingletonGetters")

local getModelFogMap         = SingletonGetters.getModelFogMap
local getModelUnitMap        = SingletonGetters.getModelUnitMap
local getPlayerIndexLoggedIn = SingletonGetters.getPlayerIndexLoggedIn
local isTotalReplay          = SingletonGetters.isTotalReplay

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function isModelUnitVisible(modelSceneWar, modelUnit)
    if (isTotalReplay(modelSceneWar)) then
        return true
    else
        return VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex(
            modelSceneWar,
            modelUnit:getGridIndex(),
            modelUnit:getUnitType(),
            (modelUnit.isDiving) and (modelUnit:isDiving()),
            modelUnit:getPlayerIndex(),
            getPlayerIndexLoggedIn(modelSceneWar)
        )
    end
end

local function updateWithModelUnitMap(self)
    local modelSceneWar = self.m_ModelSceneWar
    local modelUnitMap  = getModelUnitMap(modelSceneWar)
    local modelUnit     = modelUnitMap:getModelUnit(self.m_CursorGridIndex)
    if ((not modelUnit) or (not isModelUnitVisible(modelSceneWar, modelUnit))) then
        self.m_View:setVisible(false)
    else
        local loadedModelUnits = ((isTotalReplay(modelSceneWar)) or (not getModelFogMap(modelSceneWar):isFogOfWarCurrently()) or (modelUnit:getPlayerIndex() == getPlayerIndexLoggedIn(modelSceneWar))) and
            (modelUnitMap:getLoadedModelUnitsWithLoader(modelUnit))                                                                                                                                     or
            (nil)
        self.m_ModelUnitList = {modelUnit, unpack(loadedModelUnits or {})}

        self.m_View:updateWithModelUnit(modelUnit, loadedModelUnits)
            :setVisible(not SingletonGetters.getModelWarCommandMenu(modelSceneWar):isEnabled())
    end
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtModelUnitMapUpdated(self, event)
    updateWithModelUnitMap(self)
end

local function onEvtGridSelected(self, event)
    self.m_CursorGridIndex = GridIndexFunctions.clone(event.gridIndex)
    updateWithModelUnitMap(self)
end

local function onEvtMapCursorMoved(self, event)
    self.m_CursorGridIndex = GridIndexFunctions.clone(event.gridIndex)
    updateWithModelUnitMap(self)
end

local function onEvtWarCommandMenuUpdated(self, event)
    if (event.modelWarCommandMenu:isEnabled()) then
        if (self.m_View) then
            self.m_View:setVisible(false)
        end
    else
        updateWithModelUnitMap(self)
    end
end

local function onEvtHideUI(self, event)
    if (self.m_View) then
        self.m_View:setVisible(false)
    end
end

local function onEvtPlayerIndexUpdated(self, event)
    if (self.m_View) then
        self.m_View:updateWithPlayerIndex(event.playerIndex)
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelUnitInfo:ctor(param)
    self.m_CursorGridIndex = {x = 1, y = 1}

    return self
end

function ModelUnitInfo:setModelUnitDetail(model)
    assert(self.m_ModelUnitDetail == nil, "ModelUnitInfo:setModelUnitDetail() the model has been set.")
    self.m_ModelUnitDetail = model

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelUnitInfo:onStartRunning(modelSceneWar)
    self.m_ModelSceneWar = modelSceneWar
    SingletonGetters.getScriptEventDispatcher(modelSceneWar)
        :addEventListener("EvtModelUnitMapUpdated",   self)
        :addEventListener("EvtGridSelected",          self)
        :addEventListener("EvtMapCursorMoved",        self)
        :addEventListener("EvtWarCommandMenuUpdated", self)
        :addEventListener("EvtHideUI",                self)
        :addEventListener("EvtPlayerIndexUpdated",    self)

    if (self.m_View) then
        self.m_View:updateWithPlayerIndex(SingletonGetters.getModelTurnManager(modelSceneWar):getPlayerIndex())
    end

    updateWithModelUnitMap(self)

    return self
end

function ModelUnitInfo:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtModelUnitMapUpdated")   then onEvtModelUnitMapUpdated(  self, event)
    elseif (eventName == "EvtGridSelected")          then onEvtGridSelected(         self, event)
    elseif (eventName == "EvtMapCursorMoved")        then onEvtMapCursorMoved(       self, event)
    elseif (eventName == "EvtWarCommandMenuUpdated") then onEvtWarCommandMenuUpdated(self, event)
    elseif (eventName == "EvtHideUI")                then onEvtHideUI(               self, event)
    elseif (eventName == "EvtPlayerIndexUpdated")    then onEvtPlayerIndexUpdated(   self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelUnitInfo:onPlayerTouch(index)
    if (self.m_ModelUnitDetail) then
        self.m_ModelUnitDetail:updateWithModelUnit(self.m_ModelUnitList[index])
            :setEnabled(true)
    end

    return self
end

return ModelUnitInfo
