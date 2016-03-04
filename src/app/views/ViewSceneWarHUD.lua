
local ViewSceneWarHUD = class("ViewSceneWarHUD", cc.Node)

function ViewSceneWarHUD:ctor(param)
    if (param) then
        self:load(param)
    end
    
    return self
end

function ViewSceneWarHUD:load(param)
    return self
end

function ViewSceneWarHUD.createInstance(param)
    local view = ViewSceneWarHUD.new():load(param)
    assert(view, "ViewSceneWarHUD.createInstance() failed.")
    
    return view
end

function ViewSceneWarHUD:setTouchableChildrenViews(views)
    self.m_TouchableChildrenViews = views
    assert(type(self.m_TouchableChildrenViews) == "table", "ViewSceneWarHUD:setTouchableChildrenViews() the views is not a table, therefore invalid.")
    
    return self
end

function ViewSceneWarHUD:handleAndSwallowTouch(touch, touchType, event)
    local dispatchAndSwallowTouch = require("app.utilities.DispatchAndSwallowTouch")
    return dispatchAndSwallowTouch(self.m_TouchableChildrenViews, touch, touchType, event)
end

return ViewSceneWarHUD
