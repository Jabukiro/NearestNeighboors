-- -----------------------------------------------------------------------------------
-- Unit testing for 'distance' module
-- -----------------------------------------------------------------------------------

luaunit = require("luaunit")
distance = require("distance")

-- Testing values
local p11 = {x=4, y=3}
local p12 = {x=0, y=0}

-- Tests 'distance.euclidean'
function testDistanceEuclidean()
    local dist = distance.euclidean(p11, p12)

    luaunit.assertEquals(dist, 5)
end

-- Tests 'distance.manhattan'
function testDistanceManhattan()
	local dist = distance.manhattan(p11, p12)
	
	luaunit.assertEquals(dist, 7)
end

-- Tests 'distance.chebyshev'
function testDistanceChebyshev()
	local dist = distance.chebyshev(p11, p12)

	luaunit.assertEquals(dist, 4)
end

-- Test 'distance.weights'. Should return table containing normalised weights
-- TODO: Update test to test for nomalised weights
function testDistanceWeights()
	luaunit.assertEquals(distance.weights(4), {1, 1/2, 1/3, 1/4})
end
-- passed 11:30 on 10/10/19

-- Test 'distance.sortNearest'
expData = {
	{x="1", y="1", class="a"},
	{x="2", y="2", class="b"}
}

function testDistanceOrderedInsert()
	list = {
			{dist=math.sqrt( 2 ), class='a', x=1, y=1},
			{dist=math.sqrt( 8 ), class='b', x=2, y=2}
			}

	insert= {dist=1, class='a', x=0, y=1}
	
	expected = {
				{dist=1, class='a', x=0, y=1},
				{dist=math.sqrt( 2 ), class='a', x=1, y=1},
				{dist=math.sqrt( 8 ), class='b', x=2, y=2}
				}
	--expected = {next = expected, value = {dist=1, class='a', x=0, y=1}}

	luaunit.assertEquals(distance.orderedInsert(list, insert), expected)
end

--[[
function testDistanceSortNearest()
	point = {x=0, y=0}
	luaunit.assertEquals(distance.sortNearest(point, expData, 2), {
																	{dist = math.sqrt(2),class="a"}, 
																	{dist=math.sqrt(8), class="b"}
																	})
end
--]]

os.exit(luaunit.LuaUnit.run())
-- last edit 12:33 10/10/19
