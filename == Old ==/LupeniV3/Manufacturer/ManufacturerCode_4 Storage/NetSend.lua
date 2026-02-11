function statusOnRaw(boolValue)
	if boolValue == true then
		return "Ok|"
	else
		return "NotOk|"
	end
end

function SendMessageToServer(finishedGoodFillPercent, missingItems)
	if (finishedGoodFillPercent == nil) then
		finishedGoodFillPercent = 0
	end

	-- set message to send to server
	local txtPercent = string.format("%.2f", finishedGoodFillPercent) .. "%"
	
	local netSendMsg = whatAreWeProducing .. "|" 
		.. statusOnRaw(raw1) 
		.. statusOnRaw(raw2) 
		.. statusOnRaw(raw3) 
		.. tostring(txtPercent) 
		.. "|" .. MachineStatus
		.. "|" .. missingItems

	ShowMsg(50, 3, netSendMsg .. "                         ")	
	netcard:send(receiverNetCard, port, netSendMsg)
end