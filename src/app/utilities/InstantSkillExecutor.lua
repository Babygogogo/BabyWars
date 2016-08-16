
local InstantSkillExecutor = {}

local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")

local getSkillModifier = GameConstantFunctions.getSkillModifier

local s_Executors = {}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function modifyModelUnitHp(modelUnit, modifier)
    local newHP     = math.min(100, modelUnit:getCurrentHP() + modifier)
    newHP           = math.max(1, newHP)
    modelUnit:setCurrentHP(newHP)
        :updateView()
end

--------------------------------------------------------------------------------
-- The functions for executing instant skills.
--------------------------------------------------------------------------------
-- Modify HPs of all units of the currently-in-turn player.
s_Executors.execute4 = function(level, modelWarField, modelPlayerManager, modelTurnManager, modelWeatherManager, dispatcher)
    local modifier     = getSkillModifier(4, level) * 10
    local playerIndex  = modelTurnManager:getPlayerIndex()
    local func         = function(modelUnit)
        if (modelUnit:getPlayerIndex() == playerIndex) then
            modifyModelUnitHp(modelUnit, modifier)
        end
    end

    modelWarField:getModelUnitMap():forEachModelUnitOnMap(func)
        :forEachModelUnitLoaded(func)

    dispatcher:dispatchEvent({name = "EvtModelUnitMapUpdated"})
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function InstantSkillExecutor.doActionActivateSkillGroup(action, modelWarField, modelPlayerManager, modelTurnManager, modelWeatherManager, eventDispatcher)
    local modelSkillConfiguration = modelPlayerManager:getModelPlayer(modelTurnManager:getPlayerIndex()):getModelSkillConfiguration()
    for _, skill in pairs(modelSkillConfiguration:getAllSkillsInGroup(action.skillGroupID)) do
        local id, level  = skill.id, skill.level
        local methodName = "execute" .. id
        if (s_Executors[methodName]) then
            s_Executors[methodName](skill.level, modelWarField, modelPlayerManager, modelTurnManager, modelWeatherManager, eventDispatcher)
        end
    end

    return InstantSkillExecutor
end

return InstantSkillExecutor
