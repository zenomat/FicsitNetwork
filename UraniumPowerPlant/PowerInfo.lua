function DaysSinceLanding()
  return tostring(math.floor(computer.time()/60/60/24))
end

-- power info
function calculateBatteryPercentage(batteryStore, batteryCapacity)
    if batteryCapacity == 0 then
        return 0
    end
    local percentage = (batteryStore / batteryCapacity) * 100
    return percentage
end

function ShowPowerInfo()
	if (circuit ~= nil) then
		local capacityLableColor = "green"
		local batteryPercentage = calculateBatteryPercentage(circuit.batteryStore, circuit.batteryCapacity)	
		
		ShowMsg(2, 5, formatRow("Production:", circuit.production, "MW", labelWidth, valueWidth))	
		ShowMsg(2, 6, formatRow("Consumption:", circuit.consumption, "MW", labelWidth, valueWidth))
		ShowMsg(2, 7, formatRow("Capacity:", circuit.capacity, "MW", labelWidth, valueWidth))
				
		local remainingPower = circuit.capacity - circuit.consumption	
		if (remainingPower < 500) then
			capacityLableColor = "yellow"
		end
		
		if (remainingPower < 100) then
			capacityLableColor = "red"
		end
		
		ShowMsg(4,  8, formatRowNoMargins("Left", circuit.capacity - circuit.consumption, "MW", labelWidth, valueWidth), capacityLableColor)		
		
		ShowMsg(2, 9, formatRow("Battery: ", batteryPercentage, "% full", labelWidth, valueWidth)) 	 	 	
		ShowMsg(2, 10, formatRow("Bat. store: ", circuit.batteryStore, "MW", labelWidth, valueWidth)) 	 	 	
		ShowMsg(2, 11, formatRow("Bat. capacity: ", circuit.batteryCapacity, "MW", labelWidth, valueWidth)) 	 	 							
		ShowMsg(2, 12, formatRow("Days here: ", DaysSinceLanding(), "days", labelWidth, valueWidth)) 	 	 									
		ShowMsg(2, 13, formatRowString("Local time: ", LocalTime(), "", labelWidth, valueWidth)) 	 	 							
	else
		ShowMsg(2,1, "Power connection error!! ", "red")
		ShowMsg(2,2, "Check power pole connected to the server", "red")
	end
	
end

