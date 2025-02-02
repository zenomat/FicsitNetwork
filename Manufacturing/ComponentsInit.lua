function PrintDebugInfo(message, debug)
	if (debug == true) then
		print(message)
	end
end

function Initialization(debug, clientPort)				
	softwareVersion = 2.0
	port = clientPort
	print("Software Version: " .. tostring(softwareVersion))
	print("Opening Port: " .. tostring(port))
	
	PrintDebugInfo("Running intializatiation", debug)
	PrintDebugInfo("Manufacturing machines", debug)

	-- Manufacturing machines
	man1 = component.proxy(component.findComponent("Man1")[1])
	man2 = component.proxy(component.findComponent("Man2")[1])
	man3 = component.proxy(component.findComponent("Man3")[1])
	PrintDebugInfo("Man1: " .. tostring(man1) .. " ; Man2: " .. tostring(man2) .. " ; Man1: " .. tostring(man3), debug)

	-- Storage 
	PrintDebugInfo("Storage info:", debug)

	storage1 = component.proxy(component.findComponent("Storage1"))
	storage2 = component.proxy(component.findComponent("Storage2"))
	storage3 = component.proxy(component.findComponent("Storage3"))
	storage4 = component.proxy(component.findComponent("Storage4"))
	finishedGoods = component.proxy(component.findComponent("FinishedGoods")[1])

	PrintDebugInfo("storage1: " .. tostring(storage1) .. " ; storage2: " .. tostring(storage2) .. " ; storage3: " .. tostring(storage3) .. " ; storage4: " .. tostring(storage4), debug)
	PrintDebugInfo("finishedGoods:" .. tostring(finishedGoods), debug)

	numberOfContainers = 4

	-- Power switch
	PrintDebugInfo("Power switch", debug)

	switch = component.proxy(component.findComponent("PowerSwitch")[1])
	PrintDebugInfo("switch: " .. tostring(switch), debug)

	-- Screen and panel
	PrintDebugInfo("Screen and panel")
	gpu = computer.getPCIDevices(classes.GPUT1)[1]
	screen = component.proxy(component.findComponent("Screen1")[1])
	PrintDebugInfo("GPU: " .. tostring(gpu) .. "; Screen: " .. tostring(screen), debug)

	panel = component.proxy(component.findComponent("Panel1")[1])
	led = panel:getModule(0, 0)
	debugSwitch = panel:getModule(2, 0)
	PrintDebugInfo("Panel: " .. tostring(panel), debug)

	-- Sign post
	labelSign = component.proxy(component.findComponent("LabelSign"))
	PrintDebugInfo("LabelSign text: " .. labelSign[1]:getPrefabSignData():getTextElement( "Name" ), debug)

	-- Network High Speed connector:
	receiverNetCard = "0F346D564E2140140DEE9BADA902DAD6" -- server network card
	netcard = component.proxy(component.findComponent("NetCard")[1])
	netcard:open(port)

	PrintDebugInfo("netcard: " .. tostring(netcard), debug)	

	-- Check Recipe
	if (man1:getRecipe() == nil or man2:getRecipe() == nil or man3:getRecipe() == nil) then 
		print("!!Receipe is NOT Set!!")
	end

	-- Init screen
	gpu:bindScreen(screen)
	w,h = gpu:getSize()
	print("Screen size : " .. w, h)
end

function ReadFileFromGithub(fileName, debug)
	setupDebug = debug
	-- get library from internet
	PrintDebugInfo("Loading file: " .. fileName, debug)
	
	local req = card:request("https://raw.githubusercontent.com/zenomat/FicsitNetwork/main/Manufacturing/" .. fileName, "GET", "")
	local _, libdata = req:await()

	-- save library to filesystem
	filesystem.initFileSystem("/dev")
	filesystem.makeFileSystem("tmpfs", "tmp")
	filesystem.mount("/dev/tmp","/")
	local file = filesystem.open(fileName, "w")
	file:write(libdata)
	file:close()

	-- load the library from the file system and use it
	local json = filesystem.doFile(fileName)
	PrintDebugInfo("File loaded successfully: " .. fileName, debug)
end

function LoadFiles(debug)
	--loading and executing all LUA files
	ReadFileFromGithub("ScreenFunctions.lua", debug)	
	ReadFileFromGithub("globalVariables.lua", debug)
	ReadFileFromGithub("ScreenFunctions.lua", debug)
	ReadFileFromGithub("CreateBom.lua", debug)
	ReadFileFromGithub("StorageInfo.lua", debug)
	ReadFileFromGithub("EnoughRawInMan.lua", debug)
	ReadFileFromGithub("WokingConditions.lua", debug)
	ReadFileFromGithub("NetSend.lua", debug)
	ReadFileFromGithub("ScreenTimeout.lua", debug)
	ReadFileFromGithub("FinishedGoodsStorage.lua", debug)
	ReadFileFromGithub("ReportLowRaw.lua", debug)
	ReadFileFromGithub("MainLoop.lua", debug)
end