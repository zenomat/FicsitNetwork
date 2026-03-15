function SetPower(power, message, color, status)	
	MachineStatus = status
	ShowMsg(50, 1, message, color)	
	switch:setIsSwitchOn(power)		
	ShowMsg(50, 2, "Machine status is: " .. tostring(MachineStatus) .. "     ")	
end

-- power info
function calculateBatteryPercentage(batteryStore, batteryCapacity)
    if batteryCapacity == 0 then
        return 0
    end
    local percentage = (batteryStore / batteryCapacity) * 100
    return percentage
end

function StatusCheck()
	local remainingPower = 0
	local batteryPercentage = 0
	local sw = switch:getPowerConnectors()[2]
	
	if (sw:getCircuit() == nil) then
		print("Error reading power info. NOT connected to POWER!!")
	end
	
	local circuit = sw:getCircuit()
	if (circuit ~= nil) then
		ShowMsg(50, 7, "Power.Consumption: " .. string.format("%.2f", circuit.consumption))
		ShowMsg(50, 8, "Power.Production: " .. string.format("%.2f", circuit.production))
		remainingPower = circuit.capacity - circuit.consumption	
		batteryPercentage = calculateBatteryPercentage(circuit.batteryStore, circuit.batteryCapacity)	
		ShowMsg(50, 9, "LEFT: " .. string.format("%.2f", remainingPower))	
		ShowMsg(50, 10, "Battery: " .. string.format("%.2f", batteryPercentage) .. "% full")
	end
	
	if (batteryPercentage <= 50) then
		SetPower(false, "STOPPED!! Low Power!!       ", "red", "LoPW")	
		raw1 = FALSE
		raw2 = FALSE
		raw3 = FALSE		
	else
		-- raw1, raw2, raw3 = raw materials in machine . TRUE = enough, FALSE = not enough
		-- st1, st2, st3, st4 - storage compartments
							
		oneMachineHasNotEnough = (raw1 == false or raw2 == false or raw3 == false) 
		oneMachineHasEnough = (raw1 == true or raw2 == true or raw3 == true)
		
		allMachinesHaveEnough = (raw1 == true and raw2 == true and raw3 == true) 
		allMachinesHaveNOTEnough = (raw1 == false and raw2 == false and raw3 == false) 
		
		if (numberOfContainers == 4) then
			allStorageHasEnough = (st1 == true and st2 == true and st3 == true and st4 == true)
		end
		if (numberOfContainers == 3) then
			allStorageHasEnough = (st1 == true and st2 == true and st3 == true)
		end
				
		-- power settings
		if (storageFillPercent == 100) then	
			-- storage is full, turn off machines
			SetPower(false, "Storage if FULL                             ", "red", "FULL")
			
		elseif (allMachinesHaveNOTEnough == true and allStorageHasEnough == false) then
			-- if there are not enough raw materials in machines, STOP the power
			SetPower(false, "STOPPED!! Not enough material in machines!!  ", "red", "Empty")	
				
		elseif (oneMachineHasNotEnough and storageFillPercent ~= 100) then
			-- if one machine has enough raw materials, start production
			SetPower(true, "RUNNING !!Low on raw materials               ", "yellow", "Low")
			

		elseif (allStorageHasEnough or allMachinesHaveEnough) and (storageFillPercent ~= 100) then
			-- if there are enough raw materials in storage, turn on power
			SetPower(true, "Manufacturing process RUNNING                 ", "green", "On")
					
		elseif (allStorageHasEnough and allMachinesHaveNOTEnough) then
			-- all storage compartments have enough but machines have not enough, something is wrong
			-- might be a belt missing or something
			SetPower(true, "MALFUNCTION!!! Check the machines & belts    ", "red", "ERROR")								
			
		end
	end	
end