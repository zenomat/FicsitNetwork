function PrintDebugInfo(message, debug)
	if (debug == true) then
		print(message)
	end
end

function LoadComponent(componentName, debug)
	PrintDebugInfo("Loading component: " .. componentName, debug)
	local temp = component.proxy(component.findComponent(componentName)[1])		
	return temp
end

function Initialization(debug)				
	gpu = computer.getPCIDevices(classes.GPUT1)[1]
	screen = component.proxy(component.findComponent("Screen3")[1])

	TankSulfurLarge = component.proxy(component.findComponent("TankSulfurLarge")[1])
	UraniumBlender_UraniumStorage = component.proxy(component.findComponent("UraniumBlender_UraniumStorage")[1])
	UraniumBlender_ConcreteStorage = component.proxy(component.findComponent("UraniumBlender_ConcreteStorage")[1])

	UraniumBlender11 = component.proxy(component.findComponent("UraniumBlender11")[1])
	UraniumBlender12 = component.proxy(component.findComponent("UraniumBlender12")[1])
	UraniumBlender13 = component.proxy(component.findComponent("UraniumBlender13")[1])

	TankSulfurSmall = component.proxy(component.findComponent("TankSulfurSmall")[1])
	
	-- Manufacturer machines
	Man1Storage1 = LoadComponent("Man1Storage1", debug)
	Man1Storage2 = LoadComponent("Man1Storage2", debug)
	Man1Storage3 = LoadComponent("Man1Storage3", debug)
	
	Man1Uranium = LoadComponent("Man1Uranium", debug)
	Man2Uranium = LoadComponent("Man2Uranium", debug)
	Man3Uranium = LoadComponent("Man3Uranium", debug)

	ManFinishedGoods  = LoadComponent("ManFinishedGoods", debug)
	
	-- setup gpu
	gpu:bindScreen(screen)
	w,h = gpu:getSize()

	PrintDebugInfo("GPU: " .. tostring(gpu) .. "; Screen: " .. tostring(screen), debug)
end
	
function ReadFileFromGithub(pathToFile, debug)
	setupDebug = debug
	-- get library from internet
	PrintDebugInfo("Loading file: " .. pathToFile, debug)
	
	local req = card:request(pathToFile, "GET", "")
	local _, libdata = req:await()

	local fileName = removeUpToLastSlash(pathToFile)	
	
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

function removeUpToLastSlash(inputString)
    -- Find the position of the last "/"
    local lastSlashPosition = inputString:match(".*()/")
    
    if lastSlashPosition then
        -- Return the substring after the last "/"
        return inputString:sub(lastSlashPosition + 1)
    else
        -- If no "/" is found, return the original string
        return inputString
    end
end


function LoadFiles(debug)
	--loading and executing all LUA files
	ReadFileFromGithub("http://localhost/LuaCode/UraniumFactory/globalVariables.lua", debug)
	ReadFileFromGithub("http://localhost/LuaCode/CommonFunctions/ScreenFunctions.lua", debug)
	ReadFileFromGithub("http://localhost/LuaCode/UraniumFactory/ReportTemplate.lua", debug)
	ReadFileFromGithub("http://localhost/LuaCode/CommonFunctions/StorageContainerInfo.lua", debug)
	ReadFileFromGithub("http://localhost/LuaCode/CommonFunctions/MachineProgress.lua", debug)
	ReadFileFromGithub("http://localhost/LuaCode/CommonFunctions/FluidStorage.lua", debug)		
		
	ReadFileFromGithub("http://localhost/LuaCode/UraniumFactory/MainLoop.lua", debug)	
end	