local disk_uuid
local fs = filesystem

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
    
    if fs.exists(fileName) then
        local program = fs.open(fileName, "r")
        if program then
            fs.doFile(fileName)
        else
            print("Failed to open the file: " .. fileName)
        end
    else
        print("File does not exist: " .. fileName)
    end
end

InitDrive()

LoadFile("//initComponents.lua")
LoadFile("//globalVariables.lua")
LoadFile("//ScreenFunctions.lua")
LoadFile("//CreateBom.lua")
LoadFile("//StorageInfo.lua")
LoadFile("//EnoughRawInMan.lua")
LoadFile("//WokingConditions.lua")
LoadFile("//NetSend.lua")
LoadFile("//ScreenTimeout.lua")
LoadFile("//FinishedGoodsStorage.lua")

InitScreen()

debugMode = false

while true do
	CreateBomMatrix(man1)

	raw1 = CheckEnoughRawInMan(man1, "Manufacturer 1", 5, 13)
	raw2 = CheckEnoughRawInMan(man2, "Manufacturer 2", 40, 13)
	raw3 = CheckEnoughRawInMan(man3, "Manufacturer 3", 80, 13)

	st1 = ItemCount(storage1, 5, 22, "Storage1")
	st2 = ItemCount(storage2, 5, 24, "Storage2")
	st3 = ItemCount(storage3, 5, 26, "Storage3")
	
	local fillpercent = ShowFinishedGoodsStatus(finishedGoods, 40, 22, "Finished goods")
	
	-- Conditions:
	StatusCheck()
		
	-- set message to send to server
	SendMessageToServer(fillpercent)
	
	-- Screen Timeout
	CheckScreenTimeOut()
	
	gpu:flush()		
	event.pull(1)	
end