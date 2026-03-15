function DoLoop()
    ShowReportTemplate()
    ShowStorageInfo(3, 4, BauxiteStorage, "large")
    ShowStorageInfo(54, 12, CoalStorage, "large")
    local silicaStorage = ShowStorageInfo(38, 4, SilicaStorage1, "large")
    ShowStorageInfo(92, 26, AlumCasing, "large")
    ShowStorageInfo(3, 16, FoundrySilica1, "large")
    ShowStorageInfo(3, 18, FoundryScrap1, "large")
    ShowStorageInfo(3, 25, FoundrySilica2, "large")
    ShowStorageInfo(3, 27, FoundryScrap2, "large")
    ShowStorageInfo(92, 18, AlumSheet, "large")
    ShowStorageInfo(38, 24, CoperIgnot, "large")
    local alumIgnotStorage = ShowStorageInfo(38, 17, AlumIgnot, "large")
    ShowStorageInfo(55, 27, AlumIgnotConstructorInput, "large")
    ShowStorageInfo(72, 4, AlumScrapRefinery, "large")
    ShowStorageInfo(92, 13, CopperSheetStorage, "large")
    ShowStorageInfo(108, 13, AlumSheet2, "large")
    ShowStorageInfo(108, 4, HeatSinkStorage, "large")

    MachineStatus(21, 7, Ref11)
    MachineStatus(23, 7, Ref12)
    MachineStatus(25, 7, Ref13)
    MachineStatus(27, 7, Ref14)
    MachineStatus(29, 7, Ref15)

    MachineStatus(55, 6, Ref21)
    MachineStatus(57, 6, Ref22)
    MachineStatus(59, 6, Ref23)
    MachineStatus(61, 6, Ref24)
    MachineStatus(63, 6, Ref25)

    MachineStatus(93, 7, AssmbHeatSink1)
    MachineStatus(95, 7, AssmbHeatSink2)
    MachineStatus(97, 7, AssmbHeatSink3)
    MachineStatus(99, 7, AssmbHeatSink4)
    MachineStatus(101, 7, AssmbHeatSink5)

    FluidStorage(3, 10, WaterTank1, "large")
    FluidStorage(38, 10, AlumSolSmall, "small")
    FluidStorage(38, 11, AlumSolLarge, "large")
    FluidStorage(73, 10, WaterTank21Small, "small")

    MachineStatus(22, 19, Foundry11)
    MachineStatus(24, 19, Foundry12)
    MachineStatus(26, 19, Foundry13)
    MachineStatus(28, 19, Foundry14)
    MachineStatus(30, 19, Foundry15)
    MachineStatus(32, 19, Foundry16)

    MachineStatus(22, 27, Foundry21)
    MachineStatus(24, 27, Foundry22)
    MachineStatus(26, 27, Foundry23)
    MachineStatus(28, 27, Foundry24)
    MachineStatus(30, 27, Foundry25)
    MachineStatus(32, 27, Foundry26)

    MachineStatus(55, 21, Assmb11)
    MachineStatus(57, 21, Assmb12)
    MachineStatus(59, 21, Assmb13)
    MachineStatus(61, 21, Assmb14)
    MachineStatus(63, 21, Assmb15)

    MachineStatus(73, 26, Cons11)
    MachineStatus(75, 26, Cons12)
    MachineStatus(77, 26, Cons13)
    MachineStatus(79, 26, Cons14)
    MachineStatus(81, 26, Cons15)
    MachineStatus(83, 26, Cons16)

    -- Alum ingot control
    if alumIgnotStorage > 4000 then
        if IgnotSplitter then
            IgnotSplitter:transferItem(1)
            IgnotSplitter:transferItem(1)
        end
        ShowMsg(38, 18, "SplitOn ", "green")
    else
        ShowMsg(38, 18, "SplitOff", "red")
    end

    -- Silica control

    if silicaStorage > 100 then
        ShowMsg(38, 3, "SplitOff", "red")
    else
        if SillicaSplitter1 then
            SillicaSplitter1:transferItem(1)
            SillicaSplitter1:transferItem(1)
        end

        if SillicaSplitter2 then
            SillicaSplitter2:transferItem(1)
            SillicaSplitter2:transferItem(1)
        end
        ShowMsg(38, 3, "SplitOn ", "green")
    end
    
    gpu:flush()
    event.pull(1)
end
