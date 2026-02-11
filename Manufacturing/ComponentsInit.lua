-------------------------------------------------------
-- Debug helper
-------------------------------------------------------
function PrintDebugInfo(message, debug)
    if debug == true then
        print(message)
    end
end

-------------------------------------------------------
-- Globals
-------------------------------------------------------
local fs = filesystem
local card = nil

-------------------------------------------------------
-- Initialization
-------------------------------------------------------
function Initialization(debug, clientPort)
    PortToServer = clientPort
    debugMode = debug

    print("Opening Port: " .. tostring(PortToServer))

    PrintDebugInfo("Running initialization", debug)
    PrintDebugInfo("Manufacturing machines", debug)

    -- Manufacturing machines
    man1 = component.proxy(component.findComponent("Man1")[1])
    man2 = component.proxy(component.findComponent("Man2")[1])
    man3 = component.proxy(component.findComponent("Man3")[1])
    PrintDebugInfo("Man1: " .. tostring(man1) .. " ; Man2: " .. tostring(man2) .. " ; Man3: " .. tostring(man3), debug)

    -- Storage
    PrintDebugInfo("Storage info:", debug)
    storage1 = component.proxy(component.findComponent("Storage1")[1])
    storage2 = component.proxy(component.findComponent("Storage2")[1])
    storage3 = component.proxy(component.findComponent("Storage3")[1])
    storage4 = component.proxy(component.findComponent("Storage4")[1])
    finishedGoods = component.proxy(component.findComponent("FinishedGoods")[1])

    PrintDebugInfo(
        "storage1: " .. tostring(storage1) ..
        " ; storage2: " .. tostring(storage2) ..
        " ; storage3: " .. tostring(storage3) ..
        " ; storage4: " .. tostring(storage4), debug
    )
    PrintDebugInfo("finishedGoods: " .. tostring(finishedGoods), debug)

    -- Power switch
    PrintDebugInfo("Power switch", debug)
    switch = component.proxy(component.findComponent("PowerSwitch")[1])
    PrintDebugInfo("Switch: " .. tostring(switch), debug)

    -- Screen and panel
    PrintDebugInfo("Screen and panel", debug)
    gpu = computer.getPCIDevices(classes.GPUT1)[1]
    if not gpu then
        computer.panic("No GPU found")
    end

    screen = component.proxy(component.findComponent("Screen1")[1])
    PrintDebugInfo("GPU: " .. tostring(gpu) .. "; Screen: " .. tostring(screen), debug)

    PrintDebugInfo("Switch panel", debug)
    panel = component.proxy(component.findComponent("Panel1")[1])
    led = panel:getModule(0, 0)
    debugSwitch = panel:getModule(2, 0)
    PrintDebugInfo("Panel: " .. tostring(panel), debug)

    -- Sign post
    PrintDebugInfo("Label sign (name is LabelSign)", debug)
    labelSign = component.proxy(component.findComponent("LabelSign")[1])
    PrintDebugInfo("LabelSign text: " .. labelSign:getPrefabSignData():getTextElement("Name"), debug)

    -- Network
    PrintDebugInfo("Network card (name is NetCard)", debug)
    receiverNetCard = "4F42FDEB4D29C83CB97EFF8F122814F9" -- server network card
    netcard = component.proxy(component.findComponent("NetCard")[1])
    netcard:open(8888)
    netcard:open(PortToServer)
    PrintDebugInfo("netcard: " .. tostring(netcard), debug)

    -- Internet Card (FIXED: was missing before)
    card = computer.getPCIDevices(classes.FINInternetCard)[1]
    if not card then
        computer.panic("No Internet Card found")
    end

    -- Check Recipe
    if man1:getRecipe() == nil or man2:getRecipe() == nil or man3:getRecipe() == nil then
        print("!!Recipe is NOT Set!!")
    end

    -- Init screen
    gpu:bindScreen(screen)
    w, h = gpu:getSize()
    print("Screen size: " .. tostring(w) .. " x " .. tostring(h))
end

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
-- Load all modules
-------------------------------------------------------
function LoadFiles(debug)
    ReadFileFromGithub("SoftwareVersion.lua", debug)
    print("Software Version: " .. tostring(SoftwareVersion))

    ReadFileFromGithub("ScreenFunctions.lua", debug)
    ReadFileFromGithub("globalVariables.lua", debug)
    ReadFileFromGithub("CreateBom.lua", debug)
    ReadFileFromGithub("StorageInfo.lua", debug)
    ReadFileFromGithub("EnoughRawInMan.lua", debug)
    ReadFileFromGithub("WokingConditions.lua", debug)
    ReadFileFromGithub("NetSend.lua", debug)
    ReadFileFromGithub("ScreenTimeout.lua", debug)
    ReadFileFromGithub("FinishedGoodsStorage.lua", debug)
    ReadFileFromGithub("ReportLowRaw.lua", debug)
    ReadFileFromGithub("MainLoop.lua", debug)
end
