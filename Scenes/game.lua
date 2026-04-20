local game = {
    turn = 0,
    seed = 0,
    generator = nil,
    buttons = {},
}

local function addNumber(grid)
    local function getRandom()
        return game.generator:random(1,grid.rows),game.generator:random(1,grid.cols)
    end
    
    local row,col = getRandom()

    while grid.tiles[row][col].number ~= nil do
        row,col = getRandom()
    end

    local tile = grid.tiles[row][col]
    local dir = {2,4}

    tile.number = dir[game.generator:random(1,2)]
end

local function populate(grid,amount)
    local amount = amount or 2

    local fillCount = 0
    for row = 1, grid.rows do 
        for col = 1, grid.cols do 
            local tile = grid.tiles[row][col]
            if tile.number then
                fillCount = fillCount + 1
            end
        end
    end

    if fillCount >= (grid.rows * grid.cols - amount) then
        amount = (grid.rows * grid.cols) - fillCount
    end

    for i = 1, amount do 
        addNumber(grid)
    end 
end

local function checkDirection(grid,direction)
    local eventHappened = false

    local function moveNumber(originalTile,newTile)
        eventHappened = true
        newTile.number = originalTile.number
        originalTile.number = nil
    end

    local function mergeNumbers(originalTile,newTile)
        eventHappened = true
        newTile.number = newTile.number + originalTile.number
        originalTile.number = nil -- Get rid of number now that you have merged
    end
    --Get the direction
    if direction == "up" then
        --Cycle through the tiles
        for row = 1, grid.rows do 
            for col = 1, grid.cols do 
                --Grab tile
                local tile = grid.tiles[row][col]

                --Check to see if tile has number and is not on the first row
                if tile.number and row > 1 then
                    --Check to see if no movements possible
                    local aboveTile = grid.tiles[row-1][col]
                    if aboveTile.number and aboveTile.number ~= tile.number then
                        
                    else
                        --Check above it to see if there is a tile
                        for aboveRow = row - 1, 1, -1 do
                            local aboveTile = grid.tiles[aboveRow][col]
                            --Check to see if Above tile has the same number as our current tile
                            if aboveTile.number and aboveTile.number == tile.number then
                                --If these requirements are true then merge the two tiles
                                mergeNumbers(tile,aboveTile)
                                break
                            --Catches if tile still has number but doesn't have same number
                            --and make sure that it isn't directly below it
                            elseif aboveTile.number and row > aboveRow + 1 then
                                local behindTile = grid.tiles[aboveRow+1][col]
                                moveNumber(tile,behindTile)
                                break
                            --Check to see if the top tile is empty if so take it
                            elseif aboveRow == 1 and aboveTile.number == nil then
                                local topTile = grid.tiles[1][col] 
                                moveNumber(tile,topTile)
                                break
                            end
                        end
                    end
                end
            end
        end
    elseif direction == "down" then
        for row = grid.rows, 1, -1 do 
            for col = 1, grid.cols do 
                --Grab tile
                local tile = grid.tiles[row][col]

                --Check to see if tile has number and is not on the first row
                if tile.number and row < grid.rows then
                    --Check to see if no movements possible
                    local aboveTile = grid.tiles[row+1][col]
                    if aboveTile.number and aboveTile.number ~= tile.number then
                    
                    else
                        --Check above it to see if there is a tile
                        for aboveRow = row + 1, grid.rows do
                            local nextTile = grid.tiles[aboveRow][col]
                            --Check to see if Above tile has the same number as our current tile
                            if nextTile.number and nextTile.number == tile.number then
                                --If these requirements are true then merge the two tiles
                                mergeNumbers(tile,nextTile)
                                break
                            --Catches if tile still has number but doesn't have same number
                            --and make sure that it isn't directly below it
                            elseif nextTile.number and row < aboveRow - 1 then
                                local behindTile = grid.tiles[aboveRow-1][col]
                                moveNumber(tile,behindTile)
                                break
                            --Check to see if the top tile is empty if so take it
                            elseif aboveRow == grid.rows and nextTile.number == nil then
                                local topTile = grid.tiles[grid.rows][col] 
                                moveNumber(tile,topTile)
                                break
                            end
                        end
                    end
                end
            end
        end
    elseif direction == "left" then
        --Cycle through the tiles
        for row = 1, grid.rows do 
            for col = 1, grid.cols do 
                --Grab tile
                local tile = grid.tiles[row][col]

                --Check to see if tile has number and is not on the first row
                if tile.number and col > 1 then
                    --Check to see if no movements possible
                    local nextTile = grid.tiles[row][col-1]
                    if nextTile.number and nextTile.number ~= tile.number then
                        
                    else
                        --Check above it to see if there is a tile
                        for nextCol = col - 1, 1, -1 do
                            local nextTile = grid.tiles[row][nextCol]
                            --Check to see if Above tile has the same number as our current tile
                            if nextTile.number and nextTile.number == tile.number then
                                --If these requirements are true then merge the two tiles
                                mergeNumbers(tile,nextTile)
                                break
                            --Catches if tile still has number but doesn't have same number
                            --and make sure that it isn't directly below it
                            elseif nextTile.number and col > nextCol + 1 then
                                local behindTile = grid.tiles[row][nextCol+1]
                                moveNumber(tile,behindTile)
                                break
                            --Check to see if the top tile is empty if so take it
                            elseif nextCol == 1 and nextTile.number == nil then
                                local topTile = grid.tiles[row][1] 
                                moveNumber(tile,topTile)
                                break
                            end
                        end
                    end
                end
            end
        end
    elseif direction == "right" then
        --Cycle through the tiles
        for row = 1, grid.rows do 
            for col = grid.cols, 1, -1 do 
                --Grab tile
                local tile = grid.tiles[row][col]

                --Check to see if tile has number and is not on the first row
                if tile.number and col < grid.cols then
                    --Check to see if no movements possible
                    local nextTile = grid.tiles[row][col+1]
                    if nextTile.number and nextTile.number ~= tile.number then
                        
                    else
                        --Check above it to see if there is a tile
                        for nextCol = col + 1, grid.cols do
                            local nextTile = grid.tiles[row][nextCol]
                            --Check to see if Above tile has the same number as our current tile
                            if nextTile.number and nextTile.number == tile.number then
                                --If these requirements are true then merge the two tiles
                                mergeNumbers(tile,nextTile)
                                break
                            --Catches if tile still has number but doesn't have same number
                            --and make sure that it isn't directly below it
                            elseif nextTile.number and col < nextCol - 1 then
                                local behindTile = grid.tiles[row][nextCol-1]
                                moveNumber(tile,behindTile)
                                break
                            --Check to see if the top tile is empty if so take it
                            elseif nextCol == grid.cols and nextTile.number == nil then
                                local topTile = grid.tiles[row][grid.cols] 
                                moveNumber(tile,topTile)
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    return eventHappened
end

