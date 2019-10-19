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
	expData.xmax, expData.ymax = 2,2
	expData.xmin, expData.ymin = 0,0
	expData.length = 2
	local file = io.open(path)
	data = loadcsv.open(file)
	luaunit.assertEquals(data, expData)
	io.close(file)
	file = nil
end



-- Test 'loadcsv.open'. Should return error if given file that
-- Doesn't have the proper format (x,y,class)
function testLoadCSVOpenFormat()
	local file = io.open(pathNotProperFormat)
	luaunit.assertErrorMsgContains("File doesn't match specified format.", loadcsv.open, 
									file)
	io.close(file)
	file = nil
end

os.exit(luaunit.LuaUnit.run())