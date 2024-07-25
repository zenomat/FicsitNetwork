function calculateBatteryPercentage(batteryStore, batteryCapacity)
    if batteryCapacity == 0 then
        return 0
    end
    local percentage = (batteryStore / batteryCapacity) * 100
    return percentage
end

function ShowPowerInfo()
 	local capacityLableColor = "green"
	local batteryPercentage = calculateBatteryPercentage(circuit.batteryStore, circuit.batteryCapacity)	
	
	ShowMsg(2,1,  "╔═════════════════════════════════════╗ ")
 	ShowMsg(2,2,  "║            Power Info               ║ ")
 	ShowMsg(2,3,  "║                                     ║ ") 	
	ShowMsg(2, 4, formatRow("Consumption", circuit.consumption, "MW", labelWidth, valueWidth))
	ShowMsg(2, 5, formatRow("Production", circuit.production, "MW", labelWidth, valueWidth))
	ShowMsg(2, 6, formatRow("Capacity", circuit.capacity, "MW", labelWidth, valueWidth))
	
	ShowMsg(2,  7, "║")
		
	local remainingPower = circuit.capacity - circuit.consumption	
	if (remainingPower < 500) then
		capacityLableColor = "yellow"
	end
	
	if (remainingPower < 100) then
		capacityLableColor = "red"
	end
	
	ShowMsg(4,  7, formatRowNoMargins("Left", circuit.capacity - circuit.consumption, "MW", labelWidth, valueWidth), capacityLableColor)
	ShowMsg(40, 7, "║")
	
	ShowMsg(2, 8, formatRow("Battery: ", batteryPercentage, "% full", labelWidth, valueWidth)) 	 	 	
	ShowMsg(2, 8, formatRow("Bat. store: ", circuit.batteryStore, "MW", labelWidth, valueWidth)) 	 	 	
	ShowMsg(2, 9, formatRow("Bat. capacity: ", circuit.batteryCapacity, "MW", labelWidth, valueWidth)) 	 	 	
 	ShowMsg(2, 10,   "║                                     ║ ")
 	ShowMsg(2, 11,   "╚═════════════════════════════════════╝ ")
end


-- Circuit component:
-- Power:
-- con = powerInfo:getPowerConnectors()[1]
-- circuit = con:getCircuit()