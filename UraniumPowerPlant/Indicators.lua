


-------------------------------------------------------
-- Indicator colors
-------------------------------------------------------

function SetIndicatorColor(id, reactor)
    if reactor.standby == false then
        indicators[id]:setColor(0, 1, 0, 1) -- green
        if modular then
            modular:getModule(id - 1):setColor(0, 1, 0, 1) -- green, normalized 0-1
        end
    else
        indicators[id]:setColor(1, 0, 0, 1) -- red
        if modular then
            modular:getModule(id - 1):setColor(1, 0, 0, 1) -- red, normalized 0-1
        end
    end	
end

-------------------------------------------------------
-- Test
-------------------------------------------------------
function ColorTestGroup1()
    print("Testing indicators ...")
    for i = 1, 6 do
        print(indicators[i])
        
        indicators[i]:setColor(0, 1, 0, 1)
        event.pull(0.5)

        indicators[i]:setColor(1, 0, 0, 1)
        event.pull(0.5)

        indicators[i]:setColor(1, 1, 0, 1)
        event.pull(0.5)

        indicators[i]:setColor(0, 1, 0, 1)
    end
end

-------------------------------------------------------
-- Load indicators
-------------------------------------------------------
function LoadIndicators()
	PrintDebugInfo("Loading indicators...", true)		    

    local moduleIndex = 1
    for x = 2, 7 do
        indicators[moduleIndex] = panel:getModule(x, 9, 0)
        moduleIndex = moduleIndex + 1
    end

    moduleIndex = 1
    for x = 2, 7 do
        switches[moduleIndex] = panel:getModule(x, 8, 0)
        moduleIndex = moduleIndex + 1
    end

    -- Manual control switch and indicators
    manualControlSwitch = panel:getModule(2, 7, 0)
    manualIndicator = panel:getModule(1, 6, 0)
    autoIndicator = panel:getModule(3, 6, 0)

    panelBatteryInfo = panel:getModule(1, 4, 0)    
    panelAutoPowerOn = panel:getModule(1, 2, 0)
    
    panelBatteryInfo.size = 40
    panelAutoPowerOn.size = 40
    
    autoPowerOnPotentiometer = panel:getModule(1, 1, 0)
end
