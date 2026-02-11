function InitScreen()
	if (refreshScreen == true) then		
		-- clean screen
		gpu:setBackground(0,0,0,0)
		gpu:fill(0,0,w,h," ")
		gpu:flush()
		refreshScreen = false
	end
end

function ShowMsg(x, y, msg, color)
	if (showInfoOnScreen == true) then
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
end

function BigSignText(textForOverheadSign)
	-- changes the text for the over head sign
	signData = labelSign[1]:getPrefabSignData() --Gets the SignData Object
	signData:setTextElement( "Name" , textForOverheadSign ) -- Changes the name of the Signdata
	labelSign[1]:setPrefabSignData(signData) -- Assigns changed Signdata to Sign (this is the step you were missing)
end