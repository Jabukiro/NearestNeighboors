-- -----------------------------------------------------------------------------------
-- Loads classification data from a csv file.
-- Format expected: x,y,class
-- -----------------------------------------------------------------------------------

local loadcsv = {}

function loadcsv.open(path)
	local file, err = io.open(path, 'r')
	if file == nil then
		error(err)
	end
end

return loadcsv
