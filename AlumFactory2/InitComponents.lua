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
-- Mount Disk (Modern FN safe)
-------------------------------------------------------
function InitDrive()

    fs.initFileSystem("/dev")  -- do NOT check return

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
function LoadComponent(componentName)
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

    screen = LoadComponent("Screen2")

    WaterStorageSulfur = LoadComponent("WaterStorageSulfur")
    StorageSulfur = LoadComponent("StorageSulfur")

    SulfurRef1 = LoadComponent("SulfurRef1")
    SulfurRef2 = LoadComponent("SulfurRef2")
    SulfurRef3 = LoadComponent("SulfurRef3")
    SulfurRef4 = LoadComponent("SulfurRef4")
    SulfurRef5 = LoadComponent("SulfurRef5")

    TankSulfuricAcid = LoadComponent("TankSulfuricAcid")
    StorageAlumCasingBlender = LoadComponent("StorageAlumCasingBlender")

    BlenderBat1 = LoadComponent("BlenderBat1")
    BlenderBat2 = LoadComponent("BlenderBat2")
    BlenderBat3 = LoadComponent("BlenderBat3")

    BlenderBat21 = LoadComponent("BlenderBat21")
    BlenderBat22 = LoadComponent("BlenderBat22")
    BlenderBat23 = LoadComponent("BlenderBat23")

    StorageBattery = LoadComponent("StorageBattery")
    TankWaterBlender = LoadComponent("TankWaterBlender")

    RefAlumSol21 = LoadComponent("RefAlumSol21")
    RefAlumSol22 = LoadComponent("RefAlumSol22")
    RefAlumSol23 = LoadComponent("RefAlumSol23")
    RefAlumSol24 = LoadComponent("RefAlumSol24")
    RefAlumSol25 = LoadComponent("RefAlumSol25")

    AlumSolTank2Small = LoadComponent("AlumSolTank2Small")
    AlumSolTank2Large = LoadComponent("AlumSolTank2Large")

    DronePortBattery = LoadComponent("DronePortBattery")

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
-- Download + Execute File (Modern FN safe)
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

    ReadFileFromGithub("http://192.168.10.106/LuaCode/AlumFactory2/globalVariables.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/ScreenFunctions.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/AlumFactory2/ReportTemplate.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/StorageContainerInfo.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/MachineProgress.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/FluidStorage.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/AlumFactory2/MainLoop.lua", debug)
end
