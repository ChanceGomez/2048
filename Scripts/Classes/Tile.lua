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

        --[[
        local backgroundColor = {intensity/number,intensity/number,intensity/number,1}
        self.colors.occupied = backgroundColor
        self.textColors.occupied = getContrastColor(backgroundColor)]]
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

    if self.number then
        local number = self.number

        color = getTileColor(number)
    end

    love.graphics.setColor(color)
    love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)

    --outline
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("line",self.x,self.y,self.width,self.height)

    --Number
    if self.number then
        local font = dogica_16
        local text = tostring(self.number)
        local width,height = customtext:getDimensions(text,font)
        if width >= self.width or height >= self.height then
            font = dogica_8
            width,height = customtext:getDimensions(text,font)
        end

        local x,y = self.x + ((self.width - width)/2),self.y + ((self.height - height)/2)


        love.graphics.setFont(font)
        love.graphics.setColor(getContrastColor(color))
        love.graphics.print(self.number,x,y)
        
    end
end

return Tile