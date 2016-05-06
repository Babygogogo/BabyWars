
--[[--------------------------------------------------------------------------------
-- MoveCostOwner是ModelTile可用的组件。只有绑定了本组件，宿主才具有“移动力消耗值”的属性。
-- 主要职责：
--   维护相关数值并提供必要接口给外界访问
-- 使用场景举例：
--   宿主初始化时，根据属性来绑定和初始化本组件（所有ModelTile都需要绑定，但具体由GameConstant决定）
--   unit进行移动时，会用到本组件提供的移动消耗值
-- 其他：
--   加入co技能后，本组件需要考虑技能对移动消耗的影响
--   需要传入移动类型，本组件才能返回相应的移动力消耗值
--]]--------------------------------------------------------------------------------

local MoveCostOwner = class("MoveCostOwner")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")

local EXPORTED_METHODS = {
    "getMoveCost",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function MoveCostOwner:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function MoveCostOwner:loadTemplate(template)
    assert(type(template) == "table", "MoveCostOwner:loadTemplate() the param template is invalid.")
    self.m_Template = template

    return self
end

function MoveCostOwner:loadInstantialData(data)
    return self
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function MoveCostOwner:onBind(target)
    assert(self.m_Target == nil, "MoveCostOwner:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Target = target

    return self
end

function MoveCostOwner:onUnbind()
    assert(self.m_Target ~= nil, "MoveCostOwner:onUnbind() the component has not bound to a target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function MoveCostOwner:getMoveCost(moveType, modelPlayer)
    -- TODO: take the modelPlayer into account.

    return self.m_Template[moveType]
end

return MoveCostOwner
