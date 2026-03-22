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
    local status = 0 

    if (machine ~= nil) then
        if (machine.standby == false) then
            ShowMsg(x, y, "█", "green")
            status = 1
        else
            ShowMsg(x, y, "█", "red")
        end
    else
        ShowMsg(x, y, "?")
    end

    return status
end

function MachineProgress(x, y, machine)
	if (machine ~= nill) then		
	
		ShowMsg(x, y, string.format("%.2f%%", machine.progress * 100))
	else
		ShowMsg(x, y, "?")
	end
end