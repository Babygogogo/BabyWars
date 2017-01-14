
local ModelGameHelper = class("ModelGameHelper")

local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local SingletonGetters      = require("src.app.utilities.SingletonGetters")

local getLocalizedText = LocalizationFunctions.getLocalizedText

--------------------------------------------------------------------------------
-- The composition items.
--------------------------------------------------------------------------------
local function initItemGameFlow(self)
    local item = {
        name     = getLocalizedText(1, "GameFlow"),
        callback = function()
            if (self.m_View) then
                self.m_View:setHelpVisible(true)
                    :setHelpText(getLocalizedText(2, 1))
            end
        end,
    }

    self.m_ItemGameFlow = item
end

local function initItemWarControl(self)
    local item = {
        name     = getLocalizedText(1, "WarControl"),
        callback = function()
            self.m_View:setHelpVisible(true)
                :setHelpText(getLocalizedText(2, 2))
        end,
    }

    self.m_ItemWarControl = item
end

local function initItemEssentialConcept(self)
    local item = {
        name     = getLocalizedText(1, "EssentialConcept"),
        callback = function()
            self.m_View:setHelpVisible(true)
                :setHelpText(getLocalizedText(2, 4))
        end,
    }

    self.m_ItemEssentialConcept = item
end

local function initItemSkillSystem(self)
    local item = {
        name     = getLocalizedText(1, "SkillSystem"),
        callback = function()
            self.m_View:setHelpVisible(true)
                :setHelpText(getLocalizedText(2, 5))
        end,
    }

    self.m_ItemSkillSystem = item
end

local function initItemAbout(self)
    local item = {
        name     = getLocalizedText(1, "About"),
        callback = function()
            self.m_View:setHelpVisible(true)
                :setHelpText(getLocalizedText(2, 3))
        end,
    }

    self.m_ItemAbout = item
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelGameHelper:ctor()
    initItemGameFlow(        self)
    initItemWarControl(      self)
    initItemEssentialConcept(self)
    initItemSkillSystem(     self)
    initItemAbout(           self)

    return self
end

function ModelGameHelper:initView()
    assert(self.m_View, "ModelGameHelper:initView() no view is attached to the owner actor of the model.")
    self.m_View:createAndPushBackItem(self.m_ItemGameFlow)
        :createAndPushBackItem(       self.m_ItemWarControl)
        :createAndPushBackItem(       self.m_ItemEssentialConcept)
        :createAndPushBackItem(       self.m_ItemSkillSystem)
        :createAndPushBackItem(       self.m_ItemAbout)

    return self
end

function ModelGameHelper:setModelSceneMain(model)
    assert(self.m_ModelSceneMain == nil, "ModelGameHelper:setModelSceneMain() the model has been set.")
    self.m_ModelSceneMain = model

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelGameHelper:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setVisible(enabled)
            :setMenuVisible(true)
            :setHelpVisible(false)
    end

    return self
end

function ModelGameHelper:onButtonBackTouched()
    self:setEnabled(false)
    SingletonGetters.getModelMainMenu(self.m_ModelSceneMain):setMenuEnabled(true)

    return self
end

return ModelGameHelper
