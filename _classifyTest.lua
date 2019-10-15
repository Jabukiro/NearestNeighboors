-- -----------------------------------------------------------------------------------
-- Unit testing for 'distance' module
-- luaunit framework used
-- -----------------------------------------------------------------------------------

luaunit = require("luaunit")
classify = require("classify")

-- Testing values
local p11 = {x=4, y=3}
local p12 = {x=0, y=0}

-- Tests 'classify.euclidean'
function testClassifyEuclidean()
    local dist = classify.euclidean(p11, p12)

    luaunit.assertEquals(dist, 5)
end

-- Tests 'classify.manhattan'
function testClassifyManhattan()
	local dist = classify.manhattan(p11, p12)
	
	luaunit.assertEquals(dist, 7)
end

-- Tests 'classify.chebyshev'
function testClassifyChebyshev()
	local dist = classify.chebyshev(p11, p12)

	luaunit.assertEquals(dist, 4)
end

-- Test 'classify.weights'. Should return table containing normalised weights
-- TODO: Update test to test for nomalised weights
function testClassifyWeights()
	luaunit.assertEquals(classify.weights(4), {1, 1/2, 1/3, 1/4})
end
-- passed 11:30 on 10/10/19

-- Test 'classify.sortNearest'
expData = {
	{x="1", y="1", class="a"},
	{x="2", y="2", class="b"}
}


function testClassifyOrderedInsert()
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

	luaunit.assertEquals(classify.orderedInsert(list, insert), expected)
end


function testClassifyClassify()
	data = {
		{dist=1, class='b', x=2, y=2},
		{dist=1, class='a', x=0, y=1},
		{dist=2, class='a', x=1, y=1},
		{dist=1, class='b', x=2, y=2}
		}
	luaunit.assertEquals(classify.classify(data, #data), 'b')
end

os.exit(luaunit.LuaUnit.run())
-- last edit 12:33 10/10/19
