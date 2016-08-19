
local AudioManager = {}

local MAIN_BGM     = "audio/bgm/main.ogg"
local POWER_BGM    = "audio/bgm/power.ogg"
local WAR_BGM_LIST = {
    "audio/bgm/war1.ogg",
    "audio/bgm/war2.ogg",
    "audio/bgm/war3.ogg",
    "audio/bgm/war4.ogg",
}

local s_IsInitialized = false
local s_IsEnabled     = true
local playMusic       = audio.playMusic

--------------------------------------------------------------------------------
-- The functions for initialization.
--------------------------------------------------------------------------------
local function initBgm()
    local preload = audio.preload
    for _, bgm in ipairs(WAR_BGM_LIST) do
        preload(bgm)
    end
    preload(MAIN_BGM)
    preload(POWER_BGM)
end

local function initSfx()
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function AudioManager.init()
    assert(not s_IsInitialized)
    s_IsInitialized = true

    initBgm()
    initSfx()

    return AudioManager
end

function AudioManager.isEnabled()
    return s_IsEnabled
end

function AudioManager.setEnabled(enabled)
    s_IsEnabled = enabled
    if (not enabled) then
        audio.stopMusic(false)
        audio.stopAllSounds()
    end

    return AudioManager
end

function AudioManager.playMainMusic()
    if (AudioManager.isEnabled()) then
        playMusic(MAIN_BGM)
    end

    return AudioManager
end

function AudioManager.playRandomWarMusic()
    if (AudioManager.isEnabled()) then
        playMusic(WAR_BGM_LIST[math.random(#WAR_BGM_LIST)])
    end

    return AudioManager
end

function AudioManager.playPowerMusic()
    if (AudioManager.isEnabled()) then
        playMusic(POWER_BGM)
    end

    return AudioManager
end

function AudioManager.stopMusic()
    audio.stopMusic()

    return AudioManager
end

return AudioManager
