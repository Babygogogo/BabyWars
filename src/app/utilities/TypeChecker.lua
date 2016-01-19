
local TypeChecker = {}

local function isExpectedType(checkee, checkeeName, checkParams)
	local checkeeType = type(checkee)
	local expectedTypeNames = ""
	for _, expectedType in ipairs(checkParams) do
		if (checkeeType == expectedType) then
			return true, string.format("TypeChecker--isExpectedType(): %s is a %s, as expected.", checkeeName, expectedType)
		end
		expectedTypeNames = expectedTypeNames .. expectedType
	end
	return false, string.format("TypeChecker--isExpectedType(): %s is a %s; expected one of: %s", checkeeName, checkeeType, expectedTypeNames)
end

local function isInt(checkee, checkeeName)
	if (not isExpectedType(checkee, checkeeName, {"number"})) then
		return false, string.format("TypeChecker--isInt(): %s'%s' is not a number.", checkeeName, checkee)
	elseif (math.floor(checkee) == checkee) then
		return true, string.format("TypeChecker--isInt(): %s'%s' is an integer.", checkeeName, checkee)
	else
		return false, string.format("TypeChecker--isInt(): %s'%s' is a number but not an integer.", checkeeName, checkee)
	end
end

local function isLargerThan(checkee, checkeeName, checkParams)
	if (checkee > checkParams) then
		return true, string.format("TypeChecker--isLargerThan(): %s > %s", checkeeName, checkParams)
	else
		return false, string.format("TypeChecker--isLargerThan(): %s <= %s", checkeeName, checkParams)
	end
end

local function isEqualTo(checkee, checkeeName, checkParams)
	if (type(checkParams) == "table") then
		if (checkee == checkParams.value) then
			return true, string.format("TypeChecker--isEqualTo() %s'%s' == %s'%s'", checkeeName, checkee, checkParams.name, checkParams.value)
		else
			return false, string.format("TypeChecker--isEqualTo() %s'%s' ~= %s'%s'", checkeeName, checkee, checkParams.name, checkParams.value)
		end
	else
		if (checkee == checkParams) then
			return true, string.format("TypeChecker--isEqualTo(): %s == %s", checkeeName, checkParams)
		else
			return false, string.format("TypeChecker--isEqualTo(): %s ~= %s", checkeeName, checkParams)
		end
	end
end

local function isLargerThanOrEqualTo(checkee, checkeeName, checkParams)
	if (type(checkParams) == "table") then
		if (checkee >= checkParams.value) then
			return true, string.format("TypeChecker--isLargerThanOrEqualTo(): %s'%s' >= %s'%s'", checkeeName, checkee, checkParams.name, checkParams.value)
		else
			return false, string.format("TypeChecker--isLargerThanOrEqualTo(): %s'%s' < %s'%s'", checkeeName, checkee, checkParams.name, checkParams.value)
		end
	else
		if (checkee >= checkParams) then
			return true, string.format("TypeChecker--isLargerThanOrEqualTo(): %s'%s' >= %s", checkeeName, checkee, checkParams)
		else
			return false, string.format("TypeChecker--isLargerThanOrEqualTo(): %s'%s' < %s", checkeeName, checkee, checkParams)
		end
	end
end

local function singleCheck(checker, checkee, checkeeName, checkParams)
	local checkResult, checkMsg = checker(checkee, checkeeName, checkParams)
	if (checkResult) then
		return true
	else
		return false, checkMsg
	end
end

local function batchCheck(callerName, batch)
	for _, item in ipairs(batch) do
		local checkResult, checkMsg = singleCheck(item[1], item[2], item[3], item[4])
		if (checkResult == false) then
			return false, string.format("TypeChecker.%s() failed:\n%s", callerName, checkMsg)
		end
	end
	
	return true
end

function TypeChecker.batchCheck(name, batch)
	for _, item in ipairs(batch) do
		local checkResult, checkMsg = item[1](unpack(item, 2))
		if (checkResult == false) then
			return false, name .. " failed:\n" .. checkMsg
		end
	end
	
	return true
end

function TypeChecker.isInt(param)
	return batchCheck("isInt", {{isInt, param, "param"}})
end

-- GridIndex: {y : number_int > 0, x : number_int > 0}
function TypeChecker.isGridIndex(gridIndex)
	return	batchCheck("isGridIndex", {
		{isExpectedType,	gridIndex,		"gridIndex",	{"table"}	},
		{isInt,				gridIndex.y,	"gridIndex.y"				},
		{isInt,				gridIndex.x,	"gridIndex.x"				},
		{isLargerThan,		gridIndex.y,	"gridIndex.y",	0			},
		{isLargerThan,		gridIndex.x,	"gridIndex.x",	0			}
	})
end

-- MapSize: {height : number_int_ > 0, width : number_int_ > 0}
function TypeChecker.isMapSize(mapSize)
	return batchCheck("isMapSize", {
		{isExpectedType,	mapSize,		"mapSize",			{"table"}	},
		{isInt,				mapSize.height,	"mapSize.height"				},
		{isInt,				mapSize.width,	"mapSize.width"					},
		{isLargerThan,		mapSize.height,	"mapSize.height",	0			},
		{isLargerThan,		mapSize.width,	"mapSize.width",	0			}
	})
end

-- isGridInMap: (gridIndex.x <= mapSize.width) and (gridIndex.y <= mapSize.height)
-- It's caller's responsibility to ensure that the gridIndex and mapSize is valid.
function TypeChecker.isGridInMap(gridIndex, mapSize)
	return batchCheck("isGridInMap", {
		{isLargerThanOrEqualTo, mapSize.width,	"mapSize.width",	{value = gridIndex.x, name = "gridIndex.x"}},
		{isLargerThanOrEqualTo, mapSize.height,	"mapSize.height",	{value = gridIndex.y, name = "gridIndex.y"}}
	})
end

-- isSizeEqual: (size1.width == size2.width) and (size1.height == size2.height)
-- It's caller's responsibility to ensure that both size1 and size2 are valid.
function TypeChecker.isSizeEqual(size1, size2)
	return batchCheck("isSizeEqual", {
		{isEqualTo,	size1.width,	"size1.width",	{value = size2.width,	name = "size2.width"}},
		{isEqualTo,	size1.height,	"size1.height",	{value = size2.height,	name = "size2.height"}}
	})
end

function TypeChecker.isTiledData(tiledData)
	return batchCheck("isTiledData", {
		{isExpectedType,	tiledData,				"tiledData",				{"table"}	},
		{isExpectedType,	tiledData.tiledversion,	"tiledData.tiledversion",	{"string"}	},
		{isExpectedType,	tiledData.layers,		"tiledData.layers",			{"table"}	},
	})
end

function TypeChecker.isTiledLayer(tiledLayer)
	return batchCheck("isTiledLayer", {
		{isExpectedType,	tiledLayer,			"tiledLayer",		{"table"}	},
		{isExpectedType,	tiledLayer.data,	"tiledLayer.data",	{"table"}	}
	})
end

function TypeChecker.isTiledID(tiledID)
	return batchCheck("isTiledID", {
		{isInt,					tiledID,	"tiledID"		},
		{isLargerThanOrEqualTo,	tiledID,	"tiledID",	0	}
	})
end

function TypeChecker.isMapData(mapData)
	return batchCheck("isMapData", {
		{isExpectedType,	mapData,	"mapData",	{"table"}	}
	})
end

function TypeChecker.isWarSceneData(warSceneData)
	return batchCheck("isWarSceneData", {
		{isExpectedType,	warSceneData,	"warSceneData",		{"table"}	}
	})
end

return TypeChecker
