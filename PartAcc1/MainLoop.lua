function ScreenFunctions()
    ShowReportTemplate()
    ShowPowerInfo()
		
	MachineStatus(52, 8, PartAcc1)
    MachineStatus(52, 11, PartAcc2)
	
    MachineProgress(59, 8, PartAcc1)
    MachineProgress(59, 11, PartAcc2)    	

	activeReactors = 0
	for i = 1, numberOfReactors do
		local x = 63 + (i - 1) * 2
		activeReactors = activeReactors + ReactorStatus(x, 13, reactors[i])		
	end		

	ShowMsg(59, 14, "itemsToProduce: " .. tostring(itemsToProduce))
	ShowMsg(59, 15, "items in stock: " .. tostring(finishedGoodsInStock))	
	ShowMsg(59, 16, "productionStartedInThisCycle: " .. tostring(productionStartedInThisCycle))
	ShowMsg(59, 17, "onOffStatus: " .. tostring(onOffStatus))
	
end

function setPanel1Text()
	panelText.text = "To Produce: " .. tostring(pontentiomere.value) .. 
		"\nfinishedGoodsInStock: " .. tostring(finishedGoodsInStock) ..
		"\nAvailable cubes: " .. tostring(pressureCubesInStock) ..
		"\nReactors online: " .. tostring(activeReactors);
	
end

-------------------------------------------------------
-- Main loop
-------------------------------------------------------
function DoLoop()	

    powderInStock = ShowStorageInfo(45, 8, Storage_PartAccCopperPowder, "large")
    pressureCubesInStock = ShowStorageInfo(45, 11, Storage_PartAccPressureCube, "large")
	finishedGoodsInStock = ShowStorageInfo(45, 14, Storage_PartReactorFinishedGood, "large")

	requiredInputPowder = (200) * pontentiomere.value
	requiredInputCubes = (1 * pontentiomere.value)	

	ehoughStock = (powderInStock >= requiredInputPowder and pressureCubesInStock >= requiredInputCubes and pontentiomere.value > 0)
		
	if ehoughStock then
		canProduceLight:setColor(0, 1, 0, 1) -- green
	else 
		canProduceLight:setColor(1, 0, 0, 1) -- red
	end
	
	if activeReactors >= 3 then
		enoughPowerLight:setColor(0, 1, 0, 1) -- green
	else 
		enoughPowerLight:setColor(1, 0, 0, 1) -- red
	end
	
	-- on / off swith button

	if (onOffSwitch.state == true and ehoughStock == false) then		
		panelStatus.text ="Can NOT produce. Not enough stock."		
		onOffStatus = 0
	end

	if (onOffSwitch.state == true and ehoughStock == true and activeReactors < 3) then		
		panelStatus.text ="Can NOT produce. Not enough power."		
		onOffStatus = 0
	end
	

	--if we have enough stock, enough power and the switch is on, we can produce
	if (onOffSwitch.state == true and ehoughStock == true and activeReactors >= 3 and onOffStatus == 0 and productionStartedInThisCycle == 0) then
		--start production		
		onOffStatus = 1
		productionStartedInThisCycle = 1
		itemsInStockToFinishProduction = pontentiomere.value + finishedGoodsInStock						
	end
	
	-- Production running 
	if (onOffStatus == 1 and onOffSwitch.state == true) then
		local remaining = itemsInStockToFinishProduction - finishedGoodsInStock

		print("itemsInStockToFinishProduction: " .. tostring(itemsInStockToFinishProduction))
		print("finishedGoodsInStock: " .. tostring(finishedGoodsInStock))
		print("remaining: " .. tostring(remaining))

		panelStatus.text = "Producing... \n" .. 
			tostring(itemsInStockToFinishProduction) .. " items to produce"	..
			"\n" .. tostring(remaining) .. " items remaining"
	end


	-- condition to stop production
	if (onOffStatus == 1 and finishedGoodsInStock >= itemsInStockToFinishProduction and productionStartedInThisCycle == 1) then
		panelStatus.text = "Production complete"
		onOffStatus = 0				
	end	

	-- condition to reset production
	if (onOffSwitch.state == false and finishedGoodsInStock >= itemsInStockToFinishProduction and productionStartedInThisCycle == 1 and onOffStatus == 0) then		
		panelStatus.text = "Machine is off."				
		productionStartedInThisCycle = 0
	end

	if (activeReactors < 3 and onOffStatus == 1) then
		panelStatus.text = "Not enough power. Stopping production."
		onOffStatus = 0
	end

	--emergency stop
	if (onOffSwitch.state == false and onOffStatus == 1) then		
		onOffStatus = 0 
		panelStatus.text = "Emergency stop. Machine is off."				
		productionStartedInThisCycle = 0
	end	

	if onOffStatus == 1 then
		onOffLight:setColor(0, 1, 0, 1) -- green
		PartAcc1.standby = false
		PartAcc2.standby = false				
	else 				
		onOffLight:setColor(1, 0, 0, 1) -- red
		PartAcc1.standby = true
		PartAcc2.standby = true		
	end

	setPanel1Text()
	ScreenFunctions()


	--get inventory from the machine itself	
	--Item_Invent  = PartAcc1:getInventories()[1]
	--Item_Stack = Item_Invent:getStack(0)

	--Cont_Size = Item_Invent.size
	--Item_StackSize = Item_Stack.count
	--print(Item_StackSize)
	
    gpu:flush()
    event.pull(1)
	
end
