-------------------------------------------------------
-- Globals
-------------------------------------------------------
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
-- Mount Disk (modern FN safe)
-------------------------------------------------------
function InitDrive()

    fs.initFileSystem("/dev")  -- DO NOT check return value

    for _, drive in pairs(fs.children("/dev")) do
        disk_uuid = drive
        break
    end

    if not disk_uuid then
        computer.panic("No disk found in /dev")
    end

    fs.mount("/dev/" .. disk_uuid, "/")
end

-------------------------------------------------------
-- Safe Component Loader
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
    if not gpu then
        computer.panic("GPU not found")
    end
	
	PrintDebugInfo("Screen initialization started", debug)
    screen = LoadComponent("ScreenUraniumFuelRod", debug)
	PrintDebugInfo("Sceen: " .. tostring(screen), debug)

    TankSulfurLarge = LoadComponent("TankSulfurLarge", debug)
    UraniumBlender_UraniumStorage = LoadComponent("UraniumBlender_UraniumStorage", debug)
    UraniumBlender_ConcreteStorage = LoadComponent("UraniumBlender_ConcreteStorage", debug)

    UraniumBlender11 = LoadComponent("UraniumBlender11", debug)
    UraniumBlender12 = LoadComponent("UraniumBlender12", debug)
    UraniumBlender13 = LoadComponent("UraniumBlender13", debug)

    TankSulfurSmall = LoadComponent("TankSulfurSmall", debug)

    -- Manufacturer machines
    Man1Storage1 = LoadComponent("Man1Storage1", debug)
    Man1Storage2 = LoadComponent("Man1Storage2", debug)
    Man1Storage3 = LoadComponent("Man1Storage3", debug)

    Man1Uranium = LoadComponent("Man1Uranium", debug)
    Man2Uranium = LoadComponent("Man2Uranium", debug)
    Man3Uranium = LoadComponent("Man3Uranium", debug)

    ManFinishedGoods = LoadComponent("ManFinishedGoods", debug)

    gpu:bindScreen(screen)
    w, h = gpu:getSize()

    PrintDebugInfo("GPU and Screen initialized", debug)
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
-- Download + Execute File (modern FN safe)
-------------------------------------------------------
function ReadFileFromGithub(pathToFile, debug)

    PrintDebugInfo("Loading file: " .. pathToFile, debug)

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

    PrintDebugInfo("Loaded: " .. fileName, debug)
end

-------------------------------------------------------
-- Load Modules
-------------------------------------------------------
function LoadFiles(debug)

    InitDrive()  -- mount disk once

    ReadFileFromGithub("http://192.168.10.106/LuaCode/UraniumFactory/globalVariables.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/ScreenFunctions.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/UraniumFactory/ReportTemplate.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/StorageContainerInfo.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/MachineProgress.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/FluidStorage.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/UraniumFactory/MainLoop.lua", debug)
end
