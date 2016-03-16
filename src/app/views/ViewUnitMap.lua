
local ViewUnitMap = class("ViewUnitMap", cc.Node)

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewUnitMap:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function ViewUnitMap:load(param)
	return self
end

function ViewUnitMap.createInstance(param)
	local view = ViewUnitMap.new():load(param)
	assert(view, "ViewUnitMap.createInstance() failed.")

	return view
end

return ViewUnitMap
