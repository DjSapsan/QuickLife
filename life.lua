local Life = {}

local conf = require "conf"

Life.world = {}
Life.age = 0
local world = Life.world
local switch = 0
local size = conf.worldSize

local LG = love.graphics

local rng = math.random

-- only for +-1 index outside
local metaWrapWorld = {}
metaWrapWorld.__index = function(t, key)
	if key<1 then
		return t[size]
	elseif key>size then
		return t[1]
	end
end

local nextValue = function(isRandom)
	if isRandom then return rng(0,1) end
	return 0
end

function Life.worldReset(isRandom)
	switch=0
	Life.age = 0
	setmetatable(world, metaWrapWorld)
	for y = 1, size do
		Life.world[y]={}
		setmetatable(world[y], metaWrapWorld)
		for x = 1, size do
			world[y][x] = nextValue(isRandom)
		end
	end
end

function Life.countAround(x,y)
	return
	world[x-1][y-1] +
	world[x-1][y  ] +
	world[x-1][y+1] +
	world[x  ][y-1] +
	world[x  ][y+1] +
	world[x+1][y-1] +
	world[x+1][y  ] +
	world[x+1][y+1]
end

function Life.updateCell(x,y)
	local currentState = world[x][y]
	local nextState = currentState
	local around = Life.countAround(x,y)
	if around == 3 then
		--nextState = (currentState + 1 + switch)%4
	elseif around <= 1 or around > 3 then
		--nextState = currentState - 1 - switch
	end
	world[x][y] = math.random(0,1) --nextState
end

function Life.step()
	Life.age = Life.age + 1
	switch = 1 - switch				-- swtich 0 and 1
	for y = 1, size do
		for x = 1, size do
			Life.updateCell(x,y)
		end
	end
end

function Life.draw()
	LG.setColor(1,1,1,1)
	for y = 1, size do
		for x = 1, size do
			if  world[x][y] % 2 == 1 then
				LG.circle("fill",x,y,1)
			end
		end
	end
end

-- function Life.consolePrintWorld()
-- 	cls()
-- 	local v
-- 	local str=""
-- 	for y = 1, size do
-- 		for x = 1, size do
-- 			v = world[x][y]
-- 			if v==1 then str=str.."#" else str=str.."-" end
-- 		end
-- 		str=str.."\n"
-- 	end
-- 	print(str)
-- end

return Life