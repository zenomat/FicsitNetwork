function GetLocalTime()
    local time = computer.time()
    local totalSeconds = math.floor(time)
    local hours = math.floor(totalSeconds / 3600) % 24
    local minutes = math.floor(totalSeconds / 60) % 60
    local seconds = totalSeconds % 60
    
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function DoLoop()		
    localTime = GetLocalTime()   	

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
            Splitter_Silica1:transferItem(0)
            event.pull(0.1)	
            Splitter_Silica1:transferItem(1)	
            event.pull(0.1)	
            Splitter_Silica1:transferItem(2)
            event.pull(0.1)	
            SetIndicatorLight(splitter1Indicator, true) 
			lastLog = lastLog .. " - splitter 1 on"
			PrintDebugInfo(lastLog, debug)
        else
            SetIndicatorLight(splitter1Indicator, false) 
			lastLog = lastLog .. " - splitter 1 off"
			PrintDebugInfo(lastLog, debug)
        end

        if x2 < 1000 then
            Splitter_Silica2:transferItem(0)
            event.pull(0.1)	
            Splitter_Silica2:transferItem(1)	
            event.pull(0.1)	
            Splitter_Silica2:transferItem(2)
            event.pull(0.1)	
            SetIndicatorLight(splitter2Indicator, true) 
			lastLog = lastLog .. " - splitter 2 on"
			PrintDebugInfo(lastLog, debug)
        else
            SetIndicatorLight(splitter2Indicator, false) 
			lastLog = lastLog .. " - splitter 2 off"
			PrintDebugInfo(lastLog, debug)
        end
        
	else
		event.pull(1)	
        SetIndicatorLight(splitter1Indicator, false)
        SetIndicatorLight(splitter2Indicator, false) 
	end
	
    silicaStorageInfo.text = "Silica Storage: " .. 
        "\n" .. "S1: " .. tostring(x1) ..
        "\n" .. "S2: " .. tostring(x2) ..
		"\n" .. lastLog
		
end