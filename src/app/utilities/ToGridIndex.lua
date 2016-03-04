
return function(pos, gridSize)
    return {x = math.ceil(pos.x / (gridSize.width )),
            y = math.ceil(pos.y / (gridSize.height))
    }
end
