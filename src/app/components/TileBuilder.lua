
local TileBuilder = require("src.global.functions.class")("TileBuilder")

local ComponentManager      = require("src.global.components.ComponentManager")
local GridIndexFunctions    = require("src.app.utilities.GridIndexFunctions")
local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")

TileBuilder.EXPORTED_METHODS = {
    "isBuildingModelTile",
    "canBuildOnTileType",
    "getBuildAmount",
    "getBuildTiledIdWithTileType",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function TileBuilder:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function TileBuilder:loadTemplate(template)
    self.m_Template = template
    return self
end

function TileBuilder:loadInstantialData(data)
    self.m_IsBuilding = (data.isBuildingModelTile == true) and (true) or (false)

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function TileBuilder:toSerializableTable()
    if (not self:isBuildingModelTile()) then
        return nil
    else
        return {
            isBuildingModelTile = true,
        }
    end
end

--------------------------------------------------------------------------------
-- The functions for doing the actions.
--------------------------------------------------------------------------------
function TileBuilder:doActionMoveModelUnit(action)
    if (#action.path > 1) then
        self.m_IsBuilding = false
    end

    return self.m_Owner
end

function TileBuilder:doActionBuildModelTile(action, builder, target)
    self.m_IsBuilding = (self:getBuildAmount() < target:getCurrentBuildPoint())

    local owner = self.m_Owner
    if (not self.m_IsBuilding) then
        owner:setCurrentMaterial(owner:getCurrentMaterial() - 1)
    end

    return owner
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function TileBuilder:isBuildingModelTile()
    return self.m_IsBuilding
end

function TileBuilder:canBuildOnTileType(tileType)
    return self.m_Template.buildList[tileType] ~= nil
end

function TileBuilder:getBuildAmount()
    return self.m_Owner:getNormalizedCurrentHP()
end

function TileBuilder:getBuildTiledIdWithTileType(tileType)
    assert(self:canBuildOnTileType(tileType), "TileBuilder:getBuildTiledIdWithTileType() the builder can't build buildings on " .. tileType)
    return GameConstantFunctions.getTiledIdWithTileOrUnitName(self.m_Template.buildList[tileType], self.m_Owner:getPlayerIndex())
end

return TileBuilder
