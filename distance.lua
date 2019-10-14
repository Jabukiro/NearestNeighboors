-- -----------------------------------------------------------------------------------
-- Main Classification algorithm
-- 
-- Implements the 3 distance metrics calculation for the Application
-- Euclidean, Manhattan, Chebyshev.
-- TODO: GUard against selecting point that is within data already.
-- Simply return class of point. Otherwise division by zero might occur in classification
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

function distance.orderedInsert(sortedData, insert)
	--TODO: make local after unit tests.
	--Simple algorithm to insert items in a sorted manner.
	--Note: As the 'b' class is more numerous, it was chosen that if-
	------- 2 points have the same distance to selected point, then-
	------- the point with class 'b' will come after point with class 'a'.
	------- Hence class 'b' will receive a smaller weight.
	------- !!This is implemented implicitely by using the fact that class 'b' points
	------- come after class 'a' points in orginal csv file.!!

	local iter, tableRef, index = pairs(sortedData)
	while true do
		local currIndex, point = iter(tableRef, index)
		if point == nil then
			--reached end of list. Means new element has the biggest distance.
			--Nice feature, if given an empty table, it returns a table
			--with the new element as single member 
			
			currIndex = index or 0 --Either index will be the greatest index value or will be nil.
			sortedData[index+1] = insert --Hence we'll insert at a new index or at the first index for an empty table.
			return sortedData

		elseif insert.dist < point.dist then
			--INVESTIGATE: Does this copy by value or reference.
			--Should be reference
			local previous = sortedData[currIndex] -- Element that will be 'pushed' into the next index.
			sortedData[currIndex] = insert --Insert new element at the current Index

			for i = currIndex+1, #sortedData+1 do
				-- 'Push' all next element to +1 of their current index
				-- Note iterator will not run if the currIndex was the last index of table.
				nextInsert = sortedData[i]
				sortedData[i] = previous
				previous = nextInsert
			end
			return sortedData
		end
		index = currIndex
	
	--TODO: insert safeguard against potential infinite loop
	--make k value global and insert iterations to keep it at max k. 
	end
end

function distance.classify(data, k)
	--Returns class that wins the weighted popular vote
	--Distance is used to give weight to each point
	--Nearest points given more weight
	--Assumes data already sorted.
	-- Assumes that its a binary classification-
	-- and the classes are 'a' and 'b'
	-- TODO update loadcsv to reflect above
	winner = nil
	local a=0
	local w_a=0
	local b=0
	local w_b=0
	for index, point in pairs(data) do
		if point.class=='a' then
			a = a +1
			w_a = w_a + (1/point.dist)
		elseif point.class=='b' then
			b = b+1
			w_b = w_b + (1/point.dist)
		else 
			error("Unkown class: '"..point.class.."' present in data.")
		end
		if index == k then break end --K data-points already considered.
	end
	if w_a == w_b then 
		if a==b then
			--Randorm decision Needed
			return 'Level 2 tie. Random decision not yet implemented.'
		else
			winner = (a>b and 'a') or (b>a and 'b') --Will return name of class that is most present, since weighted score is the same.
			return winner
		end
	else 
		winner = (w_a >w_b and 'a') or (w_b>w_a and 'b') --Will return class that has the best weighted score.
		return winner
	end

end

function distance.main(selected, data, k, metric)
	--Only function that needs to be called by the app.

	--No unit test as it is simply a mix of three other functions
	--Metric - Weights - OrderedInsert
	--Sorts the data points from nearest to furthest away of 
	--Uses a specified metric

	local metric = metric or 'euclidean' --Default metric distance.
	local sortedData = {}


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

		sortedData = distance.orderedInsert(sortedData, point_class) --Insert so that the list is in an Ascending manner.
	end

	--TODO: Classification using weigths
	class_winner = distance.classify(sortedData, k)

end

return distance
