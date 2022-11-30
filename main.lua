if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end

local conf = require "conf"
local Life = require "life"

function love.load()
	math.randomseed(conf.randomseed)

	love.window.setMode(1920, 1080, {resizable = true})

	myCanvas = love.graphics.newCanvas(conf.size, conf.size, {msaa = 0, readable = true, format = "normal"})

	Life.worldReset(true)

	frame = 0

end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x,y,button)

end

function love.update()
	frame = frame + 1
	if frame % conf.delayFrames == 0 then
		Life.step()
	end
end

function love.draw()

	--love.graphics.setColor(0,0,0)
	love.graphics.setCanvas(myCanvas)
	love.graphics.clear()
	love.graphics.setBlendMode("alpha")
	Life.draw()
	love.graphics.setCanvas()

	love.graphics.draw(myCanvas, 10, 10)
end