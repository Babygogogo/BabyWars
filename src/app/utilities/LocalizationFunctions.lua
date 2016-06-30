
local LocalizationFunctions = {}

local s_LanguageCode = 1

local s_LongText1_1 = [[
--- 注：游戏尚有部分功能未完成开发，请谅解。---

--- 游戏流程 ---
首先，您需要通过主菜单的“注册/登陆”功能连接到游戏（若您曾经成功登陆过，则游戏会尝试自动登陆--暂未完成）。成功后，主菜单将出现新的选项，您可以通过它们来进入战局。

自行建立战局-开战的流程：
1. 通过“新建战局”选项创建新的战局。在里面，您可以随意选择模式（天梯或自由战斗）、地图、回合顺序、密码等多种设定。
2. 耐心等待他人加入您所创建的战局（满员前，您无法进入战局）。
3. 当战局满员后，您可以进入“继续”选项，里面将出现该战局（未满员时，该战局将*不会*出现！）。点击相应选项即可进入战局。

加入他人战局的流程：
1. 点击“参战”，里面将列出您可以加入的、由他人所建立的战局。您也可以通过里面的“搜索”按钮，用房间号来筛选出您所希望加入的战局。
2. 选中您所希望加入的战局，再选择回合顺序、密码等设定，并确认加入战局（注意，游戏不会自动进入战局画面）。
3. 回到主菜单选择“继续”，里面会出现该战局（前提是该战局已经满员。若未满员，则该战局不会出现，您仍需等候他人加入）。点击相应选项即可进入战局。
]]

local s_LongText2_1 = [[
--- 战局操作 ---
本作的战局操作方式类似于《Advanced Wars: Days of Ruin》。

战局画面的左（右）上角有一个关于玩家简要信息的标识框。点击它将弹出战局菜单，您可以通过菜单实现退出、结束回合等操作。
战局画面的左（右）下角有光标所在的地形（部队）的标识框。点击它会弹出该地形（部队）的详细信息框。

您可以随意拖动地图（使用单个手指滑动画面）和缩放地图（使用两个手指滑动画面）。

您可以预览战斗的预估伤害值：在为部队选择攻击目标时，把光标拖拽到目标之上即可（请不要直接点击目标，这将被游戏解读为直接对该目标进行攻击，而不预览战斗伤害值）。
]]

local s_LongText3_1 = [[
--- 关于本作 ---
《BabyWars》（暂名）是以《Advanced Wars》系列的设定为基础的同人作品。本作旨在为高级战争的爱好者们提供一个兼顾公平性和自由度的联网对战平台。

本作的兵种、地形等设定取材于《Advanced Wars: Days of Ruin》，不设CO系统，而使用允许玩家自由搭配的技能系统代替（《Advanced Wars: Dual Strike》中的技能装备的强化版，但目前尚未完成开发）。

本作有一定复杂度，建议您可以先游玩一下原作，以便更快上手。

作者：Babygogogo

协力（排名不分先后）：


原作：《Advanced Wars》系列
原作开发商：Intelligent Systems
]]

