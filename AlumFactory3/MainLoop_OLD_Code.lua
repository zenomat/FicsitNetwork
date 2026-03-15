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

-------------------------------------------------------

function ShowStorageInfo(storageContainer, type)
    local itemsInFirstCell, totalCount, fillPercent =
        GetMaxItemsForOneStorageCell(storageContainer, type)
    return totalCount
end


function PrintDebugInfo(message, debug)
    if debug == true then
        print(message)
    end
end

function ShowMsg()
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
	

	local label = tostring(typeShort) .. " - " .. tostring(string.format("%.0f", fillPercent)) .. " %   " 
	
	if (fillPercent > 20) then
		ShowMsg(x, y, label, "green")
	else 
		ShowMsg(x, y, label, "red")
	end
	
	--flushing 
	if (type == "small" and inventory > 380) then
        fluidContainer:flush()
        print("Flushing fluid tank")
	end 

end


AlumSolSmall = component.proxy(component.findComponent("AlumSolSmall")[1])
WaterSmall = component.proxy(component.findComponent("WaterSmall")[1])
Water2Small = component.proxy(component.findComponent("Water2Small")[1])
Splitter_Silica1 = component.proxy(component.findComponent("Splitter_Silica1")[1])
Storage_Silica1 = component.proxy(component.findComponent("Storage_Silica1")[1])
AlumSol2Small = component.proxy(component.findComponent("AlumSol2Small")[1])

while true do
	FluidStorage(0, 0, AlumSolSmall, "small")
	FluidStorage(0, 0, AlumSol2Small, "small")
	
	FluidStorage(0, 0, WaterSmall, "small")	
	FluidStorage(0, 0, Water2Small, "small")		
			
			
	x = ShowStorageInfo(Storage_Silica1, "large")
	--print(x)
	if x < 1000 then
		Splitter_Silica1:transferItem(0)
		event.pull(0.1)	
		Splitter_Silica1:transferItem(1)	
		event.pull(0.1)	
		Splitter_Silica1:transferItem(2)
		event.pull(0.1)	
		print("Splitter open")
	else
		event.pull(1)	
	end
	

end