--this is the main app that will run on server
local disk_uuid
local fs = filesystem

function LoadInitializationFile()
	-- get internet card
	card = computer.getPCIDevices(findClass("FINInternetCard"))[1]
	print(card)

	-- get library from internet
	local req = card:request("http://localhost/LuaCode/Manufacturing/ComponentsInit.lua", "GET", "")
	local _, libdata = req:await()

	-- save library to filesystem
	filesystem.initFileSystem("/dev")
	filesystem.makeFileSystem("tmpfs", "tmp")
	filesystem.mount("/dev/tmp","/")
	local file = filesystem.open("ComponentsInit.lua", "w")
	file:write(libdata)
	file:close()

	-- load the library from the file system and use it
	local json = filesystem.doFile("ComponentsInit.lua")
end

function InitDrive()
	-- Initialize /dev
	if fs.initFileSystem("/dev") == false then
	    computer.panic("Cannot initialize /dev")
	end
	-- List all the drives
	for _, drive in pairs(fs.childs("/dev")) do
    	print("Disk UUID: " .. drive)
    	print("Folder: c:\\Users\\zeno\\AppData\\Local\\FactoryGame\\Saved\\SaveGames\\Computers\\" .. drive)
	    disk_uuid = drive
	end
end

function LoadFile(fileName)
	fs.mount("/dev/".. disk_uuid, "/")
	program = fs.open(fileName, r)
	fs.doFile(fileName)
end

LoadInitializationFile()
Initialization(false, 1115)	
LoadFiles(false)
InitScreen()
print("Loading complete")


while true do
	DoLoop()
end
