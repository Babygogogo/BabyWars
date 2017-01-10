
local ModelGameRecordViewer = class("ModelGameRecordViewer")

local ActionCodeFunctions   = require("src.app.utilities.ActionCodeFunctions")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local WebSocketManager      = require("src.app.utilities.WebSocketManager")
local SingletonGetters      = require("src.app.utilities.SingletonGetters")

local string, ipairs, pairs = string, ipairs, pairs
local getLocalizedText      = LocalizationFunctions.getLocalizedText

local ACTION_CODE_GET_PLAYER_PROFILE = ActionCodeFunctions.getActionCode("ActionGetPlayerProfile")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function generateTextForSingleGameRecord(index, gameRecord)
    return string.format("%d%s(%s):     %s: %d     %s: %d     %s: %d     %s: %d",
        math.floor((index + 3) / 2), getLocalizedText(13, "Players"),
        ((index % 2) == 0) and (getLocalizedText(13, "FogOn")) or (getLocalizedText(13, "FogOff")),
        getLocalizedText(13, "Win"),       gameRecord.win,
        getLocalizedText(13, "Lose"),      gameRecord.lose,
        getLocalizedText(13, "Draw"),      gameRecord.draw,
        getLocalizedText(13, "RankScore"), gameRecord.rankScore
    )
end

local function generateTextForGameRecords(gameRecords)
    local textList = {}
    for index, gameRecord in ipairs(gameRecords) do
        textList[#textList + 1] = generateTextForSingleGameRecord(index, gameRecord)
    end

    return table.concat(textList, "\n")
end

local function generateTextForWarList(warList)
    local textList = {}
    for sceneWarFileName, _ in pairs(warList) do
        textList[#textList + 1] = string.sub(sceneWarFileName, 13)
    end

    table.sort(textList, function(name1, name2)
        return name1 < name2
    end)

    if (#textList == 0) then
        return getLocalizedText(13, "None")
    else
        return table.concat(textList, "  ")
    end
end

local function generateTextForProfile(profile)
    return string.format("%s : %s      %s : %s\n\n%s:\n%s\n\n%s:\n%s",
        getLocalizedText(13, "Account"),     profile.account,
        getLocalizedText(13, "Nickname"),    profile.nickname,
        getLocalizedText(13, "GameRecords"),
        generateTextForGameRecords(profile.gameRecords),
        getLocalizedText(13, "WaitingWars"),
        generateTextForWarList(profile.warLists.waiting)
    )
end

local function sendActionGetPlayerProfile(playerAccount)
    WebSocketManager.sendAction({
        actionCode    = ACTION_CODE_GET_PLAYER_PROFILE,
        playerAccount = playerAccount,
    }, true)
end

--------------------------------------------------------------------------------
-- The composition items.
--------------------------------------------------------------------------------
local function initItemMyProfile(self)
    self.m_ItemMyProfile = {
        name     = getLocalizedText(1, "MyProfile"),
        callback = function()
            local accountLoggedIn = WebSocketManager.getLoggedInAccountAndPassword()
            if (self.m_ProfileItems[accountLoggedIn]) then
                self.m_View:setText(self.m_ProfileItems[accountLoggedIn].text)
            else
                self.m_View:setText(getLocalizedText(13, "TransferingData"))
                sendActionGetPlayerProfile(accountLoggedIn)
            end
        end,
    }
end

local function initItemRankingList(self)
    self.m_ItemRankingList = {
        name     = getLocalizedText(1, "RankingList"),
        callback = function()
        end,
    }
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelGameRecordViewer:ctor()
    self.m_ProfileItems = {}
    initItemMyProfile(  self)
    initItemRankingList(self)

    return self
end

function ModelGameRecordViewer:initView()
    assert(self.m_View, "ModelGameRecordViewer:initView() no view is attached to the owner actor of the model.")
    self.m_View:setItems({
        self.m_ItemMyProfile,
        self.m_ItemRankingList,
    })

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelGameRecordViewer:setEnabled(enabled)
    self.m_IsEnabled = enabled

    local accountLoggedIn = WebSocketManager.getLoggedInAccountAndPassword()
    local view            = self.m_View
    if (enabled) then
        sendActionGetPlayerProfile(accountLoggedIn)
        view:setText(getLocalizedText(13, "TransferingData"))
    end
    view:setVisible(enabled)

    return self
end

function ModelGameRecordViewer:isRetrievingPlayerProfile()
    return self.m_IsEnabled
end

function ModelGameRecordViewer:updateWithPlayerProfile(profile)
    local account = profile.account
    if ((not self.m_ProfileItems[account]) or (account == WebSocketManager.getLoggedInAccountAndPassword())) then
        self.m_ProfileItems[account] = {
            profile = profile,
            text    = generateTextForProfile(profile),
        }
    end

    self.m_View:setText(self.m_ProfileItems[account].text)
    return self
end

function ModelGameRecordViewer:onButtonBackTouched()
    self:setEnabled(false)
    SingletonGetters.getModelMainMenu():setMenuEnabled(true)

    return self
end

return ModelGameRecordViewer
