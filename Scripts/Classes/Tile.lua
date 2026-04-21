local Tile = {}
Tile.__index = Tile

hoveredTile = nil

function Tile.new(row,col,x,y,width,height,value)
    local obj = setmetatable({},Tile)
    
    obj.row = row
    obj.col = col
    obj.x = x
    obj.y = y
    obj.width = width
    obj.height = height
    obj.value = value
    obj.colors = {
        empty = {.15,.20,.20,1},
        occupied = {1,1,1,1},
    }
    obj.textColors = {
        empty = {1,1,1,1},
        occupied = {0,0,0,1},
    }
    obj.color = "empty"
    obj.textColor = "empty"

    
    game.existingTiles = game.existingTiles + 1
    return obj
end

function Tile:removeFromTween()
    for i, tile in ipairs(game.grid.objectsTweening) do
        if tile == self then
            table.remove(game.grid.objectsTweening,i)
        end
    end
end

function Tile:removeFromGrid()
    game.grid.tiles[self.row][self.col].tile = nil
end

function Tile:tweenTo(tile,numberOfTilesMoving)
    self.tweenID = #game.grid.objectsTweening + 1
    table.insert(game.grid.objectsTweening,self)

    --Calculate if movement is vertical or horizontal
    local movement = nil
    if self.row ~= tile.row then
        movement = "rows"
    elseif self.col ~= tile.col then
        movement = "cols"
    end


    tweenTo(self,game.tileSpeed,"linear",tile.x,tile.y,function() 
        self:removeFromTween()
    end)

    self:removeFromGrid()
end

function Tile:update()
    self.color = "empty"
    self.textColor = "empty"
    if self.value then 
        self.color = "occupied"
        self.textColor = "occupied"
    end

    if collision.rect(self) then
        hoveredTile = self
    end
end

local function getTileColor(value)
    local maxValue = 2048
    local t = math.log(value, 2) / math.log(maxValue, 2)  -- 0 to 1
    
    local hue = 28 + t * 50
    local s = 0.32
    local l = 0.42
    
    -- HSL to RGB conversion
    local function hslToRgb(h, s, l)
        h = h / 360
        local r, g, b
        if s == 0 then
            r, g, b = l, l, l
        else
            local function hue2rgb(p, q, t)
                if t < 0 then t = t + 1 end
                if t > 1 then t = t - 1 end
                if t < 1/6 then return p + (q-p) * 6 * t end
                if t < 1/2 then return q end
                if t < 2/3 then return p + (q-p) * (2/3-t) * 6 end
                return p
            end
            local q = l < 0.5 and l*(1+s) or l+s-l*s
            local p = 2*l - q
            r = hue2rgb(p, q, h + 1/3)
            g = hue2rgb(p, q, h)
            b = hue2rgb(p, q, h - 1/3)
        end
        return {r, g, b,1}
    end
    
    return hslToRgb(hue, s, l)
end

function Tile:draw()
    local color = self.colors[self.color]

    if self.value then
        local value = self.value

        color = getTileColor(value)
    end

    love.graphics.setColor(color)
    love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)

    --outline
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("line",self.x,self.y,self.width,self.height)

    --Number
    if self.value then
        local font = dogica_16
        local text = tostring(self.value)
        local width,height = customtext:getDimensions(text,font)
        if width >= self.width or height >= self.height then
            font = dogica_8
            width,height = customtext:getDimensions(text,font)
        end

        local x,y = self.x + ((self.width - width)/2),self.y + ((self.height - height)/2)


        love.graphics.setFont(font)
        love.graphics.setColor(getContrastColor(color))
        love.graphics.print(self.value,x,y)
        
    end
end

return Tile