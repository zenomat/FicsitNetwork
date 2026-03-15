
function DoWhenSensorActive()	
	
	ShowPowerInfo()					
	ShowManHeader()	

	indicator:setColor(1, 0, 0, 1)
	
	if (switch.state == true) then
		indicator:setColor(0, 1, 0, 1)

        netcard:broadcast(8888, "Reboot")
        lastBroadcastTime = computer.time()
        print("Reboot .. " .. computer.time())
		event.pull(1)	
	end

    if computer.time() - lastBroadcastTime > cooldown then
        netcard:broadcast(8888, "SendData")
        lastBroadcastTime = computer.time()
        print("Broacast .. " .. computer.time())
    end

	local e, s, sender, port, message = event.pull(1) 
	--print("Event: " .. tostring(e) .. ", Sender: " .. tostring(sender) .. ", Port: " .. tostring(port) .. ", Message: " .. tostring(message))

	if e == "NetworkMessage" then			
		if (port == 1112) then
			-- Computer
		   ShowManufacturerInfo(50, 6, message)			
	   end		
   
		if (port == 1114) then
			--Crystal 2
		   ShowManufacturerInfo(50, 7, message)
	   end		
   
		if (port == 1115) then	
			--Heavy Frame		
		   ShowManufacturerInfo(50, 8, message)
	   end				
   
		if (port == 1116) then 
			--High Speed connector			
		   ShowManufacturerInfo(50, 9, message)
	   end						
   
	   if (port == 1117) then 
		   -- Modular Engine		   
		   ShowManufacturerInfo(50, 10, message)
	   end								
	   
	   if (port == 1118) then 
		   -- Super Computer		   
		   ShowManufacturerInfo(50, 11, message)
	   end										
	   
	   if (port == 1119) then 
		   -- Adaptive Control Unit		   
		   ShowManufacturerInfo(50, 12, message)
	   end												
	   
	   if (port == 1120) then 
		   -- Radio control unit		   
		   ShowManufacturerInfo(50, 13, message)
	   end										

	   if (port == 1121) then 
		   -- High Speed Connector 2		   
		   ShowManufacturerInfo(50, 14, message)
	   end																							
	   
	   if (port == 1124) then 
		   --Turbo Motor		   
		   ShowManufacturerInfo(50, 15, message)		   		   
	   end
		
	   if (port == 1125) then 
		   --Turbo Motor 2		   
		   ShowManufacturerInfo(50, 16, message)		   		   
	   end

	   if (port == 1126) then 
		   -- Thermal Propulsion Rocket
		   --print("Thermal Propulsion Rocket .. " .. message)
		   ShowManufacturerInfo(50, 17, message)		   		   
	   end

	   if (port == 1127) then 
		   -- Computer2
		   print("Computer2 .. " .. message)
		   ShowManufacturerInfo(50, 18, message)		   		   
	   end

	   if (port == 1128) then 
		   -- Computer3
		   --print("Computer2 .. " .. message)
		   ShowManufacturerInfo(50, 19, message)		   		   
	   end


	   if (port == 3000) then 
			-- test machine
			ShowMsg(50, 20, message)
		end										
	end
	
	ShowMissingRawMaterials()
	ShowManFooter()	
	
	event.pull(1)
end

function DoLoop()	
	screenIsClean = false
	local active = SensorActive(sensor)		
	
	if (active) then
		DoWhenSensorActive()
	else
		CleanScreen()
		--netcard:closeAll()
	end
	
	event.pull(1)
end