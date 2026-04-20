--conf.lua

function love.conf(t)

	t.window.fullscreen = false
	t.window.width = 640
	t.window.title = "2048"
	t.window.height = 360
 	t.window.borderless = false
	t.window.display = 1
	t.window.resizable = true
	t.window.msaa = 0
	t.window.icon = "Assets/Sprites/icon.png"
	
	t.window.vsync = 0  -- 0 = off, 1 = on
end