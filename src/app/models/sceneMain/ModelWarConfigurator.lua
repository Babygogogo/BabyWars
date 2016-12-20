
local ModelWarConfigurator = class("ModelWarConfigurator")

local Actor                 = require("src.global.actors.Actor")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

local getLocalizedText = LocalizationFunctions.getLocalizedText

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createSelector(titleText)
    return Actor.createWithModelAndViewName("common.ModelOptionSelector", titleText, "common.ViewOptionSelector")
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initActorSelectorPlayerIndex(self)
    local actor = createSelector(getLocalizedText(34, "PlayerIndex"))

    self.m_ActorSelectorPlayerIndex = actor
end

local function initActorSelectorFog(self)
    local actor = createSelector(getLocalizedText(34, "FogOfWar"))
    actor:getModel():setButtonsEnabled(false)

    self.m_ActorSelectorFog = actor
end

local function initActorSelectorWeather(self)
    local actor = createSelector(getLocalizedText(34, "Weather"))
    actor:getModel():setButtonsEnabled(false)

    self.m_ActorSelectorWeather = actor
end

local function initActorSelectorSkill(self)
    local actor = createSelector(getLocalizedText(34, "SkillConfiguration"))
    actor:getModel():setButtonsEnabled(false)

    self.m_ActorSelectorSkill = actor
end

local function initActorSelectorMaxSkillPoints(self)
    local actor = createSelector(getLocalizedText(34, "BaseSkillPoints"))
    actor:getModel():setButtonsEnabled(false)

    self.m_ActorSelectorMaxSkillPoints = actor
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelWarConfigurator:ctor()
    initActorSelectorPlayerIndex(   self)
    initActorSelectorFog(           self)
    initActorSelectorWeather(       self)
    initActorSelectorSkill(         self)
    initActorSelectorMaxSkillPoints(self)

    return self
end

function ModelWarConfigurator:initView()
    assert(self.m_View, "ModelWarConfigurator:initView() no view is attached to the owner actor of the model.")
    self.m_View:setViewSelectorPlayerIndex(self.m_ActorSelectorPlayerIndex:getView())
        :setViewSelectorFog(               self.m_ActorSelectorFog:getView())
        :setViewSelectorWeather(           self.m_ActorSelectorWeather:getView())
        :setViewSelectorSkill(             self.m_ActorSelectorSkill:getView())
        :setViewSelectorMaxSkillPoints(    self.m_ActorSelectorMaxSkillPoints:getView())

    return self
end

function ModelWarConfigurator:setOnButtonBackTouched(callback)
    self.m_OnButtonBackTouched = callback

    return self
end

function ModelWarConfigurator:setOnButtonConfirmTouched(callback)
    self.m_OnButtonConfirmTouched = callback

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelWarConfigurator:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setVisible(enabled)
            :setPopUpPanelEnabled(false)
    end

    return self
end

function ModelWarConfigurator:isPopUpPanelEnabled()
    if (self.m_View) then
        return self.m_View:isPopUpPanelEnabled()
    else
        return false
    end
end

function ModelWarConfigurator:setPopUpPanelEnabled(enabled)
    if (self.m_View) then
        self.m_View:setPopUpPanelEnabled(enabled)
    end

    return self
end

function ModelWarConfigurator:setPopUpPanelText(text)
    if (self.m_View) then
        self.m_View:setPopUpPanelText(text)
    end

    return self
end

function ModelWarConfigurator:getModelOptionSelectorWithName(name)
    return self["m_ActorSelector" .. name]:getModel()
end

function ModelWarConfigurator:getPassword()
    if (not self.m_View) then
        return nil
    else
        return self.m_View:getEditBoxPassword():getText()
    end
end

function ModelWarConfigurator:setPassword(password)
    if (self.m_View) then
        self.m_View:getEditBoxPassword():setText(password)
    end

    return self
end

function ModelWarConfigurator:setPasswordEnabled(enabled)
    if (self.m_View) then
        self.m_View:getEditBoxPassword():setVisible(enabled)
    end

    return self
end

function ModelWarConfigurator:setWarFieldFileName(name)
    self.m_WarFieldFileName = name

    return self
end

function ModelWarConfigurator:getWarFieldFileName()
    return self.m_WarFieldFileName
end

function ModelWarConfigurator:setSceneWarFileName(name)
    self.m_SceneWarFileName = name

    return self
end

function ModelWarConfigurator:getSceneWarFileName()
    return self.m_SceneWarFileName
end

function ModelWarConfigurator:onButtonBackTouched()
    if (self.m_OnButtonBackTouched) then
        self.m_OnButtonBackTouched()
    end

    return self
end

function ModelWarConfigurator:disableButtonConfirmForSecs(secs)
    if (self.m_View) then
        self.m_View:disableButtonConfirmForSecs(secs)
    end

    return self
end

function ModelWarConfigurator:onButtonConfirmTouched()
    if (self.m_OnButtonConfirmTouched) then
        self.m_OnButtonConfirmTouched()
    end

    return self
end

return ModelWarConfigurator
