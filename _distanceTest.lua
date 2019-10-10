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

os.exit(luaunit.LuaUnit.run())
-- last edit 12:33 10/10/19
