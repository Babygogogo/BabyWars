
return function(views, touch, touchType, event)
    for _, view in ipairs(views) do
        local isTouchSwallowed = view:handleAndSwallowTouch(touch, touchType, event)
        if (isTouchSwallowed) then
            return true
        end
    end
    
    return false
end
