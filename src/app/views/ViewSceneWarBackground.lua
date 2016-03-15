
local ViewSceneWarBackground = class("ViewSceneWarBackground", function()
    return cc.LayerGradient:create({r = 0,   g = 0,   b = 0},
--                                  {r = 240, g = 80, b = 56},  -- red
--                                   {r = 96,  g = 88, b = 240}, -- blue
--                                   {r = 216, g = 208, b = 8},  -- yellow
                                   {r = 96,  g = 224, b = 88}, -- green
                                   {x = -1,  y = 1})
end)

function ViewSceneWarBackground:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function ViewSceneWarBackground:load(param)
    return self
end

function ViewSceneWarBackground.createInstance(param)
    local view = ViewSceneWarBackground:create():load(param)
    assert(view, "ViewSceneWarBackground.createInstance() failed.")

    return view
end

return ViewSceneWarBackground
