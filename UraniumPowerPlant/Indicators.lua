
-------------------------------------------------------
-- Reactor status control
-------------------------------------------------------

function CheckReactorStatus()
	Reactor1.standby = not switches[1].state
	Reactor2.standby = not switches[2].state
	Reactor3.standby = not switches[3].state
	Reactor4.standby = not switches[4].state	
	
	--SetIndicatorColor(1, Reactor1)
	--SetIndicatorColor(2, Reactor2)
	--SetIndicatorColor(3, Reactor3)
	--SetIndicatorColor(4, Reactor4)	
end


-------------------------------------------------------
-- Indicator colors
-------------------------------------------------------

function SetIndicatorColor(id, reactor)
	if (reactor.standby == false) then
		indicators[id]:setColor(0, 1, 0, 1) -- green
		modular:getModule(id - 1):setColor(0, 255, 0, 0.01)
	end
	
	if (reactor.standby == true) then
		indicators[id]:setColor(1, 0, 0, 1) -- red
		modular:getModule(id - 1):setColor(255, 0, 0, 0.01)
	end	
end

-------------------------------------------------------
-- Test
-------------------------------------------------------
function ColorTestGroup1()
    for i = 1, 4 do
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

    indicators = {}
    switches = {}

    local moduleIndex = 1
    for x = 2, 5 do
        indicators[moduleIndex] = panel:getModule(x, 9, 0)
        moduleIndex = moduleIndex + 1
    end

    moduleIndex = 1
    for x = 2, 5 do
        switches[moduleIndex] = panel:getModule(x, 8, 0)
        moduleIndex = moduleIndex + 1
    end
end
