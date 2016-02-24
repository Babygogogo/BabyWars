
local ViewUnitMap = class("ViewUnitMap", cc.Node)

local GridSize    = require("res.data.GameConstant").GridSize
local toGridIndex = require("app.utilities.ToGridIndex")

function ViewUnitMap:ctor(param)
	if (param) then self:load(param) end
    
    self.m_Scale = 1
	
	return self
end

function ViewUnitMap:load(param)
	return self
end

function ViewUnitMap.createInstance(param)
	local view = ViewUnitMap.new():load(param)
	assert(view, "ViewUnitMap.createInstance() failed.")
	
	return view
end

function ViewUnitMap:worldPosToGridIndex(pos)
    return toGridIndex(self:convertToNodeSpace(pos), GridSize, self.m_Scale)
end

function ViewUnitMap:handleAndSwallowTouch(touch, touchType, event)
    if (touchType == cc.Handler.EVENT_TOUCH_BEGAN) then
        self.m_IsTouchMoved = false
        return false
    elseif (touchType == cc.Handler.EVENT_TOUCH_MOVED) then
        self.m_IsTouchMoved = true
        return false
    elseif (touchType == cc.Handler.EVENT_TOUCH_CANCELLED) then
        return false
    elseif (touchType == cc.Handler.EVENT_TOUCH_ENDED) then
        if (self.m_IsTouchMoved) then
            return false
        else
            local model = self.m_Model
            if (model) then
                local gridIndex = self:worldPosToGridIndex(touch:getLocation())
                model:handleAndSwallowTouchOnGrid(gridIndex)
            end
            
            return false
        end
    end
end

function ViewUnitMap:setScale(scale)
    self.m_Scale = scale
    return self
end

return ViewUnitMap
