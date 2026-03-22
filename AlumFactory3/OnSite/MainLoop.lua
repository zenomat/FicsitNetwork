function GetLocalTime()
    local time = computer.time()
    local totalSeconds = math.floor(time)
    local hours = math.floor(totalSeconds / 3600) % 24
    local minutes = math.floor(totalSeconds / 60) % 60
    local seconds = totalSeconds % 60
    
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function DoLoop()		    
	lastLog = GetLocalTime() .. " onSite"
	line2text = "L2"

	alum1 = ReturnPercentFluidStorage(AlumSolSmall, "small")
	alum2 = ReturnPercentFluidStorage(AlumSol2Small, "small")
	
	water1 = ReturnPercentFluidStorage(WaterSmall, "small")	
	water2 = ReturnPercentFluidStorage(Water2Small, "small")

    SetGaugePercent(alumSolGauge1, alum1) 
    SetGaugePercent(alumSolGauge2, alum2)
    SetGaugePercent(waterGauge1, water1) 
    SetGaugePercent(waterGauge2, water2)

    x1 = GetStorageInfo(Storage_Silica1, "large")
    x2 = GetStorageInfo(Storage_Silica2, "large")


	-- Check storage. If <1000, open splitter to fill up. If >1000, close splitter to stop filling.
	if x1 < 1000 or x2 < 1000 then
		if x1 < 1000 then
			SetIndicatorLight(splitter1Indicator, true) 			
		else
			SetIndicatorLight(splitter1Indicator, false) 
		end

		if x2 < 1000 then
			SetIndicatorLight(splitter2Indicator, true) 
		else
			SetIndicatorLight(splitter2Indicator, false) 				
		end
	else		
		SetIndicatorLight(splitter1Indicator, false)
		SetIndicatorLight(splitter2Indicator, false) 
	end
	
	-- Line 2
	l2StorageScrap = GetStorageInfo(L2_StorageScrap, "large")
	l2StorageSilica = GetStorageInfo(L2_StorageSilica, "large")			
	alumIgnotStorage = GetStorageInfo(AlumIgnotStorage, "large")					
	
	if (L2_PowerSwitch.isSwitchOn) then
		line2text = line2text .. " is ON"
	else
		line2text = line2text .. " is OFF"
	end

	line2Info.text = "Line 2 info: " ..
		"\n" .. "AlScr: " .. tostring(l2StorageScrap) .. " Slc: " .. tostring(l2StorageSilica)	..
		"\n" .. "AlumIgnot: " .. tostring(alumIgnotStorage) ..
		"\n" .. line2text		

	
    silicaStorageInfo.text = "Silica Storage: " .. 
        "\n" .. "S1: " .. tostring(x1) ..
        "\n" .. "S2: " .. tostring(x2) ..
		"\n" .. lastLog

	event.pull(1)		
	print(lastLog)
end