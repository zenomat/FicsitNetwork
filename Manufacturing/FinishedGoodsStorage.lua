
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

function ShowFinishedGoodsStatus(storageContainer, x, y, labelOnBigScreen)
	local fillPercent = 0
	local textForOverheadSign = ""
	
	itemsInFirstCell, totalCount = GetMaxItemsForOneStorageCell(storageContainer)
	
	if (itemsInFirstCell ~= nil) then		
		fillPercent = (totalCount * 100) / (itemsInFirstCell * 48)
		local label = "Count: " .. tostring(totalCount) .. " - " .. string.format("%.2f", fillPercent) .. "%" 
	
		textForOverheadSign = string.sub(whatAreWeProducing, 1, 4) .. ": "  .. tostring(totalCount) .. " - " .. string.format("%.2f", fillPercent) .. "%"
	
		ShowMsg(x, y, labelOnBigScreen)
		ShowMsg(x, y + 1, label)
	else
		textForOverheadSign = whatAreWeProducing .. ": 0"
	
		ShowMsg(x, y, labelOnBigScreen)
		ShowMsg(x, y + 1, 0)
	end
		
	return fillPercent, textForOverheadSign
end