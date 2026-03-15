-------------------------------------------------------
-- File-Based Web App Data Sender
-- Writes JSON data to file for Node.js to read
-- NO HTTP - just pure file I/O
-------------------------------------------------------

local lastSendTime = 0
local sendInterval = 0.5  -- Write file every 0.5 seconds max

function SerializeToJSON(data)
    local json = "{"
    local first = true
    
    for key, value in pairs(data) do
        if not first then json = json .. "," end
        first = false
        
        if type(value) == "string" then
            json = json .. '"' .. key .. '":"' .. tostring(value) .. '"'
        elseif type(value) == "number" then
            json = json .. '"' .. key .. '":' .. tostring(value)
        elseif type(value) == "boolean" then
            json = json .. '"' .. key .. '":' .. (value and "true" or "false")
        elseif type(value) == "table" then
            if #value > 0 then
                json = json .. '"' .. key .. '":[' .. SerializeArray(value) .. ']'
            else
                json = json .. '"' .. key .. '":' .. SerializeToJSON(value)
            end
        end
    end
    
    json = json .. "}"
    return json
end

function SerializeArray(arr)
    local json = ""
    for i, item in ipairs(arr) do
        if i > 1 then json = json .. "," end
        
        if type(item) == "table" then
            json = json .. SerializeToJSON(item)
        elseif type(item) == "string" then
            json = json .. '"' .. tostring(item) .. '"'
        elseif type(item) == "number" then
            json = json .. tostring(item)
        elseif type(item) == "boolean" then
            json = json .. (item and "true" or "false")
        end
    end
    return json
end

function GetReactorData()
    local reactors = {}
    
    for i = 1, 4 do
        local reactor = _G["Reactor" .. i]
        if reactor then
            table.insert(reactors, {
                id = i,
                standby = reactor.standby,
                efficiency = reactor.standby and 0 or (math.random(80, 99))
            })
        end
    end
    
    return reactors
end

function GetStorageData(storageContainer, type)
    if not GetMaxItemsForOneStorageCell then
        print("ERROR: GetMaxItemsForOneStorageCell not found")
        return { fillPercent = 0, itemCount = 0 }
    end
    
    local itemsInFirstCell, totalCount, fillPercent = GetMaxItemsForOneStorageCell(storageContainer, type)
    
    return {
        fillPercent = math.floor(fillPercent * 100) / 100,
        itemCount = totalCount
    }
end

function GetFluidStorageData(container, maxCapacity)
    if not container then
        return { fillPercent = 0, amount = 0 }
    end
    
    local inventory = container.fluidContent or 0
    local fillPercent = (inventory * 100) / maxCapacity
    
    return {
        fillPercent = math.floor(fillPercent * 100) / 100,
        amount = math.floor(inventory * 100) / 100
    }
end

function GetLocalTime()
    local time = computer.time()
    local totalSeconds = math.floor(time)
    local hours = math.floor(totalSeconds / 3600) % 24
    local minutes = math.floor(totalSeconds / 60) % 60
    local seconds = totalSeconds % 60
    
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function GetPowerPlantData()
    local data = {
        production = 0,
        consumption = 0,
        capacity = 0,
        batteryStore = 0,
        batteryCapacity = 0,
        daysSinceLanding = math.floor(computer.time() / 60 / 60 / 24),
        localTime = GetLocalTime(),
        reactors = GetReactorData(),
        fuelRodStorage = { fillPercent = 0, itemCount = 0 },
        waterTank = { fillPercent = 0, amount = 0 },
        nuclearWaste = { fillPercent = 0, itemCount = 0 },
        fabricStorage = { fillPercent = 0, itemCount = 0 }
    }
    
    if circuit then
        data.production = math.floor(circuit.production * 100) / 100
        data.consumption = math.floor(circuit.consumption * 100) / 100
        data.capacity = math.floor(circuit.capacity * 100) / 100
        data.batteryStore = math.floor(circuit.batteryStore * 100) / 100
        data.batteryCapacity = math.floor(circuit.batteryCapacity * 100) / 100
        -- Calculate electricity left (capacity - consumption)
        data.left = math.floor((circuit.capacity - circuit.consumption) * 100) / 100
    end
    
    if FuelRodStorage then
        data.fuelRodStorage = GetStorageData(FuelRodStorage, "large")
    end
    
    if WaterTankReactor then
        data.waterTank = GetFluidStorageData(WaterTankReactor, 2400)
    end
    
    if NuclearWasteStorage then
        data.nuclearWaste = GetStorageData(NuclearWasteStorage, "large")
    end
    
    if FabricStorage then
        data.fabricStorage = GetStorageData(FabricStorage, "large")
    end
    
    return data
end

function SendDataViaFile()
    -- Rate limit: only send every N seconds
    local currentTime = computer.time()
    if (currentTime - lastSendTime) < sendInterval then
        return true  -- Skip this iteration
    end
    
    lastSendTime = currentTime
    
    local success = pcall(function()
        -- Initialize filesystem
        filesystem.initFileSystem("/dev")
        
        -- Gather data
        local data = GetPowerPlantData()
        local jsonData = SerializeToJSON(data)
        
        -- Write to file (Node.js reads this file)
        local file = filesystem.open("powerplant_data.json", "w")
        if not file then
            print("ERROR: Failed to open powerplant_data.json")
            return false
        end
        
        file:write(jsonData)
        file:close()
        
        return true
    end)
    
    if not success then
        print("ERROR: Failed to write data to file")
        return false
    end
    
    return true
end

function SendDataToWebApp(unused)
    -- Wrapper for compatibility
    return SendDataViaFile()
end
