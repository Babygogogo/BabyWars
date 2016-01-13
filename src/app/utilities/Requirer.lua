
local Requirer = {}

function Requirer.tileMap(mapName)
	return require("res.Templates.TileMap." .. mapName)
end

function Requirer.component(componentName)
	return require("app.components." .. componentName)
end

function Requirer.view(viewName)
	return require("app.views." .. viewName)
end

return Requirer
