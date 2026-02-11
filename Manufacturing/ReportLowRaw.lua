-- Report Low Raw Materials

local missingRawReport

-------------------------------------------------------
-- Check a single container for a raw material
-------------------------------------------------------
function CheckContainerForRawMaterial(container, rawMaterial)
    -- searches for raw material in storage container
    -- return TRUE if found
    -- if quantity < 100 - add to report

    local found = false

    if not container then
        return false
    end

    -- Get inventories from container (object → table)
    local inventories = container:getInventories()
    if not inventories or not inventories[1] then
        return false
    end

    local inv = inventories[1]

    -- Get item count
    local value = inv.ItemCount or 0

    -- Get first stack
    local stack = inv:getStack(0)
    if stack and stack.item and stack.item.type then
        local content = stack.item.type.name

        if content == rawMaterial then
            found = true
            if value < 100 then
                missingRawReport = tostring(missingRawReport) .. tostring(rawMaterial) .. ";"
            end
        end
    end

    return found
end

-------------------------------------------------------
-- Check all BOM items across storages
-------------------------------------------------------
function CheckMissingItem()
    if numberOfContainers == nil then
        print("numberOfContainers is NOT defined in initComponents.lua")
    end

    local f1, f2, f3, f4 = false, false, false, false

    missingRawReport = ""

    for i = 1, #bomMatrix do
        local rawMaterial = bomMatrix[i][1]

        f1 = CheckContainerForRawMaterial(storage1, rawMaterial)
        f2 = CheckContainerForRawMaterial(storage2, rawMaterial)
        f3 = CheckContainerForRawMaterial(storage3, rawMaterial)

        if numberOfContainers == 4 then
            f4 = CheckContainerForRawMaterial(storage4, rawMaterial)
        else
            f4 = false
        end

        -- raw material not found in any storage
        if numberOfContainers == 4 then
            if not f1 and not f2 and not f3 and not f4 then
                missingRawReport = tostring(missingRawReport) .. tostring(rawMaterial) .. ";"
            end
        else
            if not f1 and not f2 and not f3 then
                missingRawReport = tostring(missingRawReport) .. tostring(rawMaterial) .. ";"
            end
        end
    end

    ShowMsg(50, 4, "LOW: " .. tostring(missingRawReport) .. "                         ")
    return missingRawReport
end
