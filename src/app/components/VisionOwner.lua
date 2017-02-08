
local VisionOwner = requireBW("src.global.functions.class")("VisionOwner")

local SingletonGetters       = requireBW("src.app.utilities.SingletonGetters")
local SkillModifierFunctions = requireBW("src.app.utilities.SkillModifierFunctions")

local getModelTileMap = SingletonGetters.getModelTileMap

VisionOwner.EXPORTED_METHODS = {
    "getVisionForPlayerIndex",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function VisionOwner:ctor(param)
    self:loadTemplate(param.template)

    return self
end

function VisionOwner:loadTemplate(template)
    self.m_Template = template

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function VisionOwner:onStartRunning(modelSceneWar)
    self.m_ModelSceneWar = modelSceneWar

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function VisionOwner:getVisionForPlayerIndex(playerIndex, gridIndex)
    local template         = self.m_Template
    local owner            = self.m_Owner
    local ownerPlayerIndex = owner:getPlayerIndex()
    if ((not template.isEnabledForAllPlayers) and (ownerPlayerIndex ~= playerIndex)) then
        return nil
    else
        local modelSceneWar           = self.m_ModelSceneWar
        local baseVision              = template.vision
        local modelSkillConfiguration = SingletonGetters.getModelPlayerManager(modelSceneWar):getModelPlayer(playerIndex):getModelSkillConfiguration()
        if (owner.getTileType) then
            if (ownerPlayerIndex == playerIndex) then
                return baseVision + SkillModifierFunctions.getVisionModifierForTiles(modelSkillConfiguration)
            else
                return baseVision
            end
        else
            local tileType = getModelTileMap(modelSceneWar):getModelTile(gridIndex or owner:getGridIndex()):getTileType()
            local bonus    = (template.bonusOnTiles) and (template.bonusOnTiles[tileType] or 0) or (0)
            return baseVision + bonus + SkillModifierFunctions.getVisionModifierForUnits(modelSkillConfiguration)
        end
    end
end

return VisionOwner
