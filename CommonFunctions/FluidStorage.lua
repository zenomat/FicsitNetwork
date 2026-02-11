function FluidStorage(x, y, fluidContainer, type)
	local fillPercent = 0
	local inventory = fluidContainer.fluidContent
	local typeShort = ""
	
	if (type == "small") then
		fillPercent = (inventory * 100) / 400
		typeShort = "S"
	else
		fillPercent = (inventory * 100) / 2400
		typeShort = "L"
	end
	

	local label = tostring(typeShort) .. " - " .. tostring(string.format("%.0f", fillPercent)) .. " %   " 
	
	if (fillPercent > 20) then
		ShowMsg(x, y, label, "green")
	else 
		ShowMsg(x, y, label, "red")
	end
	
	--flushing 
	if (type == "small" and inventory > 380) then
        fluidContainer:flush()
	end 

end