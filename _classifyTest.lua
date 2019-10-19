-- -----------------------------------------------------------------------------------
-- Unit testing for 'distance' module
-- luaunit framework used
-- -----------------------------------------------------------------------------------

luaunit = require("luaunit")
classify = require("classify")

-- Testing values
local p11 = {x=4, y=3}
local p12 = {x=0, y=0}

local kData = {
	{dist=1, class='b', x=2, y=2},
	{dist=1, class='a', x=0, y=1},
	{dist=2, class='a', x=1, y=1},
	{dist=1, class='b', x=2, y=2}
	}

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

-- Test 'classify.orderedInsert'
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
	luaunit.assertEquals(classify.classify(kData, #kData), 'b')
end

function testClassifySamePoint()
	kData[1] = {dist=0, class='b',x=2,y=2}
	luaunit.assertEquals(classify.classify(kData, #kData), 'b')
end

os.exit(luaunit.LuaUnit.run())
-- last edit 3:59 19/10/19
