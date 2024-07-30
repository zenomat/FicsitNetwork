function SetPower(power, message, color, status)	
	MachineStatus = status
	ShowMsg(50, 1, message, color)	
	switch:setIsSwitchOn(power)		
	ShowMsg(50, 2, "Machine status is: " .. tostring(MachineStatus) .. "     ")
end

function StatusCheck()
	local sw = switch:getPowerConnectors()[2]
	
	if (sw:getCircuit() == nil) then
		print("Error reading power info. NOT connected to POWER!!")
	end

	local circuit = sw:getCircuit()
		
	if (circuit.production == 0) then
		SetPower(false, "STOPPED!! NO Power!!  ", "red", "NoPWR")	
		raw1 = FALSE
		raw2 = FALSE
		raw3 = FALSE		
	else

		-- raw1, raw2, raw3 = raw materials in machine . TRUE = enough, FALSE = not enough
		-- st1, st2, st3, st4 - storage compartments
		
		--print(tostring(raw1) .. tostring(raw2) .. tostring(raw3) )
		
		-- Conditions:
		
		oneMachineHasNotEnough = (raw1 == false or raw2 == false or raw3 == false) 
		oneMachineHasEnough = (raw1 == true or raw2 == true or raw3 == true)
		
		allMachinesHaveEnough = (raw1 == true and raw2 == true and raw3 == true) 
		allMachinesHaveNOTEnough = (raw1 == false and raw2 == false and raw3 == false) 
		
		allStorageHasEnough = (st1 == true and st2 == true and st3 == true and st4 == true)
		
		if (allMachinesHaveNOTEnough) then
			-- if there are not enough raw materials in machines, STOP the power
			SetPower(false, "STOPPED!! Not enough material in machines!!  ", "red", "Empty")	
		end	
		
		if (oneMachineHasEnough) then
			-- if one machine has enough raw materials, start production
			SetPower(true, "RUNNING !!Low on raw materials               ", "yellow", "Low")
		end

		if (allStorageHasEnough) then
			-- if there are enough raw materials in storage, turn on power
			SetPower(true, "Manufacturing process RUNNING                 ", "green", "On")
		end	
		
		if (allStorageHasEnough and allMachinesHaveNOTEnough)
		then
			-- all storage compartments have enough but machines have not enough, something is wrong
			-- might be a belt missing or something
			SetPower(true, "MALFUNCTION!!! Check the machines & belts    ", "red", "ERROR")
		end	
	end
end