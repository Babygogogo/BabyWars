
--[[--------------------------------------------------------------------------------
-- DisplayNodeFunctions是一系列关于显示节点的工具函数。
--]]--------------------------------------------------------------------------------

local DisplayNodeFunctions = {}

function DisplayNodeFunctions.isTouchWithinNode(touch, node)
    local location = node:convertToNodeSpace(touch:getLocation())
    local x, y = location.x, location.y

    local contentSize = node:getContentSize()
    local width, height = contentSize.width, contentSize.height

    return (x >= 0) and (y >= 0) and (x <= width) and (y <= height)
end

function DisplayNodeFunctions.createTouchSwallowerForNode(node)
    local swallower = cc.EventListenerTouchOneByOne:create()
    swallower:setSwallowTouches(true)
        :registerScriptHandler(function(touch, event)
            return DisplayNodeFunctions.isTouchWithinNode(touch, node)
        end, cc.Handler.EVENT_TOUCH_BEGAN)

    return swallower
end

return DisplayNodeFunctions
