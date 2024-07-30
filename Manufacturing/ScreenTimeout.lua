function CheckScreenTimeOut()
	if (debugMode == true) then
		showInfoOnScreen = true	
	else
		ShowMsg(50, 5, "TimeOut: " .. tostring(ScreenTimeoutSeconds - timeOut) .. " ")
		
		if (debugSwitch.state == true) then
			led:setColor(0, 1, 0, 1)
			showInfoOnScreen = true	
			refreshScreen = true	
			timeOut = timeOut + 1
		else
			led:setColor(1, 0, 0, 1)
			showInfoOnScreen = false		
			InitScreen()
		end	
		
		if (debugSwitch.state == true and timeOut == ScreenTimeoutSeconds) then
			debugSwitch.state = false
			led:setColor(1, 0, 0, 1)
			showInfoOnScreen = false
			refreshScreen = true			
			InitScreen()			
			timeOut = 0
		end
	end
end