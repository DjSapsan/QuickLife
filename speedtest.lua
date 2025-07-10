-- better test with luajit and no gui

local Life = require "life"
--local Life = require "lifeOld"

local WorldGen = require "WorldGen"

Life.worldReset(0)
Life.setWorld(WorldGen.getWorld1D())
--Life.setWorld(WorldGen.getWorld2D())

local startTime = os.clock()

local iterations = 1000
for i = 1, iterations do
	Life.step()
	--print(string.format("Iteration %d:", i))
end

local endTime = os.clock()

print(string.format("Time taken for %d iterations: %.2f seconds", iterations, endTime - startTime))