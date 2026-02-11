man1 = component.proxy(component.findComponent("Man1")[1])

function RadInvMan()
	inv = man1:getInputInv()

	for j = 0, inv.size do
		 local stack = inv:getStack( j)
		 if stack ~= nil and stack.item ~= nil and stack.item.type ~= nil then
			print(stack.item.type.name.." "..stack.count)
		 end
	end
end