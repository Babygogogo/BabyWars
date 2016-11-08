
local VisionOwner = require("src.global.functions.class")("VisionOwner")

local SingletonGetters       = require("src.app.utilities.SingletonGetters")
local SkillModifierFunctions = require("src.app.utilities.SkillModifierFunctions")

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
function VisionOwner:onStartRunning(sceneWarFileName)
    self.m_SceneWarFileName = sceneWarFileName

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function VisionOwner:getVisionForPlayerIndex(playerIndex, gridIndex)
    local template         = self.m_Template
    local owner            = self.m_Owner
    local ownerPlayerIndex = owner:getPlayerIndex()
    if ((not template.isEnabledForAllPlayers) and
        (ownerPlayerIndex ~= playerIndex))    then
        return nil
    else
        local sceneWarFileName        = self.m_SceneWarFileName
        local baseVision              = template.vision
        local modelSkillConfiguration = SingletonGetters.getModelPlayerManager(sceneWarFileName):getModelPlayer(ownerPlayerIndex):getModelSkillConfiguration()
        if (owner.getTileType) then
            if (ownerPlayerIndex == playerIndex) then
                return baseVision + SkillModifierFunctions.getVisionModifierForTiles(modelSkillConfiguration)
            else
                return baseVision
            end
        else
            local tileType = getModelTileMap(sceneWarFileName):getModelTile(gridIndex or owner:getGridIndex()):getTileType()
            local bonus    = (template.bonusOnTiles) and (template.bonusOnTiles[tileType] or 0) or (0)
            return baseVision + bonus + SkillModifierFunctions.getVisionModifierForUnits(modelSkillConfiguration)
        end
    end
end

return VisionOwner
