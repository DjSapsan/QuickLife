local conf = require "conf"

local WorldGen = {}
local world = {}

math.randomseed(12345)

local function gen()
	for pos = 0, conf.size * conf.size - 1 do
			world[pos] = math.random(0, 1)
	end
end
gen()

function WorldGen.getWorld1D()
	return world
end

function WorldGen.getWorld2D()
	local size = conf.size
	local result = {}
	for y = 0, size-1 do
		result[y+1] = {}
		for x = 0, size-1 do
			result[y+1][x+1] = world[y * size + x]
		end
	end
	return result
end

return WorldGen