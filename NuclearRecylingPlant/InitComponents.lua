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
    
	--screen = LoadComponent("NR_ScreenOnSite", debug)        
	screen = LoadComponent("NR_Screen_ControlRoom", debug)        

	NR_SulfuricAcid1 = LoadComponent("NR_SulfuricAcid1", debug)        
	NR_NitricAcid1 = LoadComponent("NR_NitricAcid1", debug)        
	NR_UraniumWaste_Blender1 = LoadComponent("NR_UraniumWaste_Blender1", debug)        
	NR_Silicon_Blender1 = LoadComponent("NR_Silicon_Blender1", debug)        
	NR_NonFisUranium_Blender1 = LoadComponent("NR_NonFisUranium_Blender1", debug)        
	NR_WaterTank_Blender1 = LoadComponent("NR_WaterTank_Blender1", debug)        

	-- Arc reactor
	NR_NuclearWaste_ArcReactor = LoadComponent("NR_NuclearWaste_ArcReactor", debug)        
	NR_ArcReactor1 = LoadComponent("NR_ArcReactor1", debug)        
	NR_ArcReactor2 = LoadComponent("NR_ArcReactor2", debug)
	NR_ArcReactor3 = LoadComponent("NR_ArcReactor3", debug)
	
	-- Assembler
	NR_PlutoniumPallet_Assmb = LoadComponent("NR_PlutoniumPallet_Assmb", debug)        
	NR_Concrete_Assmb = LoadComponent("NR_Concrete_Assmb", debug)        
	
	-- Manufacturer 1	
	Man1_Storage1 = LoadComponent("Man1_Storage1", debug)        
	Man1_Storage2 = LoadComponent("Man1_Storage2", debug)        
	Man1_Storage3 = LoadComponent("Man1_Storage3", debug)        
	Man1_Storage4 = LoadComponent("Man1_Storage4", debug)        	

	NR_Cell1_Man1 = LoadComponent("NR_Cell1_Man1", debug)        	
	NR_Cell1_Man2 = LoadComponent("NR_Cell1_Man2", debug)        	
	NR_Cell1_Man3 = LoadComponent("NR_Cell1_Man3", debug)        		 

	-- Manufacturer 2
	Man2_Storage1 = LoadComponent("Man2_Storage1", debug)        
	Man2_Storage2 = LoadComponent("Man2_Storage2", debug)        
	Man2_Storage3 = LoadComponent("Man2_Storage3", debug)        
	Man2_Storage4 = LoadComponent("Man2_Storage4", debug)        	

	NR_Cell2_Man1 = LoadComponent("NR_Cell2_Man1", debug)        	
	NR_Cell2_Man2 = LoadComponent("NR_Cell2_Man2", debug)        	
	NR_Cell2_Man3 = LoadComponent("NR_Cell2_Man3", debug)       

	-- Finished goods
	
	NR_FinishedFuelRod = LoadComponent("NR_FinishedFuelRod", debug)        	

    gpu:bindScreen(screen)
    w, h = gpu:getSize()

    PrintDebugInfo("GPU: " .. tostring(gpu) .. "; Screen: " .. tostring(screen), debug)

    PowerInfo = LoadComponent("PowerInfo", debug)
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
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/ScreenFunctions.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/MachineProgress.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/FluidStorage.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/GeneralInfo.lua", debug)
	ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/PowerInfo.lua", debug)	
	
	ReadFileFromGithub("http://192.168.10.106/LuaCode/NuclearRecylingPlant/globalVariables.lua", debug)
	ReadFileFromGithub("http://192.168.10.106/LuaCode/NuclearRecylingPlant/MainLoop.lua", debug)
	ReadFileFromGithub("http://192.168.10.106/LuaCode/NuclearRecylingPlant/ReportTemplate.lua", debug)
end
