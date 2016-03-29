
local ActionExecutor = {}

local function executeEndTurn(action, sceneModel)
    sceneModel:getTurnManager():endTurn(action.nextWeather)
end

function ActionExecutor.execute(action, sceneModel)
    local actionName = action.actionName
    if (actionName == "EndTurn") then
        executeEndTurn(action, sceneModel)
    end
end

return ActionExecutor
