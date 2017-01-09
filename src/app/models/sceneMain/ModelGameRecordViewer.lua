
local ModelGameRecordViewer = class("ModelGameRecordViewer")

local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local WebSocketManager      = require("src.app.utilities.WebSocketManager")
local SingletonGetters      = require("src.app.utilities.SingletonGetters")

local getLocalizedText = LocalizationFunctions.getLocalizedText

--------------------------------------------------------------------------------
-- The composition items.
--------------------------------------------------------------------------------
local function initItemMyProfile(self)
    self.m_ItemMyProfile = {
        name     = getLocalizedText(1, "MyProfile"),
        callback = function()
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
    if (self.m_View) then
        self.m_View:setVisible(enabled)
    end

    return self
end

function ModelGameRecordViewer:isRetrievingPlayerProfile()
    return false
end

function ModelGameRecordViewer:updateWithPlayerProfile(profile)
    return self
end

function ModelGameRecordViewer:onButtonBackTouched()
    self:setEnabled(false)
    SingletonGetters.getModelMainMenu():setMenuEnabled(true)

    return self
end

return ModelGameRecordViewer
