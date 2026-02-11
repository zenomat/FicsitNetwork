function MachineStatus(x, y, machine)
	if (machine ~= nill) then
		if (machine.progress * 100) > 10 then
			ShowMsg(x, y, "█", "green")
		else
			ShowMsg(x, y, "█", "red")
		end
	else
		ShowMsg(x, y, "?")
	end
end

function ReactorStatus(x, y, machine)
	if (machine ~= nill) then
		if (machine.standby == false) then
			ShowMsg(x, y, "█", "green")
		else
			ShowMsg(x, y, "█", "red")
		end
	else
		ShowMsg(x, y, "?")
	end
end