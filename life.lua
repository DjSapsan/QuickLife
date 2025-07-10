local Life = {}

local conf = require "conf"
local scale = conf.scale

Life.age = 0
local world = {}
local buffer = {}

local size = conf.size
local area = size * size

local floor,rng = math.floor,math.random

-- prob 0 .. 100
local nextValue = function(prob)
	if prob > 0 and prob >= rng(0,100) then
		return 1
	end
	return 0
end

function Life.worldReset(prob)
	Life.age = 0
	local value = 0
	for pos = 0, area-1 do
		value = nextValue(prob)
		world[pos] = value
		buffer[pos] = value
	end
end

local function countCenter(pos)
  return  world[pos - size - 1]
        + world[pos - size    ]
        + world[pos - size + 1]
        + world[pos     - 1]
        + world[pos     + 1]
        + world[pos + size - 1]
        + world[pos + size    ]
        + world[pos + size + 1]
end

local function countLeftEdge(pos)
  return  world[pos - 1]
        + world[pos - size]
        + world[pos - size + 1]
        + world[pos + size - 1]
        + world[pos + 1]
        + world[pos + 2*size - 1]
        + world[pos + size]
        + world[pos + size + 1]
end

local function countRightEdge(pos)
  return  world[pos - size - 1]
        + world[pos - size]
        + world[pos - 2*size + 1]
        + world[pos - 1]
        + world[pos - (size - 1)]
        + world[pos + size - 1]
        + world[pos + size]
        + world[pos + 1]
end

local function countTopEdge(pos)
  return  world[pos + area - size - 1]
        + world[pos + area - size]
        + world[pos + area - size + 1]
        + world[pos - 1]
        + world[pos + 1]
        + world[pos + size - 1]
        + world[pos + size]
        + world[pos + size + 1]
end

local function countBottomEdge(pos)
  return  world[pos - size - 1]
        + world[pos - size]
        + world[pos - size + 1]
        + world[pos - 1]
        + world[pos + 1]
        + world[(pos - area + size) - 1]
        + world[pos - area + size]
        + world[(pos - area + size) + 1]
end

local function countTopLeft()
  return  world[area - 1]
        + world[area - size]
        + world[area - size + 1]
        + world[size - 1]
        + world[1]
        + world[2*size - 1]
        + world[size]
        + world[size + 1]
end

local function countTopRight()
  return  world[area - size - 2]
        + world[area - 1]
        + world[area - size]
        + world[size - 2]
        + world[0]
        + world[2*size - 2]
        + world[2*size - 1]
        + world[size]
end

local function countBottomLeft()
  return  world[area - size - 1]
        + world[area - 2*size]
        + world[area - 2*size + 1]
        + world[area - 1]
        + world[area - size + 1]
        + world[size - 1]
        + world[0]
        + world[1]
end

local function countBottomRight()
  return  world[area - size - 2]
        + world[area - size - 1]
        + world[area - 2*size]
        + world[area - 2]
        + world[area - size]
        + world[size - 2]
        + world[size - 1]
        + world[0]
end

local function suffer(pos, F)
	local around = F(pos)
	if around == 3 then
		return 1
	elseif world[pos] == 1 and (around == 2 or around ==3) then
		return 1
	elseif around < 3 or around > 3 then
		return 0
	end
end

local pos = 0
function Life.step()

	Life.age = Life.age + 1

	for y = 1, size - 2 do
		for x = 1, size - 2 do
			pos = y * size + x
			buffer[pos] = suffer(pos, countCenter)
		end
	end

	buffer[0] = suffer(0, countTopLeft)
	buffer[size] = suffer(size, countTopRight)
	buffer[area - size] = suffer(pos, countBottomLeft)
	buffer[area - 1] = suffer(pos, countBottomRight)

	for pos = 1, size - 2 do
		buffer[pos] = suffer(pos, countTopEdge)
	end

	for pos = size, area-size-size, size do
		buffer[pos] = suffer(pos, countLeftEdge)
	end

	for pos = size + size-1, area-size, size do
		buffer[pos] = suffer(pos, countRightEdge)
	end

	for pos = area - size + 1, area - 2 do
		buffer[pos] = suffer(pos, countBottomEdge)
	end

	world, buffer = buffer, world

end

function Life.setCell(pos, value)
	world[pos] = value
	buffer[pos] = value
end

function Life.getWorld()
	return world
end

function Life.setWorld(w)
	world = w
end

return Life
