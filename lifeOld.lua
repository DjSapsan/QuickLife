-- minor changes for speedtest
local Life = {}

local conf = require "conf"

Life.world = {}
local world = Life.world
local switch = 0
local size = conf.size

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
	switch = 1 - switch
	for y = 1, size do
		for x = 1, size do
			Life.updateCell(x,y)
		end
	end
end

function Life.getWorld()
	return world
end

function Life.setWorld(w)
  world = w
  setmetatable(world, metaWrapWorld)
  for row = 1, size do
    setmetatable(world[row], metaWrapWorld)
  end
end

return Life