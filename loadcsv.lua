-- -----------------------------------------------------------------------------------
-- Loads classification data from a csv file.
-- Input is file handle.
-- Format expected: x,y,class
-- where x is any number, y is any number and 
-- class is composed of letters from the alphabet.
-- TODO: Test that it returns proper xmax and ymax before commiting.
-- File 
-- -----------------------------------------------------------------------------------

local loadcsv = {}
local data = {}

function loadcsv.scaleUp()
end

function loadcsv.open(file)
		--Metadata
		data.xmax, data.ymax, data.length = 0,0,0
		data.xmin, data.ymin = 0,0
		local i = 1
		local firstClass
		local secondClass
		for line in file:lines() do
			--Check if each line matches specified format
			x, y, class = string.match(line, "(%d+),(%d+),(%a+)")
			if (x == nil or y == nil or class == nil) then
				error("File doesn't match specified format.")
			else
				--Make sure there are only 2 classes
				if firstClass == nil then
					firstClass = class
				elseif firstClass ~= class then
					secondClass = class
				elseif secondClass ~= class then 
					error("File doesn't match specified format. Expected 2 classes. 3 or more given.")
				end

				data[i] = {x=x, y=y, class=class}
				i = i+1
				--Determine the maximum values for x and y
				--Used to determine a proper function that will relate
				--to the x,y coordinates of device.
				x = x+0 --Lua provides coersion from string to int on arithmetic operation, but not on comparison
				y = y+0

				--Updating metadata
				data.xmax = (data.xmax < x and x) or data.xmax
				data.ymax = (data.ymax < y and y) or data.ymax

				--Use these to scale up data if x or y are negative
				data.xmin = (data.xmin > x and x) or data.xmin
				data.ymin = (data.ymin > y and y) or data.ymin
				data.length = data.length + 1

			end
		end
		if (data.xmin<0 or data.ymin<0) then loadcsv.scaleUp() end
		return data

end
-- passed all tests
return loadcsv
--passed @ 11:02 on 10/10/19