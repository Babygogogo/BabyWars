
local ViewSceneMain = class("ViewSceneMain", cc.Scene)

function ViewSceneMain:ctor(param)
    if (param) then
        self:load(param)
    end
    
    return self
end

function ViewSceneMain:load(param)
    return self
end

function ViewSceneMain.createInstance(param)
    local view = ViewSceneMain:create():load(param)
    assert(view, "ViewSceneMain.createInstance() failed.")
    
    return view
end

return ViewSceneMain
