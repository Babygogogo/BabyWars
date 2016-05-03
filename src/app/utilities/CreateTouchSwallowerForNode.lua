
--[[--------------------------------------------------------------------------------
-- CreateTouchSwallowerForNode是一个函数，用于创建一个会吞噬显示节点内部的触摸事件的EventListener。
-- 目前没有在使用，但函数是可以正确工作的。
--]]--------------------------------------------------------------------------------

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
