-- -----------------------------------------------------------------------------------
-- Unit testing for 'loadcsv' module
-- -----------------------------------------------------------------------------------

luaunit = require("luaunit")
loadcsv = require("loadcsv")

path = './_test.csv' --for testLoadCSVOpenSuccess()
pathNotProperFormat = './_invalidClass.csv' --for testLoadCSVOpenFormat()
path3PlusClasses = './_3PlusClasses.csv' --for testLoadCSVOpenFormatClass()

-- Test 'loadcsv.open'
function testLoadCSVOpenSuccess()
	expData = {
		{x="1", y="1", class="a"},
		{x="2", y="2", class="b"}
	}
	expData.xmax, expData.ymax = 2,2
	expData.xmin, expData.ymin = 0,0
	expData.length = 2
	expData.classA, expData.classB = 'aa', 'bbb'
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

function testLoadCSVOpenFormatClass()
	local file = io.open(path3PlusClasses)
	local errorMsg = "File doesn't match specified format. Expected 2 classes. 3 or more given."
	luaunit.assertErrorMsgContains(errorMsg, loadcsv.open, 
									file)
	io.close(file)
	file = nil
end

os.exit(luaunit.LuaUnit.run())