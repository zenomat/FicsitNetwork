
 -- Function to create a data line
function createDataLine(name, man1, man2, man3, quantity, onoff)
    local paddedName = padRight(name, colWidthName)
    local paddedMan1 = padRight(man1, colWidthMan)
    local paddedMan2 = padRight(man2, colWidthMan)
    local paddedMan3 = padRight(man3, colWidthMan)
    local paddedQty = padRight(tostring(quantity), colWidthQty)
    local paddedOnOff = padRight(onoff, colWidthOnOff)
    return "║ " .. paddedName .. "║ " .. paddedMan1 .. "║ " .. paddedMan2 .. "║ " .. paddedMan3 .. "║ " .. paddedQty .. "║ " .. paddedOnOff .. "║"
end

-- Function to show data line with color
function showDataLine(x, y, data)
    local offsetX = x

    -- Helper function to set color and write text
    local function writeColoredText(text, color)
        gpu:setForeground(color[1], color[2], color[3], color[4])
        gpu:setText(offsetX, y, text)
        offsetX = offsetX + #text
    end

    -- Define colors
    local green = {0, 1, 0, 1}
    local red = {1, 0, 0, 1}
	local yellow = {1, 1, 0, 1}
    local defaultColor = {1, 1, 1, 1}

    -- Helper function to determine color
    local function getColor(value)
        if value == "Ok" or value == "On" or value == "FULL" then
            return green
        elseif value == "NotOk" or value == "OFF" or value == "ERROR" or value == "NoPWR" then
            return red
		elseif value == "Low" then	
			return yellow					
        else
            return defaultColor
        end
    end

    -- Prepare data segments
    local segments = {
        {text = padRight(data[1], colWidthName), color = defaultColor},
        {text = padRight(data[2], colWidthMan), color = getColor(data[2])},
        {text = padRight(data[3], colWidthMan), color = getColor(data[3])},
        {text = padRight(data[4], colWidthMan), color = getColor(data[4])},
        {text = padRight(data[5], colWidthQty), color = defaultColor},
        {text = padRight(data[6], colWidthOnOff), color = getColor(data[6])},
    }

    -- Write segments with appropriate colors and separators
    gpu:setText(offsetX, y, "║")
    offsetX = offsetX + 2 -- Adjust for the separator
    for i, segment in ipairs(segments) do
        writeColoredText(segment.text, segment.color)
        gpu:setForeground(defaultColor[1], defaultColor[2], defaultColor[3], defaultColor[4])
        gpu:setText(offsetX, y, "║")
        offsetX = offsetX + 2 -- Adjust for the separator
    end
end

function ShowManufacturerInfo(x, y, dataString)
	--local dataString = "Crystal Oscilator|Ok|NotOk|Ok|996|Off"
	-- Split the data string
	local data = {}
	for value in string.gmatch(dataString, "[^|]+") do
	    table.insert(data, value)
	end

	local dataLine = createDataLine(data[1], data[2], data[3], data[4], data[5], data[6])

	showDataLine(x, y, data)			
	AddRemoveMissingRawMaterials(data[1], data[7])
end

local function findFirstElementIndex(matrix, item)
    for index, row in ipairs(matrix) do
        if row[1] == item then
            return index
        end
    end
    return -1
end

function AddRemoveMissingRawMaterials(manufacturingMachine, missingRawMaterialInMachine)

	--missing raw material reported by manufacturing cell
	if (missingRawMaterialInMachine ~= nil) then		
		local index = findFirstElementIndex(missingRawMaterial, manufacturingMachine)
			
		--material not found, added
		if (index == -1) then
			table.insert(missingRawMaterial, {manufacturingMachine, missingRawMaterialInMachine})
		end
	else
		-- missing raw material no longer reported, need to be removed
		local index = findFirstElementIndex(missingRawMaterial, manufacturingMachine)

		if (index > 0) then
			table.remove(missingRawMaterial, index)
		end		
	end
end

function ShowManHeader()
	ShowMsg(50,  1, "╔══════════════════════════════════════════════════════════════════╗")
	ShowMsg(50,  2, "║                      Manufacturing Cells                         ║")
	ShowMsg(50,  3, "║                                                                  ║")
	ShowMsg(50,  4, "║ Name                 ║ Man1  ║ Man2  ║ Man3  ║ Quantity  ║ Stat. ║")
	ShowMsg(50,  5, "║══════════════════════════════════════════════════════════════════║")
end

function ShowManFooter()
	-- Remember: First is X , second is Y. !! Need to increase Y !!
	ShowMsg(50, 16, "║                      ║       ║       ║       ║           ║       ║")
	ShowMsg(50, 17, "╚══════════════════════════════════════════════════════════════════╝")
end