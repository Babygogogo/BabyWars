
local ModelMoneyEnergyInfo = class("ModelMoneyEnergyInfo")

local WAR_COMMAND_MENU_Z_ORDER = 2

local Actor = require("global.actors.Actor")

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelMoneyEnergyInfo:ctor(param)
    if (self.m_View) then
        self:initView()
    end

    return self
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
        self.m_WarCommandMenuActor = Actor.createWithModelAndViewName("ModelWarCommandMenu", nil, "ViewWarCommandMenu")
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
