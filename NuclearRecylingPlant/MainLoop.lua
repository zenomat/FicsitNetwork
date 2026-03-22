
function CheckRawMaterialParticleReactor()
	-- turn ON / OFF particle reactors
	if (nonFisUraniumStorage < 100) then
		NR_ArcReactor1.standby = true
		NR_ArcReactor2.standby = true
		NR_ArcReactor3.standby = true
	end

	if (nonFisUraniumStorage > 250) then
		NR_ArcReactor1.standby = false
		NR_ArcReactor2.standby = false
		NR_ArcReactor3.standby = false
	end
end

function CheckRawMaterialManufacturer()
	-- turn ON / OFF Manufacturer Cell 1
	if (encPlutMan1 < 10) then
		NR_Cell1_Man1.standby = true
		NR_Cell1_Man2.standby = true
		NR_Cell1_Man3.standby = true
	end
	
	if (encPlutMan1 > 25) then
		NR_Cell1_Man1.standby = false
		NR_Cell1_Man2.standby = false
		NR_Cell1_Man3.standby = false
	end	

	-- turn ON / OFF Manufacturer Cell 1
	if (encPlutMan2 < 5) then
		NR_Cell2_Man1.standby = true
		NR_Cell2_Man2.standby = true
		NR_Cell2_Man3.standby = true
	end
	
	if (encPlutMan2 > 20) then
		NR_Cell2_Man1.standby = false
		NR_Cell2_Man2.standby = false
		NR_Cell2_Man3.standby = false
	end	
end

-------------------------------------------------------
-- Main loop
-------------------------------------------------------
function DoLoop()    
    ShowReportTemplate()
    ShowPowerInfo()

    -- Blender
	FluidStorage(58, 6, NR_SulfuricAcid1, "large")
	FluidStorage(58, 7, NR_NitricAcid1, "large")
	ShowStorageInfo(58, 8, NR_UraniumWaste_Blender1, "large")
	ShowStorageInfo(58, 9, NR_Silicon_Blender1, "large")
	
	FluidStorage(87, 6, NR_WaterTank_Blender1, "small")
	ShowStorageInfoValue(87, 7, NR_NonFisUranium_Blender1, "large")	

	-- Arc Reactor
	ShowStorageInfo(58, 13, NR_NuclearWaste_ArcReactor, "large")		
	nonFisUraniumStorage = ShowStorageInfoValue(58, 14, NR_NonFisUranium_Blender1, "large")		
		
	MachineProgress(98, 13, NR_ArcReactor1)
	MachineProgress(106, 13, NR_ArcReactor2)
	MachineProgress(114, 13, NR_ArcReactor3)
	
	ReactorStatus(98, 14, NR_ArcReactor1)
	ReactorStatus(106, 14, NR_ArcReactor1)
	ReactorStatus(114, 14, NR_ArcReactor1)
	
	ShowStorageInfoValue(85, 13, NR_PlutoniumPallet_Assmb, "large")	
	
	-- Assembler	
	ShowStorageInfo(58, 18, NR_Concrete_Assmb, "large")	
	ShowStorageInfoValue(58, 19, NR_PlutoniumPallet_Assmb, "large")		
	
	-- Manufacturer 1	
	ShowStorageInfo(58, 23, Man1_Storage1, "small")	
	ShowStorageInfo(58, 24, Man1_Storage2, "small")	
	ShowStorageInfo(58, 25, Man1_Storage3, "small")	
	encPlutMan1 = ShowStorageInfoValue(58, 26, Man1_Storage4, "small")	

	ReactorStatus(43, 22, NR_Cell1_Man1)
	ReactorStatus(45, 22, NR_Cell1_Man1)
	ReactorStatus(47, 22, NR_Cell1_Man1)
	
	MachineProgress(47, 27, NR_Cell1_Man1)
	MachineProgress(57, 27, NR_Cell1_Man2)
	MachineProgress(67, 27, NR_Cell1_Man3)
	
	-- Manufacturer 2	
	ShowStorageInfo(96, 23, Man2_Storage1, "small")	
	ShowStorageInfo(96, 24, Man2_Storage2, "small")	
	ShowStorageInfo(96, 25, Man2_Storage3, "small")	
	encPlutMan2 = ShowStorageInfoValue(96, 26, Man2_Storage4, "small")	
	
	MachineProgress(85, 27, NR_Cell2_Man1)
	MachineProgress(95, 27, NR_Cell2_Man2)
	MachineProgress(105, 27, NR_Cell2_Man3)	

	ReactorStatus(81, 22, NR_Cell2_Man1)
	ReactorStatus(83, 22, NR_Cell2_Man2)
	ReactorStatus(85, 22, NR_Cell2_Man3)

	-- Finished goods
	ShowStorageInfoValue(23, 14, NR_FinishedFuelRod, "small")	

	-- Machine ON / OFF
	CheckRawMaterialParticleReactor()	
	CheckRawMaterialManufacturer()

    gpu:flush()
    event.pull(2)
end
