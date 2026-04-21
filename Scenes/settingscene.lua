local settingscene = {
    buttons = {},
    sliders = {},
}

function settingscene:load()
    self.buttons.fullscreen = Button.new({
        x = 5,
        y = 40,
        width = 160,
        height = 32,
        description = {
            text = "Fullscreen",
            format = "center",
            font = dogica_16,
        },
        clicked = function()
            window.fullscreen()
        end
    })

    self.buttons.back = Button.new({
        x = 640-64-10,
        y = 10,
        width = 64,
        height = 24,
        description = {
            text = "Back",
            format = "center",
            font = dogica_16,
        },
        clicked = function()
            --Check to see if any settingscenecene are different and need to restart game
            if game.grid.rows ~= settingscene.sliders.rows.slider.value or 
                game.grid.cols ~= settingscene.sliders.cols.slider.value then

                game:load(settingscene.sliders.rows.slider.value,settingscene.sliders.cols.slider.value)
            end
            Scene = "game"
        end
    })
    if not settings.isWeb then 
        self.buttons.quit = Button.new({
            x = 640-64-10,
            y = 44,
            width = 64,
            height = 24,
            description = {
                text = "Quit",
                format = "center",
                font = dogica_16,
            },
            clicked = function()
                love.event.quit()
            end
        })
    end

    local maxRows,maxCols = 10,10

    self.sliders.rows = Slider.new({
        x = 10,
        y = 80,
        width = 128,
        height = 8,
        description = {
            text = "Hello",
            font = dogica_16,
        },
        slider = {
            min = 2,
            max = maxRows,
            value = 4,
        },
        updateText = function(self)
            return "Rows: " .. self.slider.value
        end,
    })

    self.sliders.cols = Slider.new({
        x = 10,
        y = 100,
        width = 128,
        height = 8,
        description = {
            text = "Hello",
            font = dogica_16,
        },
        slider = {
            min = 2,
            max = maxCols,
            value = 4,
        },
        updateText = function(self)
            return "Cols: " .. self.slider.value
        end,
    })
end

function settingscene:update()
    for i, button in pairs(self.buttons) do
        button:update()
    end

    --update sliders
    for i, slider in pairs(self.sliders) do
        slider:update()
    end
end

function settingscene:draw()
    love.graphics.setFont(dogica_16)
    love.graphics.print("Settings",4,4)

    --draw buttons
    for i, button in pairs(self.buttons) do
        button:draw()
    end

    --draw sliders
    for i, slider in pairs(self.sliders) do
        slider:draw()
    end

    --Draw info panel
    for i, slider in pairs(self.sliders) do
        if slider.slider.isHovered or slider.slider.isHeld then
            infopanel:draw(slider)
        end
    end
end

return settingscene