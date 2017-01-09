
local SingletonGetters = {}

local IS_SERVER       = require("src.app.utilities.GameConstantFunctions").isServer()
local SceneWarManager = (    IS_SERVER) and (require("src.app.utilities.SceneWarManager")) or (nil)
local ActorManager    = (not IS_SERVER) and (require("src.global.actors.ActorManager"))    or (nil)

local getOngoingModelSceneWar = (SceneWarManager) and (SceneWarManager.getOngoingModelSceneWar) or (nil)
local getRootActor            = (ActorManager) and (ActorManager.getRootActor) or (nil)
local type                    = type

--------------------------------------------------------------------------------
-- The public getters.
--------------------------------------------------------------------------------
local function getModelScene(param)
    local t = type(param)
    if (IS_SERVER) then
        if     (t == "table")  then return param
        elseif (t == "string") then return getOngoingModelSceneWar(param)
        else                        error("SingletonGetters-getModelScene() invalid param type on the server: " .. t)
        end
    else
        if (t == "table") then
            return param
        else
            local modelScene = getRootActor():getModel()
            assert((not param) or (param == modelScene:getFileName()), "SingletonGetters-getModelScene() invalid param on the client.")
            return modelScene
        end
    end
end

--------------------------------------------------------------------------------
-- The public getters.
--------------------------------------------------------------------------------
SingletonGetters.getModelScene = getModelScene

function SingletonGetters.getActionId(param)
    return getModelScene(param):getActionId()
end

function SingletonGetters.getModelFogMap(param)
    return SingletonGetters.getModelWarField(param):getModelFogMap()
end

function SingletonGetters.getModelPlayerManager(param)
    return getModelScene(param):getModelPlayerManager()
end

function SingletonGetters.getModelTileMap(param)
    return SingletonGetters.getModelWarField(param):getModelTileMap()
end

function SingletonGetters.getModelTurnManager(param)
    return getModelScene(param):getModelTurnManager()
end

function SingletonGetters.getModelUnitMap(param)
    return SingletonGetters.getModelWarField(param):getModelUnitMap()
end

function SingletonGetters.getModelWarField(param)
    return getModelScene(param):getModelWarField()
end

function SingletonGetters.getModelWeatherManager(param)
    return getModelScene(param):getModelWeatherManager()
end

function SingletonGetters.getSceneWarFileName(param)
    return getModelScene(param):getFileName()
end

function SingletonGetters.getScriptEventDispatcher(param)
    return getModelScene(param):getScriptEventDispatcher()
end

function SingletonGetters.isTotalReplay(param)
    return getModelScene(param):isTotalReplay()
end

--------------------------------------------------------------------------------
-- The public getters that can be used only on the client.
--------------------------------------------------------------------------------
function SingletonGetters.getModelConfirmBox(param)
    return getModelScene(param):getModelConfirmBox()
end

function SingletonGetters.getModelGridEffect(param)
    return SingletonGetters.getModelWarField(param):getModelGridEffect()
end

function SingletonGetters.getModelMapCursor(param)
    return SingletonGetters.getModelWarField(param):getModelMapCursor()
end

function SingletonGetters.getModelMessageIndicator(param)
    return getModelScene(param):getModelMessageIndicator()
end

function SingletonGetters.getModelMainMenu(param)
    return getModelScene(param):getModelMainMenu()
end

function SingletonGetters.getModelReplayController(param)
    return getModelScene(param):getModelWarHud():getModelReplayController()
end

function SingletonGetters.getModelWarCommandMenu(param)
    return getModelScene(param):getModelWarHud():getModelWarCommandMenu()
end

function SingletonGetters.getPlayerIndexLoggedIn(param)
    return SingletonGetters.getModelPlayerManager(param):getPlayerIndexLoggedIn()
end

return SingletonGetters
