
return function(touch, node)
    local location = node:convertToNodeSpace(touch:getLocation())
    local x, y = location.x, location.y

    local contentSize = node:getContentSize()
    local width, height = contentSize.width, contentSize.height

    return (x >= 0) and (y >= 0) and (x <= width) and (y <= height)
end
