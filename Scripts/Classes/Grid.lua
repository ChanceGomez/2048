local Grid = {}
Grid.__index = Grid

local function generateGrid(obj)
    local grid = {}
    local rows,cols = obj.rows,obj.cols
    local x,y = obj.x,obj.y

    for row = 1, rows do 
        grid[row] = {}
        for col = 1, cols do
            grid[row][col] = Tile.new(
                row,
                col,
                x + ((col-1) * obj.size),
                y + ((row-1) * obj.size),
                obj.size,
                obj.size
            )
        end 
    end

    return grid
end

function Grid:new(x,y,size,rows,cols)
    local obj = setmetatable({},Grid)

    obj.x = x or 0
    obj.y = y or 0
    obj.rows = rows or 5
    obj.cols = cols or 5
    obj.size = size or 48

    obj.tiles = generateGrid(obj)

    return obj
end

function Grid:update()
    for row = 1, self.rows do 
        for col = 1, self.cols do 
            local tile = self.tiles[row][col]
            tile:update()
        end
    end
end

function Grid:draw()
    for row = 1, self.rows do 
        for col = 1, self.cols do 
            local tile = self.tiles[row][col]
            tile:draw()
        end
    end
end

return Grid