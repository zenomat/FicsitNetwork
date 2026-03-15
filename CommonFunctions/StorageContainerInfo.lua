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

function ShowStorageInfo(x, y, storageContainer, type)
    local itemsInFirstCell, totalCount, fillPercent =
        GetMaxItemsForOneStorageCell(storageContainer, type)

    local label = string.format("%.2f", fillPercent) .. " %   "

    if fillPercent > 50 and fillPercent < 100 then
        ShowMsg(x, y, label, "green")
    elseif fillPercent > 15 and fillPercent <= 50 then
        ShowMsg(x, y, label, "yellow")
    elseif fillPercent == 100 then
        ShowMsg(x, y, "FULL", "green")
    else
        ShowMsg(x, y, label, "red")
    end

    return totalCount
end


function GetStorageInfo(storageContainer, type)
    local itemsInFirstCell, totalCount, fillPercent = GetMaxItemsForOneStorageCell(storageContainer, type)

    return totalCount
end
