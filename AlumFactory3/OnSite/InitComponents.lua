local fs = filesystem
local card = nil
local disk_uuid = nil

onSite = true

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

function LoadRefineries(cellNo, debug)
    -- Initialize the row for this specific cell
    refineries[cellNo] = {}

    for x = 1, 5 do
        local tagName = "Cell" .. cellNo .. "_Refinery" .. x
        local findResult = component.findComponent(tagName)
        
        if findResult[1] then
            -- Store in matrix: refineries[Cell][Refinery]
            refineries[cellNo][x] = component.proxy(findResult[1])
            PrintDebugInfo("Loaded: " .. tagName, debug)
        else
            PrintDebugInfo("Missing: " .. tagName, debug)
        end
    end
end


-------------------------------------------------------
-- Initialization
-------------------------------------------------------
function Initialization(debug)
    AlumSolSmall = LoadComponent("AlumSolSmall", debug)
    AlumSol2Small = LoadComponent("AlumSol2Small", debug)
    WaterSmall = LoadComponent("WaterSmall", debug)
    Water2Small = LoadComponent("Water2Small", debug)
    Splitter_Silica1 = LoadComponent("Splitter_Silica1", debug)
    Splitter_Silica2 = LoadComponent("Splitter_Silica2", debug)    
    Storage_Silica1 = LoadComponent("Storage_Silica1", debug)
    Storage_Silica2 = LoadComponent("Storage_Silica2", debug)

	--Line2
	L2_StorageScrap = LoadComponent("L2_StorageScrap", debug)
	L2_StorageSilica = LoadComponent("L2_StorageSilica", debug)
	L2_PowerSwitch = LoadComponent("L2_PowerSwitch", debug)
	AlumIgnotStorage = LoadComponent("AlumIgnotStorage", debug)

    panel = LoadComponent("Panel_OnSite", debug) -- panel at server room

    -- AlumiumSol Tank gauges (top row)
    alumSolGauge1  = panel:getModule(3, 9, 0)
    alumSolGauge2  = panel:getModule(4, 9, 0)

    -- Water Tank gauges (second row)
    waterGauge1    = panel:getModule(3, 8, 0)
    waterGauge2    = panel:getModule(4, 8, 0)

    -- Silica Storage displays
    silicaStorageInfo = panel:getModule(3, 5, 0)

    -- Splitter knobs
    splitter1Indicator  = panel:getModule(2, 4, 0)
    splitter2Indicator  = panel:getModule(3, 4, 0)    

	--Line 2 text
	line2Info = panel:getModule(7, 8, 0)

    SetGaugeLimit(alumSolGauge1, 0.8)
    SetGaugeLimit(alumSolGauge2, 0.8)
    SetGaugeLimit(waterGauge1, 0.8)
    SetGaugeLimit(waterGauge2, 0.8)
    silicaStorageInfo.size = 25
	line2Info.size = 25

    PrintDebugInfo("Initialization complete", debug)
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
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/FluidStorage.lua", debug)    
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/StorageContainerInfo.lua", debug)    
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/ScreenFunctions.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/Gauges.lua", debug)
   
    ReadFileFromGithub("http://192.168.10.106/LuaCode/AlumFactory3/OnSite/InitComponents.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/AlumFactory3/OnSite/MainLoop.lua", debug)
end


