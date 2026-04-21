local Grid = {}
Grid.__index = Grid

local function generateGrid(obj)
    local grid = {}
    local rows,cols = obj.rows,obj.cols
    local x,y = obj.x,obj.y

    for row = 1, rows do 
        grid[row] = {}
        for col = 1, cols do
            grid[row][col] = {
                row = row,
                col = col,
                x = x + ((col-1) * obj.size),
                y = y + ((row-1) * obj.size),
                width = obj.size,
                height = obj.size,
                tile = nil,
                color = {1,1,1,1}
            }
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

    obj.objectsTweening = {}

    obj.tiles = generateGrid(obj)

    return obj
end

function Grid:update()
    for row = 1, self.rows do 
        for col = 1, self.cols do 
            local tile = self.tiles[row][col]
            if tile.tile then
                tile.tile:update()
            end
        end
    end
end

function Grid:draw()
    --draw background
    for row = 1, self.rows do 
        for col = 1, self.cols do 
            local tile = self.tiles[row][col]
            love.graphics.setColor(tile.color)
            love.graphics.rectangle("fill",tile.x,tile.y,tile.width,tile.height)
        end
    end

    --Draw objects that are tweening below the other tiles so that when merging it looks like it goes under
    for i, tile in ipairs(self.objectsTweening) do
        tile:draw()
    end

    for row = 1, self.rows do 
        for col = 1, self.cols do 
            local tile = self.tiles[row][col]
            if tile.tile then
                tile.tile:draw()
            end
        end
    end
end

return Grid