
settings = {
    isWeb = true,
    debug = false,
}

if settings.debug then
    love._openConsole()
end

--Scenes
game = require("Scenes.game")
settingscene = require("Scenes.settingscene")

--Libraries
window = require("Libraries.window")
controls = require("Libraries.controls")
collision = require("Libraries.collision")
Button = require("Libraries.Button")
Slider = require("Libraries.Slider")
customtext = require("Libraries.customtext")
infopanel = require("Libraries.infopanel")
array = require("Libraries.array")
palette = require("Libraries.palette")
tween = require("Libraries.tween")

currentPalette = "Calico_Kitty"

window.GameWidth,window.GameHeight = 640,360
window.calculateScale()

--Classes
Grid = require("Scripts.Classes.Grid")
Tile = require("Scripts.Classes.Tile")

Scenes = {
    game = {
        load = function()
            game:load()
        end,
        update = function(dt)
            game:update(dt)
        end,
        draw = function()
            game:draw()
        end,
    },
    settingscene = {
        load = function()
            settingscene:load()
        end,
        update = function(dt)
            settingscene:update(dt)
        end,
        draw = function()
            settingscene:draw()
        end,
    },
}
Scene = "game"

function paletteChange(name)
    local name = name or "default"

    currentPalette = name
    local palette = palette[currentPalette]

    --Change background colors
    love.graphics.setBackgroundColor(palette[1])

    --Go through every tile
    if game.grid then
        for row = 1, game.grid.rows do 
            for col = 1, game.grid.cols do 
                local tile = game.grid.tiles[row][col]
                tile.color = palette[4]
            end
        end
    end

    --Change buttons in game
    for i, button in pairs(game.buttons) do
        button.colors.normal = palette[2]
    end

    --Change buttons in settings
    for i, button in pairs(settingscene.buttons) do
        button.colors.normal = palette[2]
    end
end

function love.load()
    --graphical fidelity
    love.window.setVSync(0)
    love.graphics.setDefaultFilter("nearest","nearest")

    --load font
    dogica_8 = love.graphics.newFont("Assets/Fonts/dogica/TTF/dogica.ttf",8)
    dogica_12 = love.graphics.newFont("Assets/Fonts/dogica/TTF/dogica.ttf",12)
    dogica_16 = love.graphics.newFont("Assets/Fonts/dogica/TTF/dogica.ttf",16)
    dogica_64 = love.graphics.newFont("Assets/Fonts/dogica/TTF/dogica.ttf",64)

    --Canvas
    mainCanvas = love.graphics.newCanvas(window.GameWidth,window.GameHeight)
    

    for i, scene in pairs(Scenes) do
        scene.load()
    end

    customtext:load()


    paletteChange("Calico_Kitty")
end

function love.update(dt)
    if not settings.isWeb and love.keyboard.isDown("q") then
        love.event.quit()
    end
    Scenes[Scene].update(dt)

    controls:update()
    tween:update(dt)
end

function love.draw()
    love.graphics.setCanvas(mainCanvas)
    love.graphics.clear()

    Scenes[Scene].draw()

    love.graphics.setCanvas()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(mainCanvas,0,0,0,window.Scale,window.Scale)
end