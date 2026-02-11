function PrintDebugInfo(message, debug)
	if (debug == true) then
		print(message)
	end
end

function Initialization(debug)				
	gpu = computer.getPCIDevices(classes.GPUT1)[1]
	screen = component.proxy(component.findComponent("Screen2")[1])

	WaterStorageSulfur = component.proxy(component.findComponent("WaterStorageSulfur")[1])
	StorageSulfur = component.proxy(component.findComponent("StorageSulfur")[1])

	SulfurRef1 = component.proxy(component.findComponent("SulfurRef1")[1])
	SulfurRef2 = component.proxy(component.findComponent("SulfurRef2")[1])
	SulfurRef3 = component.proxy(component.findComponent("SulfurRef3")[1])
	SulfurRef4 = component.proxy(component.findComponent("SulfurRef4")[1])
	SulfurRef5 = component.proxy(component.findComponent("SulfurRef5")[1])

	TankSulfuricAcid = component.proxy(component.findComponent("TankSulfuricAcid")[1])
	StorageAlumCasingBlender  = component.proxy(component.findComponent("StorageAlumCasingBlender")[1])

	BlenderBat1 = component.proxy(component.findComponent("BlenderBat1")[1])
	BlenderBat2 = component.proxy(component.findComponent("BlenderBat2")[1])
	BlenderBat3 = component.proxy(component.findComponent("BlenderBat3")[1])

	BlenderBat21 = component.proxy(component.findComponent("BlenderBat21")[1])
	BlenderBat22 = component.proxy(component.findComponent("BlenderBat22")[1])
	BlenderBat23 = component.proxy(component.findComponent("BlenderBat23")[1])

	StorageBattery = component.proxy(component.findComponent("StorageBattery")[1])
	TankWaterBlender = component.proxy(component.findComponent("TankWaterBlender")[1])

	RefAlumSol21 = component.proxy(component.findComponent("RefAlumSol21")[1])
	RefAlumSol22 = component.proxy(component.findComponent("RefAlumSol22")[1])
	RefAlumSol23 = component.proxy(component.findComponent("RefAlumSol23")[1])
	RefAlumSol24 = component.proxy(component.findComponent("RefAlumSol24")[1])
	RefAlumSol25 = component.proxy(component.findComponent("RefAlumSol25")[1])

	AlumSolTank2Small = component.proxy(component.findComponent("AlumSolTank2Small")[1])
	AlumSolTank2Large = component.proxy(component.findComponent("AlumSolTank2Large")[1])

	DronePortBattery = component.proxy(component.findComponent("DronePortBattery")[1])

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
	ReadFileFromGithub("http://localhost/LuaCode/AlumFactory2/globalVariables.lua", debug)
	ReadFileFromGithub("http://localhost/LuaCode/CommonFunctions/ScreenFunctions.lua", debug)
	ReadFileFromGithub("http://localhost/LuaCode/AlumFactory2/ReportTemplate.lua", debug)
	ReadFileFromGithub("http://localhost/LuaCode/CommonFunctions/StorageContainerInfo.lua", debug)
	ReadFileFromGithub("http://localhost/LuaCode/CommonFunctions/MachineProgress.lua", debug)
	ReadFileFromGithub("http://localhost/LuaCode/CommonFunctions/FluidStorage.lua", debug)		
		
	ReadFileFromGithub("http://localhost/LuaCode/AlumFactory2/MainLoop.lua", debug)	
end	