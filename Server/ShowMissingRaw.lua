function ShowMissingRawMaterials()

	local y = 21
	ShowMsg(2, 20, "Missing raw materials:")
	
	for i, row in ipairs(missingRawMaterial) do
        ShowMsg(2, y, tostring(row[1]) .. " - " .. tostring(row[2]))
		y = y + 1
    end
	
	for i = y, 30 do
		ShowMsg(2, i, "                                                    ")
	end
end
