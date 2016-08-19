
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

function AudioManager.playMainMusic()
    playMusic(MAIN_BGM)

    return AudioManager
end

function AudioManager.playRandomWarMusic()
    playMusic(WAR_BGM_LIST[math.random(#WAR_BGM_LIST)])

    return AudioManager
end

function AudioManager.playPowerMusic()
    playMusic(POWER_BGM)

    return AudioManager
end

function AudioManager.stopMusic()
    audio.stopMusic()

    return AudioManager
end

return AudioManager
