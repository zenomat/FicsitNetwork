
function DoWhenSensorActive()	
	netcard:open(3000) -- test machine	
	netcard:open(8888) -- broadcast messages

	netcard:open(1112) -- Computer
	netcard:open(1114) -- Crystal 2
	netcard:open(1115) -- Heavy Frame
	netcard:open(1116) -- High Speed connector
	netcard:open(1117) -- Modular Engine
	netcard:open(1118) -- Super Computer
	netcard:open(1119) -- Adaptive Control Unit
	netcard:open(1120) -- Radio Control Unit
	netcard:open(1121) -- High Speed Connector 2
	netcard:open(1122) -- MagneticFieldGenerator

	e, s, sender, port, message = event.pull(1)			
	event.listen(netcard)
	netcard:broadCast(8888, "SendData")
	
	ShowPowerInfo()					
	ShowManHeader()		

	

	if e == "NetworkMessage" then			
		if (port == 1112) then
			-- Computer
		   ShowManufacturerInfo(50, 6, message)			
	   end		
   
		if (port == 1114) then
		   ShowManufacturerInfo(50, 7, message)
	   end		
   
		if (port == 1115) then
			--print(message)
		   ShowManufacturerInfo(50, 8, message)
	   end				
   
		if (port == 1116) then 
			--High Speed connector
			--print(message)
		   ShowManufacturerInfo(50, 9, message)
	   end						
   
	   if (port == 1117) then 
		   -- Modular Engine
		   --print(message)
		   ShowManufacturerInfo(50, 10, message)
	   end								
	   
	   if (port == 1118) then 
		   -- Super Computer
		   --print(message)
		   ShowManufacturerInfo(50, 11, message)
	   end										
	   
	   if (port == 1119) then 
		   -- Adaptive Control Unit
		   --print(message)
		   ShowManufacturerInfo(50, 12, message)
	   end												
	   
	   if (port == 1120) then 
		   -- Radio control unit
		   --print(message)
		   ShowManufacturerInfo(50, 13, message)
	   end										

	   if (port == 1121) then 
		   -- High Speed Connector 2
		   --print(message)
		   ShowManufacturerInfo(50, 14, message)
	   end																							
	   
	   if (port == 1122) then 
		   -- Magnetic Field Generator
		   --print(message)
		   ShowManufacturerInfo(50, 15, message)
	   end													

		if (port == 3000) then 
			-- test machine
			--ShowMsg(50, 20, message)
		end										
	end
	
	ShowMissingRawMaterials()
	ShowManFooter()	

	
	event.pull(1)
end

function DoLoop()
	screenIsClean = false
	local active = SensorActive(sensor)	
	
	--DoWhenSensorActive()	

	if (active) then
		DoWhenSensorActive()
	else
		CleanScreen()
		netcard:closeAll()
	end
	
	event.pull(5)
end