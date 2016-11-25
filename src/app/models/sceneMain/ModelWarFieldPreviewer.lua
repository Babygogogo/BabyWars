
local ModelWarFieldPreviewer = class("ModelWarFieldPreviewer")

local Actor = require("src.global.actors.Actor")

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initActorTileMap(self, tileMapData)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelTileMap", tileMapData, "sceneWar.ViewTileMap")

    self.m_ActorTileMap = actor
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelWarFieldPreviewer:ctor(param)
    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelWarFieldPreviewer:setWarField(warFieldFileName, isRandom)
    if (self.m_WarFieldFileName ~= warFieldFileName) then
        self.m_WarFieldFileName = warFieldFileName
        if (isRandom) then
            self.m_RandomPlayersCount = require("res.data.templateWarField." .. warFieldFileName).playersCount
        else
            self.m_RandomPlayersCount = nil

            initActorTileMap(self, {template = warFieldFileName, isPreview = true})
            self.m_View:setViewTileMap(self.m_ActorTileMap:getView(), self.m_ActorTileMap:getModel():getMapSize())
        end
        self.m_View:setAuthorName(require("res.data.templateWarField." .. warFieldFileName).authorName)
    end

    return self
end

function ModelWarFieldPreviewer:setPlayerNicknames(names, count)
    if (self.m_View) then
        self.m_View:setPlayerNicknames(names, count)
    end

    return self
end

function ModelWarFieldPreviewer:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setEnabled(enabled, self.m_RandomPlayersCount)
    end

    return self
end

return ModelWarFieldPreviewer
