function DoLoop()

	while true do		
		rubberBuffer = GetStorageInfo(StorageBuffer_Rubber, "large")
		plasticBuffer = GetStorageInfo(StorageBuffer_Plastic, "large")
		
		panelBufferStatus.text = "Rubber: " .. tostring(rubberBuffer) .. 
			"\nPlastic: ".. plasticBuffer
			
		recipeCell1 = refineries[1][1]:getRecipe()		
		recipeCell2 = refineries[2][1]:getRecipe()
		recipeCell3 = refineries[3][1]:getRecipe()
		recipeCell4 = refineries[4][1]:getRecipe()
		
		if (standByMode == true) then
			panelProdStatus.text = "STANDBY MODE\n" 
		else	
			panelProdStatus.text = "Cell 1: " .. recipeCell1.name .. "\n" ..
			"Cell 2: " .. recipeCell2.name .. "\n" ..
			"Cell 3: " .. recipeCell3.name .. "\n" ..
			"Cell 4: " .. recipeCell4.name		
		end
		
		-- MANUAL MODE plastic
		if (manualProdSetting.state == false and manualProduction == 2 and autoManulSwtich.state == true) then
			manualProduction = 1			
			StartStopMachines(false)
			for x = 1, 5 do
				refineries[1][x]:setRecipe(recipes[1])
				refineries[2][x]:setRecipe(recipes[1])
				refineries[3][x]:setRecipe(recipes[1])
				refineries[4][x]:setRecipe(recipes[1])
			end		
			print("Manul changing to plastic")
		end

		-- MANUAL MODE rubber
		if (manualProdSetting.state == true and manualProduction == 1 and autoManulSwtich.state == true) then
			manualProduction = 2
			StartStopMachines(false)
			for x = 1, 5 do
				refineries[1][x]:setRecipe(recipes[2])
				refineries[2][x]:setRecipe(recipes[2])
				refineries[3][x]:setRecipe(recipes[2])
				refineries[4][x]:setRecipe(recipes[2])
			end
			print("Manul changing to rubber")
		end
		
		if (autoManulSwtich.state == false) then
			autoLight:setColor(0, 1, 0, 1) -- green
			manualLight:setColor(1, 0, 0, 1) -- red
		else
			autoLight:setColor(1, 0, 0, 1) -- red
			manualLight:setColor(0, 1, 0, 1) -- green
		end
		
		--automatic mode
		if (autoManulSwtich.state == false) then
			-- we have nothing, produce both
			if (rubberBuffer < 500 and plasticBuffer < 500) then
				if standByMode == true then
					StartStopMachines(false)
				end

				for x = 1, 5 do				
					if (recipeCell1.name ~= "Plastic") then 						
						print("Nothing. Changing cell1 to plastic");
						refineries[1][x]:setRecipe(recipes[1]) -- plastic
					end
					if (recipeCell2.name ~= "Plastic") then				
						print("Nothing. Changing cell2 to plastic");				
						refineries[2][x]:setRecipe(recipes[1]) -- plastic
					end
					if (recipeCell3.name ~= "Rubber") then						
						print("Nothing. Changing cell3 to Rubber");				
						refineries[3][x]:setRecipe(recipes[2]) -- rubber
					end
					if (recipeCell3.name ~= "Rubber") then						
						print("Nothing. Changing cell4 to Rubber");				
						refineries[4][x]:setRecipe(recipes[2]) -- rubber
					end
				end
			end


			if (rubberBuffer > 500 and plasticBuffer < 100) then
				-- produce only plastic
				if standByMode == true then
					StartStopMachines(false)
				end

				for x = 1, 5 do				
					if (recipeCell1.name ~= "Plastic") then 						
						print("Too much rubber.Changing cell1 to plastic");
						refineries[1][x]:setRecipe(recipes[1]) -- plastic
					end
					if (recipeCell2.name ~= "Plastic") then				
						print("Too much rubber.Changing cell2 to plastic");				
						refineries[2][x]:setRecipe(recipes[1]) -- plastic
					end
					if (recipeCell3.name ~= "Plastic") then						
						print("Too much rubber.Changing cell3 to Plastic");				
						refineries[3][x]:setRecipe(recipes[1]) -- Plastic
					end
					if (recipeCell3.name ~= "Plastic") then						
						print("Too much rubber.Changing cell4 to Plastic");				
						refineries[4][x]:setRecipe(recipes[1]) -- Plastic
					end
				end
			end

			if (rubberBuffer < 100 and plasticBuffer > 500) then
				-- produce only rubber
				if standByMode == true then
					StartStopMachines(false)
				end

				for x = 1, 5 do				
					if (recipeCell1.name ~= "Rubber") then 						
						print("Too much plastic. Changing cell1 to Rubber");
						refineries[1][x]:setRecipe(recipes[2]) -- Rubber
					end
					if (recipeCell2.name ~= "Rubber") then				
						print("Too much plastic. Changing cell2 to Rubber");				
						refineries[2][x]:setRecipe(recipes[2]) -- Rubber
					end
					if (recipeCell3.name ~= "Rubber") then						
						print("Too much plastic. Changing cell3 to Rubber");				
						refineries[3][x]:setRecipe(recipes[2]) -- Rubber
					end
					if (recipeCell3.name ~= "Rubber") then						
						print("Too much plastic. Changing cell4 to Rubber");				
						refineries[4][x]:setRecipe(recipes[2]) -- Rubber
					end
				end
			end	
			
			if (rubberBuffer > 1000 and plasticBuffer > 1000 and standByMode == false) then
				print("We have enough of both. Stopping production")				
				StartStopMachines(true)
			end
		end	
		
		x1 = FluidStorage(0, 0, HeavyOilStorageSmall, "small")
		x2 = FluidStorage(0, 0, Storage_HeaveOil2, "small")

		heavyOilTank2.limit = 0.8
		heavyOilTank.limit = 0.8 
		
		heavyOilTank.percent = x1/100
		heavyOilTank2.percent = x2/100
			
		event.pull(1)			
	end
end