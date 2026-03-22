function InitScreen()
    -- clean screen
    if not gpu then return end
    gpu:setBackground(0, 0, 0, 0)
    gpu:fill(0, 0, w, h, " ")
    gpu:flush()
end

function ShowMsg(x, y, msg, color)
    if not showInfoOnScreen or not gpu then
        return
    end

    if color == nil then
        gpu:setForeground(1, 1, 1, 1)
    elseif color == "red" then
        gpu:setForeground(1, 0, 0, 1)
    elseif color == "green" then
        gpu:setForeground(0, 1, 0, 1)
    elseif color == "yellow" then
        gpu:setForeground(1, 1, 0, 1)
    elseif color == "blue" then
        gpu:setForeground(0, 0, 1, 1)
    end

    gpu:setText(x, y, msg)
    gpu:flush()
end

function formatRow(label, value, unit, labelWidth, valueWidth)
    local paddedLabel = padRight(label, labelWidth)
    local paddedValue = padRight(string.format("%.2f", value) .. " " .. unit, valueWidth)
    return "║ " .. paddedLabel .. paddedValue .. " ║"
end

function formatRowString(label, value, unit, labelWidth, valueWidth)
    local paddedLabel = padRight(label, labelWidth)
    local paddedValue = padRight(value .. " " .. unit, valueWidth)
    return "║ " .. paddedLabel .. paddedValue .. " ║"
end

function formatRowNoMargins(label, value, unit, labelWidth, valueWidth)
    local paddedLabel = padRight(label, labelWidth)
    local paddedValue = padRight(string.format("%.2f", value) .. " " .. unit, valueWidth)
    return paddedLabel .. paddedValue
end

function padRight(str, width)
    local pad = width - #str
    if pad > 0 then
        return str .. string.rep(" ", pad)
    else
        return str
    end
end

function Log(message)
	lastLog =  LocalTime() .. ": " .. message
	print(lastLog)	
end
