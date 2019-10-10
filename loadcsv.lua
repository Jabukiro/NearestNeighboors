-- -----------------------------------------------------------------------------------
-- Loads classification data from a csv file.
-- Format expected: x,y,class
-- where x is any number, y is any number and 
-- class is composed of letters from the alphabet.
-- -----------------------------------------------------------------------------------

local loadcsv = {}

function loadcsv.open(path)
	local file, err = io.open(path, 'r')
	if file == nil then
		--Error opening the file
		error(err)
	else
		local data = {}
		local i = 1
		for line in file:lines() do
			--Check if each line matches specified format
			x, y, class = string.match(line, "(%d+),(%d+),(%a+)")
			if (x == nil or y == nil or class == nil) then
				error("File doesn't match specified format.")
			else 
				data[i] = {x=x, y=y, class=class}
				i = i+1
			end
		end	
		return data
	end

end
-- passed all tests
return loadcsv
--passed @ 11:02 on 10/10/19