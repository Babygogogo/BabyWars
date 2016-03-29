
local ActionTranslator = {}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getCurrentPlayerID(playerManagerModel, turnManagerModel)
    return playerManagerModel:getModelPlayer(turnManagerModel:getPlayerIndex()):getID()
end

local function translatePath(path, focusUnitModel, unitMapModel, tileMapModel)

end

local function translateEndTurn(action, sceneModel)
    local playerManagerModel = sceneModel:getModelPlayerManager()
    local turnManagerModel   = sceneModel:getModelTurnManager()

    if (action.playerID ~= getCurrentPlayerID(playerManagerModel, turnManagerModel)) then
        return nil, "ActionTranslator-translateEndTurn() the playerID is not the same as the one of the logged in player."
    elseif (turnManagerModel:getTurnPhase() ~= "main") then
        return nil, "ActionTranslator-translateEndTurn() the current turn phase is expected to be 'main'."
    end

    return {actionName = "EndTurn", nextWeather = sceneModel:getModelWeatherManager():getNextWeather()}
end

local function translateWait(action, sceneModel)
    local warFieldModel = sceneModel:getModelWarField()
    local unitMapModel  = warFieldModel:getModelUnitMap()
    local tileMapModel  = warFieldModel:getModelTileMap()

    local path = action.path
    local focusUnitModel = unitMapModel:getModelUnit(path[1].gridIndex)
    if (not focusUnitModel) then
        return nil, "ActionTranslator-translateWait() there is no unit on the starting grid of the path."
    elseif (focusUnitModel:getPlayerIndex() ~= action.playerID) then
        return nil, "ActionTranslator-translateWait() the playerID of the unit is not the same as the one of the logged in player."
    elseif (focusUnitModel:getState() ~= "idle") then
        return nil, "ActionTranslator-translateWait() the unit is not in idle state."
    end




end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ActionTranslator.translate(action, sceneModel)
    local actionName = action.actionName
    if (actionName == "EndTurn") then
        return translateEndTurn(action, sceneModel)
    elseif (actionName == "Wait") then
--        return translateWait(action, sceneModel)
    else
        return nil, "ActionTranslator.translate() unrecognized action name."
    end
end

return ActionTranslator
