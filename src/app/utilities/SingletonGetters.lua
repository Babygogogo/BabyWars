
local SingletonGetters = {}

--------------------------------------------------------------------------------
-- The public getters.
--------------------------------------------------------------------------------
function SingletonGetters.getActionId(modelSceneWar)
    return modelSceneWar:getActionId()
end

function SingletonGetters.getModelFogMap(modelSceneWar)
    return SingletonGetters.getModelWarField(modelSceneWar):getModelFogMap()
end

function SingletonGetters.getModelPlayerManager(modelSceneWar)
    return modelSceneWar:getModelPlayerManager()
end

function SingletonGetters.getModelTileMap(modelSceneWar)
    return SingletonGetters.getModelWarField(modelSceneWar):getModelTileMap()
end

function SingletonGetters.getModelTurnManager(modelSceneWar)
    return modelSceneWar:getModelTurnManager()
end

function SingletonGetters.getModelUnitMap(modelSceneWar)
    return SingletonGetters.getModelWarField(modelSceneWar):getModelUnitMap()
end

function SingletonGetters.getModelWarField(modelSceneWar)
    return modelSceneWar:getModelWarField()
end

function SingletonGetters.getModelWeatherManager(modelSceneWar)
    return modelSceneWar:getModelWeatherManager()
end

function SingletonGetters.getSceneWarFileName(modelSceneWar)
    return modelSceneWar:getFileName()
end

function SingletonGetters.getScriptEventDispatcher(modelSceneWar)
    return modelSceneWar:getScriptEventDispatcher()
end

function SingletonGetters.isTotalReplay(modelSceneWar)
    return modelSceneWar:isTotalReplay()
end

--------------------------------------------------------------------------------
-- The public getters that can be used only on the client.
--------------------------------------------------------------------------------
function SingletonGetters.getModelConfirmBox(modelScene)
    return modelScene:getModelConfirmBox()
end

function SingletonGetters.getModelGridEffect(modelSceneWar)
    return SingletonGetters.getModelWarField(modelSceneWar):getModelGridEffect()
end

function SingletonGetters.getModelMapCursor(modelSceneWar)
    return SingletonGetters.getModelWarField(modelSceneWar):getModelMapCursor()
end

function SingletonGetters.getModelMessageIndicator(modelScene)
    return modelScene:getModelMessageIndicator()
end

function SingletonGetters.getModelMainMenu(modelSceneMain)
    return modelSceneMain:getModelMainMenu()
end

function SingletonGetters.getModelReplayController(modelSceneWar)
    return modelSceneWar:getModelWarHud():getModelReplayController()
end

function SingletonGetters.getModelWarCommandMenu(modelSceneWar)
    return modelSceneWar:getModelWarHud():getModelWarCommandMenu()
end

function SingletonGetters.getPlayerIndexLoggedIn(modelSceneWar)
    return SingletonGetters.getModelPlayerManager(modelSceneWar):getPlayerIndexLoggedIn()
end

return SingletonGetters
