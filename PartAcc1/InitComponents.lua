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

    screen = LoadComponent("Screen2_PartAcc", debug)    
    Storage_PartAccCopperPowder = LoadComponent("Storage_PartAccCopperPowder", debug)
    Storage_PartAccPressureCube = LoadComponent("Storage_PartAccPressureCube", debug)    
    Storage_PartReactorFinishedGood = LoadComponent("Storage_PartReactorFinishedGood", debug)
    
    PartAcc1 = LoadComponent("PartAcc1", debug)
    PartAcc2 = LoadComponent("PartAcc2", debug)   

    reactors[1] = LoadComponent("Reactor1", debug)
    reactors[2] = LoadComponent("Reactor2", debug)
    reactors[3] = LoadComponent("Reactor3", debug)
    reactors[4] = LoadComponent("Reactor4", debug)
    reactors[5] = LoadComponent("Reactor5", debug)
    reactors[6] = LoadComponent("Reactor6", debug)    
    
    PowerInfo = LoadComponent("PowerInfoPartAcc", debug)

    PrintDebugInfo("Loading panel...", debug)
    panel = LoadComponent("Panel2_PartAcc", debug)
    PrintDebugInfo("panel: " .. tostring(panel), debug)

    panelText = panel:getModule(3, 9, 0)
    pontentiomere = panel:getModule(3, 8, 0)
    canProduceLight = panel:getModule(3, 7, 0)
	enoughPowerLight = panel:getModule(3, 6, 0)
	onOffLight = panel:getModule(4, 5, 0)
	
	onOffSwitch = panel:getModule(3, 5, 0)
	panelStatus = panel:getModule(3, 3, 0)
	
    panelText.size = 20
	panelStatus.size = 20

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
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/MachineProgress.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/FluidStorage.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/GeneralInfo.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/ScreenFunctions.lua", debug)    

    ReadFileFromGithub("http://192.168.10.106/LuaCode/PartAcc1/ReportTemplate.lua", debug)    
    ReadFileFromGithub("http://192.168.10.106/LuaCode/PartAcc1/MainLoop.lua", debug)    
    ReadFileFromGithub("http://192.168.10.106/LuaCode/PartAcc1/PowerInfo.lua", debug)  
    ReadFileFromGithub("http://192.168.10.106/LuaCode/PartAcc1/globalVariables.lua", debug)
end


function InitScreen()
	-- setup gpu
	gpu:bindScreen(screen)
	w,h = gpu:getSize()
	print("Screen resolution: " .. tostring(w) .. " x " .. tostring(h))
		
	-- clean screen
	gpu:setBackground(0,0,0,0)
	gpu:fill(0,0,w,h," ")
	gpu:flush()
end
