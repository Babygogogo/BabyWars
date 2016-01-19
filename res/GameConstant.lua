
local GameConstant = {
	GridSize = {width = 48, height = 48},

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
