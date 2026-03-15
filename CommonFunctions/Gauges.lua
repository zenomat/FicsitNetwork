
-- Gauges -- 

function SetGaugeLimit(gauge, gaugeLimit)
	gauge.limit = gaugeLimit
end

function SetGaugePercent(gauge, gaugePercent)	
	gauge.percent = gaugePercent/100
end

-- indicators --

function SetIndicatorLight(indicator, isOn)
    if isOn then
        indicator:setColor(0, 1, 0, 1) -- green
    else
        indicator:setColor(1, 0, 0, 1) -- red
    end
end
