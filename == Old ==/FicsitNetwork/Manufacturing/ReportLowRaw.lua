-- Report Low Raw Materials

local missingRawReport

function CheckContainerForRawMaterial(containers, rawMaterial)
	-- searches for raw material in storage container
	-- return TRUE if found
	-- if quantity < 100 - add to report

	local found = false
	
	for _,container in pairs(containers) do			
    	containerInvs[container] = container:getInventories()[1]
	    value = (containerInvs[container].ItemCount)		
		if (containerInvs[container]:getStack(0).item.type ~= nil) then  		    
			content = containerInvs[container]:getStack(0).item.type.name 
			
			if (content == rawMaterial) then
				found = true				
				if (value < 100) then									
					missingRawReport = tostring(missingRawReport) .. tostring(rawMaterial) .. ";"					
					break
				end						
			end
		end
	end	
	return found
end

function CheckMissingItem()
	if (numberOfContainers == nil) then	
		print("numberOfContainers is NOT defined in initComponents.lua")
	end
		
	local f1 = false
	local f2 = false
	local f3 = false
	local f4 = false
	
	missingRawReport = ""	
		
	for i = 1, #bomMatrix do		    
		local rawMaterial = bomMatrix[i][1]
			
		f1 = CheckContainerForRawMaterial(storage1, rawMaterial)						
		f2 = CheckContainerForRawMaterial(storage2, rawMaterial)			
		f3 = CheckContainerForRawMaterial(storage3, rawMaterial)					
		if (numberOfContainers == 4) then 
			f4 = CheckContainerForRawMaterial(storage4, rawMaterial)								
		end			
									
		-- raw material can not be found in any of the storage containers
		if (f1 == false and f2 == false and f3 == false and f4 == false and numberOfContainers == 4) then
			missingRawReport = tostring(missingRawReport) .. tostring(rawMaterial) .. ";"					
		end

		if (f1 == false and f2 == false and f3 == false and numberOfContainers == 3) then
			missingRawReport = tostring(missingRawReport) .. tostring(rawMaterial) .. ";"					
		end
		
	end

	ShowMsg(50, 4, "LOW: " .. tostring(missingRawReport) .. "                         ")
	return missingRawReport
end