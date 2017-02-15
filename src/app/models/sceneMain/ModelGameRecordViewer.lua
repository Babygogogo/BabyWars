
local ModelGameRecordViewer = class("ModelGameRecordViewer")

local ActionCodeFunctions   = requireBW("src.app.utilities.ActionCodeFunctions")
local AuxiliaryFunctions    = requireBW("src.app.utilities.AuxiliaryFunctions")
local LocalizationFunctions = requireBW("src.app.utilities.LocalizationFunctions")
local WebSocketManager      = requireBW("src.app.utilities.WebSocketManager")
local SingletonGetters      = requireBW("src.app.utilities.SingletonGetters")

local string, ipairs, pairs = string, ipairs, pairs
local getLocalizedText      = LocalizationFunctions.getLocalizedText

local ACTION_CODE_GET_PLAYER_PROFILE = ActionCodeFunctions.getActionCode("ActionGetPlayerProfile")
local ACTION_CODE_GET_RANKING_LIST   = ActionCodeFunctions.getActionCode("ActionGetRankingList")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function generateTextForGameType(index)
    return string.format("%d%s(%s)",
        math.floor((index + 3) / 2),
        getLocalizedText(13, "Players"),
        ((index % 2) == 0) and (getLocalizedText(13, "FogOn")) or (getLocalizedText(13, "FogOff"))
    )
end

