
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
