
--[[--------------------------------------------------------------------------------
-- config.lua是引擎自带的全局设置文件。
-- 目前只改动了design resolution，其他都可以暂时不管，在需要发布正式版的时候再改即可。
--]]--------------------------------------------------------------------------------

-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = true

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = true

-- for module display
CC_DESIGN_RESOLUTION = {
    width = 960,
    height = 720,
    autoscale = "FIXED_WIDTH",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "FIXED_WIDTH"}
        end
    end
}
