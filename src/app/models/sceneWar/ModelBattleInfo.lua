
--[[--------------------------------------------------------------------------------
-- ModelBattleInfo用于在战局中显示预估的进攻/反击伤害值。
--
-- 主要职责及使用场景：
--   在玩家为单位预选进攻目标时，显示预估的进攻/反击伤害值。
--
-- 其他：
--   - 本类不负责计算预估伤害，该数值由ModelActionPlanner计算。
--     这是因为ModelActionPlanner在生成单位可攻击目标列表时已经计算了预估伤害，所以这里没必要再算一次，直接利用算好的数值就行。
--
--   - ModelBattleInfo是ModelWarHUD的子model，与ModelActionPlanner没有直接联系，因此需要通过event来传递参数。
--]]--------------------------------------------------------------------------------

local ModelBattleInfo = class("ModelBattleInfo")

local SingletonGetters = require("src.app.utilities.SingletonGetters")

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtPreviewBattleDamage(self, event)
    if (self.m_View) then
        self.m_View:setVisible(true)
            :updateWithAttackAndCounterDamage(event.attackDamage, event.counterDamage)
    end
end

local function onEvtPreviewNoBattleDamage(self, event)
    if (self.m_View) then
        self.m_View:setVisible(false)
    end
end

local function onEvtPlayerIndexUpdated(self, event)
    if (self.m_View) then
        self.m_View:updateWithPlayerIndex(event.playerIndex)
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelBattleInfo:ctor(param)
    return self
end

function ModelBattleInfo:initView()
    local view = self.m_View
    assert(view, "ModelBattleInfo:initView() thers's no view attached to the owner actor of the model.")

    view:setVisible(false)

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelBattleInfo:onStartRunning(modelSceneWar, sceneWarFileName)
    SingletonGetters.getScriptEventDispatcher(modelSceneWar)
        :addEventListener("EvtPreviewBattleDamage",         self)
        :addEventListener("EvtPreviewNoBattleDamage",       self)
        :addEventListener("EvtActionPlannerIdle",           self)
        :addEventListener("EvtActionPlannerMakingMovePath", self)
        :addEventListener("EvtActionPlannerChoosingAction", self)
        :addEventListener("EvtPlayerIndexUpdated",          self)

    if (self.m_View) then
        self.m_View:updateWithPlayerIndex(SingletonGetters.getModelTurnManager(modelSceneWar):getPlayerIndex())
    end

    return self
end

function ModelBattleInfo:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtActionPlannerIdle")           then onEvtPreviewNoBattleDamage(self, event)
    elseif (eventName == "EvtActionPlannerMakingMovePath") then onEvtPreviewNoBattleDamage(self, event)
    elseif (eventName == "EvtActionPlannerChoosingAction") then onEvtPreviewNoBattleDamage(self, event)
    elseif (eventName == "EvtPreviewNoBattleDamage")       then onEvtPreviewNoBattleDamage(self, event)
    elseif (eventName == "EvtPreviewBattleDamage")         then onEvtPreviewBattleDamage(  self, event)
    elseif (eventName == "EvtPlayerIndexUpdated")          then onEvtPlayerIndexUpdated(   self, event)
    end

    return self
end

return ModelBattleInfo
