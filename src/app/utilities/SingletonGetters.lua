
local SingletonGetters = {}

local IS_SERVER       = require("src.app.utilities.GameConstantFunctions").isServer()
local SceneWarManager = (    IS_SERVER) and (require("src.app.utilities.SceneWarManager")) or (nil)
local ActorManager    = (not IS_SERVER) and (require("src.global.actors.ActorManager"))    or (nil)

function SingletonGetters.getModelScene(sceneWarFileName)
    return (IS_SERVER)                                              and
        (SceneWarManager.getOngoingModelSceneWar(sceneWarFileName)) or
        (ActorManager.getRootActor():getModel())
end

function SingletonGetters.getSceneWarFileName()
    return SingletonGetters.getModelScene():getFileName()
end

function SingletonGetters.getActionId(sceneWarFileName)
    return SingletonGetters.getModelScene(sceneWarFileName):getActionId()
end

function SingletonGetters.getModelFogMap(sceneWarFileName)
    return SingletonGetters.getModelWarField(sceneWarFileName):getModelFogMap()
end

function SingletonGetters.getModelPlayerManager(sceneWarFileName)
    return SingletonGetters.getModelScene(sceneWarFileName):getModelPlayerManager()
end

function SingletonGetters.getModelTileMap(sceneWarFileName)
    return SingletonGetters.getModelWarField(sceneWarFileName):getModelTileMap()
end

function SingletonGetters.getModelTurnManager(sceneWarFileName)
    return SingletonGetters.getModelScene(sceneWarFileName):getModelTurnManager()
end

function SingletonGetters.getModelUnitMap(sceneWarFileName)
    return SingletonGetters.getModelWarField(sceneWarFileName):getModelUnitMap()
end

function SingletonGetters.getModelWarField(sceneWarFileName)
    return SingletonGetters.getModelScene(sceneWarFileName):getModelWarField()
end

function SingletonGetters.getModelWeatherManager(sceneWarFileName)
    return SingletonGetters.getModelScene(sceneWarFileName):getModelWeatherManager()
end

function SingletonGetters.getScriptEventDispatcher(sceneWarFileName)
    return SingletonGetters.getModelScene(sceneWarFileName):getScriptEventDispatcher()
end

function SingletonGetters.isTotalReplay(sceneWarFileName)
    return SingletonGetters.getModelScene(sceneWarFileName):isTotalReplay()
end

--------------------------------------------------------------------------------
-- The public getters that can be used only on the client.
--------------------------------------------------------------------------------
function SingletonGetters.getModelConfirmBox()
    return SingletonGetters.getModelScene():getModelConfirmBox()
end

function SingletonGetters.getModelGridEffect()
    return SingletonGetters.getModelWarField():getModelGridEffect()
end

function SingletonGetters.getModelMapCursor()
    return SingletonGetters.getModelWarField():getModelMapCursor()
end

function SingletonGetters.getModelMessageIndicator()
    return SingletonGetters.getModelScene():getModelMessageIndicator()
end

function SingletonGetters.getModelMainMenu()
    return SingletonGetters.getModelScene():getModelMainMenu()
end

function SingletonGetters.getModelWarCommandMenu()
    return SingletonGetters.getModelScene():getModelWarHud():getModelWarCommandMenu()
end

function SingletonGetters.getPlayerIndexLoggedIn()
    return SingletonGetters.getModelPlayerManager():getPlayerIndexLoggedIn()
end

return SingletonGetters
