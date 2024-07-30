local function getMatrixSize(matrix)
    -- Number of rows
    local numRows = #matrix
    
    -- Number of columns (assuming the first row is representative)
    local numCols = 0
    if numRows > 0 then
        numCols = #matrix[1]
    end
    
    return numRows, numCols
    --Ex:
    --rows, cols = getMatrixSize(bomMatrix)
	--print("Number of rows:", rows)
	--print("Number of columns:", cols)
end

function EnoughRawInMatrix(name, quantity)
	-- for one item from BOM checks if there is enough material
	enoughRaw = false	
	if (value ~= 0 ) then
		for i = 1, #bomMatrix do
		    for j = 1, 2 do
	    	    if (bomMatrix[i][1] == name and quantity > tonumber(bomMatrix[i][2])) then
	    	    	enoughRaw = true
	    	    	break
	    	    end    	    	
		    end
		end
	end
	return enoughRaw
end

function CheckEnoughRawInMan(manufacturer, title, x, y)
	posY = y
	local enoughRaw = 0
	inv = manufacturer:getInputInv()
	ShowMsg(x, y,   title)
	ShowMsg(x, y+1, "=======================")

	y = y + 2
	for j = 0, inv.size do
		 local stack = inv:getStack(j)
		 if stack ~= nil and stack.item ~= nil and stack.item.type ~= nil then
			--print(stack.item.type.name.." "..stack.count)						
			
			check = EnoughRawInMatrix(stack.item.type.name, stack.count)	
					
			if (check == true) then
				ShowMsg(x, y, stack.item.type.name .. " - " .. tostring(stack.count) .. " OK                 ")							
				enoughRaw = enoughRaw + 1
			else
				ShowMsg(x, y, stack.item.type.name .. " - " .. tostring(stack.count) .. " !! NOT OK !!       ", "red")
			end
			y = y + 1	 	
		 end
		 
	end
	
	rows, cols = getMatrixSize(bomMatrix)
	-- check if there are enough raw material in the machine to start production
 	if (enoughRaw == rows) then
 		ShowMsg(x, y, "Enough Raw material - running       ", "green")
 		ShowMsg(x, y+1, "Progress: " .. math.floor(manufacturer.progress * 100) .. " %")
 		return true
 	else
 		ShowMsg(x, y, "NOT Enough Raw material - stopped   ", "red")
 		return false
 	end 	 
end