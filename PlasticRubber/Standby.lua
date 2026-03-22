function StartStopMachines(standby)
	standByMode = standby
	for i = 1, 8 do
		for x = 1, 5 do						
			refineries[i][x].standby = standByMode -- nothing
		end
	end
	
	Log("Stanby mode:" .. tostring(standby))
end	