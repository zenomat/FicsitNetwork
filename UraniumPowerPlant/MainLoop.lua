-------------------------------------------------------
-- Power control
-------------------------------------------------------
function SetPower(power, message, color, status)

    local machineStatus = status

    ShowMsg(50, 1, message, color)

    if switch then
        switch:setIsSwitchOn(power)
    end

    ShowMsg(50, 2, "Machine status is: " .. tostring(machineStatus) .. "     ")
end

function calculateBatteryPercentage(batteryStore, batteryCapacity)
    if batteryCapacity == 0 then
        return 0
    end
    local percentage = (batteryStore / batteryCapacity) * 100
    return percentage
end

-------------------------------------------------------
-- Reactor status control
-------------------------------------------------------

function CheckReactorStatusBasedonSwitches()
    -- Check manual control switch state
    if manualControlSwitchState then
        Reactor1.standby = not switches[1].state
        Reactor2.standby = not switches[2].state
        Reactor3.standby = not switches[3].state
        Reactor4.standby = not switches[4].state	    
        Reactor5.standby = not switches[5].state
        Reactor6.standby = not switches[6].state

        SetIndicatorColor(1, Reactor1)
        SetIndicatorColor(2, Reactor2)
        SetIndicatorColor(3, Reactor3)
        SetIndicatorColor(4, Reactor4)	
        SetIndicatorColor(5, Reactor5)	
        SetIndicatorColor(6, Reactor6)	
    else    
        TurnReactorOnWhenBatteryLow()
    end

    manualControlSwitchState = not manualControlSwitch.state
    if manualControlSwitchState then
        manualIndicator:setColor(0, 1, 0, 1) -- green
        autoIndicator:setColor(1, 0, 0, 1) -- red
    else
        manualIndicator:setColor(1, 0, 0, 1) -- red
        autoIndicator:setColor(0, 1, 0, 1) -- green
    end

    local batteryPercentage = calculateBatteryPercentage(circuit.batteryStore, circuit.batteryCapacity)	
    panelBatteryInfo.text = string.format("Battery: %.1f%%", batteryPercentage)
    
    panelAutoPowerOn.text = "Auto Power: " .. string.format("%.1f%%", autoPowerOnPotentiometer.value)

end



function TurnOnReactorDurinNight()
    local hour = math.floor((computer.time()/60/60) % 24)

    if hour >= 20 or hour < 8 then
        Reactor3.standby = false
        Reactor4.standby = false
    else
        Reactor3.standby = true
        Reactor4.standby = true        
    end

	SetIndicatorColor(1, Reactor1)
	SetIndicatorColor(2, Reactor2)
	SetIndicatorColor(3, Reactor3)
	SetIndicatorColor(4, Reactor4)    
end


function TurnReactorOnWhenBatteryLow()
    local batteryPercentage = calculateBatteryPercentage(circuit.batteryStore, circuit.batteryCapacity)	

    if batteryPercentage < autoPowerOnPotentiometer.value then
        Reactor1.standby = false
        Reactor2.standby = false
        Reactor3.standby = false
        Reactor4.standby = false
        Reactor5.standby = false
        Reactor6.standby = false
    else
        if batteryPercentage >= 95 then
            Reactor1.standby = true
            Reactor2.standby = true        
            Reactor3.standby = true
            Reactor4.standby = true
            Reactor5.standby = true
            Reactor6.standby = true
        end
    end

    SetIndicatorColor(1, Reactor1)
    SetIndicatorColor(2, Reactor2)
    SetIndicatorColor(3, Reactor3)
    SetIndicatorColor(4, Reactor4)
    SetIndicatorColor(5, Reactor5)
    SetIndicatorColor(6, Reactor6)
end

-------------------------------------------------------
-- Main loop
-------------------------------------------------------
function DoLoop()

    ShowReportTemplate()
    ShowPowerInfo()
    CheckReactorStatusBasedonSwitches()
    --TurnOnReactorDurinNight()
    --TurnReactorOnWhenBatteryLow()

    FluidStorage(45, 14, WaterTankReactor, "large")
    FluidStorage(45, 15, WaterTank2, "large")
    ShowStorageInfo(45, 8, FuelRodStorage, "large")
    ShowStorageInfo(85, 11, NuclearWasteStorage, "large")

    ReactorStatus(63, 13, Reactor1)
    ReactorStatus(65, 13, Reactor2)
    ReactorStatus(67, 13, Reactor3)
    ReactorStatus(69, 13, Reactor4)
    ReactorStatus(71, 13, Reactor5)
    ReactorStatus(73, 13, Reactor6)

    --SendDataViaFile()
    
    ---------------------------------------------------
    -- safer circuit access
    ---------------------------------------------------

    local remainingPower = circuit.capacity - circuit.consumption

    ---------------------------------------------------
    -- safer inventory access
    ---------------------------------------------------
    local fabricCount = 0

    if FabricStorage then
        local invs = FabricStorage:getInventories()
        local inv = invs and invs[1]
        fabricCount = inv and (inv.ItemCount or 0) or 0
    end

    if fabricCount < 4000 then
        if FuelRefPowerSwitch then
            FuelRefPowerSwitch:setIsSwitchOn(true)
        end
    else
        if FuelRefPowerSwitch then
            FuelRefPowerSwitch:setIsSwitchOn(false)
        end
    end
        
    gpu:flush()
    event.pull(1)
end
