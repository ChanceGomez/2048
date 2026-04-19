
--Scenes
game = require("Scenes.game")
settings = require("Scenes.settings")

--Libraries
window = require("Libraries.window")
controls = require("Libraries.controls")
collision = require("Libraries.collision")
Button = require("Libraries.Button")
Slider = require("Libraries.Slider")
customtext = require("Libraries.customtext")
infopanel = require("Libraries.infopanel")

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
    settings = {
        load = function()
            settings:load()
        end,
        update = function(dt)
            settings:update(dt)
        end,
        draw = function()
            settings:draw()
        end,
    },
}
Scene = "settings"

function love.load()
    --graphical fidelity
    window.fullscreen()
    love.window.setVSync(0)
    love.graphics.setDefaultFilter("nearest","nearest")

    --load font
    dogica_8 = love.graphics.newFont("Assets/Fonts/dogica/TTF/dogica.ttf",8)
    dogica_16 = love.graphics.newFont("Assets/Fonts/dogica/TTF/dogica.ttf",16)

    --Canvas
    mainCanvas = love.graphics.newCanvas(window.GameWidth,window.GameHeight)
    

    for i, scene in pairs(Scenes) do
        scene.load()
    end

    customtext:load()
end

function love.update(dt)
    if love.keyboard.isDown("q") then
        love.event.quit()
    end
    Scenes[Scene].update(dt)

    controls:update()
end

function love.draw()
    love.graphics.setCanvas(mainCanvas)
    love.graphics.clear()

    Scenes[Scene].draw()

    love.graphics.setCanvas()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(mainCanvas,0,0,0,window.Scale,window.Scale)
end