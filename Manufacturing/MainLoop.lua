-------------------------------------------------------
-- Download and execute a file
-------------------------------------------------------
function ReadFileFromGithub(fileName, debug)
    PrintDebugInfo("Loading file: " .. fileName, debug)

    -- Ensure Internet Card exists (FIX)
    if not card then
        card = computer.getPCIDevices(classes.FINInternetCard)[1]
        if not card then
            computer.panic("No Internet Card found")
        end
    end

    local req = card:request("http://192.168.10.106/LuaCode/Manufacturing/" .. fileName, "GET", "")
    local _, libdata = req:await()

    if not libdata then
        PrintDebugInfo("Failed to download: " .. fileName, debug)
        return
    end

    local file = filesystem.open(fileName, "w")
    file:write(libdata)
    file:close()

    filesystem.doFile(fileName)

    PrintDebugInfo("File loaded successfully: " .. fileName, debug)
end
-------------------------------------------------------
-- Main loop
-------------------------------------------------------
function DoLoop()
    e, s, sender, port, message = event.pull(1)

    CreateBomMatrix(man1)

    raw1 = CheckEnoughRawInMan(man1, "Manufacturer 1", 5, 13)
    raw2 = CheckEnoughRawInMan(man2, "Manufacturer 2", 40, 13)
    raw3 = CheckEnoughRawInMan(man3, "Manufacturer 3", 80, 13)

    st1 = ItemCount(storage1, 5, 22, "Storage1")
    st2 = ItemCount(storage2, 5, 24, "Storage2")
    st3 = ItemCount(storage3, 5, 26, "Storage3")
    if numberOfContainers == 4 then
        st4 = ItemCount(storage4, 5, 28, "Storage4")
    end

    storageFillPercent, textForOverheadSign =
    ShowFinishedGoodsStatus(finishedGoods, 40, 22, "Finished goods")

    -- Conditions
    StatusCheck()

    -- Check missing items
    local missingItems = CheckMissingItem()

    -- Send to server if requested
    if e == "NetworkMessage" and message == "SendData" then
        SendMessageToServer(missingItems)
    else
        ShowMsg(50, 3, "Not sending to server ...                   ")
    end

    -- Send to server if requested
    if e == "NetworkMessage" and message == "Reboot" then
        computer.reset()
        print("Computer reset by server command.")
    end

    -- Screen timeout
    CheckScreenTimeOut()

    -- Overhead sign
    BigSignText(textForOverheadSign .. " - " .. MachineStatus)
    

    gpu:flush()

    -- Check for new version
    --CurrentSoftwareVersion = SoftwareVersion
    --print("Current Software Version: " .. tostring(CurrentSoftwareVersion))
    --ReadFileFromGithub("SoftwareVersion.lua", debugMode)
    --print("Latest Software Version: " .. tostring(SoftwareVersion))
    --if CurrentSoftwareVersion ~= SoftwareVersion then
        --print("Computer reset. New version detected: " .. SoftwareVersion)
        --computer.reset()
    --end
    ShowMsg(50, 5, "Software Version is: " .. tostring(SoftwareVersion) .. " Port: " .. tostring(PortToServer))
    --BigSignText("version: " .. tostring(SoftwareVersion))
end
