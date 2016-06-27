
local LocalizationFunctions = {}

local s_LanguageCode = 1

local s_LongText1_1 = [[
--- 注：游戏尚有部分功能未完成开发，请谅解。---

--- 游戏流程 ---
首先，您需要通过主菜单的“注册/登陆”功能连接到游戏（若您曾经成功登陆过，则游戏会尝试自动登陆--暂未完成）。成功后，主菜单将出现新的选项，您可以通过它们来进入战局。

自行建立战局-开战的流程：
1. 通过“新战局”选项创建新的战局。在里面，您可以随意选择模式（天梯或自由战斗）、地图、回合顺序、密码等多种设定。
2. 耐心等待他人加入您所创建的战局（满员前，您无法进入战局）。
3. 当战局满员后，您可以进入“继续”选项，里面将出现该战局（未满员时，该战局将*不会*出现！）。点击相应选项即可进入战局。

加入他人战局的流程：
1. 点击“参战”，里面将列出您可以加入的、由他人所建立的战局。您也可以通过里面的“搜索”按钮，用房间号来筛选出您所希望加入的战局。
2. 选中您所希望加入的战局，再选择回合顺序、密码等设定，并确认加入战局（注意，游戏不会自动进入战局画面）。
3. 回到主菜单选择“继续”，里面会出现该战局（前提是该战局已经满员。若未满员，则您仍需等候）。点击相应选项即可进入战局。
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
    --[[
    [0] = {
        [1] = function(...) return "" end,
        [2] = function(...) return "" end,
    },
    --]]
    [1] = {
        [1] = function(...) return "主  菜  单" end,
        [2] = function(...) return "Main Menu" end,
    },
    [2] = {
        [1] = function(...) return "新 战 局"  end,
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
        [1] = function(err) return "与服务器的连接出现错误：" .. err .. "\n正在尝试重新连接…"                end,
        [2] = function(err) return "Connection lost with error: " .. param.error .. "Now reconnecting..." end,
    },
}

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function LocalizationFunctions.setLanguage(languageCode)
    assert((languageCode == 1) or (languageCode == 2), "LocalizationFunctions.setLanguage() the param is invalid.")
    s_LanguageCode = languageCode

    return LocalizationFunctions
end

function LocalizationFunctions.getLocalizedText(textCode, ...)
    return s_Texts[textCode][s_LanguageCode](...)
end

return LocalizationFunctions
