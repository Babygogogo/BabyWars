
--[[--------------------------------------------------------------------------------
-- GameConstantFunctions是一组与GameConstant相关的函数的集合。
-- 主要职责：
--   在游戏刚开始运行时，读入GameConstant并进行初始化（GameConstant里的某些数据是高度浓缩的，要处理一下才能给其他代码使用）
--   提供接口给外界读取有关GameConstant的数据
-- 使用场景举例：
--   参照上述主要职责
-- 其他：
--   - 关于TiledID：
--     TiledID指的是Tiled（一个地图编辑器）所生成的地图所带有的id值（如res/data/tileMap/TileMap_Test.lua文件里的data表的数据）。
--     TiledID是非负整数。0表示无，1及以上表示相应的unit或tile。
--     游戏中所有ModelUnit/ModelTile都带有自己的tiledID（无论model是文件中读入的还是游戏中动态产生的）。
--     TiledID与游戏中的许多相关信息都有固定的联系，因此在整个游戏中都很重要。
--
--     从Tiled的角度来看：
--       Tiled并不知道游戏的设定，它只会机械地对tileset里的所有图片逐一编号，而这个编号就是tiledID。
--       Tiled所生成的地图，实际上就是一个由tiledID组成的矩阵（严格来说是三个相同大小的矩阵，其中一个表示unit层，其余两个一起表示tile层）。
--       Tiled不能自动处理图块交界，因此tileset里包含了游戏中可能出现的unit或tile所有图块（的第一帧），由地图编辑者自行选择。
--       举例而言，像plain之类的tile就只有一种形态，而sea就有多达40种以上的形态，而不同的形态的tiledID也是不同的（尽管游戏逻辑上它们没有区别）。
--
--     从游戏的角度来看：
--       一个TiledID就代表了一个unit或tile，因此游戏必须能够以TiledID重建一个完整的unit或tile。
--       为此，在GameConstant内列出游戏所有的unit和tile的模板，也就是templateModelUnits/templateModelTiles。
--       同时，通过GameConstant.indexesForTileOrUnit，使得每一个TiledID都和正确的unit或tile的模板联系起来，这就使得ModelUnit/ModelTile能够仅通过TiledID来获取模板并初始化自身。
--       通过模板初始化的tile/unit都是满血满状态的，但游戏中它们的状态都有可能发生变化。模板无法记录这些变化，因此使用别的机制来记录这些变化（参考ModelTile/ModelUnit）。
--
--   - 关于PlayerIndex：
--     PlayerIndex是一个正整数，表示战局中的第几个玩家。举例来说，PlayerIndex为2，就表示是第二个玩家（换言之，这个玩家在回合中是第二个行动的）。
--
--     PlayerIndex可以由TiledID计算得到。
--       假设一个TiledID代表的是plain，而plain是中立的，由这个TiledID所计算出来的PlayerIndex就是0。
--       再考虑city。city有5种形态（包括中立、以及分别属于四名玩家的形态），5种形态下的TiledID各不相同，因此也可以由此计算出对应的PlayerIndex。
--       现阶段，PlayerIndex的合法取值为0、1、2、3、4，分别表示属于中立、红色势力、蓝色势力、黄色势力、黑色势力。
--
--     PlayerIndex和unit/tile的类型名字联合，可以反推得到TiledID。
--       这一点非常重要。考虑占领，一个city由A势力变为B势力，实质上就是TiledID发生了变化。
--       我们可以利用占领者的PlayerIndex和city的名字反推出新的TiledID，其他相关代码可以再由此获取更多信息（如动画）。
--]]--------------------------------------------------------------------------------

local GameConstantFunctions = {}

local Actor = require("src.global.actors.Actor")

local GAME_CONSTANT        = require("res.data.GameConstant")
local GRID_SIZE            = GAME_CONSTANT.gridSize
local UNIT_NAMES           = GAME_CONSTANT.categories.AllUnits
local TEMPLATE_MODEL_TILES = GAME_CONSTANT.templateModelTiles
local TEMPLATE_MODEL_UNITS = GAME_CONSTANT.templateModelUnits
local TILE_ANIMATIONS      = GAME_CONSTANT.tileAnimations
local TILE_UNIT_INDEXES    = {}

local FATAL_DAMAGE     = 90
local EFFECTIVE_DAMAGE = 50

local s_IsInitialized = false
local s_IsServer      = false

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
function GameConstantFunctions.init(isServer)
    if (not s_IsInitialized) then
        s_IsInitialized = true

        if (isServer) then
            s_IsServer = true
            Actor.setViewEnabled(false)
        end

        initTileUnitIndexes()
        initUnitAttackAndDefenseList()
    end

    return GameConstantFunctions
