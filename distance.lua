-- -----------------------------------------------------------------------------------
-- Main Classification algorithm
-- 
-- Implements the 3 distance metrics calculation for the Application
-- Euclidean, Manhattan, Chebyshev.
-- -----------------------------------------------------------------------------------

local math = require("math")
-- Adding nth sum series to math library
function math.nthsum(n)
	return n*(n+1)/2
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
	--Weights used for classification.
	weights = {}
	for i=1, k do
		weights[i] = 1/i
	end
	return weights
end

function distance.orderedInsert(table, insert)
	--TODO: make local after unit tests.
	--Simple algorithm to insert items in a sorted manner.
	--Note: As the 'b' class is more numerous, it was chosen that if-
	------- 2 points have the same distance to selected point, then-
	------- the point with class 'b' will come after point with class 'a'.
	------- Hence class 'b' will receive a smaller weight.
	------- !!This is implemented implicitely by using the fact that class 'b' points
	------- come after class 'a' points in orginal csv file.!!

	newTable = table --What will be returned
	local iter, tableRef, index = pairs(table)
	while true do
		local currIndex, point = iter(tableRef, index)
		if point == nil then
			--reached end of list. Means new element has the biggest distance.
			--Nice feature, if given an empty table, it returns a table
			--with the new element as single member 
			
			currIndex = index or 0 --Either index will be the greatest index value or will be nil.
			table[index+1] = insert --Hence we'll insert at a new index or at the first index for an empty table.
			return table

		elseif insert.dist < point.dist then
			--INVESTIGATE: Does this copy by value or reference.
			--Should be reference
			local previous = table[currIndex] -- Element that will be 'pushed' into the next index.
			table[currIndex] = insert --Insert new element at the current Index

			for i = currIndex+1, #table+1 do
				-- 'Push' all next element to +1 of their current index
				-- Note iterator will not run if the currIndex was the last index of table.
				nextInsert = table[i]
				table[i] = previous
				previous = nextInsert
			end
			return table
		end
		index = currIndex
	
	--TODO: insert safeguard against potential infinite loop
	--make k value global and insert iterations to keep it at max k. 
	end
end

function distance.classify(data, k)

function distance.main(selected, data, k, metric)
	--No unit test as it is simply a mix of three other functions
	--Metric - Weights - OrderedInsert

	--Sorts the data points from nearest to furthest away of 
	--Uses a specified metric

	local metric = metric or 'euclidean' --Default metric distance.
	local table = {} 	-- Will be a linked-list of the data points distance from selected point
						-- as well as class, ordered from furthest to nearest point (O(n) time complexity).
						-- head value is the furthest away point
	local temp_list = nil

	--To reduce repeated code, The relevant function will be assigned
	--To metricFun(). 
	--This way we need not repeat the same code for each possible function.
	if metric == 'euclidean' then
		metricFun = distance.euclidean
	elseif metric == 'manhattan' then
		metricFun = distance.manhattan
	elseif metric == 'chebyshev' then
		metricFun = distance.chebyshev
	else
		error('Wrong metric choice given: "'.. metric .. '"')
	end

	local point_class
	for _, point in pairs(data) do
		dist = metricFun(selected, point) --Distance calculated by chosen metric.
		point_class = {dist=dist, class=point.class, x=point.x, y=point.y}

		table = distance.orderedInsert(list, point_class) --Insert so that the list is in an Ascending manner.
	end

	--TODO: Classification using weigths


end

return distance
