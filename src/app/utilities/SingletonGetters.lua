
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
        if   (t == "table")  then return param
        else                      return getRootActor():getModel()
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

function SingletonGetters.getScriptEventDispatcher(param)
    return getModelScene(param):getScriptEventDispatcher()
end

function SingletonGetters.isTotalReplay(param)
    return getModelScene(param):isTotalReplay()
end

--------------------------------------------------------------------------------
-- The public getters that can be used only on the client.
--------------------------------------------------------------------------------
function SingletonGetters.getModelConfirmBox()
    return getModelScene():getModelConfirmBox()
end

function SingletonGetters.getModelGridEffect()
    return SingletonGetters.getModelWarField():getModelGridEffect()
end

function SingletonGetters.getModelMapCursor()
    return SingletonGetters.getModelWarField():getModelMapCursor()
end

function SingletonGetters.getModelMessageIndicator()
    return getModelScene():getModelMessageIndicator()
end

function SingletonGetters.getModelMainMenu()
    return getModelScene():getModelMainMenu()
end

function SingletonGetters.getModelWarCommandMenu()
    return getModelScene():getModelWarHud():getModelWarCommandMenu()
end

function SingletonGetters.getPlayerIndexLoggedIn()
    return SingletonGetters.getModelPlayerManager():getPlayerIndexLoggedIn()
end

function SingletonGetters.getSceneWarFileName()
    return getModelScene():getFileName()
end

return SingletonGetters
