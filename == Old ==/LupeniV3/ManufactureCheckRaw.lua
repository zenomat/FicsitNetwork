switch = component.proxy(component.findComponent("PowerSwitch")[1])

man1 = component.proxy(component.findComponent("Man1")[1])
ingredients = man1:getRecipe():getIngredients()
storage1 = component.proxy(component.findComponent("Storage1"))
storage2 = component.proxy(component.findComponent("Storage2"))
storage3 = component.proxy(component.findComponent("Storage3"))
containerInvs = {}
local gpu = computer.getPCIDevices(classes.GPUT1)[1]
local screen = component.proxy(component.findComponent("Screen1")[1])

local receiptMatrix = {}

function InitScreen()
	-- setup gpu
	gpu:bindScreen(screen)
	w,h = gpu:getSize()
	print(w, h)
		
	-- clean screen
	gpu:setBackground(0,0,0,0)
	gpu:fill(0,0,w,h," ")
	gpu:flush()
end

function ShowMsg(x, y, msg)
	gpu:setText(x, y, msg)
end

function ReadIngridients(manufacturer)
	i = 1
	posy = 5
	ShowMsg(5, 1, "Producing: " .. man1:getRecipe().name)
	ShowMsg(5, 3, "Ingridients:")
	
	for i, ingredient in ipairs(ingredients) do		
		ShowMsg(5, posy, ingredient.type.name .. " - Quantity: " .. ingredient.amount)
		posy = posy + 1
		-- create ingridient matrix
		receiptMatrix[i] = {ingredient.type.name, ingredient.amount}
		i = i + 1;
	end
	
	gpu:flush()
end

function ItemCount(containers, x, y, name)
	value = 0
	content = ""
	enoughRaw = false
	enoughRawString = "Enough for prod"
	
	for _,container in pairs(containers) do
    	containerInvs[container] = container:getInventories()[1]
	    value = (containerInvs[container].ItemCount)		
		if (containerInvs[container]:getStack(0).item.type ~= nil) then  		    
			content = containerInvs[container]:getStack(0).item.type.name 
		end
	end
				
	--check if we have enough raw material in storage
	if (value ~= 0 ) then
		for i = 1, #receiptMatrix do
		    for j = 1, 2 do
	    	    if (receiptMatrix[i][1] == content and value > tonumber(receiptMatrix[i][2])) then
	    	    	enoughRaw = true
	    	    	break
	    	    end    	    	
		    end
		end
	end

	if (enoughRaw == true) then
		enoughRawString = "Enough for prod"
	else
		enoughRawString = "NOT Enough for prod"
	end

	ShowMsg(x, y, name)
	if (value == 0 ) then
		ShowMsg(x, y + 1, "Empty" .. " -> " .. enoughRawString)
	else
		ShowMsg(x, y + 1, content .. " -> " .. tostring(value) .. " - " ..enoughRawString )
	end		

	gpu:flush()
	return enoughRaw
end

InitScreen()

while true do
	ReadIngridients(man1)
	enough1 = ItemCount(storage1, 5, 10, "Storage1")
	enough2 = ItemCount(storage2, 5, 13, "Storage2")
	enough3 = ItemCount(storage3, 5, 16, "Storage3")
	event.pull(1)

	if (enough1 == true and enough2 == true and enough3 == true) then
		ShowMsg(5, 20, "Production - Running")
		switch:setIsSwitchOn(true)
	else
		ShowMsg(5, 20, "Production - Stopped")
		switch:setIsSwitchOn(false)
	end
	
	gpu:flush()
end

