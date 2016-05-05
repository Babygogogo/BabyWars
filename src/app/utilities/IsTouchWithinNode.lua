
--[[--------------------------------------------------------------------------------
-- IsTouchWithinNode是个返回判断touch是否位于node内部的函数的函数。
-- 主要职责：
--   见上
-- 使用场景举例：
--   ComfirmBox、UnitDetail、TileDetail等都有用到
--]]--------------------------------------------------------------------------------

return function(touch, node)
    local location = node:convertToNodeSpace(touch:getLocation())
    local x, y = location.x, location.y

    local contentSize = node:getContentSize()
    local width, height = contentSize.width, contentSize.height

    return (x >= 0) and (y >= 0) and (x <= width) and (y <= height)
end
