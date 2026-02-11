function DoLoop()
	ShowReportTemplate()

	ShowStorageInfo(7, 6, StorageSulfur)
	FluidStorage(7, 11, WaterStorageSulfur, "large")	
	MachineStatus(26, 9, SulfurRef1)
	MachineStatus(28, 9, SulfurRef2)
	MachineStatus(30, 9, SulfurRef3)
	MachineStatus(32, 9, SulfurRef4)
	MachineStatus(34, 9, SulfurRef5)

	FluidStorage(43, 6, TankSulfuricAcid, "large")	
	ShowStorageInfo(43, 11, StorageAlumCasingBlender)

	FluidStorage(43, 15, AlumSolTank2Small, "small")	
	FluidStorage(43, 16, AlumSolTank2Large, "large")	

	MachineStatus(63, 9, BlenderBat1)
	MachineStatus(65, 9, BlenderBat2)
	MachineStatus(67, 9, BlenderBat3)
	
	MachineStatus(63, 12, BlenderBat21)
	MachineStatus(65, 12, BlenderBat22)
	MachineStatus(67, 12, BlenderBat23)

	ShowStorageInfo(80, 8, StorageBattery)
	FluidStorage(80, 14, TankWaterBlender, "small")	
	
	MachineStatus(26, 18, RefAlumSol21)
	MachineStatus(28, 18, RefAlumSol21)
	MachineStatus(30, 18, RefAlumSol21)
	MachineStatus(32, 18, RefAlumSol21)		
	MachineStatus(34, 18, RefAlumSol21)	
	
	ShowMsg(80,23, DronePortBattery:getInventories()[1].itemCount)
	
	gpu:flush()
	event.pull(1)		
end