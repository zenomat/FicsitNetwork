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
    print("manualControlSwitchState: " .. tostring(manualControlSwitch.State))    

    if manualControlSwitch.State == false then
        print("switches[1].state: " .. tostring(switches[1].state))

        ReactorArray[1].standby = not switches[1].state
        ReactorArray[2].standby = not switches[1].state
        
        ReactorArray[3].standby = not switches[2].state
        ReactorArray[4].standby = not switches[2].state

        ReactorArray[5].standby = not switches[3].state
        ReactorArray[6].standby = not switches[3].state

        ReactorArray[7].standby = not switches[4].state
        ReactorArray[8].standby = not switches[4].state

        ReactorArray[9].standby = not switches[5].state
        ReactorArray[10].standby = not switches[5].state

        ReactorArray[11].standby = not switches[6].state
        ReactorArray[12].standby = not switches[6].state
       
        SetIndicatorColor(1, ReactorArray[1])
        SetIndicatorColor(2, ReactorArray[3])
        SetIndicatorColor(3, ReactorArray[5])
        SetIndicatorColor(4, ReactorArray[7])	
        SetIndicatorColor(5, ReactorArray[9])	
        SetIndicatorColor(6, ReactorArray[11])	
    end
    
    if manualControlSwitch.State == true then
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


function turnAllOff()
    for i = 1, 12 do 
        ReactorArray[i].standby = true
    end
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
    print("running TurnReactorOnWhenBatteryLow")
    local batteryPercentage = calculateBatteryPercentage(circuit.batteryStore, circuit.batteryCapacity)	

    if batteryPercentage < autoPowerOnPotentiometer.value then
        for i = 1, 12 do 
            ReactorArray[i].standby = false
        end
    else
        if batteryPercentage >= 95 then
            for i = 1, 12 do 
                ReactorArray[i].standby = true
            end      
        end    
    end

    SetIndicatorColor(1, ReactorArray[1])
    SetIndicatorColor(2, ReactorArray[3])
    SetIndicatorColor(3, ReactorArray[5])
    SetIndicatorColor(4, ReactorArray[7])	
    SetIndicatorColor(5, ReactorArray[9])	
    SetIndicatorColor(6, ReactorArray[11])	
end

-------------------------------------------------------
-- Main loop
-------------------------------------------------------
function DoLoop()    
    ShowReportTemplate()
    ShowPowerInfo()

    ShowStorageInfo(45, 8, FuelRodStorage, "large")
    ShowStorageInfo(95, 11, NuclearWasteStorage, "large")

    for i = 1, numberOfWaterTanks do
        --local waterTank = "ReactorWaterTank" .. tostring(i)                
        FluidStorage(45, 13 + i, WaterTankArray[i], "large")            
    end

    for i = 1, 12 do
        local xCoord = 61 + (i * 2);
        ReactorStatus(xCoord, 13, ReactorArray[i])        
    end

    CheckReactorStatusBasedonSwitches()
       
    ---------------------------------------------------
    -- safer circuit access
    ---------------------------------------------------

    local remainingPower = circuit.capacity - circuit.consumption
    
    Log("reactor 1 standby: " .. tostring(ReactorArray[1].standby))

    gpu:flush()
    event.pull(1)
end
