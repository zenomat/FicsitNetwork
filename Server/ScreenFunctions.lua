function InitScreen()
	-- setup gpu
	gpu:bindScreen(screen)
	w,h = gpu:getSize()
	--print("Screen resolution: " .. tostring(w) .. " x " .. tostring(h))
		
	CleanScreen()
end

function CleanScreen()
	-- clean screen
	if (screenIsClean == false) then
		gpu:setBackground(0,0,0,0)
		gpu:fill(0,0,w,h," ")
		gpu:flush()
		screenIsClean = true
	end
end

function ShowMsg(x, y, msg, color)
    if (color == nil) then
			gpu:setForeground(1, 1, 1 , 1) 
		elseif (color == "red") then
			gpu:setForeground(1, 0, 0 , 1) 
		elseif (color == "green") then		
			gpu:setForeground(0, 1, 0, 1) 	
		elseif (color == "yellow") then					
			gpu:setForeground(1, 1, 0, 1) 	
    end
    
	gpu:setText(x, y, msg)
	gpu:flush()
end

function formatRow(label, value, unit, labelWidth, valueWidth)
    local paddedLabel = padRight(label, labelWidth)
    local paddedValue = padRight(string.format("%.2f", value) .. " " .. unit, valueWidth)
    return "║ " .. paddedLabel .. paddedValue .. " ║"
end

function formatRowString(label, value, unit, labelWidth, valueWidth)
	local paddedLabel = padRight(label, labelWidth)
    local paddedValue = padRight(value .. " " .. unit, valueWidth)
    return "║ " .. paddedLabel .. paddedValue .. " ║"
end


function formatRowNoMargins(label, value, unit, labelWidth, valueWidth)
    local paddedLabel = padRight(label, labelWidth)
    local paddedValue = padRight(string.format("%.2f", value) .. " " .. unit, valueWidth)
    return paddedLabel .. paddedValue
end


function padRight(str, width)
    return str .. string.rep(" ", width - #str)
end

function SetLabelText(textForOverheadSign)
	-- changes the text for the over head sign
	signData = labelSign:getPrefabSignData() --Gets the SignData Object
	signData:setTextElement( "Name" , textForOverheadSign ) -- Changes the name of the Signdata
	labelSign:setPrefabSignData(signData) -- Assigns changed Signdata to Sign (this is the step you were missing)
end