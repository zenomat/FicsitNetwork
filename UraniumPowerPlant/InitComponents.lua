local fs = filesystem
local card = nil
local disk_uuid = nil

-------------------------------------------------------
-- Debug
-------------------------------------------------------
function PrintDebugInfo(message, debug)
    if debug == true then
        print(message)
    end
end

-------------------------------------------------------
-- Disk mount (ONE TIME)
-------------------------------------------------------
function InitDrive()
    PrintDebugInfo("Initializing disk...", true)
    fs.initFileSystem("/dev")

    for _, drive in pairs(fs.children("/dev")) do
        disk_uuid = drive
        break
    end

    if not disk_uuid then
        computer.panic("No disk found")
    end

    fs.mount("/dev/" .. disk_uuid, "/")
    PrintDebugInfo("Disk mounted: " .. disk_uuid, true)
end

-------------------------------------------------------
-- Safe component loader
-------------------------------------------------------
function LoadComponent(componentName, debug)
    PrintDebugInfo("Loading component: " .. componentName, debug)

    local found = component.findComponent(componentName)
    if not found or not found[1] then
        computer.panic("Component not found: " .. componentName)
    end

    return component.proxy(found[1])
end

-------------------------------------------------------
-- Initialization
-------------------------------------------------------
function Initialization(debug)

    gpu = computer.getPCIDevices(classes.GPUT1)[1]
    screen = LoadComponent("Screen2", debug)

    FuelRodStorage = LoadComponent("FuelRodStorage", debug)
    Reactor1 = LoadComponent("Reactor1", debug)
    Reactor2 = LoadComponent("Reactor2", debug)
    Reactor3 = LoadComponent("Reactor3", debug)
    Reactor4 = LoadComponent("Reactor4", debug)
    Reactor5 = LoadComponent("Reactor5", debug)
    Reactor6 = LoadComponent("Reactor6", debug)

    WaterTankReactor = LoadComponent("WaterTankReactor", debug)
    WaterTank2 = LoadComponent("WaterTank2", debug)
    PowerInfo = LoadComponent("PowerInfo", debug)
    NuclearWasteStorage = LoadComponent("NuclearWasteStorage", debug)

    FuelRef1 = LoadComponent("FuelRef1", debug)
    FuelRef2 = LoadComponent("FuelRef2", debug)
    FuelRef3 = LoadComponent("FuelRef3", debug)
    FuelRef4 = LoadComponent("FuelRef4", debug)
    FuelRef5 = LoadComponent("FuelRef5", debug)
    FuelRefPowerSwitch = LoadComponent("FuelRefPowerSwitch", debug)
    FabricStorage = LoadComponent("FabricStorage", debug)

    PrintDebugInfo("Loading panel...", debug)
    panel = LoadComponent("Panel2", debug)
    PrintDebugInfo("panel: " .. tostring(panel), debug)

    dsp1 = panel:getModule(2, 9, 0)
    dsp2 = panel:getModule(3, 9, 0)
    dsp3 = panel:getModule(4, 9, 0)
    dsp4 = panel:getModule(5, 9, 0)

    --modular = LoadComponent("ModularIndicatorPole", debug)

    gpu:bindScreen(screen)
    w, h = gpu:getSize()

    PrintDebugInfo("GPU: " .. tostring(gpu) .. "; Screen: " .. tostring(screen), debug)

    con = PowerInfo:getPowerConnectors()[1]
    circuit = con:getCircuit()

    PrintDebugInfo("Finished loading components", debug)
end

-------------------------------------------------------
-- Download and load files (FIXED)
-------------------------------------------------------
function ReadFileFromGithub(pathToFile, debug)

    --PrintDebugInfo("Loading file: " .. pathToFile, debug)

    -- ensure internet card exists
    if not card then
        card = computer.getPCIDevices(classes.FINInternetCard)[1]
        if not card then
            computer.panic("No Internet Card found")
        end
    end

    local req = card:request(pathToFile, "GET", "")
    local _, libdata = req:await()

    if not libdata then
        PrintDebugInfo("Download failed: " .. pathToFile, debug)
        return
    end

    local fileName = removeUpToLastSlash(pathToFile)

    local file = fs.open(fileName, "w")
    file:write(libdata)
    file:close()

    fs.doFile(fileName)

    PrintDebugInfo("File loaded successfully: " .. fileName, debug)
end

-------------------------------------------------------
-- Helper
-------------------------------------------------------
function removeUpToLastSlash(inputString)
    local lastSlashPosition = inputString:match(".*()/")
    if lastSlashPosition then
        return inputString:sub(lastSlashPosition + 1)
    end
    return inputString
end

-------------------------------------------------------
-- Load modules
-------------------------------------------------------
function LoadFiles(debug)

    InitDrive()  -- mount disk ONCE
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/StorageContainerInfo.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/UraniumPowerPlant/globalVariables.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/ScreenFunctions.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/UraniumPowerPlant/PowerInfo.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/UraniumPowerPlant/ReportTemplate.lua", debug)    
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/MachineProgress.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/FluidStorage.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/GeneralInfo.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/UraniumPowerPlant/Indicators.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/UraniumPowerPlant/MainLoop.lua", debug)
    
    --ReadFileFromGithub("http://192.168.10.106/LuaCode/UraniumPowerPlant/WebAppDataSender.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/UraniumPowerPlant/FileDataSender.lua", debug)
end
