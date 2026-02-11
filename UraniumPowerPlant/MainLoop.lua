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

-------------------------------------------------------
-- Main loop
-------------------------------------------------------
function DoLoop()

    ShowReportTemplate()
    ShowPowerInfo()
    CheckReactorStatus()

    FluidStorage(45, 14, WaterTankReactor, "large")
    ShowStorageInfo(45, 8, FuelRodStorage, "large")
    ShowStorageInfo(85, 11, NuclearWasteStorage, "large")

    ReactorStatus(63, 13, Reactor1)
    ReactorStatus(65, 13, Reactor2)
    ReactorStatus(67, 13, Reactor3)
    ReactorStatus(69, 13, Reactor4)

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
