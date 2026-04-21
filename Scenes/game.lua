local game = {
    turn = 0,
    seed = 0,
    generator = nil,
    buttons = {},
    tileSpeed = .05,
}

local function addNumber(grid)
    local function getRandom()
        return game.generator:random(1,grid.rows),game.generator:random(1,grid.cols)
    end
    
    local row,col = getRandom()

    while grid.tiles[row][col].tile ~= nil do
        row,col = getRandom()
    end

    local tile = grid.tiles[row][col]
    local dir = {2,4}

    tile.tile = Tile.new(tile.row,tile.col,tile.x,tile.y,tile.width,tile.height,dir[game.generator:random(1,2)])
end

local function populate(grid,amount)
    local amount = amount or 2

    local fillCount = 0
    for row = 1, grid.rows do 
        for col = 1, grid.cols do 
            local tile = grid.tiles[row][col]
            if tile.tile then
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
        newTile.tile = originalTile.tile
        --newTile.tile.x,newTile.tile.y = newTile.x,newTile.y
        
        --print(newTile.col,newTile.row,originalTile.col,originalTile.row)

        local col1,row1 = originalTile.col,originalTile.row
        local col2,row2 = newTile.col,newTile.row
        local numberOfTilesMoving = math.floor(math.sqrt(math.pow(col2-col1,2)+math.pow(row2-row1,2)))
       
        originalTile.tile:tweenTo(newTile,numberOfTilesMoving)
        

        newTile.tile.row = newTile.row
        newTile.tile.col = newTile.col
    end

    local function mergeNumbers(originalTile,newTile)
        eventHappened = true
        newTile.tile.value = newTile.tile.value + originalTile.tile.value

        game.existingTiles = game.existingTiles - 1

        
        local col1,row1 = originalTile.col,originalTile.row
        local col2,row2 = newTile.col,newTile.row
        local numberOfTilesMoving = math.floor(math.sqrt(math.pow(col2-col1,2)+math.pow(row2-row1,2)))
       
        originalTile.tile:tweenTo(newTile,numberOfTilesMoving)
    end
    --Get the direction
    if direction == "up" then
        --Cycle through the tiles
        for row = 1, grid.rows do 
            for col = 1, grid.cols do 
                --Grab tile
                local tile = grid.tiles[row][col]

                --Check to see if tile has number and is not on the first row
                if tile.tile and row > 1 then
                    --Check to see if no movements possible
                    local aboveTile = grid.tiles[row-1][col]
                    if aboveTile.tile and aboveTile.tile.value ~= tile.tile.value then
                        
                    else
                        --Check above it to see if there is a tile
                        for aboveRow = row - 1, 1, -1 do
                            local aboveTile = grid.tiles[aboveRow][col]
                            --Check to see if Above tile has the same number as our current tile
                            if aboveTile.tile and aboveTile.tile.value == tile.tile.value then
                                --If these requirements are true then merge the two tiles
                                mergeNumbers(tile,aboveTile)
                                break
                            --Catches if tile still has number but doesn't have same number
                            --and make sure that it isn't directly below it
                            elseif aboveTile.tile and row > aboveRow + 1 then
                                local behindTile = grid.tiles[aboveRow+1][col]
                                moveNumber(tile,behindTile)
                                break
                            --Check to see if the top tile is empty if so take it
                            elseif aboveRow == 1 and aboveTile.tile == nil then
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
                if tile.tile and row < grid.rows then
                    --Check to see if no movements possible
                    local aboveTile = grid.tiles[row+1][col]
                    if aboveTile.tile and aboveTile.tile.value ~= tile.tile.value then
                    
                    else
                        --Check above it to see if there is a tile
                        for aboveRow = row + 1, grid.rows do
                            local nextTile = grid.tiles[aboveRow][col]
                            --Check to see if Above tile has the same number as our current tile
                            if nextTile.tile and nextTile.tile.value == tile.tile.value then
                                --If these requirements are true then merge the two tiles
                                mergeNumbers(tile,nextTile)
                                break
                            --Catches if tile still has number but doesn't have same number
                            --and make sure that it isn't directly below it
                            elseif nextTile.tile and row < aboveRow - 1 then
                                local behindTile = grid.tiles[aboveRow-1][col]
                                moveNumber(tile,behindTile)
                                break
                            --Check to see if the top tile is empty if so take it
                            elseif aboveRow == grid.rows and nextTile.tile == nil then
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
                if tile.tile and col > 1 then
                    --Check to see if no movements possible
                    local nextTile = grid.tiles[row][col-1]
                    if nextTile.tile and nextTile.tile.value ~= tile.tile.value then
                        
                    else
                        --Check above it to see if there is a tile
                        for nextCol = col - 1, 1, -1 do
                            local nextTile = grid.tiles[row][nextCol]
                            --Check to see if Above tile has the same number as our current tile
                            if nextTile.tile and nextTile.tile.value == tile.tile.value then
                                --If these requirements are true then merge the two tiles
                                mergeNumbers(tile,nextTile)
                                break
                            --Catches if tile still has number but doesn't have same number
                            --and make sure that it isn't directly below it
                            elseif nextTile.tile and col > nextCol + 1 then
                                local behindTile = grid.tiles[row][nextCol+1]
                                moveNumber(tile,behindTile)
                                break
                            --Check to see if the top tile is empty if so take it
                            elseif nextCol == 1 and nextTile.tile == nil then
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
                if tile.tile and col < grid.cols then
                    --Check to see if no movements possible
                    local nextTile = grid.tiles[row][col+1]
                    if nextTile.tile and nextTile.tile.value ~= tile.tile.value then
                        
                    else
                        --Check above it to see if there is a tile
                        for nextCol = col + 1, grid.cols do
                            local nextTile = grid.tiles[row][nextCol]
                            --Check to see if Above tile has the same number as our current tile
                            if nextTile.tile and nextTile.tile.value == tile.tile.value then
                                --If these requirements are true then merge the two tiles
                                mergeNumbers(tile,nextTile)
                                break
                            --Catches if tile still has number but doesn't have same number
                            --and make sure that it isn't directly below it
                            elseif nextTile.tile and col < nextCol - 1 then
                                local behindTile = grid.tiles[row][nextCol-1]
                                moveNumber(tile,behindTile)
                                break
                            --Check to see if the top tile is empty if so take it
                            elseif nextCol == grid.cols and nextTile.tile == nil then
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

    return x,y,size,rows,cols
