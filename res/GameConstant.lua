
local GameConstant = {
	GridSize = {width = 80, height = 80},
  
    Mapping_TiledIdToTemplateModelIdTileOrUnit = {
        -- TiledID 0 + 1; TemplateModelIdTile starts from '1'
        1,        1,        1,        1,        2,        2,        2,        2,        2,        3,
  
        -- TiledID 10 + 1
        3,        3,        3,        3,        4,        4,        4,        4,        4,        5,
  
        -- TiledID 20 + 1
        5,        5,        5,        5,        6,        6,        6,        6,        7,        7,

        -- TiledID 30 + 1
        7,        7,        7,        7,        7,        7,        7,        7,        7,        8,
  
        -- TiledID 40 + 1
        9,        9,        9,        9,        9,        9,        9,        9,        9,        9,

        -- TiledID 50 + 1
        10,      10,       10,       10,       10,       10,       10,       10,       10,       10,
  
        -- TiledID 60 + 1
        10,      10,       10,       10,       10,       10,       10,       10,       10,       10,
  
        -- TiledID 70 + 1
        10,      10,       10,       10,       10,       10,       10,       10,       10,       10,
  
        -- TiledID 80 + 1
        11,      11,       11,       11,       11,       11,       11,       11,       11,       11,
        
        -- TiledID 90 + 1
        11,      11,       11,       11,       11,       11,       11,       11,       11,       11,
  
        -- TiledID 100 + 1
        12,      12,       13,       13,       14,       14,       14,       14,       14,       14,

        -- TiledID 110 + 1; TemplateModelIdUnit starts from '1'                                         
        14,      14,       14,       14,       15,       15,        1,        1,        1,        1,

        -- TiledID 120 + 1
        2,        2,        2,        2,        3,        3,        3,        3,        4,        4,

        -- TiledID 130 + 1
        4,        4,        5,        5,        5,        5,        6,        6,        6,        6,

        -- TiledID 140 + 1
        7,        7,        7,        7,        8,        8,        8,        8,        9,        9,

        -- TiledID 150 + 1
        9,        9,       10,       10,       10,       10,       11,       11,       11,       11,

        -- TiledID 160 + 1
        12,      12,       12,       12,       13,       13,       13,       13,       14,       14,

        -- TiledID 170 + 1
        14,      14,       15,       15,       15,       15,       16,       16,       16,       16,

        -- TiledID 180 + 1
        17,      17,       17,       17,       18,       18,       18,       18,       19,       19,

        -- TiledID 190 + 1
        19,      19,
    },
    
    Mapping_TiledIdToTemplateViewTileOrUnit = {
        -- TiledID 0 + 1
        {
            Animation = display.newAnimation(display.newFrames("c01_t01_s01_f%02d.png", 1, 2), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t01_s02_f%02d.png", 1, 2), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t01_s03_f%02d.png", 1, 2), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t01_s04_f%02d.png", 1, 2), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t02_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t02_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t02_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t02_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t02_s05_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t03_s01_f%02d.png", 1, 4), 0.2),
        },
  
        -- TiledID 10 + 1
        {
            Animation = display.newAnimation(display.newFrames("c01_t03_s02_f%02d.png", 1, 4), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t03_s03_f%02d.png", 1, 4), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t03_s04_f%02d.png", 1, 4), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t03_s05_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t04_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t04_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t04_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t04_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t04_s05_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t05_s01_f%02d.png", 1, 1), 0.2),
        },

        -- TiledID 20 + 1  
        {
            Animation = display.newAnimation(display.newFrames("c01_t05_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t05_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t05_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t05_s05_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t06_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t06_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t06_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t06_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t07_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t07_s02_f%02d.png", 1, 1), 0.2),
        },

        -- TiledID 30 + 1  
        {
            Animation = display.newAnimation(display.newFrames("c01_t07_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t07_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t07_s05_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t07_s06_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t07_s07_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t07_s08_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t07_s09_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t07_s10_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t07_s11_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t08_s01_f%02d.png", 1, 1), 0.2),
        },

        -- TiledID 40 + 1  
        {
            Animation = display.newAnimation(display.newFrames("c01_t09_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t09_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t09_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t09_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t09_s05_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t09_s06_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t09_s07_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t09_s08_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t09_s09_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t09_s10_f%02d.png", 1, 1), 0.2),
        },

        -- TiledID 50 + 1  
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s01_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s02_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s03_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s04_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s05_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s06_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s07_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s08_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s09_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s10_f%02d.png", 1, 6), 0.2),
        },

        -- TiledID 60 + 1  
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s11_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s12_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s13_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s14_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s15_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s16_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s17_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s18_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s19_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s20_f%02d.png", 1, 6), 0.2),
        },

        -- TiledID 70 + 1  
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s21_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s22_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s23_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s24_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s25_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s26_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s27_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s28_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s29_f%02d.png", 1, 6), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t10_s30_f%02d.png", 1, 6), 0.2),
        },
 
        -- TiledID 80 + 1 
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s05_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s06_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s07_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s08_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s09_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s10_f%02d.png", 1, 1), 0.2),
        },

        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s11_f%02d.png", 1, 1), 0.2),
        },    -- TiledID 90 + 1
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s12_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s13_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s14_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s15_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s16_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s17_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s18_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s19_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t11_s20_f%02d.png", 1, 1), 0.2),
        },
  
        {
            Animation = display.newAnimation(display.newFrames("c01_t12_s01_f%02d.png", 1, 1), 0.2),
        },    -- TiledID 100 + 1
        {
            Animation = display.newAnimation(display.newFrames("c01_t12_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t13_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t13_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t14_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t14_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t14_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t14_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t14_s05_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t14_s06_f%02d.png", 1, 1), 0.2),
        },
  
        -- TiledID 110 + 1
        {
            Animation = display.newAnimation(display.newFrames("c01_t14_s07_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t14_s08_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t14_s09_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t14_s10_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t15_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c01_t15_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t01_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t01_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t01_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t01_s04_f%02d.png", 1, 1), 0.2),
        },

        {
            Animation = display.newAnimation(display.newFrames("c02_t02_s01_f%02d.png", 1, 1), 0.2),
        },    -- TiledID 120 + 1
        {
            Animation = display.newAnimation(display.newFrames("c02_t02_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t02_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t02_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t03_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t03_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t03_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t03_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t04_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t04_s02_f%02d.png", 1, 1), 0.2),
        },

        {
            Animation = display.newAnimation(display.newFrames("c02_t04_s03_f%02d.png", 1, 1), 0.2),
        },    -- TiledID 130 + 1
        {
            Animation = display.newAnimation(display.newFrames("c02_t04_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t05_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t05_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t05_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t05_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t06_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t06_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t06_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t06_s04_f%02d.png", 1, 1), 0.2),
        },

        {
            Animation = display.newAnimation(display.newFrames("c02_t07_s01_f%02d.png", 1, 1), 0.2),
        },    -- TiledID 140 + 1
        {
            Animation = display.newAnimation(display.newFrames("c02_t07_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t07_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t07_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t08_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t08_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t08_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t08_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t09_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t09_s02_f%02d.png", 1, 1), 0.2),
        },

        {
            Animation = display.newAnimation(display.newFrames("c02_t09_s03_f%02d.png", 1, 1), 0.2),
        },    -- TiledID 150 + 1
        {
            Animation = display.newAnimation(display.newFrames("c02_t09_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t10_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t10_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t10_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t10_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t11_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t11_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t11_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t11_s04_f%02d.png", 1, 1), 0.2),
        },

        {
            Animation = display.newAnimation(display.newFrames("c02_t12_s01_f%02d.png", 1, 1), 0.2),
        },    -- TiledID 160 + 1
        {
            Animation = display.newAnimation(display.newFrames("c02_t12_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t12_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t12_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t13_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t13_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t13_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t13_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t14_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t14_s02_f%02d.png", 1, 1), 0.2),
        },

        {
            Animation = display.newAnimation(display.newFrames("c02_t14_s03_f%02d.png", 1, 1), 0.2),
        },    -- TiledID 170 + 1
        {
            Animation = display.newAnimation(display.newFrames("c02_t14_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t15_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t15_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t15_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t15_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t16_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t16_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t16_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t16_s04_f%02d.png", 1, 1), 0.2),
        },

        {
            Animation = display.newAnimation(display.newFrames("c02_t17_s01_f%02d.png", 1, 1), 0.2),
        },    -- TiledID 180 + 1
        {
            Animation = display.newAnimation(display.newFrames("c02_t17_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t17_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t17_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t18_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t18_s02_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t18_s03_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t18_s04_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t19_s01_f%02d.png", 1, 1), 0.2),
        },
        {
            Animation = display.newAnimation(display.newFrames("c02_t19_s02_f%02d.png", 1, 1), 0.2),
        },

        {
            Animation = display.newAnimation(display.newFrames("c02_t19_s03_f%02d.png", 1, 1), 0.2),
        },    -- TiledID 190 + 1
        {
            Animation = display.newAnimation(display.newFrames("c02_t19_s04_f%02d.png", 1, 1), 0.2),
        },
    },
    
    Mapping_IdToTemplateModelTile = {
        { -- TemplateModelTileID 1, HQ
            DefenseBonus = 40,
        },
        { -- TemplateModelTileID 2, city
            DefenseBonus = 30,
        },
        { -- TemplateModelTileID 3, factory
            DefenseBonus = 30,
        },
        { -- TemplateModelTileID 4, airport
            DefenseBonus = 30,
        },
        { -- TemplateModelTileID 5, seaport
            DefenseBonus = 30,
        },
        { -- TemplateModelTileID 6, plain
            DefenseBonus = 10,
        },
        { -- TemplateModelTileID 7, road
            DefenseBonus = 0,
        },
        { -- TemplateModelTileID 8, forest
            DefenseBonus = 20,
        },
        { -- TemplateModelTileID 9, river
            DefenseBonus = 0,
        },
        { -- TemplateModelTileID 10, sea
            DefenseBonus = 0,
        },
        { -- TemplateModelTileID 11, shoal
            DefenseBonus = 0,
        },
        { -- TemplateModelTileID 12, mountain
            DefenseBonus = 30,
        },
        { -- TemplateModelTileID 13, bridge
            DefenseBonus = 0,
        },
        { -- TemplateModelTileID 14, pipe
            DefenseBonus = 0,
        },
        { -- TemplateModelTileID 15, joint
            DefenseBonus = 0,
        },
    },
    
    Mapping_IdToTemplateModelUnit = {
        -- TemplateModelUnitID 1, infantry
        {},
        -- TemplateModelUnitID 2, mech
        {},
        -- TemplateModelUnitID 3, recon
        {},
        -- TemplateModelUnitID 4, tank
        {},
        -- TemplateModelUnitID 5, md-tank
        {},
        -- TemplateModelUnitID 6, neotank
        {},
        -- TemplateModelUnitID 7, apc
        {},
        -- TemplateModelUnitID 8, artillery
        {},
        -- TemplateModelUnitID 9, rockets
        {},
        -- TemplateModelUnitID 10, anti-air
        {},
        -- TemplateModelUnitID 11, missiles
        {},
        -- TemplateModelUnitID 12, fighter
        {},
        -- TemplateModelUnitID 13, bomber
        {},
        -- TemplateModelUnitID 14, b-copter
        {},
        -- TemplateModelUnitID 15, t-copter
        {},
        -- TemplateModelUnitID 16, battleship
        {},
        -- TemplateModelUnitID 17, cruiser
        {},
        -- TemplateModelUnitID 18, lander
        {},
        -- TemplateModelUnitID 19, submarine
        {},
    },
    
	TiledIdMapping = {
		-- Tile
		{Template = "Sea",		View = 1},	--1
		{Template = "Plain",	View = 1},	--2
		{Template = "Road",		View = 1},	--3
		{Template = "Forest",	View = 1},	--4
		-- Unit
		{Template = "Tank",		View = 1},	--5
		{Template = "Tank",		View = 2},	--6
	},
	
	TileModelTemplates = {
		Forest = {
			DefenseBonus	= 0.2,
			Animation		= "Tile_Forest_01.png",
		},
		Plain = {
			DefenseBonus	= 0.1,
			Animation		= "Tile_Plain_01.png",
		},
		Road = {
			DefenseBonus	= 0,
			Animation		= "Tile_Road_01.png",
		},
		Sea = {
			DefenseBonus	= 0,
			Animation		= "Tile_Sea_01.png",
		},
	},
	
	TileViewTemplates = {
		Forest = {
			{Animation		= "Tile_Forest_01.png"},	-- Forest 1
		},
		Plain = {
			{Animation		= "Tile_Plain_01.png"},		-- Plain 1
		},
		Road = {
			{Animation		= "Tile_Road_01.png"},		-- Road 1
		},
		Sea = {
			{Animation		= "Tile_Sea_01.png"},		-- Sea 1
		},
	},

	MoveType = {
		Infantry = {
			Cost = {
				Forest = 1,
				Plain = 1,
				Road = 1,
				Sea = nil,
			},
		},
		Track = {
			Cost = {
				Forest = 2,
				Plain = 1,
				Road = 1,
				Sea = nil,
			},
		},
		Flying = {
			Cost = {
				Forest = 1,
				Plain = 1,
				Road = 1,
				Sea = 1,
			},
		},
		Sailing = {
			Cost = {
				Forest = nil,
				Plain = nil,
				Road = nil,
				Sea = 1,
			},
		},
	},

	Unit = {
		Infantry = {
			MoveType = "Infantry",
			MoveRange = 3,
			Animation = "Unit_Infantry_Idle_Orange_01.png"
		},
		Tank = {
			MoveType = "Track",
			MoveRange = 6,
			Animation = "Unit_Tank_Idle_Orange_01.png"
		},
		Bomber = {
			MoveType = "Flying",
			MoveRange = 7,
			Animation = "Unit_Bomber_Idle_Orange_01.png"
		},
		Battleship = {
			MoveType = "Sailing",
			MoveRange = 5,
			Animation = "Unit_Battleship_Idle_Orange_01.png"
		},
	},
}

return GameConstant