end

function GameConstantFunctions.isServer()
    return s_IsServer
end

function GameConstantFunctions.getGameVersion()
    return GAME_CONSTANT.version
end

function GameConstantFunctions.getGridSize()
    return GRID_SIZE
end

function GameConstantFunctions.getUnitMaxHP()
    return GAME_CONSTANT.unitMaxHP
end

function GameConstantFunctions.getTileMaxHP()
    return GAME_CONSTANT.tileMaxHP
end

function GameConstantFunctions.getCommandTowerAttackBonus()
    return GAME_CONSTANT.commandTowerAttackBonus
end

function GameConstantFunctions.getMaxPromotion()
    return GAME_CONSTANT.maxPromotion
end

function GameConstantFunctions.getPromotionBonus()
    return GAME_CONSTANT.promotionBonus
end

function GameConstantFunctions.getPassiveSkillSlotsCount()
    return GAME_CONSTANT.passiveSkillSlotsCount
end

function GameConstantFunctions.getActiveSkillSlotsCount()
    return GAME_CONSTANT.activeSkillSlotsCount
end

function GameConstantFunctions.getSkillPointsMinMaxStep()
    return GAME_CONSTANT.minSkillPoints, GAME_CONSTANT.maxSkillPoints, GAME_CONSTANT.skillPointsPerStep
end

function GameConstantFunctions.getSkillPoints(skillName, level)
    return GAME_CONSTANT.skills[skillName].levels[level].points
end

function GameConstantFunctions.getSkillModifier(skillName, level)
    return GAME_CONSTANT.skills[skillName].levels[level].modifier
end

function GameConstantFunctions.getSkillLevelMinMax(skillName)
    local skill = GAME_CONSTANT.skills[skillName]
    return skill.minLevel, skill.maxLevel
end

function GameConstantFunctions.getTiledIdWithTileOrUnitName(name, playerIndex)
    for id, index in ipairs(TILE_UNIT_INDEXES) do
        if ((index.name == name) and
            ((not playerIndex) or (playerIndex == index.playerIndex))) then
                return id
        end
    end

    error("GameConstantFunctions.getTiledIdWithTileOrUnitName() failed to find the Tiled ID.")
end

function GameConstantFunctions.getTileTypeWithTiledId(tiledID)
    return TILE_UNIT_INDEXES[tiledID].name
end

function GameConstantFunctions.getTileTypeWithObjectAndBaseId(objectID, baseID)
    local baseType = GameConstantFunctions.getTileTypeWithTiledId(baseID)
    if ((objectID == nil) or (objectID == 0)) then
        return baseType
    else
        local objectType = GameConstantFunctions.getTileTypeWithTiledId(objectID)
        if (objectType ~= "Bridge") then
            return objectType
        else
            if (baseType == "Sea") then
                return "BridgeOnSea"
            else
                return "BridgeOnRiver"
            end
        end
    end
end

function GameConstantFunctions.getUnitTypeWithTiledId(tiledID)
    return TILE_UNIT_INDEXES[tiledID].name
end

function GameConstantFunctions.getPlayerIndexWithTiledId(tiledID)
    return TILE_UNIT_INDEXES[tiledID].playerIndex
end

function GameConstantFunctions.getShapeIndexWithTiledId(tiledID)
    return TILE_UNIT_INDEXES[tiledID].shapeIndex
end

function GameConstantFunctions.getTemplateModelTileWithObjectAndBaseId(objectID, baseID)
    return TEMPLATE_MODEL_TILES[GameConstantFunctions.getTileTypeWithObjectAndBaseId(objectID, baseID)]
end

function GameConstantFunctions.getTemplateModelUnitWithTiledId(tiledID)
    return TEMPLATE_MODEL_UNITS[TILE_UNIT_INDEXES[tiledID].name]
end

function GameConstantFunctions.getTemplateModelUnitWithName(name)
    return TEMPLATE_MODEL_UNITS[name]
end

function GameConstantFunctions.doesViewTileFillGrid(tiledID)
    if ((not tiledID) or (tiledID == 0)) then
        return false
    else
        return TILE_ANIMATIONS[GameConstantFunctions.getTileTypeWithTiledId(tiledID)].fillsGrid
    end
end

function GameConstantFunctions.getCategory(categoryType)
    return GAME_CONSTANT.categories[categoryType]
end

function GameConstantFunctions.isTypeInCategory(type, categoryType)
    for _, t in pairs(GameConstantFunctions.getCategory(categoryType) or {}) do
        if (type == t) then
            return true
        end
    end

    return false
end

return GameConstantFunctions