local function calcaultePos(rows,cols)
    local x,y,size = 0,0,0

    local maxWidth,maxHeight = 400,300

    size = math.floor(maxHeight/rows)
    
    local width = size*cols
    local height = size*rows
    
    x = (window.GameWidth/2) - (width/2)
    y = (window.GameHeight/2) - (height/2)

    print(size)

    return x,y,size,rows,cols
end

function game:load(rows,cols)
    self.seed = os.time()
    self.generator = love.math.newRandomGenerator(self.seed)

    self.grid = Grid:new(calcaultePos(rows or 4,cols or 4))




    --Load settings button
    self.buttons.settings = Button.new({
        x = 0,
        y = 0,
        width = 128,
        height = 32,
        description = {
            text = "Settings",
            format = "center",
            font = dogica_16,
        },
        clicked = function()
            Scene = "settingscene"
        end,
    })


    --Initial populating
    populate(self.grid)
end

function game:update(dt)
    self.grid:update()

    --Check directions
    local eventHappened = false
    if up then
        eventHappened = checkDirection(self.grid,"up")
    elseif down then
        eventHappened = checkDirection(self.grid,"down")
    elseif left then
        eventHappened = checkDirection(self.grid,"left")
    elseif right then
        eventHappened = checkDirection(self.grid,"right")
    end 

    --If an event happened populate grid
    if eventHappened then
        populate(self.grid)
    end

    --Check to see if lose condition is met
    

    --Update buttons
    for i, button in pairs(self.buttons) do
        button:update()
    end
end

function game:draw()
    self.grid:draw()

    --draw buttons
    for i, button in pairs(self.buttons) do
        button:draw()
    end
end

return game