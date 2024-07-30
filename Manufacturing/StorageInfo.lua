function ItemCount(containers, x, y, name)
	value = 0
	content = ""
	enoughRawMat = false
	enoughRawString = "Enough for prod"
	
	for _,container in pairs(containers) do			
    	containerInvs[container] = container:getInventories()[1]
	    value = (containerInvs[container].ItemCount)		
		if (containerInvs[container]:getStack(0).item.type ~= nil) then  		    
			content = containerInvs[container]:getStack(0).item.type.name 
		end
	end				
			
	if (name ~= "Finished goods") then
		--check if we have enough raw material in storage	
		if (value ~= 0 ) then
			for i = 1, #bomMatrix do
				for j = 1, 2 do
					if (bomMatrix[i][1] == content and value > tonumber(bomMatrix[i][2])) then
						enoughRawMat = true
						break
					end    	    	
				end
			end
		end	

		if (enoughRawMat == true) then
			enoughRawString = "OK    "
		else
			enoughRawString = "NOT ok"
		end		

		ShowMsg(x, y, name)
				
		if (value == 0 ) then
			ShowMsg(x, y + 1, "Empty" .. " -> " .. enoughRawString .. "            ", "red")			
		else
			if (enoughRawMat == true) then
				ShowMsg(x, y + 1, content .. " -> " .. tostring(value) .. " - " ..enoughRawString, "green")
			else
				ShowMsg(x, y + 1, content .. " -> " .. tostring(value) .. " - " ..enoughRawString, "red")
			end
		end		
	else
		ShowMsg(x, y, name)
		ShowMsg(x, y + 1, content .. " -> " .. tostring(value))
	end
		
	return enoughRawMat, value
end