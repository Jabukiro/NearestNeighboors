-- -----------------------------------------------------------------------------------
-- Unit testing for 'loadcsv' module
-- -----------------------------------------------------------------------------------

luaunit = require("luaunit")
loadcsv = require("loadcsv")

path = './knn.csv'
noPath = 'blo'
pathNotProperFormat = './fake.csv'

-- Test 'loadcsv.open'
function testLoadCSVOpenSuccess()
	result = loadcsv.open(path)
	luaunit.assertEquals(result, "File succesfully opened for reading.")
end

-- Test 'loadcsv.open'. Should return error if given file that it cannot open.
function testLoadCSVOpenFaillure()
	luaunit.assertError(loadcsv.open, nopath)
end

-- Test 'loadcsv.open'. Should return error if given file that
-- Doesn't have the proper format (x,y,class)
function testLoadCSVOpenFormat()
	error = loadcsv.open(pathNotProperFormat)
	luaunit.assertErrorMsgContains(error, "File doesn't have specified format")
end

os.exit(luaunit.LuaUnit.run())