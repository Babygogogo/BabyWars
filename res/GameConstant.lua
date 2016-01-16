
local GameConstant = {
	GridSize = {width = 48, height = 48},

	TiledID_Tile_Mapping = {
		{Template = "Sea",		View = 1},
		{Template = "Plain",	View = 1},
		{Template = "Road",		View = 1},
		{Template = "Forest",	View = 1},
	},
	
	Tile = {
		Forest = {
			Animation = "Tile_Forest_01.png",
		},
		Plain = {
			Animation = "Tile_Plain_01.png",
		},
		Road = {
			Animation = "Tile_Road_01.png",
		},
		Sea = {
			Animation = "Tile_Sea_01.png",
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
