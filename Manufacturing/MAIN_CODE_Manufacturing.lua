local debugMode = true
local networkPort = 1119

local disk_uuid
local fs = filesystem

-------------------------------------------------------
-- Initialize and mount disk
-------------------------------------------------------
function InitDrive()
    if not fs.initFileSystem("/dev") then
        computer.panic("Cannot initialize /dev")
    end

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
-- Download + load initialization file
-------------------------------------------------------
function LoadInitializationFile()
    -- get internet card
    local card = computer.getPCIDevices(classes.FINInternetCard)[1]
    if not card then
        computer.panic("No Internet Card found")
    end

    print(card)

    -- fetch file
    local req = card:request("http://192.168.10.106/LuaCode/Manufacturing/ComponentsInit.lua", "GET", "")
    local _, libdata = req:await()

    if not libdata then
        computer.panic("Failed to download ComponentsInit.lua")
    end

    -- write file
    local file = fs.open("ComponentsInit.lua", "w")
    file:write(libdata)
    file:close()

    -- load the library from the file system
    fs.doFile("ComponentsInit.lua")
end

-------------------------------------------------------
-- Load a file from disk
-------------------------------------------------------
function LoadFile(fileName)
    fs.doFile(fileName)
end

-------------------------------------------------------
-- Main
-------------------------------------------------------
InitDrive()
LoadInitializationFile()
Initialization(debugMode, networkPort)
LoadFiles(debugMode)
InitScreen()
print("Loading complete")

event.listen(netcard)

while true do
    DoLoop()
end
