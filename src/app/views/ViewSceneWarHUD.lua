
local ViewSceneWarHUD = class("ViewSceneWarHUD", cc.Node)

--------------------------------------------------------------------------------
-- The contructor.
--------------------------------------------------------------------------------
function ViewSceneWarHUD:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function ViewSceneWarHUD:load(param)
    return self
end

function ViewSceneWarHUD.createInstance(param)
    local view = ViewSceneWarHUD.new():load(param)
    assert(view, "ViewSceneWarHUD.createInstance() failed.")

    return view
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewSceneWarHUD:setViewMoneyEnergyInfo(view)
    if (self.m_ViewMoneyEnergyInfo) then
        self:removeChild(self.m_ViewMoneyEnergyInfo)
    end

    self.m_ViewMoneyEnergyInfo = view
    self:addChild(view)

    return self
end

function ViewSceneWarHUD:setViewTileInfo(view)
    if (self.m_ViewTileInfo) then
        self:removeChild(self.m_ViewTileInfo)
    end

    self.m_ViewTileInfo = view
    self:addChild(view)

    return self
end

function ViewSceneWarHUD:setViewUnitInfo(view)
    if (self.m_ViewUnitInfo) then
        self:removeChild(self.m_ViewUnitInfo)
    end

    self.m_ViewUnitInfo = view
    self:addChild(view)

    return self
end

function ViewSceneWarHUD:setTouchListener(listener)
    local eventDispatcher = self:getEventDispatcher()
    if (self.m_TouchListener) then
        eventDispatcher:removeEventListener(self.m_TouchListener)
    end

    self.m_TouchListener = listener
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

    return self
end

return ViewSceneWarHUD
