
local ActionTranslator = {}

local function translateEndTurn(action, sceneModel)
    if (action.playerID ~= sceneModel:getCurrentPlayerID()) then
        return nil, "ActionTranslator-translateEndTurn() the playerID is not the same as the one of the logged in player."
    end

    if (sceneModel:getCurrentTurnPhase() ~= "main") then
        return nil, "ActionTranslator-translateEndTurn() the current turn phase is expected to be 'main'."
    end

    return {actionName = "EndTurn", nextWeather = sceneModel:getNextWeather()}
end

function ActionTranslator.translate(action, sceneModel)
    local actionName = action.actionName
    if (actionName == "EndTurn") then
        return translateEndTurn(action, sceneModel)
    else
        return nil, "ActionTranslator.translate() unrecognized action name."
    end
end

return ActionTranslator
