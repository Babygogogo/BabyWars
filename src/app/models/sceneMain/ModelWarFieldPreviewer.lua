
local ModelWarFieldPreviewer = class("ModelWarFieldPreviewer")

local AnimationLoader       = requireBW("src.app.utilities.AnimationLoader")
local GameConstantFunctions = requireBW("src.app.utilities.GameConstantFunctions")
local GridIndexFunctions    = requireBW("src.app.utilities.GridIndexFunctions")
local Actor                 = requireBW("src.global.actors.Actor")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function isRandomWarField(warFieldFileName)
    return string.find(warFieldFileName, "Random", 1, true) == 1
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initActorTileMap(self, warFieldFileName)
    local modelTileMap = Actor.createModel("sceneWar.ModelTileMap", nil, warFieldFileName, true)
    local actor        = Actor.createWithModelAndViewInstance(modelTileMap, Actor.createView("sceneWar.ViewTileMap"))

    self.m_ActorTileMap = actor
end

local function initViewUnitMap(self, warFieldFileName)
    local layer               = requireBW("res.data.templateWarField." .. warFieldFileName).layers[3]
    local data, width, height = layer.data, layer.width, layer.height
    local viewUnitMap         = cc.Node:create()

    for x = 1, width do
        for y = 1, height do
            local tiledID = data[x + (height - y) * width]
            if (tiledID > 0) then
                local viewUnit    = cc.Sprite:create()
                local unitType    = GameConstantFunctions.getUnitTypeWithTiledId(tiledID)
                local playerIndex = GameConstantFunctions.getPlayerIndexWithTiledId(tiledID)
                viewUnit:ignoreAnchorPointForPosition(true)
                    :setPosition(GridIndexFunctions.toPositionWithXY(x, y))
                    :playAnimationForever(AnimationLoader.getUnitAnimation(unitType, playerIndex, "normal"))

                viewUnitMap:addChild(viewUnit)
            end
        end
    end

    self.m_ViewUnitMap = viewUnitMap
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
function ModelWarFieldPreviewer:setWarField(warFieldFileName)
    if (self.m_WarFieldFileName ~= warFieldFileName) then
        self.m_WarFieldFileName = warFieldFileName
        if (isRandomWarField(warFieldFileName)) then
            self.m_RandomPlayersCount = requireBW("res.data.templateWarField." .. warFieldFileName).playersCount
        else
            self.m_RandomPlayersCount = nil

            initActorTileMap(self, warFieldFileName)
            initViewUnitMap(self, warFieldFileName)
            self.m_View:setViewTileAndUnitMap(self.m_ActorTileMap:getView(), self.m_ViewUnitMap, self.m_ActorTileMap:getModel():getMapSize())
        end
        self.m_View:setAuthorName(requireBW("res.data.templateWarField." .. warFieldFileName).authorName)
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
