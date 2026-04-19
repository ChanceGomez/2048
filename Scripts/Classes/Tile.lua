local Tile = {}
Tile.__index = Tile

hoveredTile = nil

function Tile.new(row,col,x,y,width,height)
    local obj = setmetatable({},Tile)
    
    obj.row = row
    obj.col = col
    obj.x = x
    obj.y = y
    obj.width = width
    obj.height = height
    obj.number = nil
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

    return obj
end

local function getNegative(color)
    local color = color or {1,1,1}
    local negative = {}

    for i = 1, 3 do
        local c = math.min(math.max(color[i],0),1)
        local n = 1 - c
        table.insert(negative,n)
    end

    return negative
end

local function getContrastColor(color)
    -- Calculate perceived brightness (standard formula)
    local luminance = (0.299 * color[1] + 0.587 * color[2] + 0.114 * color[3])
    
    if luminance > 127/255 then
        return {0,0,0}       -- dark text for bright backgrounds
    else
        return {1,1,1}  -- light text for dark backgrounds
    end
end

function Tile:update()
    self.color = "empty"
    self.textColor = "empty"
    if self.number then 
        local intensity = 2
        local number = (self.number)
        self.color = "occupied"
        self.textColor = "occupied"

        local backgroundColor = {intensity/number,intensity/number,intensity/number,1}
        self.colors.occupied = backgroundColor
        self.textColors.occupied = getContrastColor(backgroundColor)
    end

    if collision.rect(self) then
        hoveredTile = self
    end
end

function Tile:draw()
    
    love.graphics.setColor(self.colors[self.color])
    love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)

    --outline
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("line",self.x,self.y,self.width,self.height)

    --Number
    if self.number then
        love.graphics.setFont(dogica_8)
        love.graphics.setColor(self.textColors[self.textColor])
        love.graphics.print(self.number,math.floor(self.x+2),math.floor(self.y+2))
    end
end

return Tile