
--[[--------------------------------------------------------------------------------
-- IncomeProvider是ModelTile可用的组件。只有绑定了本组件，宿主才具有“收入”的属性。
-- 主要职责：
--   维护相关数值并提供必要接口给外界访问
-- 使用场景举例：
--   初始化单位时，根据单位属性来绑定和初始化本组件（所有ModelUnit/ModelTile都需要绑定，但具体由GameConstant决定）
--   回合初计算玩家收入时会用到本组件
-- 其他：
--   - 目前，计算玩家总收入的方式是：ModelPlayerManager接收到EvtTurnPhaseGetFund的消息后，遍历地图找到所有可提供收入的tile并计算总收入
--     因此，本组件只要提供接口让外界知道单个收入是多少就行了，不用计算总量
--]]--------------------------------------------------------------------------------

local IncomeProvider = require("src.global.functions.class")("IncomeProvider")

local TypeChecker        = require("src.app.utilities.TypeChecker")
local ComponentManager   = require("src.global.components.ComponentManager")

IncomeProvider.EXPORTED_METHODS = {
    "getIncomeAmount",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function IncomeProvider:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function IncomeProvider:loadTemplate(template)
    assert(template.amount, "IncomeProvider:loadTemplate() the param template.amount is invalid.")
    self.m_Template = template

    return self
end

function IncomeProvider:loadInstantialData(data)
    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function IncomeProvider:getIncomeAmount(playerIndex)
    if ((not playerIndex) or (self.m_Owner:getPlayerIndex() == playerIndex)) then
        return self.m_Template.amount
    else
        return nil
    end
end

return IncomeProvider
