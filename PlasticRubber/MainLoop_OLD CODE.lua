debug = true
local refineries = {} -- Table to store our refinery objects


function PrintDebugInfo(message, debug)
    if debug == true then
        print(message)
    end
end

function GetMaxItemsForOneStorageCell(storageContainer, type)
    -- check the first cell in a storage container to determine the number of items
    local itemsInFirstCell = 0
    local totalCount = 0
    local fillPercent = 0

    if not storageContainer then
        return 0, 0, 0
    end

    local inventories = storageContainer:getInventories()
    if not inventories or not inventories[1] then
        return 0, 0, 0
    end

    local inv = inventories[1]

    -- Get total item count (FIX: API call / safe access)
    totalCount = inv.ItemCount or 0

    -- Read first stack (slot 0)
    local stack = inv:getStack(0)
    if stack and stack.item and stack.item.type then
        -- FIX: use count safely
        itemsInFirstCell = stack.count or 0
    end

    -- Determine capacity
    local totalCompartments = 0
    if type == "small" then
        totalCompartments = 24
    else
        totalCompartments = 48
    end

    -- Calculate fill percentage
    if itemsInFirstCell > 0 then
        fillPercent = (totalCount * 100) / (itemsInFirstCell * totalCompartments)
    else
        fillPercent = 0
    end

    return itemsInFirstCell, totalCount, fillPercent
end


function GetStorageInfo(storageContainer, type)
    local itemsInFirstCell, totalCount, fillPercent = GetMaxItemsForOneStorageCell(storageContainer, type)

    return totalCount
end


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
	

	
	--flushing 
	if (type == "small" and inventory > 380) then
        fluidContainer:flush()
        print("Flushing fluid tank")
	end 
	
	return fillPercent
end


-------------------------------------------------------
-- Safe component loader
-------------------------------------------------------
function LoadComponent(componentName, debug)
    PrintDebugInfo("Loading component: " .. componentName, debug)

    local found = component.findComponent(componentName)
    if not found or not found[1] then
        computer.panic("Component not found: " .. componentName)
    end

    return component.proxy(found[1])
end

function LoadRefineries(cellNo)
    -- Initialize the row for this specific cell
    refineries[cellNo] = {}

    for x = 1, 5 do
        local tagName = "Cell" .. cellNo .. "_Refinery" .. x
        local findResult = component.findComponent(tagName)
        
        if findResult[1] then
            -- Store in matrix: refineries[Cell][Refinery]
            refineries[cellNo][x] = component.proxy(findResult[1])
            print("Loaded: " .. tagName)
        else
            print("Missing: " .. tagName)
        end
    end
end

-- Init Components

StorageBuffer_Rubber = LoadComponent("StorageBuffer_Rubber", debug)
StorageBuffer_Plastic = LoadComponent("StorageBuffer_Plastic", debug)
HeavyOilStorageSmall = LoadComponent("Storage_HeaveOil", debug)
Storage_HeaveOil2 = LoadComponent("Storage_HeaveOil2", debug)


sign = LoadComponent("Display1", debug)
print(sign)


LoadRefineries(1)
LoadRefineries(2)
LoadRefineries(3)
LoadRefineries(4)

-- Panels and buttons
panel = LoadComponent("Panel1", debug)
panelBufferStatus = panel:getModule(3, 9, 0)
panelBufferStatus.size = 40
panelProdStatus = panel:getModule(3, 7, 0)
panelProdStatus.size = 30

manualProdSetting = panel:getModule(3, 4, 0)
autoManulSwtich = panel:getModule(3, 5, 0)
autoLight = panel:getModule(0, 5, 0)
manualLight = panel:getModule(6, 5, 0)

heavyOilTank = panel:getModule(9, 9, 0)
heavyOilTank2 = panel:getModule(9, 7, 0)


-- Load all recipes from a refinery. 1 = plastic; 2 = Rubber
print("Loading recipes")

print(refineries[1][1])

recipes = refineries[1][1]:getRecipes()
print("Loaded");

manualProduction = 1 -- 1 = plastic, 2 = rubber


while true do
	rubberBuffer = GetStorageInfo(StorageBuffer_Rubber, "large")
	plasticBuffer = GetStorageInfo(StorageBuffer_Plastic, "large")
	
	panelBufferStatus.text = "Rubber: " .. tostring(rubberBuffer) .. 
		"\nPlastic: ".. plasticBuffer
		
	recipeCell1 = refineries[1][1]:getRecipe()		
	recipeCell2 = refineries[2][1]:getRecipe()
	recipeCell3 = refineries[3][1]:getRecipe()
	recipeCell4 = refineries[4][1]:getRecipe()
	
	panelProdStatus.text = "Cell 1: " .. recipeCell1.name .. "\n" ..
		"Cell 2: " .. recipeCell2.name .. "\n" ..
		"Cell 3: " .. recipeCell3.name .. "\n" ..
		"Cell 4: " .. recipeCell4.name		
		
	-- plastic
	if (manualProdSetting.state == false and manualProduction == 2 and autoManulSwtich.state == true) then
		manualProduction = 1
		for x = 1, 5 do
			refineries[1][x]:setRecipe(recipes[1])
			refineries[2][x]:setRecipe(recipes[1])
			refineries[3][x]:setRecipe(recipes[1])
			refineries[4][x]:setRecipe(recipes[1])
		end		
		print("Changing to plastic")
	end

	-- rubber
	if (manualProdSetting.state == true and manualProduction == 1 and autoManulSwtich.state == true) then
		manualProduction = 2
		for x = 1, 5 do
			refineries[1][x]:setRecipe(recipes[2])
			refineries[2][x]:setRecipe(recipes[2])
			refineries[3][x]:setRecipe(recipes[2])
			refineries[4][x]:setRecipe(recipes[2])
		end
		print("Changing to rubber")
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
		if (rubberBuffer < 100 and plasticBuffer < 100) then
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
	end	
	
	x1 = FluidStorage(0, 0, HeavyOilStorageSmall, "small")
	x2 = FluidStorage(0, 0, Storage_HeaveOil2, "small")

	heavyOilTank2.limit = 0.8
	heavyOilTank.limit = 0.8 
	
	heavyOilTank.percent = x1/100
	heavyOilTank2.percent = x2/100
		
	event.pull(1)			
end


--ref11 = LoadComponent("Cell1_Refinery1", debug)
--refineries[1]:setRecipe(recipes[1])

--print(refineries[1])