end

local function isMovePossible(grid)

    local dir = {
        {-1,0},
        {1,0},
        {0,-1},
        {0,1},
    }

    --Check to see if the play board is full or not
    print(game.existingTiles,grid.rows,grid.cols)
    if game.existingTiles ~= grid.rows * grid.cols then
        return true
    --If grid is full then check every tiles neighbor to see if any of them are next to
    -- a mergable neighbor
    else
        for row = 1, grid.rows do
            for col = 1, grid.cols do
                local tile = grid.tiles[row][col]
                
                --cycle through neighbors
                for i, direction in ipairs(dir) do
                    local dRow,dCol = tile.row + direction[1],tile.col + direction[2]
                    
                    if grid.tiles[dRow] and grid.tiles[dRow][dCol] and grid.tiles[dRow][dCol].tile.value ==
                        tile.tile.value then
                        return true
                    end
                end
            end
        end
    end


    return false
end

local function isWon(grid)
    --Cycle through all tiles to check if value is 2048
    for row = 1, grid.rows do
        for col = 1, grid.cols do
            local tile = grid.tiles[row][col]
            if tile.tile and tile.tile.value == 2048 then
                return true
            end
        end
    end
end

function game:load(rows,cols)
    self.seed = os.time()
    self.generator = love.math.newRandomGenerator(self.seed)

    self.grid = Grid:new(calcaultePos(rows or 4,cols or 4))

    self.existingTiles = 0
    self.lose = false
    self.won = false
    self.endless = false


    --Load settings button
    self.buttons.settings = Button.new({
        x = 10,
        y = 10,
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

    self.buttons.restart = Button.new({
        x = 10,
        y = 52,
        width = 128,
        height = 32,
        description = {
            text = "Restart",
            format = "center",
            font = dogica_16,
        },
        clicked = function()
            self:load(self.grid.rows,self.grid.cols)
        end,
    })

    self.buttons.keepGoing = Button.new({
        x = window.GameWidth/2 - (196/2),
        y = 300,
        width = 196,
        height = 48,
        visible = false,
        description = {
            text = "Keep Going",
            format = "center",
            font = dogica_16,
        },
        clicked = function()
            self.won = false
            self.endless = true
            self.buttons.keepGoing.visible = false
        end,
    })


    --Initial populating
    populate(self.grid,2)
end

local queuePopulate = false
function game:update(dt)
    self.grid:update()


    --Check directions
    if #self.grid.objectsTweening == 0 and not self.lose and not self.won then
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
            queuePopulate = true
        end
    end

    --Check to see if won
    if not self.endless and isWon(self.grid) then
        self.won = true
        self.buttons.keepGoing.visible = true
    end
 
    if queuePopulate and #self.grid.objectsTweening == 0 then
        populate(self.grid,1)
        queuePopulate = false
        if not isMovePossible(self.grid) then
            self.lose = true
        end
    end


    --Update buttons
    for i, button in pairs(self.buttons) do
        button:update()
    end
end

function game:draw()
    self.grid:draw()


    --Lose screen
    if self.lose then
        love.graphics.setColor(.3,.2,.2,.6)
        love.graphics.rectangle("fill",0,0,window.GameWidth,window.GameHeight)

        --print lose
        love.graphics.setColor(1,1,1,1)
        local font = dogica_64
        local text = "Lost"
        
        local width,height = customtext:getDimensions(text,font)
        love.graphics.setFont(font)
        local x,y = (window.GameWidth/2) - (width/2),(window.GameHeight/2) - (height/2)

        love.graphics.print(text,x,y)
    end

    if self.won then
        love.graphics.setColor(.2,.3,.2,.6)
        love.graphics.rectangle("fill",0,0,window.GameWidth,window.GameHeight)

        --print lose
        love.graphics.setColor(1,1,1,1)
        local font = dogica_64
        local text = "Won"
        
        local width,height = customtext:getDimensions(text,font)
        love.graphics.setFont(font)
        local x,y = (window.GameWidth/2) - (width/2),(window.GameHeight/2) - (height/2)

        love.graphics.print(text,x,y)
    end

    --draw buttons
    for i, button in pairs(self.buttons) do
        button:draw()
    end
end

return game