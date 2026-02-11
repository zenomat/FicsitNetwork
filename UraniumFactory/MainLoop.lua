function DoLoop()
	ShowReportTemplate()

	FluidStorage(5, 5, TankSulfurLarge, "large")	
	ShowStorageInfo(5, 11, UraniumBlender_UraniumStorage)
	ShowStorageInfo(5, 17, UraniumBlender_ConcreteStorage)
	
	MachineStatus(25, 10, UraniumBlender11)
	MachineStatus(27, 10, UraniumBlender12)
	MachineStatus(29, 10, UraniumBlender13)

	ShowStorageInfo(43, 8, Man1Storage1, "small" )
	FluidStorage(24, 21, TankSulfurSmall, "small")	
	
	-- Uranium Fuel Cells
	
	ShowStorageInfo(43, 14, Man1Storage2, "small")
	ShowStorageInfo(43, 20, Man1Storage3, "small")
	
	MachineStatus(65, 14, Man1Uranium)
	MachineStatus(67, 14, Man2Uranium)
	MachineStatus(69, 14, Man2Uranium)
	
	ShowStorageInfo(65, 23, ManFinishedGoods)
	
	gpu:flush()
	event.pull(1)		
end