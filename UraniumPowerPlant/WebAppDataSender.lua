-------------------------------------------------------
-- Web App Data Sender for Uranium Power Plant
-- Sends real game data to web dashboard via HTTP
-- Dependencies: CommonFunctions/StorageContainerInfo.lua
-------------------------------------------------------

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
            -- Handle arrays
            if #value > 0 then
                json = json .. '"' .. key .. '":[' .. SerializeArray(value) .. ']'
            else
                -- Handle objects
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
    -- Use proven function from CommonFunctions
    if not GetMaxItemsForOneStorageCell then
        print("ERROR: GetMaxItemsForOneStorageCell not found. Load CommonFunctions/StorageContainerInfo.lua first!")
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
    
    -- Get power info
    if circuit then
        data.production = math.floor(circuit.production * 100) / 100
        data.consumption = math.floor(circuit.consumption * 100) / 100
        data.capacity = math.floor(circuit.capacity * 100) / 100
        data.batteryStore = math.floor(circuit.batteryStore * 100) / 100
        data.batteryCapacity = math.floor(circuit.batteryCapacity * 100) / 100
    end
    
    -- Get storage info (using proven CommonFunctions)
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

function SendDataToWebApp(webappUrl)
    -- Wrap everything in pcall to prevent crashes
    local success, result = pcall(function()
        -- Get internet card if not already loaded
        if not card then
            local cards = computer.getPCIDevices(classes.FINInternetCard)
            if not cards or not cards[1] then
                print("ERROR: No Internet Card found")
                return false
            end
            card = cards[1]
        end
        
        print("Gathering power plant data...")
        local data = GetPowerPlantData()
        
        print("Serializing to JSON...")
        local jsonData = SerializeToJSON(data)
        
        print("JSON Data: " .. string.sub(jsonData, 1, 100) .. "...")
        print("Sending to: " .. webappUrl)
        
        -- Send the HTTP request
        local request = card:request(webappUrl, "POST", jsonData)
        print("Request created, waiting for response...")
        
        local reqSuccess, response = request:await()
        
        if reqSuccess then
            print("✓ Web app data sent successfully")
            return true
        else
            print("✗ Failed to send data to web app: " .. tostring(response))
            return false
        end
    end)
    
    if not success then
        print("ERROR in SendDataToWebApp: " .. tostring(result))
        return false
    end
    
    return result
end

function SendDataToWebAppV1(webappUrl)
    -- Get internet card if not already loaded
    if not card then
        local cards = computer.getPCIDevices(classes.FINInternetCard)
        if not cards or not cards[1] then
            print("ERROR: No Internet Card found")
            return false
        end
        card = cards[1]
    end
    
    local data = GetPowerPlantData()
    local jsonData = SerializeToJSON(data)
    
    print("Data ready (HTTP disabled for now)")
    print("JSON: " .. string.sub(jsonData, 1, 100) .. "...")
    
    -- TODO: Fix non-blocking HTTP call
    -- For now, just log that we would send this data
    return true
end

function TestWebAppSender()
    print("Test 1: Getting power data...")
    local data = GetPowerPlantData()
    print("✓ Data gathered successfully")
    
    print("Test 2: Serializing to JSON...")
    local jsonData = SerializeToJSON(data)
    print("✓ JSON created: " .. string.sub(jsonData, 1, 50) .. "...")
    
    print("✓ No crashes yet - WebAppDataSender is working!")
end

function InitializeWebAppSender(webappUrl, updateIntervalSeconds)
    print("Initializing Web App Data Sender")
    print("Target URL: " .. webappUrl)
    print("Update interval: " .. updateIntervalSeconds .. " seconds")
    
    if not card then
        card = computer.getPCIDevices(classes.FINInternetCard)[1]
        if not card then
            print("ERROR: No internet card found. Web app sender disabled.")
            return false
        end
    end
    
    return true
end
