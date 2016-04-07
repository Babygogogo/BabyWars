
local GameConstantFunctions = {}

local GAME_CONSTANT        = require("res.data.GameConstant")
local GRID_SIZE            = GAME_CONSTANT.gridSize
local UNIT_NAMES           = GAME_CONSTANT.unitCatagory.allUnits
local TEMPLATE_MODEL_TILES = GAME_CONSTANT.templateModelTiles
local TEMPLATE_MODEL_UNITS = GAME_CONSTANT.templateModelUnits
local TILE_UNIT_INDEXES    = {}

local FATAL_DAMAGE     = 90
local EFFECTIVE_DAMAGE = 50

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function initTileUnitIndexes()
    for _, data in ipairs(GAME_CONSTANT.indexesForTileOrUnit) do
        local name        = data.name
        local playerIndex = data.firstPlayerIndex

        for shapeIndex = 1, data.shapesCount do
            TILE_UNIT_INDEXES[#TILE_UNIT_INDEXES + 1] = {name = name, playerIndex = playerIndex, shapeIndex = shapeIndex}
            playerIndex = (data.isSamePlayerIndex) and (playerIndex) or (playerIndex + 1)
        end
    end
end

local function getBaseDamage(weapon, defenseType)
    if (weapon) then
        return weapon.baseDamage[defenseType]
    else
        return nil
    end
end

local function initUnitAttackAndDefenseWithEmptyList()
    for _, unit in pairs(TEMPLATE_MODEL_UNITS) do
        unit.AttackTaker.fatal, unit.AttackTaker.weak = {}, {}
        if (unit.AttackDoer) then
            local primaryWeapon = unit.AttackDoer.primaryWeapon
            if (primaryWeapon) then
                primaryWeapon.fatal, primaryWeapon.strong = {}, {}
            end

            local secondaryWeapon = unit.AttackDoer.secondaryWeapon
            if (secondaryWeapon) then
                secondaryWeapon.fatal, secondaryWeapon.strong = {}, {}
            end
        end
    end
end

local function updateWeaponAttackList(weapon, defenseType, defenderName)
    if (not weapon) then
        return nil
    else
        local damage = getBaseDamage(weapon, defenseType)
        if (damage) then
            if (damage >= FATAL_DAMAGE) then
                weapon.fatal[#weapon.fatal + 1] = defenderName
            elseif (damage >= EFFECTIVE_DAMAGE) then
                weapon.strong[#weapon.strong + 1] = defenderName
            end
        end

        return damage
    end
end

local function initUnitAttackAndDefenseList()
    initUnitAttackAndDefenseWithEmptyList()

    for _, defenderName in ipairs(UNIT_NAMES) do
        local defenderData = TEMPLATE_MODEL_UNITS[defenderName]
        local defenseFatalList, defenseWeakList = defenderData.AttackTaker.fatal, defenderData.AttackTaker.weak
        local defenseType = defenderData.AttackTaker.defenseType

        for _, attackerName in ipairs(UNIT_NAMES) do
            local attackerData = TEMPLATE_MODEL_UNITS[attackerName]
            if (attackerData.AttackDoer) then
                local primaryWeaponDamage   = updateWeaponAttackList(attackerData.AttackDoer.primaryWeapon,   defenseType, defenderName)
                local secondaryWeaponDamage = updateWeaponAttackList(attackerData.AttackDoer.secondaryWeapon, defenseType, defenderName)
                local maxDamage = math.max((primaryWeaponDamage or 0), (secondaryWeaponDamage or 0))

                if (maxDamage >= FATAL_DAMAGE) then
                    defenseFatalList[#defenseFatalList + 1] = attackerName
                elseif (maxDamage >= EFFECTIVE_DAMAGE) then
                    defenseWeakList[#defenseWeakList + 1] = attackerName
                end
            end
        end
    end
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function GameConstantFunctions.init()
    initTileUnitIndexes()
    initUnitAttackAndDefenseList()
end

function GameConstantFunctions.getGridSize()
    return GRID_SIZE
end

function GameConstantFunctions.getTiledIdWithTileOrUnitName(name)
    for id, index in ipairs(TILE_UNIT_INDEXES) do
        if (index.name == name) then
            return id
        end
    end

    error("GameConstantFunctions.getTiledIdWithTileOrUnitName() failed to find the Tiled ID.")
end

function GameConstantFunctions.getTileNameWithTiledId(tiledID)
    return TILE_UNIT_INDEXES[tiledID].name
end

function GameConstantFunctions.getUnitNameWithTiledId(tiledID)
    return TILE_UNIT_INDEXES[tiledID].name
end

function GameConstantFunctions.getPlayerIndexWithTiledId(tiledID)
    return TILE_UNIT_INDEXES[tiledID].playerIndex
end

function GameConstantFunctions.getShapeIndexWithTiledId(tiledID)
    return TILE_UNIT_INDEXES[tiledID].shapeIndex
end

function GameConstantFunctions.getTemplateModelTileWithTiledId(tiledID)
    return TEMPLATE_MODEL_TILES[TILE_UNIT_INDEXES[tiledID].name]
end

function GameConstantFunctions.getTemplateModelUnitWithTiledId(tiledID)
    return TEMPLATE_MODEL_UNITS[TILE_UNIT_INDEXES[tiledID].name]
end

return GameConstantFunctions
