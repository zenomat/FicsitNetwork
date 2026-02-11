function ItemCount(container, x, y, name)
    local value = 0
    local content = ""
    local enoughRawMat = false
    local enoughRawString = "Enough for prod"

    if not container then
        return false, 0
    end

    -- Get the first inventory from the container
    local inventories = container:getInventories()
    if not inventories or not inventories[1] then
        return false, 0
    end

    local inv = inventories[1]

    -- Read item count
    value = inv.ItemCount or 0

    -- Read item type from first stack
    local stack = inv:getStack(0)
    if stack and stack.item and stack.item.type then
        content = stack.item.type.name
    end

    -------------------------------------------------
    -- Raw material checks (unchanged logic)
    -------------------------------------------------
    if name ~= "Finished goods" then

        if value ~= 0 then
            for i = 1, #bomMatrix do
                if bomMatrix[i][1] == content and value > tonumber(bomMatrix[i][2]) then
                    enoughRawMat = true
                    break
                end
            end
        end

        if enoughRawMat == true then
            enoughRawString = "OK    "
        else
            enoughRawString = "NOT ok"
        end

        ShowMsg(x, y, name)

        if value == 0 then
            ShowMsg(x, y + 1, "Empty -> " .. enoughRawString .. "            ", "red")
        else
            if enoughRawMat == true then
                ShowMsg(x, y + 1, content .. " -> " .. tostring(value) .. " - " .. enoughRawString, "green")
            else
                ShowMsg(x, y + 1, content .. " -> " .. tostring(value) .. " - " .. enoughRawString, "red")
            end
        end

    else
        ShowMsg(x, y, name)
        ShowMsg(x, y + 1, content .. " -> " .. tostring(value))
    end

    return enoughRawMat, value
end
