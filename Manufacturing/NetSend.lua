function statusOnRaw(boolValue)	

	local status 
	
	if boolValue == true then
		status =  "Ok|"
	else
		status =  "NotOk|"
	end
		
	if (storageFillPercent == 100) then 
		status = "OFF|"
	end
	
	return status 
end

function SendMessageToServer(missingItems)	
	local machineName = ""
	
	if (storageFillPercent == nil) then
		storageFillPercent = 0
	end

	-- set message to send to server
	local txtPercent = string.format("%.2f", storageFillPercent) .. "%"
					
	if (MachineNameOverride == nil or MachineNameOverride == "") then
		machineName = whatAreWeProducing
	else 
		machineName = MachineNameOverride
	end
	
	local netSendMsg = machineName .. "|" 
		.. tostring(statusOnRaw(raw1)) 
		.. tostring(statusOnRaw(raw2))
		.. tostring(statusOnRaw(raw3))
		.. tostring(txtPercent) 
		.. "|" .. MachineStatus
		.. "|" .. missingItems


	ShowMsg(50, 3, netSendMsg .. "                         ")	
	netcard:send(receiverNetCard, PortToServer, netSendMsg)	
end