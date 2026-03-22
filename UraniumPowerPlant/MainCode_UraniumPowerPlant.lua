local fs = filesystem
local serverOnLine = false
debugMode = true

local card = nil
local disk_uuid = nil

-------------------------------------------------------
-- Mount disk
-------------------------------------------------------
function InitDrive()
    -- just call it, ignore result
    fs.initFileSystem("/dev")

    for _, drive in pairs(fs.children("/dev")) do
        print("Disk UUID: " .. drive)
        disk_uuid = drive
        break
    end

    if not disk_uuid then
        computer.panic("No disk found in /dev")
    end

    fs.mount("/dev/" .. disk_uuid, "/")
end

-------------------------------------------------------
-- Download + load InitComponents
-------------------------------------------------------
function LoadInitializationFile()

    -- Internet card (FIX)
    card = computer.getPCIDevices(classes.FINInternetCard)[1]
    if not card then
        computer.panic("No Internet Card installed")
    end

    local req = card:request(
        "http://192.168.10.106/LuaCode/UraniumPowerPlant/InitComponents.lua",
        "GET",
        ""
    )

    local _, libdata = req:await()

    if not libdata then
        print("Cannot load file, server NOT online")
        return false
    end

    -- mount real disk (FIX: no tmpfs)
    InitDrive()

    -- save file
    local file = fs.open("InitComponents.lua", "w")
    file:write(libdata)
    file:close()

    -- execute
    fs.doFile("InitComponents.lua")

    return true
end

-------------------------------------------------------
-- Main
-------------------------------------------------------
serverOnLine = LoadInitializationFile()

if serverOnLine then
    LoadInitializationFile(debugMode)
    LoadFiles(debugMode)
    Initialization(debugMode)
    InitScreen()
    LoadIndicators()
    print("Loading complete")
end


while serverOnLine do
	DoLoop()
end
