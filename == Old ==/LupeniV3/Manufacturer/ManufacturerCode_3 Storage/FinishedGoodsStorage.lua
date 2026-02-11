
function GetMaxItemsForOneStorageCell(storageContainer)
	--check the first cell in a storage container to determine the number of items
	local itemsInFirstCell
	local totalCount
	
	inv = storageContainer:getInventories()[1]
	totalCount = inv.ItemCount
	
	for j = 0, 0 do
		 local stack = inv:getStack(j)
		 if stack ~= nil and stack.item ~= nil and stack.item.type ~= nil then
			--print(stack.item.type.name.." "..stack.count)									
			itemsInFirstCell = stack.count
		 end		 
	end
	return itemsInFirstCell, totalCount
end

function ShowFinishedGoodsStatus(storageContainer, x, y, name)
	--print(storageContainer)

	itemsInFirstCell, totalCount = GetMaxItemsForOneStorageCell(storageContainer)
		
	local fillPercent = (totalCount * 100) / (itemsInFirstCell * 48)
	local label = "Count: " .. tostring(totalCount) .. " - " .. string.format("%.2f", fillPercent) .. "%" 
	
	ShowMsg(x, y, name)
	ShowMsg(x, y + 1, label)
	
	return fillPercent
end