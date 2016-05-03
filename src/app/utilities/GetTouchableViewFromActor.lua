
--[[--------------------------------------------------------------------------------
-- GetTouchableViewFromActor是一个函数，用于获取一个Actor下属的、可以接收手动分发的触摸消息的View。
-- 已废弃。
--]]--------------------------------------------------------------------------------

return function(actor)
    if (not actor) then
        return nil
    else
        local view = actor:getView()
        if (view and view.handleAndSwallowTouch) then
            return view
        else
            return nil
        end
    end
end
