
local ModelMapCursor = class("ModelMapCursor")

function ModelMapCursor:ctor(param)
    require("global.components.ComponentManager").bindComponent(self, "GridIndexable")
    self:setGridIndex({x = 1, y = 1})

    if (param) then
        self:load(param)
    end
    
    return self
end

function ModelMapCursor:load(param)
    if (param and param.gridIndex) then
        self:setGridIndex(param.gridIndex)
    end
    
    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelMapCursor.createInstance(param)
    local model = ModelMapCursor:create():load(param)
    assert(model, "ModelMapCursor.createInstance() failed.")
    
    return model
end

function ModelMapCursor:initView()
    local view = self.m_View
    assert(view, "ModelMapCursor:initView() no view is attached to the owner actor of the model.")
    
    self:setViewPositionWithGridIndex()
    
    return self
end

return ModelMapCursor
