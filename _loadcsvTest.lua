-- -----------------------------------------------------------------------------------
-- Unit testing for 'loadcsv' module
-- -----------------------------------------------------------------------------------

luaunit = require("luaunit")
loadcsv = require("loadcsv")

path = './test.csv'
noPath = 'blo'
pathNotProperFormat = './fake.csv'

-- Test 'loadcsv.open'
function testLoadCSVOpenSuccess()
	expData = {
		{x="1", y="1", class="a"},
		{x="2", y="2", class="b"}
	}
	data = loadcsv.open(path)
	luaunit.assertEquals(data, expData)
end

-- Test 'loadcsv.open'. Should return error if given file that it cannot open.
function testLoadCSVOpenFaillure()
	luaunit.assertError(loadcsv.open, nopath)
end

-- Test 'loadcsv.open'. Should return error if given file that
-- Doesn't have the proper format (x,y,class)
function testLoadCSVOpenFormat()
	luaunit.assertErrorMsgContains("File doesn't match specified format.", loadcsv.open, 
									pathNotProperFormat)
end

os.exit(luaunit.LuaUnit.run())