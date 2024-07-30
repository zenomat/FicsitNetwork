function DoLoop()
	CreateBomMatrix(man1)

	raw1 = CheckEnoughRawInMan(man1, "Manufacturer 1", 5, 13)
	raw2 = CheckEnoughRawInMan(man2, "Manufacturer 2", 40, 13)
	raw3 = CheckEnoughRawInMan(man3, "Manufacturer 3", 80, 13)

	st1 = ItemCount(storage1, 5, 22, "Storage1")
	st2 = ItemCount(storage2, 5, 24, "Storage2")
	st3 = ItemCount(storage3, 5, 26, "Storage3")
	st4 = ItemCount(storage4, 5, 28, "Storage4")
	
	local fillpercent, textForOverheadSign = ShowFinishedGoodsStatus(finishedGoods, 40, 22, "Finished goods")
	
	-- Conditions:
	StatusCheck()
	
	-- check missing items
	local missingItems = CheckMissingItem()
		
	-- set message to send to server
	SendMessageToServer(fillpercent, missingItems)
	
	-- Screen Timeout
	CheckScreenTimeOut()

	-- Over head sign
	BigSignText(textForOverheadSign .. " - " .. MachineStatus)			
	
	gpu:flush()		
	event.pull(1)
end