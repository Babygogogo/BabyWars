
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

local function round(num)
    return math.floor(num + 0.5)
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

s_Executors.execute5 = function(level, modelWarField, modelPlayerManager, modelTurnManager, modelWeatherManager, dispatcher)
    local modifier     = getSkillModifier(5, level) * 10
    local playerIndex  = modelTurnManager:getPlayerIndex()
    local func         = function(modelUnit)
        if (modelUnit:getPlayerIndex() ~= playerIndex) then
            modifyModelUnitHp(modelUnit, modifier)
        end
    end

    modelWarField:getModelUnitMap():forEachModelUnitOnMap(func)
        :forEachModelUnitLoaded(func)

    dispatcher:dispatchEvent({name = "EvtModelUnitMapUpdated"})
end

s_Executors.execute8 = function(level, modelWarField, modelPlayerManager, modelTurnManager, modelWeatherManager, dispatcher)
    local playerIndex = modelTurnManager:getPlayerIndex()
    local func        = function(modelUnit)
        if ((modelUnit:getPlayerIndex() == playerIndex)                                             and
            (not GameConstantFunctions.isTypeInCategory(modelUnit:getUnitType(), "InfantryUnits"))) then
            modelUnit:setStateIdle()
                :updateView()
        end
    end

    modelWarField:getModelUnitMap():forEachModelUnitOnMap(func)
        :forEachModelUnitLoaded(func)

    dispatcher:dispatchEvent({name = "EvtModelUnitMapUpdated"})
end

s_Executors.execute9 = function(level, modelWarField, modelPlayerManager, modelTurnManager, modelWeatherManager, dispatcher)
    local playerIndex  = modelTurnManager:getPlayerIndex()
    local baseModifier = getSkillModifier(9, level)
    local modifier     = (baseModifier >= 0) and ((100 + baseModifier) / 100) or (100 / (100 - baseModifier))
    local func         = function(modelUnit)
        if (modelUnit:getPlayerIndex() ~= playerIndex) then
            modelUnit:setCurrentFuel(math.min(modelUnit:getMaxFuel(), round(modelUnit:getCurrentFuel() * modifier)))
                :updateView()
        end
    end

    modelWarField:getModelUnitMap():forEachModelUnitOnMap(func)
        :forEachModelUnitLoaded(func)

    dispatcher:dispatchEvent({name = "EvtModelUnitMapUpdated"})
end

s_Executors.execute12 = function(level, modelWarField, modelPlayerManager, modelTurnManager, modelWeatherManager, dispatcher)
    local playerIndex  = modelTurnManager:getPlayerIndex()
    local modelPlayer  = modelPlayerManager:getModelPlayer(playerIndex)
    local baseModifier = getSkillModifier(12, level)
    if (baseModifier >= 0) then
        modelPlayer:setFund(round(modelPlayer:getFund() * (baseModifier + 100) / 100))
    else
        modelPlayer:setFund(round(modelPlayer:getFund() * 100 / (100 - baseModifier)))
    end

    dispatcher:dispatchEvent({
        name        = "EvtModelPlayerUpdated",
        modelPlayer = modelPlayer,
        playerIndex = playerIndex,
    })
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
