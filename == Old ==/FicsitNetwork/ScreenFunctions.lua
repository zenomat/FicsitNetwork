-------------------------------------------------------
-- Screen initialization
-------------------------------------------------------
function InitScreen()

    if not gpu or not screen then
        print("GPU or Screen not initialized")
        return
    end

    gpu:bindScreen(screen)

    w, h = gpu:getSize()
    print("Screen resolution: " .. tostring(w) .. " x " .. tostring(h))

    gpu:setBackground(0, 0, 0, 0)
    gpu:fill(0, 0, w, h, " ")
    gpu:flush()
end

-------------------------------------------------------
-- Message display
-------------------------------------------------------
function ShowMsg(x, y, msg, color)

    if not gpu then
        return
    end

    if color == "red" then
        gpu:setForeground(1, 0, 0, 1)
    elseif color == "green" then
        gpu:setForeground(0, 1, 0, 1)
    elseif color == "yellow" then
        gpu:setForeground(1, 1, 0, 1)
    else
        gpu:setForeground(1, 1, 1, 1) -- default white
    end

    gpu:setText(x, y, tostring(msg))
    gpu:flush()
end

-------------------------------------------------------
-- Formatting helpers
-------------------------------------------------------
function formatRow(label, value, unit, labelWidth, valueWidth)

    value = value or 0
    unit = unit or ""

    local paddedLabel = padRight(tostring(label), labelWidth)
    local paddedValue = padRight(string.format("%.2f", value) .. " " .. unit, valueWidth)

    return "║ " .. paddedLabel .. paddedValue .. " ║"
end

function formatRowNoMargins(label, value, unit, labelWidth, valueWidth)

    value = value or 0
    unit = unit or ""

    local paddedLabel = padRight(tostring(label), labelWidth)
    local paddedValue = padRight(string.format("%.2f", value) .. " " .. unit, valueWidth)

    return paddedLabel .. paddedValue
end

-------------------------------------------------------
-- Safe padding
-------------------------------------------------------
function padRight(str, width)

    str = tostring(str)

    local pad = width - #str
    if pad > 0 then
        return str .. string.rep(" ", pad)
    else
        return str
    end
end
