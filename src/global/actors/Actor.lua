
--[[--------------------------------------------------------------------------------
-- Actor是游戏中几乎所有元素的统一的容器，能够各容纳最多一个model和view。
--
-- 主要职责和使用场景举例：
--   创建新的actor实例（此功能可以考虑改由ActorManager实现）
--   提供接口给外界访问actor内的model和view
--   接收node事件（下面有详细描述）
--
-- 其他：
--   - actor实例举例：
--     刚进游戏所看到的主场景是一个actor实例，它所包含的model和view分别是ModelSceneMain和ViewSceneMain类的实例。
--     主场景中的战局列表也是一个actor实例，它所包含的model和view分别是ModelContinueGameSelector和ViewContinueGameSelector类的实例。
--
--   - actor间的树状层级关系：
--     继续以主场景和战局列表为例。在逻辑上，可以认为主场景是父节点，战局列表是子节点（并非继承关系，而是类似于cocos2d-x中的父显示节点和子显示节点的关系）。
--     但actor本身并没有体现父子关系的代码（这是因为一个父actor可能有很多作用迥异的子actor，强行在actor里写通用的处理函数没有太多意义），因此要手动在model里添加相应代码。
--     也就是说，以主场景和战局列表为例，我们需要在ModelSceneMain里创建和维护战局列表的actor。
--     同时，为了使得战局列表能够显示出来，我们还需要调用cc.Node:addChild()，把战局列表的view添加到主场景的view中（具体参看ViewContinueGameSelector）。
--
--     场景的actor是最顶级的父节点，也就是根节点，因此又称为rootActor。
--     rootActor的view必须继承cc.Scene，而为了显示它，需要通过ActorManager的相关函数（参看ActorManager）。
--
--   - model和view，以及游戏引擎的关系
--     虽然actor本身并没有强制要求，但一般来说，特定的model总是配合特定的view来一起工作的。这些有特定联系的model和view，类名也基本是一致的（分别是ModelXXX和ViewXXX）。
--     一般来说，特定的view的公有接口，应该只由相对应的model来调用。
--
--     actor和model都可以独立于游戏引擎存在，但view则不能（因为显示画面需要依靠引擎）。
--     理想状态下，如果需要更换引擎，那么我们只需要改写view就可以，其他都可以不用更改。
--]]--------------------------------------------------------------------------------

local Actor = require("src.global.functions.class")("Actor")

local MODEL_PATH = "src.app.models."
local VIEW_PATH  = "src.app.views."

local s_IsViewEnabled = true

--------------------------------------------------------------------------------
-- The functions for configuration.
--------------------------------------------------------------------------------
function Actor.setViewEnabled(enabled)
    s_IsViewEnabled = enabled

    return Actor
end

function Actor.createModel(name, param)
    if (not name) then
        return nil
    else
        return require(MODEL_PATH .. name):create(param)
    end
end

function Actor.createView(name, param)
    if (not name) then
        return nil
    else
        return require(VIEW_PATH .. name):create(param)
    end
end

function Actor.createWithModelAndViewInstance(modelInstance, viewInstance)
    local actor = Actor.new()
    if (modelInstance) then
        actor:setModel(modelInstance)
    end
    if ((s_IsViewEnabled) and (viewInstance)) then
        actor:setView(viewInstance)
    end

    return actor
end

function Actor.createWithModelAndViewName(modelName, modelParam, viewName, viewParam)
    local model = Actor.createModel(modelName, modelParam)
    local view = (s_IsViewEnabled) and (Actor.createView( viewName,  viewParam)) or (nil)

    return Actor.createWithModelAndViewInstance(model, view)
end

function Actor:setView(view)
    assert(view.m_Actor == nil, "Actor:setView() the param view already has an owner actor.")
    assert(self.m_View == nil, "Actor:setView() the actor already has a view.")

    local model = self.m_Model
    view.m_Model = model
    if (model) then
        model.m_View = view
        if (model.initView) then model:initView() end
    end

    self.m_View = view
    view.m_Actor = self

    return self
end

function Actor:getView()
    return self.m_View
end

function Actor:removeView()
    local view = self.m_View
    if (view) then
        local model = self.m_Model
        if (model) then model.m_View = nil end

        view.m_Model, view.m_Actor = nil, nil
        self.m_View = nil
    end

    return self
end

function Actor:setModel(model)
    assert(type(model) == "table", "Actor:setModel() the param model is not a table.")
    assert(model.m_Actor == nil, "Actor:setModel() the param model already has an owner actor.")
    assert(self.m_Model == nil, "Actor:setModel() the actor already has a model.")

    local view = self.m_View
    model.m_View = view
    if (view) then
        view.m_Model = model
        if (model.initView) then model:initView() end
    end

    self.m_Model = model
    model.m_Actor = self

    return self
end

function Actor:getModel()
    return self.m_Model
end

function Actor:removeModel()
    local model = self.m_Model
    if (model) then
        local view = self.m_View
        if (view) then view.m_Model = nil end

        model.m_View, model.m_Actor = nil, nil
        self.m_Model = nil
    end

    return self
end

return Actor
