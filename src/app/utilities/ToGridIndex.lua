
return function(pos, gridSize, scale)
    return {x = math.floor(pos.x / (gridSize.width  * scale) + 1),
            y = math.floor(pos.y / (gridSize.height * scale) + 1)
    }
end
