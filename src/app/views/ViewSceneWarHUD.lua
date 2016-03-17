
local ViewSceneWarHUD = class("ViewSceneWarHUD", cc.Node)

--------------------------------------------------------------------------------
-- The contructor.
--------------------------------------------------------------------------------
function ViewSceneWarHUD:ctor(param)
    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewSceneWarHUD:setViewMoneyEnergyInfo(view)
    if (self.m_ViewMoneyEnergyInfo) then
        if (self.m_ViewMoneyEnergyInfo == view) then
            return self
        else
            self:removeChild(self.m_ViewMoneyEnergyInfo)
        end
    end

    self.m_ViewMoneyEnergyInfo = view
    self:addChild(view)

    return self
end

function ViewSceneWarHUD:setViewTileInfo(view)
    if (self.m_ViewTileInfo) then
        if (self.m_ViewTileInfo == view) then
            return self
        else
            self:removeChild(self.m_ViewTileInfo)
        end
    end

    self.m_ViewTileInfo = view
    self:addChild(view)

    return self
end

function ViewSceneWarHUD:setViewUnitInfo(view)
    if (self.m_ViewUnitInfo) then
        if (self.m_ViewUnitInfo == view) then
            return self
        else
            self:removeChild(self.m_ViewUnitInfo)
        end
    end

    self.m_ViewUnitInfo = view
    self:addChild(view)

    return self
end

function ViewSceneWarHUD:setTouchListener(listener)
    local eventDispatcher = self:getEventDispatcher()
    if (self.m_TouchListener) then
        if (self.m_TouchListener == listener) then
            return self
        else
            eventDispatcher:removeEventListener(self.m_TouchListener)
        end
    end

    self.m_TouchListener = listener
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

    return self
end

return ViewSceneWarHUD
