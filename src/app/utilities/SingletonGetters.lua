
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

function SingletonGetters.getModelConfirmBox(sceneWarFileName)
    return SingletonGetters.getModelScene(sceneWarFileName):getModelConfirmBox()
end

function SingletonGetters.getModelMessageIndicator(sceneWarFileName)
    return SingletonGetters.getModelScene(sceneWarFileName):getModelMessageIndicator()
end

function SingletonGetters.getModelPlayerManager(sceneWarFileName)
    return SingletonGetters.getModelScene(sceneWarFileName):getModelPlayerManager()
end

function SingletonGetters.getModelTurnManager(sceneWarFileName)
    return SingletonGetters.getModelScene(sceneWarFileName):getModelTurnManager()
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

function SingletonGetters.getModelTileMap(sceneWarFileName)
    return SingletonGetters.getModelWarField(sceneWarFileName):getModelTileMap()
end

function SingletonGetters.getModelUnitMap(sceneWarFileName)
    return SingletonGetters.getModelWarField(sceneWarFileName):getModelUnitMap()
end

return SingletonGetters
