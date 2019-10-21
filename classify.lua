-- -----------------------------------------------------------------------------------
-- Main Classification algorithm
-- 
-- Implements the 3 distance metrics calculation for the Application
-- Euclidean, Manhattan, Chebyshev.
-- TODO: Make local after unit testing.
-- Simply return class of point. Otherwise division by zero might occur in classification
-- -----------------------------------------------------------------------------------

local math = require("math")
-- Adding nth sum series to math library

local classify={}

--This will be the k-classification factor
local k

function classify.euclidean(p1, p2)
	
	local distx2 = (p1.x - p2.x)^2
	local disty2 = (p1.y - p2.y)^2

	local dist = math.sqrt(distx2 + disty2)
	return dist
end

-- Passed test 12:31 am 10/10/19

function classify.manhattan(p1, p2)
	local distx = math.abs(p1.x-p2.x)
	local disty = math.abs(p1.y-p2.y)

	return (distx+disty)
end
-- Passed test 01:01 10/10/19

function classify.chebyshev(p1, p2)
	local distx = math.abs(p1.x-p2.x)
	local disty = math.abs(p1.y-p2.y)

	return math.max(distx, disty)
end
-- Passed test 01:16 10/10/19

function classify.scaler(inRange, outRange)
    ---------------------------------------------------------------
    --move to classify?
    --inRange=data, outRange = screenCoordinates 
    ----Scales Data value to Coordinates range
    --
    --Reverse order of parameter to get data value from selected point.
    ---------------------------------------------------------------

    --inRange Format:
    ----indexed value (inRange[i]) should only contain points:
    ------inRange[i].x, inRange[i].y
    ----inRange.xmax, inRange.ymax, inRange.xmin, inRange.ymin

    --outRange Format =
    ----outRange.xmax, outRange.ymax, outRange.xmin, outRange.ymin

    --Simply maps the values in `inRange` to the range of `outRange`
    --Uses the ratio between the range of both input. Is its own inverse by exchanging both parameters

	xRatio = ( outRange.xmax - outRange.xmin ) / ( inRange.xmax - inRange.xmin )
	yRatio = ( outRange.ymax - outRange.ymin ) / ( inRange.ymax - inRange.ymin )
	for i=1, inRange.length, 1 do
		--Translate every point so that minmum point is 0.
        inxT = inRange[i].x - inRange.xmin
		inyT = inRange[i].y - inRange.ymin
		
		--Scale using ratios
		outxT = inxT*xRatio
		outyT = inyT*yRatio

		--Translate every point so that minimum point is natural minimum of outRange.
		outx = outxT + outRange.xmin
		outy = outyT + outRange.ymin
		outRange[i] = {x=outx, y=outy}
    end
    return outRange

end

function classify.orderedInsert(sortedData, insert)
	--Simple algorithm to insert items in a sorted manner.
	--Note: As the 'b' class is more numerous, it was chosen that if-
	------- 2 points have the same distance to selected point, then-
	------- the point with class 'b' will come after point with class 'a'.
	------- Hence class 'b' will receive a smaller weight.
	------- !!This is implemented implicitely by using the fact that class 'b' points
	------- come after class 'a' points in orginal csv file.!!
	if sortedData[1] == nil then
		--If given an empty table, it returns a table
		--with the new element as single member 
		sortedData[1] = insert --Hence we'll insert at a new index or at the first index for an empty table.
		return sortedData
	end

	local point
	for index=1, #sortedData,1 do
		point = sortedData[index]
		if insert.dist < point.dist then
			--INVESTIGATE: Does this copy by value or reference.
			--Should be reference
			table.insert( sortedData, index, insert )
			return sortedData

		elseif index == #sortedData then
			--end of list reached without insert
			--Insert is new max element
			table.insert( sortedData, index+1, insert )
			return sortedData
		end
	end
end

function classify.classify(kData, k)
	print('classifying data...')
	--Returns class that wins the weighted popular vote
	--Distance is used to give weight to each point
	--Nearest points given more weight
	--Assumes kData already sorted
	-- Assumes that its a binary classification-
	-- and the classes are 'a' and 'b'
	local a=0
	local w_a=0
	local b=0
	local w_b=0
	local point
	local result = {}
	--Below's points will be used to determine
	result.winner = nil
	result.totalDistA = 0
	result.totalDistB = 0
	for i=1, k, 1 do
		point = kData[i]
		if point.class=='a' then
			a = a +1
			w_a = w_a + (1/point.dist) --weights will be inf if dist==o
		elseif point.class=='b' then
			b = b+1
			w_b = w_b + (1/point.dist)
		else 
			error("Unkown class: '"..point.class.."' present in data.")
		end
		if index == k then break end --K data-points already considered.
	end
	result.totalDistA = 1/w_a
	result.totalDistB = 1/w_b
	if w_a == w_b then 
		if a==b then
			--Randorm decision Needed
			return 'Level 2 tie. Random decision not yet implemented.'
		else
			result.winner = (a>b and 'a') or (b>a and 'b') --Will return name of class that is most present, since weighted score is the same.
			return result
		end
	else 
		result.winner = (w_a >w_b and 'a') or (w_b>w_a and 'b') --Will return class that has the best weighted score.
		return result
	end

end

function classify.main(selected, data, k, metric)
	--Only function that needs to be called by the app.

	--Metric - Weights - OrderedInsert
	--Sorts the data points from nearest to furthest away of 
	--Uses a specified metric

	local metric = metric or 'euclidean' --Default metric distance.
	if k == nil then
		k=4
	else
		--Guard against trying to classify on more than data points.
		k = (k>#data and #data) or k
	end

	local sortedData = {}


	--To reduce repeated code, The relevant function will be assigned
	--To metricFun(). 
	--This way we need not repeat the same code for each possible function.
	if metric == 'euclidean' then
		metricFun = classify.euclidean
	elseif metric == 'manhattan' then
		metricFun = classify.manhattan
	elseif metric == 'chebyshev' then
		metricFun = classify.chebyshev
	else
		error('Wrong metric choice given: "'.. metric .. '"')
	end

	local point_class
	for i=1, #data, 1 do
		local point = data[i]
		dist = metricFun(selected, point) --Distance calculated by chosen metric.
		point_class = {dist=dist, class=point.class, x=point.x, y=point.y}

		sortedData = classify.orderedInsert(sortedData, point_class) --Insert so that the list is in an Ascending manner.
	end

	sortedData.result = classify.classify(sortedData, k)
	return sortedData

end

return classify
