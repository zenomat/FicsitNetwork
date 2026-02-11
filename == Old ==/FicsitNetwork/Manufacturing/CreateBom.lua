function CreateBomMatrix(manufacturer)
	-- read the BOM and creates the matrix
	i = 1
	posy = 5
	ShowMsg(5, 1, "Producing: " .. man1:getRecipe().name)
	ShowMsg(5, 3, "Ingridients:")
	whatAreWeProducing = man1:getRecipe().name
	
	for i, ingredient in ipairs(ingredients) do		
		ShowMsg(5, posy, ingredient.type.name .. " - Quantity: " .. ingredient.amount)
		posy = posy + 1
		-- create ingridient matrix
		bomMatrix[i] = {ingredient.type.name, ingredient.amount}
		i = i + 1;
	end
	
	gpu:flush()
end