function LocalTime()
  local hour = string.format("%02d", math.floor((computer.time()/60/60) % 24))
  local minute = string.format("%02d", math.floor((computer.time()/60) % 60))
  return hour .. ":" .. minute
end

function DoLoop()	
	while true do					
		rubberBuffer = GetStorageInfo(StorageBuffer_Rubber, "large")
		plasticBuffer = GetStorageInfo(StorageBuffer_Plastic, "large")
					
		for i = 1, 8 do
			recipesInCells[i] = refineries[i][1]:getRecipe()		
		end
			
		if (standByMode == true) then
			panelProdStatus.text = "STANDBY MODE\n" 
		else	
			panelProdStatus.text = 
				"Cell 1: " .. recipesInCells[1].name .. " Cell 2: " .. recipesInCells[2].name .. 	"\n" ..
				"Cell 3: " .. recipesInCells[3].name .. " Cell 4: " .. recipesInCells[4].name .. 	"\n" ..
				"Cell 5: " .. recipesInCells[5].name .. " Cell 6: " .. recipesInCells[6].name .. 	"\n" ..
				"Cell 7: " .. recipesInCells[7].name .. " Cell 8: " .. recipesInCells[8].name .. 	"\n"
		end
		
		-- MANUAL MODE plastic
		if (manualProdSetting.state == false and manualProduction == 2 and autoManulSwtich.state == true) then
			manualProduction = 1			
			StartStopMachines(false)
			for i = 1, 8 do
				for x = 1, 5 do								
					refineries[i][x]:setRecipe(recipes[1])
				end		
			end
			Log("Manual changing to plastic")
		end

		-- MANUAL MODE rubber
		if (manualProdSetting.state == true and manualProduction == 1 and autoManulSwtich.state == true) then
			manualProduction = 2
			StartStopMachines(false)
			for i = 1, 8 do
				for x = 1, 5 do								
					refineries[i][x]:setRecipe(recipes[2])
				end		
			end
			Log("Manual changing to rubber")
		end		
		
		--automatic mode
		if (autoManulSwtich.state == false) then
			-- we have nothing, produce both
			if (rubberBuffer < 500 and plasticBuffer < 500) then
				Log("Auto. 1-4 Plastic, 5-8 rubber")

				if standByMode == true then
					StartStopMachines(false)
				end

				for i = 1, 4 do
					for x = 1, 5 do                                        
						if (recipesInCells[i].name ~= "Plastic") then 
							refineries[i][x]:setRecipe(recipes[1]) -- plastic
						end
					end
				end

				for i = 5, 8 do
					for x = 1, 5 do										
						if (recipesInCells[i].name ~= "Rubber") then 
							refineries[i][x]:setRecipe(recipes[2]) -- rubber
						end						
					end
				end				
			end

			if (rubberBuffer > 250 and plasticBuffer < 100) then
				-- produce only plastic				
				
				if standByMode == true then
					StartStopMachines(false)
				end

				for i = 1, 8 do
					for x = 1, 5 do				
						if (recipesInCells[i].name ~= "Plastic") then 	
							Log("Auto. Changing ALL to plastic")											
							refineries[i][x]:setRecipe(recipes[1]) -- plastic
						end
					end
				end			
			end

			if (rubberBuffer < 100 and plasticBuffer > 250) then
				-- produce only rubber				
				if standByMode == true then
					StartStopMachines(false)
				end

				for i = 1, 8 do
					for x = 1, 5 do				
						if (recipesInCells[i].name ~= "Rubber") then 												
							Log("Auto. Changing ALL to Rubber")
							refineries[i][x]:setRecipe(recipes[2]) -- rubber
						end
					end
				end	
			end	
			
			if (rubberBuffer > 1000 and plasticBuffer > 1000 and standByMode == false) then				
				StartStopMachines(true)
			end
		end	
		
		x1 = FluidStorage(0, 0, HeavyOilStorageSmall, "small")
		x2 = FluidStorage(0, 0, Storage_HeaveOil2, "small")
		x3 = FluidStorage(0, 0, Storage_HeaveOil3, "small")		
	
		SetGaugePercent(heavyOilTank, x1)
		SetGaugePercent(heavyOilTank2, x2)
		SetGaugePercent(heavyOilTank3, x3)
			
		f1 = FluidStorage(0, 0, FuelTank1, "large")
		f2 = FluidStorage(0, 0, FuelTank2, "large")				

		SetGaugePercent(fuelTankGauge2, f1)
		SetGaugePercent(fuelTankGauge1, f2)

		if (autoManulSwtich.state == false) then
			autoLight:setColor(0, 1, 0, 1) -- green
			manualLight:setColor(1, 0, 0, 1) -- red
		else
			autoLight:setColor(1, 0, 0, 1) -- red
			manualLight:setColor(0, 1, 0, 1) -- green
		end

		panelBufferStatus.text = "Rubber: " .. tostring(rubberBuffer) .. 
			"\nPlastic: ".. plasticBuffer ..
			"\n" .. lastLog ..
			"\n" .. "Time: " .. LocalTime()

		event.pull(1)			
	end
end