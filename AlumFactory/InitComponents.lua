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
function Initialization(debug)
    gpu = computer.getPCIDevices(classes.GPUT1)[1]
    if not gpu then
        computer.panic("No GPU found")
    end

    screen = component.proxy(component.findComponent("Screen1AlumFactory")[1])

    BauxiteStorage = component.proxy(component.findComponent("BauxiteStorage")[1])
    CoalStorage = component.proxy(component.findComponent("CoalStorage")[1])
    SilicaStorage1 = component.proxy(component.findComponent("SilicaStorage1")[1])
    SilicaStorage2 = component.proxy(component.findComponent("SilicaStorage2")[1])
    AlumCasing = component.proxy(component.findComponent("AlumCasing")[1])
    FoundryScrap1 = component.proxy(component.findComponent("FoundryScrap1")[1])
    FoundrySilica1 = component.proxy(component.findComponent("FoundrySilica1")[1])
    AlumSheet = component.proxy(component.findComponent("AlumSheet")[1])
    AlumSheet2 = component.proxy(component.findComponent("AlumSheet2")[1])
    CoperIgnot = component.proxy(component.findComponent("CoperIgnot")[1])
    AlumIgnot = component.proxy(component.findComponent("AlumIgnot")[1])
    AlumIgnotConstructorInput = component.proxy(component.findComponent("AlumIgnotConstructorInput")[1])
    AlumScrapRefinery = component.proxy(component.findComponent("AlumScrapRefinery")[1])
    CopperSheetStorage = component.proxy(component.findComponent("CopperSheetStorage")[1])
    HeatSinkStorage = component.proxy(component.findComponent("HeatSinkStorage")[1])

    IgnotSplitter = component.proxy(component.findComponent("IgnotSplitter")[1])
    SillicaSplitter1 = component.proxy(component.findComponent("SillicaSplitter1")[1])
    SillicaSplitter2 = component.proxy(component.findComponent("SillicaSplitter2")[1])

    FoundryScrap2 = component.proxy(component.findComponent("FoundryScrap2")[1])
    FoundrySilica2 = component.proxy(component.findComponent("FoundrySilica2")[1])

    Ref11 = component.proxy(component.findComponent("Ref11")[1])
    Ref12 = component.proxy(component.findComponent("Ref12")[1])
    Ref13 = component.proxy(component.findComponent("Ref13")[1])
    Ref14 = component.proxy(component.findComponent("Ref14")[1])
    Ref15 = component.proxy(component.findComponent("Ref15")[1])

    Ref21 = component.proxy(component.findComponent("Ref21")[1])
    Ref22 = component.proxy(component.findComponent("Ref22")[1])
    Ref23 = component.proxy(component.findComponent("Ref23")[1])
    Ref24 = component.proxy(component.findComponent("Ref24")[1])
    Ref25 = component.proxy(component.findComponent("Ref25")[1])

    AlumSolSmall = component.proxy(component.findComponent("AlumSolSmall")[1])
    AlumSolLarge = component.proxy(component.findComponent("AlumSolLarge")[1])

    WaterTank1 = component.proxy(component.findComponent("WaterTank1")[1])
    WaterTank21Small = component.proxy(component.findComponent("WaterTank21Small")[1])

    Foundry11 = component.proxy(component.findComponent("Foundry11")[1])
    Foundry12 = component.proxy(component.findComponent("Foundry12")[1])
    Foundry13 = component.proxy(component.findComponent("Foundry13")[1])
    Foundry14 = component.proxy(component.findComponent("Foundry14")[1])
    Foundry15 = component.proxy(component.findComponent("Foundry15")[1])
    Foundry16 = component.proxy(component.findComponent("Foundry16")[1])

    Foundry21 = component.proxy(component.findComponent("Foundry21")[1])
    Foundry22 = component.proxy(component.findComponent("Foundry22")[1])
    Foundry23 = component.proxy(component.findComponent("Foundry23")[1])
    Foundry24 = component.proxy(component.findComponent("Foundry24")[1])
    Foundry25 = component.proxy(component.findComponent("Foundry25")[1])
    Foundry26 = component.proxy(component.findComponent("Foundry26")[1])

    Assmb11 = component.proxy(component.findComponent("Assmb11")[1])
    Assmb12 = component.proxy(component.findComponent("Assmb12")[1])
    Assmb13 = component.proxy(component.findComponent("Assmb13")[1])
    Assmb14 = component.proxy(component.findComponent("Assmb14")[1])
    Assmb15 = component.proxy(component.findComponent("Assmb15")[1])

    Cons11 = component.proxy(component.findComponent("Cons11")[1])
    Cons12 = component.proxy(component.findComponent("Cons12")[1])
    Cons13 = component.proxy(component.findComponent("Cons13")[1])
    Cons14 = component.proxy(component.findComponent("Cons14")[1])
    Cons15 = component.proxy(component.findComponent("Cons15")[1])
    Cons16 = component.proxy(component.findComponent("Cons16")[1])

    AssmbHeatSink1 = component.proxy(component.findComponent("AssmbHeatSink1")[1])
    AssmbHeatSink2 = component.proxy(component.findComponent("AssmbHeatSink2")[1])
    AssmbHeatSink3 = component.proxy(component.findComponent("AssmbHeatSink3")[1])
    AssmbHeatSink4 = component.proxy(component.findComponent("AssmbHeatSink4")[1])
    AssmbHeatSink5 = component.proxy(component.findComponent("AssmbHeatSink5")[1])

    -- Setup GPU
    gpu:bindScreen(screen)
    w, h = gpu:getSize()

    PrintDebugInfo("GPU: " .. tostring(gpu) .. "; Screen: " .. tostring(screen), debug)
end

-------------------------------------------------------
-- Download and execute a file
-------------------------------------------------------
function ReadFileFromGithub(pathToFile, debug)
    PrintDebugInfo("Loading file: " .. pathToFile, debug)

    -- Ensure Internet Card exists (FIX)
    if not card then
        card = computer.getPCIDevices(classes.FINInternetCard)[1]
        if not card then
            computer.panic("No Internet Card found")
        end
    end

    local req = card:request(pathToFile, "GET", "")
    local _, libdata = req:await()

    if not libdata then
        PrintDebugInfo("Failed to download: " .. pathToFile, debug)
        return
    end

    local fileName = removeUpToLastSlash(pathToFile)

    -- Write to mounted disk (NO tmpfs anymore)
    local file = fs.open(fileName, "w")
    file:write(libdata)
    file:close()

    -- Execute file
    fs.doFile(fileName)

    PrintDebugInfo("File loaded successfully: " .. fileName, debug)
end

-------------------------------------------------------
-- Helpers
-------------------------------------------------------
function removeUpToLastSlash(inputString)
    local lastSlashPosition = inputString:match(".*()/")
    if lastSlashPosition then
        return inputString:sub(lastSlashPosition + 1)
    else
        return inputString
    end
end

-------------------------------------------------------
-- Load all modules
-------------------------------------------------------
function LoadFiles(debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/AlumFactory/globalVariables.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/ScreenFunctions.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/AlumFactory/ReportTemplate.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/StorageContainerInfo.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/MachineProgress.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/CommonFunctions/FluidStorage.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/AlumFactory/MainLoop.lua", debug)
end
