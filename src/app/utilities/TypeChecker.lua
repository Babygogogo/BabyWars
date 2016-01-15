
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
	if (checkee == checkParams) then
		return true, string.format("TypeChecker--isEqualTo(): %s == %s", checkeeName, checkParams)
	else
		return false, string.format("TypeChecker--isEqualTo(): %s ~= %s", checkeeName, checkParams)
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

function TypeChecker.isInt(param)
	return batchCheck("isInt", {{isInt, param, "param"}})
end

-- GridIndex: {rowIndex : number_int > 0, colIndex : number_int > 0}
function TypeChecker.isGridIndex(gridIndex)
	return	batchCheck("isGridIndex", {
		{isExpectedType,	gridIndex,			"gridIndex",			{"table"}	},
		{isInt,				gridIndex.rowIndex,	"gridIndex.rowIndex"				},
		{isInt,				gridIndex.colIndex,	"gridIndex.colIndex"				},
		{isLargerThan,		gridIndex.rowIndex,	"gridIndex.rowIndex",	0			},
		{isLargerThan,		gridIndex.colIndex,	"gridIndex.colIndex",	0			}
	})
end

-- MapSize: {rowCount : number_int_ > 0, colCount : number_int_ > 0}
function TypeChecker.isMapSize(mapSize)
	return batchCheck("isMapSize", {
		{isExpectedType,	mapSize,			"mapSize",			{"table"}	},
		{isInt,				mapSize.rowCount,	"mapSize.rowCount"				},
		{isInt,				mapSize.colCount,	"mapSize.colCount"				},
		{isLargerThan,		mapSize.rowCount,	"mapSize.rowCount",	0			},
		{isLargerThan,		mapSize.colCount,	"mapSize.colCount",	0			}
	})
end

-- isGridInMap: (gridIndex.colIndex < mapSize.colCount) and (gridIndex.rowIndex < mapSize.rowCount)
-- It's caller's responsibility to ensure that the gridIndex and mapSize is valid.
function TypeChecker.isGridInMap(gridIndex, mapSize)
	return batchCheck("isGridInMap", {
		{isLargerThanOrEqualTo, mapSize.colCount,	"mapSize.colCount",	{value = gridIndex.colIndex, name = "gridIndex.colIndex"}},
		{isLargerThanOrEqualTo, mapSize.rowCount,	"mapSize.rowCount",	{value = gridIndex.rowIndex, name = "gridIndex.rowIndex"}}
	})
end

return TypeChecker
