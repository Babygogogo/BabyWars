
local ModelActionPlanner = class("ModelActionPlanner")

local function onEvtGridSelected(model, gridIndex)
    local unit = model.m_UnitMapModel:getUnitActor(gridIndex)
    if (unit) then
        print("ModelActionPlanner-onEvtGridSelected() a unit is selected.")
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializer.
--------------------------------------------------------------------------------
function ModelActionPlanner:ctor(param)
    return self
end

function ModelActionPlanner:initView()
    assert(self.m_View, "ModelActionPlanner:initView() no view is attached to the owner actor of the model.")

    return self
end

function ModelActionPlanner:setUnitMapModel(model)
    self.m_UnitMapModel = model

    return self
end

function ModelActionPlanner:setTileMapModel(model)
    self.m_TileMapModel = model

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelActionPlanner:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtGridSelected", self)

    return self
end

function ModelActionPlanner:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtGridSelected", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelActionPlanner:onEvent(event)
    if (event.name == "EvtGridSelected") then
        onEvtGridSelected(self, event.gridIndex)
    elseif (event.name == "EvtPlayerSwitched") then
        self.m_PlayerIndex = event.playerIndex
    elseif (event.name == "EvtWeatherChanged") then
        self.m_CurrentWeather = event.weather
    end

    return self
end

return ModelActionPlanner