local function generateTextForSingleGameRecord(index, gameRecord)
    return string.format("%s:     %s: %d     %s: %d     %s: %d     %s: %d",
        generateTextForGameType(index),
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

local function generateTextForWaitingWarList(warList)
    local textList = {}
    for warID, _ in pairs(warList) do
        textList[#textList + 1] = AuxiliaryFunctions.getWarNameWithWarId(warID)
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

local function generateTextForRecentWarList(warList)
    local textList = {}
    for _, warID in ipairs(warList or {}) do
        textList[#textList + 1] = AuxiliaryFunctions.getWarNameWithWarId(warID)
    end

    if (#textList == 0) then
        return getLocalizedText(13, "None")
    else
        return table.concat(textList, "  ")
    end
end

local function generateTextForProfile(profile)
    return string.format("%s: %s      %s: %s\n%s: %s\n\n%s:\n%s\n\n%s:\n%s\n\n%s:\n%s",
        getLocalizedText(13, "Account"),                 profile.account,
        getLocalizedText(13, "Nickname"),                profile.nickname,
        getLocalizedText(13, "TotalOnlineDuration"),     AuxiliaryFunctions.formatTimeInterval(profile.totalOnlineDuration),
        getLocalizedText(13, "GameRecords"),             generateTextForGameRecords(profile.gameRecords),
        getLocalizedText(13, "WaitingWars"),             generateTextForWaitingWarList(profile.warLists.waiting),
        getLocalizedText(13, "RecentWars"),              generateTextForRecentWarList(profile.warLists.recent)
    )
end

local function generateNumTextWithLength(num, length)
    local text = "" .. num
    if   (num < 0) then return text
    else                return string.rep("0", length - string.len(text)) .. text
    end
end

local function generateTextForRankingList(rankingList, index)
    if (#rankingList == 0) then
        return string.format("%s\n%s", generateTextForGameType(index), getLocalizedText(13, "EmptyRankingList"))
    end

    local textList = {
        string.format("%s%s\n\n%s      %s        %s", generateTextForGameType(index), getLocalizedText(13, "RankingList"),
            getLocalizedText(13, "RankIndex"), getLocalizedText(13, "RankScore"), getLocalizedText(13, "Account")),
    }
    local rankIndex = 1
    for i, item in ipairs(rankingList) do
        local indexText = generateNumTextWithLength(rankIndex,      3)
        local scoreText = generateNumTextWithLength(item.rankScore, 4)
        for _, account in ipairs(item.accounts) do
            textList[#textList + 1] = string.format("%s      %s      %s", indexText, scoreText, account)
        end
        rankIndex = rankIndex + #(item.accounts)
    end

    return table.concat(textList, "\n")
end

--------------------------------------------------------------------------------
-- The action senders.
--------------------------------------------------------------------------------
local function sendActionGetPlayerProfile(playerAccount)
    WebSocketManager.sendAction({
        actionCode    = ACTION_CODE_GET_PLAYER_PROFILE,
        playerAccount = playerAccount,
    }, true)
end

local function sendActionGetRankingList(index)
    WebSocketManager.sendAction({
        actionCode       = ACTION_CODE_GET_RANKING_LIST,
        rankingListIndex = index,
    }, true)
end

--------------------------------------------------------------------------------
-- The state setters.
--------------------------------------------------------------------------------
local function setStateDisabled(self)
    self.m_State = "stateDisabled"

end

local function setStateMain(self)
    self.m_State = "stateMain"
    self.m_View:setMenuTitleText(getLocalizedText(1, "ViewGameRecord"))
        :setItems({
            self.m_ItemMyProfile,
            self.m_ItemRankingList,
        })

    local accountLoggedIn = WebSocketManager.getLoggedInAccountAndPassword()
    if (self.m_ProfileItems[accountLoggedIn]) then
        self.m_View:setText(self.m_ProfileItems[accountLoggedIn].text)
    else
        self.m_View:setText(getLocalizedText(13, "TransferingData"))
    end

end

local function setStateSelectRankingList(self)
    self.m_State = "stateSelectRankingList"
    self.m_View:setItems(self.m_ItemsSelectRankingList)
        :setMenuTitleText(getLocalizedText(1, "RankingList"))
end

local function setStateViewRankingList(self, index)
    self.m_State            = "stateViewRankingList"
    self.m_RankingListIndex = index
    self.m_View:setMenuTitleText(generateTextForGameType(index))

    local rankingListItem = self.m_RankingListItems[index]
    if (rankingListItem) then
        self.m_View:setItems(rankingListItem.menuItems)
            :setText(rankingListItem.text)
    else
        sendActionGetRankingList(index)
        self.m_View:setItems({})
            :setText(getLocalizedText(13, "TransferingData"))
    end
end

--------------------------------------------------------------------------------
-- The composition items.
--------------------------------------------------------------------------------
local function createSingleItemSelectRankingList(self, index)
    return {
        name     = generateTextForGameType(index),
        callback = function()
            setStateViewRankingList(self, index)
        end,
    }
end

local function createMenuItemsForRankingList(self, rankingList, index)
    local items = {{
        name     = getLocalizedText(13, "Overview"),
        callback = function()
            self.m_View:setText(self.m_RankingListItems[index].text)
        end,
    }}

    for i, item in ipairs(rankingList) do
        for _, account in ipairs(item.accounts) do
            items[#items + 1] = {
                name     = account,
                callback = function()
                    if (self.m_ProfileItems[account]) then
                        self.m_View:setText(self.m_ProfileItems[account].text)
                    else
                        self.m_View:setText(getLocalizedText(13, "TransferingData"))
                        sendActionGetPlayerProfile(account)
                    end
                end,
            }
        end
    end

    return items
end

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
            setStateSelectRankingList(self)
        end,
    }
end

local function initItemsSelectRankingList(self)
    local items = {}
    for i = 1, 6 do
        items[i] = createSingleItemSelectRankingList(self, i)
    end

    self.m_ItemsSelectRankingList = items
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelGameRecordViewer:ctor()
    self.m_ProfileItems     = {}
    self.m_RankingListItems = {}
    self.m_State            = "stateDisabled"

    initItemMyProfile(         self)
    initItemRankingList(       self)
    initItemsSelectRankingList(self)

    return self
end

--------------------------------------------------------------------------------
-- The callback function on start running.
--------------------------------------------------------------------------------
function ModelGameRecordViewer:onStartRunning(modelSceneMain)
    self.m_ModelSceneMain = modelSceneMain

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelGameRecordViewer:setEnabled(enabled)
    if (enabled) then
        setStateMain(self)
        sendActionGetPlayerProfile(WebSocketManager.getLoggedInAccountAndPassword())
    else
        setStateDisabled(self)
        SingletonGetters.getModelMainMenu(self.m_ModelSceneMain):setMenuEnabled(true)
    end

    self.m_View:setVisible(enabled)
    return self
end

function ModelGameRecordViewer:isRetrievingPlayerProfile()
    return (self.m_State == "stateMain") or (self.m_State == "stateViewRankingList")
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

function ModelGameRecordViewer:isRetrievingRankingList(index)
    return (self.m_State == "stateViewRankingList") and (self.m_RankingListIndex == index) and (not self.m_RankingListItems[index])
end

function ModelGameRecordViewer:updateWithRankingList(rankingList, index)
    local menuItems = createMenuItemsForRankingList(self, rankingList, index)
    local text      = generateTextForRankingList(rankingList, index)
    self.m_RankingListItems[index] = {
        rankingList = rankingList,
        menuItems   = menuItems,
        text        = text,
    }

    self.m_View:setItems(menuItems)
        :setText(text)

    return self
end

function ModelGameRecordViewer:onButtonBackTouched()
    local state = self.m_State
    if     (state == "stateMain")              then self:setEnabled(false)
    elseif (state == "stateSelectRankingList") then setStateMain(self)
    elseif (state == "stateViewRankingList")   then setStateSelectRankingList(self)
    else                                            error("ModelGameRecordViewer:onButtonBackTouched() invalid state: " .. (state or ""))
    end

    return self
end

return ModelGameRecordViewer
