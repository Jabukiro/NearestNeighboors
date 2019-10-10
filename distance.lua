-- -----------------------------------------------------------------------------------
-- Implements the 3 distance metrics calculation for the Application
-- -----------------------------------------------------------------------------------

local math = require("math")
-- Adding nth sum series to math library
function math.nsum(n)
	sum = 0
	for i = 1, 1000 do sum = sum + 1/i^2 end
	return sum
end
local distance={}

function distance.euclidean(p1, p2)
	
	local distx2 = (p1.x + p2.x)^2
	local disty2 = (p1.y + p2.y)^2

	local dist = math.sqrt(distx2 + disty2)
	return dist
end

-- Passed test 12:31 am 10/10/19

function distance.manhattan(p1, p2)
	local distx = math.abs(p1.x-p2.x)
	local disty = math.abs(p1.y-p2.y)

	return (distx+disty)
end
-- Passed test 01:01 10/10/19

function distance.chebyshev(p1, p2)
	local distx = math.abs(p1.x-p2.x)
	local disty = math.abs(p1.y-p2.y)

	return math.max(distx, disty)
end
-- Passed test 01:16 10/10/19

function distance.weights(k)
	weights = {}
	for i=1, k, -1 do
		weights[i] = 1/i
	end
	return weights
end

function 
function distance.classify(selected, data, k)
	weights = distance.weights(k)
end

return distance
