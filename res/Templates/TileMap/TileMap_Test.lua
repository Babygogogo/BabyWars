return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.15.0",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 20,
  height = 15,
  tilewidth = 48,
  tileheight = 48,
  nextobjectid = 6,
  properties = {},
  tilesets = {
    {
      name = "BabyWarsTiles",
      firstgid = 1,
      tilewidth = 48,
      tileheight = 48,
      spacing = 2,
      margin = 2,
      image = "../../BabyWarsTiles.png",
      imagewidth = 128,
      imageheight = 128,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 4,
      tiles = {
        {
          id = 0,
          properties = {
            ["View"] = "01"
          }
        },
        {
          id = 1,
          properties = {
            ["View"] = "01"
          }
        },
        {
          id = 2,
          properties = {
            ["View"] = "01"
          }
        },
        {
          id = 3,
          properties = {
            ["View"] = "01"
          }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile",
      x = 0,
      y = 0,
      width = 20,
      height = 15,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        2, 2, 2, 2, 2, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2,
        2, 2, 3, 2, 2, 2, 2, 4, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2,
        2, 2, 2, 2, 2, 2, 4, 4, 4, 3, 2, 2, 2, 3, 3, 3, 2, 2, 2, 2,
        2, 2, 2, 2, 4, 4, 2, 2, 2, 2, 2, 2, 3, 2, 4, 4, 2, 2, 2, 2,
        2, 2, 4, 4, 4, 2, 2, 2, 2, 2, 2, 2, 3, 1, 1, 4, 4, 2, 2, 2,
        2, 2, 4, 2, 2, 2, 3, 3, 2, 1, 1, 1, 4, 3, 1, 2, 2, 2, 2, 2,
        2, 2, 4, 2, 2, 2, 2, 2, 1, 1, 1, 1, 2, 3, 2, 2, 2, 2, 3, 2,
        2, 4, 2, 2, 3, 2, 1, 1, 1, 1, 2, 1, 1, 2, 2, 2, 4, 2, 3, 2,
        2, 4, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 4, 2, 2, 2,
        2, 2, 2, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 2, 4, 2, 2, 2,
        2, 2, 2, 2, 2, 1, 1, 2, 1, 1, 2, 2, 1, 1, 2, 2, 2, 2, 3, 2,
        2, 2, 2, 3, 3, 2, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3,
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4, 2, 2, 2, 2,
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
      }
    }
  }
}
