-- Manufacturing machines
man1 = component.proxy(component.findComponent("Man1")[1])
man2 = component.proxy(component.findComponent("Man2")[1])
man3 = component.proxy(component.findComponent("Man3")[1])

-- Storage 
storage1 = component.proxy(component.findComponent("Storage1"))
storage2 = component.proxy(component.findComponent("Storage2"))
storage3 = component.proxy(component.findComponent("Storage3"))
finishedGoods = component.proxy(component.findComponent("FinishedGoods")[1])

-- Power switch
switch = component.proxy(component.findComponent("PowerSwitch")[1])

-- Screen and panel
gpu = computer.getPCIDevices(classes.GPUT1)[1]
screen = component.proxy(component.findComponent("Screen1")[1])

panel = component.proxy(component.findComponent("Panel1")[1])
led = panel:getModule(0, 0)
debugSwitch = panel:getModule(2, 0)

-- Network High Speed connector:
receiverNetCard = "0F346D564E2140140DEE9BADA902DAD6" -- server network card
port = 1116 
netcard = component.proxy(component.findComponent("NetCard")[1])
netcard:open(port)
print("Remember to check server port. Currently is: " .. tostring(port))

-- Check Recipe
if (man1:getRecipe() == nil or man2:getRecipe() == nil or man3:getRecipe() == nil) then 
	print("Receipe is NOT Set!!")
end

-- Init screen
gpu:bindScreen(screen)
w,h = gpu:getSize()
print("Screen size : " .. w, h)


-- First run check:
--print("Running checks:")
--print("Man1: " .. tostring(man1) .. " ; Man2: " .. tostring(man2) .. " ; Man1: " .. tostring(man3))
--print("storage1: " .. tostring(storage1) .. " ; storage2: " .. tostring(storage2) .. " ; storage3: " .. tostring(storage3))
--print("finishedGoods: " .. tostring(finishedGoods))