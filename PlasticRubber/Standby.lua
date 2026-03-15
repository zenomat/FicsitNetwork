function StartStopMachines(standby)
	standByMode = standby
	for x = 1, 5 do						
		refineries[1][x].standby = standByMode -- nothing
		refineries[2][x].standby = standByMode -- nothing
		refineries[3][x].standby = standByMode -- nothing
		refineries[4][x].standby = standByMode -- nothing
	end
end	