--------------------------------------------------------------------------------
-- The private functions.
--------------------------------------------------------------------------------
local s_Texts = {
    [1] = {
        [1] = function(...) return "主  菜  单" end,
        [2] = function(...) return "Main Menu" end,
    },
    [2] = {
        [1] = function(...) return "新 建 战 局"  end,
        [2] = function(...) return "New Game" end,
    },
    [3] = {
        [1] = function(...) return "继 续"    end,
        [2] = function(...) return "Continue" end,
    },
    [4] = {
        [1] = function(...) return "参 战" end,
        [2] = function(...) return "Join" end,
    },
    [5] = {
        [1] = function(...) return "配 置 技 能"    end,
        [2] = function(...) return "Config Skills" end,
    },
    [6] = {
        [1] = function(...) return "注 册 / 登 陆" end,
        [2] = function(...) return "Login"        end,
    },
    [7] = {
        [1] = function(...) return "帮 助" end,
        [2] = function(...) return "Help" end,
    },
    [8] = {
        [1] = function(...) return "返 回" end,
        [2] = function(...) return "Back" end,
    },
    [9] = {
        [1] = function(...) return "游 戏 流 程" end,
        [2] = function(...) return "Game Flow"  end,
    },
    [10] = {
        [1] = function(...) return "战 局 操 作" end,
        [2] = function(...) return "War Control" end,
    },
    [11] = {
        [1] = function(...) return "关 于 本 作" end,
        [2] = function(...) return "About" end,
    },
    [12] = {
        [1] = function(...) return s_LongText1_1     end,
        [2] = function(...) return "Untranslated..." end,
    },
    [13] = {
        [1] = function(...) return s_LongText2_1     end,
        [2] = function(...) return "Untranslated..." end,
    },
    [14] = {
        [1] = function(...) return s_LongText3_1     end,
        [2] = function(...) return "Untranslated..." end,
    },
    [15] = {
        [1] = function(...) return "账 号："  end,
        [2] = function(...) return "Account:" end,
    },
    [16] = {
        [1] = function(...) return "密 码："  end,
        [2] = function(...) return "Password:" end,
    },
    [17] = {
        [1] = function(...) return "注 册"  end,
        [2] = function(...) return "Register" end,
    },
    [18] = {
        [1] = function(...) return "登 陆"  end,
        [2] = function(...) return "Login" end,
    },
    [19] = {
        [1] = function(...) return "账号密码只能使用英文字符和/或数字，且最少6位。请检查后重试。"                               end,
        [2] = function(...) return "Only alphanumeric characters and/or underscores are allowed for account and password." end,
    },
    [20] = {
        [1] = function(...) return "请输入6位以上英文和/或数字"    end,
        [2] = function(...) return "input at least 6 characters" end,
    },
    [21] = {
        [1] = function(account) return "您已使用账号【" .. account .. "】进行了登陆。"      end,
        [2] = function(account) return "You have already logged in as " .. account .. "." end,
    },
    [22] = {
        [1] = function() return "账号或密码错误，请重试。"    end,
        [2] = function() return "Invalid account/password." end,
    },
    [23] = {
        [1] = function(account) return "您的账号【" .. account .. "】在另一台设备上被登陆，您已被迫下线！"     end,
        [2] = function(account) return "Another device is logging in with your account!" .. account .. "." end,
    },
    [24] = {
        [1] = function(account, password)
            return "您确定要用以下账号和密码进行注册吗？\n" .. account .. "\n" .. password
        end,
        [2] = function(account, password)
            return "Are you sure to register with the following account and password:\n" .. account .. "\n" .. password
        end,
    },
    [25] = {
        [1] = function() return "该账号已被注册，请使用其他账号。"                                  end,
        [2] = function() return "The account is registered already. Please use another account." end,
    },
    [26] = {
        [1] = function(account) return "欢迎登陆，【" .. account .. "】！" end,
        [2] = function(account) return "Welcome, " .. account .. "!"      end,
    },
    [27] = {
        [1] = function(account) return "欢迎注册，【" .. account .. "】！祝您游戏愉快！"            end,
        [2] = function(account) return "Welcome, " .. account .. "!\nThank you for registering!" end,
    },
    [28] = {
        [1] = function() return "是"  end,
        [2] = function() return "Yes" end,
    },
    [29] = {
        [1] = function() return "否" end,
        [2] = function() return "No" end,
    },
    [30] = {
        [1] = function() return "已成功连接服务器。"       end,
        [2] = function() return "Connection established." end,
    },
    [31] = {
        [1] = function() return "连接服务器失败，正在尝试重新连接…"       end,
        [2] = function() return "Connection lost. Now reconnecting..." end,
    },
    [32] = {
        [1] = function(err) return "与服务器的连接出现错误：" .. (err or "") .. "\n正在尝试重新连接…"                end,
        [2] = function(err) return "Connection lost with error: " .. (err or "") .. "Now reconnecting..." end,
    },
    [33] = {
        [1] = function() return "下 一 步" end,
        [2] = function() return "Next"  end,
    },
    [34] = {
        [1] = function() return "行 动 次 序"  end,
        [2] = function() return "Player Index" end,
    },
    [35] = {
        [1] = function() return "战 争 迷 雾" end,
        [2] = function() return "Fog of War" end,
    },
    [36] = {
        [1] = function() return "天 气"   end,
        [2] = function() return "Weather" end,
    },
    [37] = {
        [1] = function() return "技 能 配 置" end,
        [2] = function() return "Skills"     end,
    },
    [38] = {
        [1] = function() return "技 能 点 上 限"    end,
        [2] = function() return "Max Skill Points" end,
    },
    [39] = {
        [1] = function() return "密 码（可 选）"       end,
        [2] = function() return "Password (optional)" end,
    },
    [40] = {
        [1] = function() return "正 常" end,
        [2] = function() return "Clear" end,
    },
    [41] = {
        [1] = function() return "随 机"  end,
        [2] = function() return "Random" end,
    },
    [42] = {
        [1] = function() return "雨 天" end,
        [2] = function() return "Rainy" end,
    },
    [43] = {
        [1] = function() return "雪 天" end,
        [2] = function() return "Snowy" end,
    },
    [44] = {
        [1] = function() return "沙 尘 暴" end,
        [2] = function() return "Sandy"    end,
    },
    [45] = {
        [1] = function() return "暂 不 可 用"  end,
        [2] = function() return "Unavailable" end,
    },
    [46] = {
        [1] = function() return "确 认"   end,
        [2] = function() return "Confirm" end,
    },
    [47] = {
        [1] = function() return "留空或4位数字"        end,
        [2] = function() return "input 0 or 4 digits" end,
    },
    [48] = {
        [1] = function() return "作者："   end,
        [2] = function() return "Author: " end,
    },
    [49] = {
        [1] = function() return "回 合 内"   end,
        [2] = function() return "In Turn" end,
    },
    [50] = {
        [1] = function(err) return "无法创建战局。请重试或联系作者解决。\n" .. (err or "") end,
        [2] = function(err) return "Failed to create the war:\n" .. (err or "")         end,
    },
    [51] = {
        [1] = function(warShortName) return "【" .. warShortName .. "】战局已创建，请等待其他玩家参战。"                                          end,
        [2] = function(warShortName) return "The war [" .. warShortName .. "] is created successfully. Please wait for other players to join." end,
    },
    [52] = {
        [1] = function() return "无法进入战局，可能因为该战局已结束。"                           end,
        [2] = function() return "Failed entering the war, possibly because the war has ended." end,
    },
    [53] = {
        [1] = function(err) return "无法获取可参战列表。请重试或联系作者解决。\n" .. (err or "") end,
        [2] = function(err) return "Failed to get the joinable war list:\n" .. (err or "")   end,
    },
    [54] = {
        [1] = function(err) return "无法加入战局，可能因为您选择的行动顺序已被其他玩家占用，或密码不正确。\n" end,
        [2] = function(err) return "Failed to join the war:\n" .. (err or "")                          end,
    },
    [55] = {
        [1] = function() return "参战成功。战局尚未满员，请耐心等候。"                            end,
        [2] = function() return "Join war successfully. Please wait for more players to join." end,
    },
    [56] = {
        [1] = function(warShortName) return "【" .. warShortName .. '】参战成功。战局已开始，您可以通过"继续"选项进入战局。' end,
        [2] = function(warShortName) return "Join war [" .. warShortName .. "] successfully. The war has started."      end,
    },
    [57] = {
        [1] = function() return "查 找："   end,
        [2] = function() return "Find:" end,
    },
    [58] = {
        [1] = function() return "房号"   end,
        [2] = function() return "War ID" end,
    },
    [59] = {
        [1] = function() return "您输入的房号无效，请重试。"                 end,
        [2] = function() return "The War ID is invalid. Please try again." end,
    },
    [60] = {
        [1] = function() return "当前没有可加入（或符合查找条件）的战局。请等候，或自行建立战局。"                    end,
        [2] = function() return "Sorry, but no war is currently joinable. Please wait for or create a new war." end,
    },
    [61] = {
        [1] = function() return "您输入的密码无效，请重试。"                   end,
        [2] = function() return "The password is invalid. Please try again." end,
    },
    [62] = {
        [1] = function(nickname) return "玩家：" .. nickname    end,
        [2] = function(nickname) return "Player:  " .. nickname end,
    },
    [63] = {
        [1] = function(fund) return "金钱：" .. fund     end,
        [2] = function(fund) return "Fund:     " .. fund end,
    },
    [64] = {
        [1] = function(energy) return "能量：" .. energy    end,
        [2] = function(energy) return "Energy:  " .. energy end,
    },
    [65] = {
        [1] = function() return "退 出" end,
        [2] = function() return "Quit" end,
    },
    [66] = {
        [1] = function() return "您将回到主界面（可以随时再回到本战局）。\n是否确定退出？" end,
        [2] = function() return "You are quitting the war (you may reenter it later).\nAre you sure?" end,
    },
    [67] = {
        [1] = function() return "投 降" end,
        [2] = function() return "Surrender" end,
    },
    [68] = {
        [1] = function() return "您将输掉本战局，且无法反悔！\n是否确定投降？"              end,
        [2] = function() return "You will lose the game by surrendering!\nAre you sure?" end,
    },
    [69] = {
        [1] = function() return "结 束 回 合" end,
        [2] = function() return "End Turn" end,
    },
    [70] = {
        [1] = function(emptyProducersCount, idleUnitsCount)
            return string.format("空闲工厂机场海港数量：%d\n空闲部队数量：%d\n您是否确定结束回合？", emptyProducersCount, idleUnitsCount)
        end,
        [2] = function(emptyProducersCount, idleUnitsCount)
            return string.format("Idle factories count: %d\n Idle units count: %d\nAre you sure to end turn?", emptyProducersCount, idleUnitsCount)
        end,
    },
    [71] = {
        [1] = function() return "当前是您对手的回合，请耐心等候。"           end,
        [2] = function() return "It's your opponent's turn. Please wait." end,
    },
    [72] = {
        [1] = function(turnIndex, nickname)
            return string.format("回合：%d\n玩家：%s\n战斗开始！", turnIndex, nickname)
        end,
        [2] = function(turnIndex, nickname)
            return string.format("Turn:     %d\nPlayer:  %s\nFight!", turnIndex, nickname)
        end,
    },
    [73] = {
        [1] = function() return "您 已 投 降 …"     end,
        [2] = function() return "You surrender..." end,
    },
    [74] = {
        [1] = function() return "您 已 获 胜 ！" end,
        [2] = function() return "You win!"      end,
    },
    [75] = {
        [1] = function() return "您 已 战 败 …" end,
        [2] = function() return "You lose..."  end,
    },
    [76] = {
        [1] = function(nickname) return "玩家【" .. nickname .. "】已战败！"        end,
        [2] = function(nickname) return "Player [" .. nickname .. "] is defeated!" end,
    },
    [77] = {
        [1] = function(nickname) return "玩家【" .. nickname .. "】已投降！"        end,
        [2] = function(nickname) return "Player [" .. nickname .. "] surrendered!" end,
    },
    [78] = {
        [1] = function() return "攻 击"  end,
        [2] = function() return "Attack" end,
    },
    [79] = {
        [1] = function() return "占 领"   end,
        [2] = function() return "Capture" end,
    },
    [80] = {
        [1] = function() return "待 机" end,
        [2] = function() return "Wait" end,
    },
    [81] = {
        [1] = function() return "合 流" end,
        [2] = function() return "Join" end,
    },
    [82] = {
        [1] = function() return "装 载" end,
        [2] = function() return "Load"  end,
    },
    [83] = {
        [1] = function() return "卸 载"  end,
        [2] = function() return "Unload" end,
    },
    [84] = {
        [1] = function() return "发 射"  end,
        [2] = function() return "Launch" end,
    },
    [85] = {
        [1] = function() return "建 造"  end,
        [2] = function() return "Build" end,
    },
    [86] = {
        [1] = function() return "生 产"   end,
        [2] = function() return "Produce" end,
    },
    [87] = {
        [1] = function() return "补 给"  end,
        [2] = function() return "Supply" end,
    },
    [88] = {
        [1] = function() return "下 潜" end,
        [2] = function() return "Dive" end,
    },
    [89] = {
        [1] = function() return "上 浮"   end,
        [2] = function() return "Surface" end,
    },
    [90] = {
        [1] = function(attack, counter) return string.format("攻：    %d%%\n防：    %s%%", attack, counter or "--") end,
        [2] = function(attack, counter) return string.format("Atk:   %d%%\nDef:   %s%%", attack, counter or "--") end,
    },
    [91] = {
        [1] = function(moveRange, moveTypeName) return "移动力：" .. moveRange .. "（" .. moveTypeName .. "）"       end,
        [2] = function(moveRange, moveTypeName) return "Movement Range:  " .. moveRange .. "(" .. moveTypeName .. ")" end,
    },
    [92] = {
        [1] = function(vision) return "视野：" .. vision    end,
        [2] = function(vision) return "Vision:  " .. vision end,
    },
    [93] = {
        [1] = function(currentFuel, maxFuel, consumption, destroyOnRunOut)
            return string.format("燃料存量：%d / %d     每回合消耗：%d     耗尽后消灭：%s", currentFuel, maxFuel, consumption, (destroyOnRunOut) and ("是") or ("否"))
        end,
        [2] = function(currentFuel, maxFuel, consumption, destroyOnRunOut)
            return "Fuel:    Amount:  " .. currentFuel .. " / " .. maxFuel .. "    ConsumptionPerTurn:  " .. consumption ..
                "\n            " .. ((destroyOnRunOut) and ("This unit is destroyed when out of fuel.") or ("This unit can't move when out of fuel."))
        end,
    },
    [94] = {
        [1] = function(weaponName, currentAmmo, maxAmmo, minRange, maxRange)
            return "主武器：" .. weaponName ..
                "      弹药量：" .. currentAmmo .. " / " .. maxAmmo ..
                "      射程：" .. ((minRange == maxRange) and (minRange) or (minRange .. " - " .. maxRange))
        end,
        [2] = function(weaponName, currentAmmo, maxAmmo, minRange, maxRange)
            return "Primary Weapon: " .. weaponName ..
                "    Ammo:  "      .. currentAmmo .. " / " .. maxAmmo ..
                "    Range:  "     .. ((minRange == maxRange) and (minRange) or (minRange .. " - " .. maxRange))
        end,
    },
    [95] = {
        [1] = function() return "主武器：无"                    end,
        [2] = function() return "Primary Weapon: Not equipped." end,
    },
    [96] = {
        [1] = function() return "极强："   end,
        [2] = function() return "Fatal:" end,
    },
    [97] = {
        [1] = function() return "较强："   end,
        [2] = function() return "Good:" end,
    },
    [98] = {
        [1] = function(weaponName, minRange, maxRange)
            return "副武器：" .. weaponName ..
                "      射程：" .. ((minRange == maxRange) and (minRange) or (minRange .. " - " .. maxRange))
        end,
        [2] = function(weaponName, minRange, maxRange)
            return "Secondary Weapon: " .. weaponName ..
                "    Range:  "     .. ((minRange == maxRange) and (minRange) or (minRange .. " - " .. maxRange))
        end,
    },
    [99] = {
        [1] = function() return "副武器：无"                       end,
        [2] = function() return "Secondary Weapon: Not equipped." end,
    },
    [100] = {
        [1] = function() return "防御："   end,
        [2] = function() return "Defense:" end,
    },
    [101] = {
        [1] = function() return "极弱：" end,
        [2] = function() return "Fatal:" end,
    },
    [102] = {
        [1] = function() return "较弱：" end,
        [2] = function() return "Weak:" end,
    },
    [103] = {
        [1] = function(bonus, catagory) return "防御加成：" .. bonus .. "%（" .. catagory .. "）"     end,
        [2] = function(bonus, catagory) return "DefenseBonus: " .. bonus .. "% (" .. catagory .. ")" end,
    },
    [104] = {
        [1] = function(amount, catagory) return "维修：+" .. amount .. "HP（" .. catagory .. "）"   end,
        [2] = function(amount, catagory) return "Repair:  +" .. amount .. "HP (" .. catagory .. ")" end,
    },
    [105] = {
        [1] = function() return "维修：无"      end,
        [2] = function() return "Repair:  None" end,
    },
    [106] = {
        [1] = function(currentPoint, maxPoint) return "占领点数：" .. currentPoint .. " / " .. maxPoint      end,
        [2] = function(currentPoint, maxPoint) return "CapturePoint:  " .. currentPoint .. " / " .. maxPoint end,
    },
    [107] = {
        [1] = function() return "占领点数：无"         end,
        [2] = function() return "CapturePoint:  None" end,
    },
    [108] = {
        [1] = function(income) return "收入：" .. income    end,
        [2] = function(income) return "Income:  " .. income end,
    },
    [109] = {
        [1] = function() return "收入：无"      end,
        [2] = function() return "Income:  None" end,
    },
    [110] = {
        [1] = function(moveType)
            if     (moveType == "infantry")  then return "步兵"
            elseif (moveType == "mech")      then return "炮兵"
            elseif (moveType == "tireA")     then return "重型轮胎"
            elseif (moveType == "tireB")     then return "轻型轮胎"
            elseif (moveType == "tank")      then return "履带"
            elseif (moveType == "air")       then return "飞行"
            elseif (moveType == "ship")      then return "航行"
            elseif (moveType == "transport") then return "运输"
            else                                  return "未知"
            end
        end,
        [2] = function()
            if     (moveType == "infantry")  then return "infantry"
            elseif (moveType == "mech")      then return "mech"
            elseif (moveType == "tireA")     then return "tireA"
            elseif (moveType == "tireB")     then return "tireB"
            elseif (moveType == "tank")      then return "tank"
            elseif (moveType == "air")       then return "air"
            elseif (moveType == "ship")      then return "ship"
            elseif (moveType == "transport") then return "transport"
            else                                  return "unrecognized"
            end
        end,
    },
    [111] = {
        [1] = function(moveType, moveCost) return LocalizationFunctions.getLocalizedText(110, moveType) .. "：" .. (moveCost or "--") end,
        [2] = function(moveType, moveCost) return LocalizationFunctions.getLocalizedText(110, moveType) .. ":  " .. (moveCost or "--") end,
    },
    [112] = {
        [1] = function() return "移动力消耗："  end,
        [2] = function() return "Move Cost:  " end,
    },
}

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function LocalizationFunctions.setLanguageCode(languageCode)
    assert((languageCode == 1) or (languageCode == 2), "LocalizationFunctions.setLanguageCode() the param is invalid.")
    s_LanguageCode = languageCode

    return LocalizationFunctions
end

function LocalizationFunctions.getLanguageCode()
    return s_LanguageCode
end

function LocalizationFunctions.getLocalizedText(textCode, ...)
    return s_Texts[textCode][s_LanguageCode](...)
end

return LocalizationFunctions
