
local ActionExecutor = {}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function executeEndTurn(action, sceneModel)
    sceneModel:getModelTurnManager():endTurn(action.nextWeather)
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ActionExecutor.execute(action, sceneModel)
    local actionName = action.actionName
    if (actionName == "EndTurn") then
        executeEndTurn(action, sceneModel)
    end
end

return ActionExecutor
