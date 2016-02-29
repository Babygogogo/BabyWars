
return function (node) 
    local swallower = cc.EventListenerTouchOneByOne:create()
    swallower:setSwallowTouches(true)
        :registerScriptHandler(function(touch, event)
            local locationInNodeSpace = node:convertToNodeSpace(touch:getLocation())
            local x, y = locationInNodeSpace.x, locationInNodeSpace.y
            
            local contentSize = node:getContentSize()
            local width, height = contentSize.width, contentSize.height

            return (x >= 0) and (y >= 0) and (x <= width) and (y <= height)
        end, cc.Handler.EVENT_TOUCH_BEGAN)
        
    return swallower
end
