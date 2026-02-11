function InitScreen()
    if refreshScreen == true then
        -- clean screen
        gpu:setBackground(0, 0, 0, 0)
        gpu:fill(0, 0, w, h, " ")
        gpu:flush()
        refreshScreen = false
    end
end

function ShowMsg(x, y, msg, color)
    if showInfoOnScreen == true then
        if color == nil then
            gpu:setForeground(1, 1, 1, 1)
        elseif color == "red" then
            gpu:setForeground(1, 0, 0, 1)
        elseif color == "green" then
            gpu:setForeground(0, 1, 0, 1)
        elseif color == "yellow" then
            gpu:setForeground(1, 1, 0, 1)
        end

        gpu:setText(x, y, msg)
        gpu:flush()
    end
end

function BigSignText(textForOverheadSign)
    -- changes the text for the overhead sign
    local signData = labelSign:getPrefabSignData()       -- FIX: no [1]
    signData:setTextElement("Name", textForOverheadSign)
    labelSign:setPrefabSignData(signData)               -- FIX: no [1]
end
