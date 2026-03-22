function GetLocalTime()
    local time = computer.time()
    local totalSeconds = math.floor(time)
    local hours = math.floor(totalSeconds / 3600) % 24
    local minutes = math.floor(totalSeconds / 60) % 60
    local seconds = totalSeconds % 60
    
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function DoLoop()		    
	lastLog = GetLocalTime()  
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

	if onSite == false then	
		-- Check storage. If <1000, open splitter to fill up. If >1000, close splitter to stop filling.
		if x1 < 1000 or x2 < 1000 then
			if x1 < 1000 then
				Splitter_Silica1:transferItem(0)
				event.pull(0.1)	
				Splitter_Silica1:transferItem(1)	
				event.pull(0.1)	
				Splitter_Silica1:transferItem(2)
				event.pull(0.1)	
				SetIndicatorLight(splitter1Indicator, true) 
				lastLog = lastLog .. " - SP1 on"			
			else
				SetIndicatorLight(splitter1Indicator, false) 
				lastLog = lastLog .. " - SP1 off"			
			end

			if x2 < 1000 then
				Splitter_Silica2:transferItem(0)
				event.pull(0.1)	
				Splitter_Silica2:transferItem(1)	
				event.pull(0.1)	
				Splitter_Silica2:transferItem(2)
				event.pull(0.1)	
				SetIndicatorLight(splitter2Indicator, true) 
				lastLog = lastLog .. " - SP2 on"			
			else
				SetIndicatorLight(splitter2Indicator, false) 
				lastLog = lastLog .. " - SP2 off"		
			end
			
		else
			event.pull(1)	
			SetIndicatorLight(splitter1Indicator, false)
			SetIndicatorLight(splitter2Indicator, false) 
		end
	else
		lastLog = lastLog .. " on site computer"
		event.pull(1)
	end
	
	
	-- Line 2
	l2StorageScrap = GetStorageInfo(L2_StorageScrap, "large")
	l2StorageSilica = GetStorageInfo(L2_StorageSilica, "large")			
	alumIgnotStorage = GetStorageInfo(AlumIgnotStorage, "large")					
	
	-- starting line 2 if storage is enough and missing alumn ignots
	if (l2StorageScrap > 5000 and l2StorageSilica > 500 and alumIgnotStorage < 500) then
		L2_PowerSwitch:setIsSwitchOn(true)	
		lastLog = lastLog .. "L2 On"
	end
	
	if (l2StorageScrap < 2000 or l2StorageSilica < 250 or alumIgnotStorage > 1000) then	
		L2_PowerSwitch:setIsSwitchOn(false)		
		lastLog = lastLog .. "L2 OFF"		
	end	
	
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
	
	print(lastLog)
end