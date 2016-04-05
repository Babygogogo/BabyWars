
local ActionExecutor = {}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function executeEndTurn(action, sceneModel)
    sceneModel:getModelTurnManager():endTurn(action.nextWeather)
end

local function executeWait(action, sceneModel)
    for _, gridIndex in ipairs(action.path) do
        print(gridIndex.x, gridIndex.y)
    end
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ActionExecutor.execute(action, sceneModel)
    local actionName = action.actionName
    if (actionName == "EndTurn") then
        executeEndTurn(action, sceneModel)
    elseif (actionName == "Wait") then
        executeWait(action, sceneModel)
    end
end

return ActionExecutor
