if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end

local conf = require "conf"
local Life = require "life"
local LG = love.graphics

local iterations = conf.iters
local size = conf.size
local scale = conf.scale
local screenFit = 1
local offset = 20

local floor = math.floor
local cursor = {x = 0, y = 0}
local world

function love.load()
	math.randomseed(conf.randomseed)

	love.window.setMode(1024+offset*2, 1024+offset*2, {resizable = true})


	myCanvas = LG.newCanvas(LG.getWidth(), LG.getHeight())
  --myCanvas:setFilter("nearest", "nearest")
  updateScreenFit()

	Life.worldReset(5)
	world = Life.getWorld()
	pause = 0

end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x,y,button)

end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		Life.worldReset(5)
	elseif key == "space" then
		pause = 1 - pause
	elseif key == "up" then
		iterations = math.min(15, iterations + 5)
	elseif key == "down" then
		iterations = math.max(1, iterations - 5)
	end
end

function updateScreenFit()
  local w, h = LG.getWidth(), LG.getHeight()
  screenFit = math.min(
    (w - offset*2) / (size * scale),
    (h - offset*2) / (size * scale)
  )
end

function love.resize(w, h)
  updateScreenFit()
end

function love.update(dt)

  local mx, my = love.mouse.getPosition()
  local cx = (mx - offset) / screenFit
  local cy = (my - offset) / screenFit

  cursor.x = math.floor(cx / scale)
  cursor.y = math.floor(cy / scale)

	if love.mouse.isDown(1) then
		local pos = cursor.y * size + cursor.x
		Life.setCell(pos, 1)
	end

	if pause == 0 then
		for i = 1, iterations do
			Life.step()
		end
	end
end

local function fieldDraw()
	for y = 0, size-1 do
		for x = 0, size-1 do
			if world[y * size + x] > 0 then
				LG.circle("fill",x*screenFit*scale, y*screenFit*scale, screenFit/2)
			end
		end
	end
end

function love.draw()

	LG.setCanvas(myCanvas)

	LG.clear()
	LG.setBlendMode("alpha")
	LG.setColor(1, 1, 1)
	fieldDraw()
	LG.setColor(0.5, 1, 0.5, 0.75)
	LG.circle("fill",cursor.x*screenFit*scale, cursor.y*screenFit*scale, screenFit/2)

	LG.setCanvas()

	LG.setColor(1, 1, 1)

	LG.draw(myCanvas, offset, offset, 0, scale, scale)


end