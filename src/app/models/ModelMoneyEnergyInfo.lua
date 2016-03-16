
local ModelMoneyEnergyInfo = class("ModelMoneyEnergyInfo")

local WAR_COMMAND_MENU_Z_ORDER = 2

local Actor = require("global.actors.Actor")

local function createWarCommandMenuActor()
    return Actor.createWithModelAndViewName("ModelWarCommandMenu", nil, "ViewWarCommandMenu")
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function ModelMoneyEnergyInfo:load(param)
    return self
end

function ModelMoneyEnergyInfo.createInstance(param)
    local model = ModelMoneyEnergyInfo.new():load(param)
    assert(model, "ModelMoneyEnergyInfo.createInstance() failed.")

    return model
end

function ModelMoneyEnergyInfo:initView()
    local view = self.m_View
    assert(view, "ModelMoneyEnergyInfo:initView() no view is attached to the owner actor of the model.")

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:onPlayerTouch()
    if (self.m_WarCommandMenuActor) then
        self.m_WarCommandMenuActor:getModel():setEnabled(true)
    else
        self.m_WarCommandMenuActor = createWarCommandMenuActor()
        self.m_View:getScene():addChild(self.m_WarCommandMenuActor:getView(), WAR_COMMAND_MENU_Z_ORDER)
    end

    return self
end

function ModelMoneyEnergyInfo:adjustPositionOnTouch(touch)
    if (self.m_View) then
        self.m_View:adjustPositionOnTouch(touch)
    end

    return self
end

return ModelMoneyEnergyInfo
