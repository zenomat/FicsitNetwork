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
    print(debug)
    -- Init Components

    StorageBuffer_Rubber = LoadComponent("StorageBuffer_Rubber", debug)
    StorageBuffer_Plastic = LoadComponent("StorageBuffer_Plastic", debug)
    HeavyOilStorageSmall = LoadComponent("Storage_HeaveOil", debug)
    Storage_HeaveOil2 = LoadComponent("Storage_HeaveOil2", debug)

    sign = LoadComponent("Display1", debug)
    print(sign)

    LoadRefineries(1, debug)
    LoadRefineries(2, debug)
    LoadRefineries(3, debug)
    LoadRefineries(4, debug)

    -- Panels and buttonsc
    -- panel = LoadComponent("Panel1", debug) - panel at site
    
    panel = LoadComponent("PanelSeverRoom", debug) -- panel at server room

    -- Panel modules
    panelBufferStatus = panel:getModule(3, 9, 0)
    panelBufferStatus.size = 40
    panelProdStatus = panel:getModule(3, 7, 0)
    panelProdStatus.size = 30

    manualProdSetting = panel:getModule(3, 4, 0)
    autoManulSwtich = panel:getModule(3, 5, 0)
    autoLight = panel:getModule(0, 5, 0)
    manualLight = panel:getModule(6, 5, 0)

    heavyOilTank = panel:getModule(9, 9, 0)
    heavyOilTank2 = panel:getModule(9, 7, 0)

    -- Load all recipes from a refinery. 1 = plastic; 2 = Rubber
    print("Loading recipes")

    print(refineries[1][1])

    recipes = refineries[1][1]:getRecipes()

    manualProduction = 1 -- 1 = plastic, 2 = rubber
    
    --start with machines ON
    StartStopMachines(false)

    print("Loaded");

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

    ReadFileFromGithub("http://192.168.10.106/LuaCode/PlasticRubber/globalVariables.lua", debug)    
    ReadFileFromGithub("http://192.168.10.106/LuaCode/PlasticRubber/MainLoop.lua", debug)    
    ReadFileFromGithub("http://192.168.10.106/LuaCode/PlasticRubber/Standby.lua", debug)
   
end


