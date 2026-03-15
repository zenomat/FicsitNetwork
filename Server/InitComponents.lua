-------------------------------------------------------
-- Debug helpers
-------------------------------------------------------
function PrintDebugInfo(message, debug)
    if debug == true then
        print(message)
    end
end

-------------------------------------------------------
-- Component loading
-------------------------------------------------------
function LoadComponent(componentName, debug)
    PrintDebugInfo("Loading component: " .. componentName, debug)
    local comps = component.findComponent(componentName)
    if not comps or not comps[1] then
        computer.panic("Component not found: " .. componentName)
    end
    return component.proxy(comps[1])
end

-------------------------------------------------------
-- Global hardware
-------------------------------------------------------
local fs = filesystem
local card = nil

lastBroadcastTime = 0
cooldown = 1  -- seconds

swtich = nil
indicator = nil

-------------------------------------------------------
-- Initialization
-------------------------------------------------------
function Initialization(debug)
    -- GPU / Screen
    gpu = computer.getPCIDevices(classes.GPUT1)[1]
    if not gpu then
        computer.panic("No GPU found")
    end

    screen     = LoadComponent("Display1", debug)
    powerInfo  = LoadComponent("powerInfo", debug)
    sensor     = LoadComponent("SensorSign", debug)
    labelSign  = LoadComponent("HQLabelSign", debug)

    -- Network
    netcard = LoadComponent("NetCard", debug)
    print("!!Remember to use same UID for network cards around the network!!")

    -- Internet card (FIXED: was missing → card was nil)
    card = computer.getPCIDevices(classes.FINInternetCard)[1]
    if not card then
        computer.panic("No Internet Card found")
    end

    -- Column layout
    colWidthName  = 21
    colWidthMan   = 6
    colWidthQty   = 10
    colWidthOnOff = 6

    labelWidth = 15
    valueWidth = 20

    -- Power
    local con = powerInfo:getPowerConnectors()[1]
    if not con then
        computer.panic("No power connector found")
    end

    circuit = con:getCircuit()

    missingRawMaterial = {}
    screenIsClean = false

    print("Loading panel...")
    panel = LoadComponent("ServerPanel", debug)
    print("panel: " .. tostring(panel))

	switch = panel:getModule(0, 9, 0)
	indicator = panel:getModule(1, 9, 0)

	print(indicator)

end

-------------------------------------------------------
-- Download and load a file
-------------------------------------------------------
function ReadFileFromGithub(pathToFile, debug)
    PrintDebugInfo("Loading file: " .. pathToFile, debug)

    -- HTTP request
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


function openPorts(debug)
    PrintDebugInfo("Opening network ports...", debug)
    PrintDebugInfo("-------------------------------", debug)
    --netcard:open(8888)
    
    --netcard:open(1111) -- Assembler
    netcard:open(3000) -- Test Machine
    netcard:open(1112) -- Computer
    
    netcard:open(1114) -- Crystal 2
    netcard:open(1115) -- Heavy Frame
    netcard:open(1116) -- High Speed connector
    netcard:open(1117) -- Modular Engine
    netcard:open(1118) -- Super Computer
    netcard:open(1119) -- Adaptive Control Unit
    netcard:open(1120) -- Radio Control Unit
    netcard:open(1121) -- High Speed Connector 2    
    netcard:open(1124) -- Turbo Motorw 1
    netcard:open(1125) -- Turbo Motorw 2
    netcard:open(1126) -- Thermal Propulsion Rocket
    netcard:open(1127) -- Computer 2
    netcard:open(1128) -- Computer 3
    
end


-------------------------------------------------------
-- Load all modules
-------------------------------------------------------
function LoadFiles(debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/Server/ScreenFunctions.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/Server/PowerInfo.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/Server/Manufacturer.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/Server/ShowMissingRaw.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/Server/MotionSensor.lua", debug)
    ReadFileFromGithub("http://192.168.10.106/LuaCode/Server/MainLoop.lua", debug)
end
