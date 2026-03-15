-- Function to display the message
function ShowReportTemplate()
    local message = [[
                                          == Particle Accelerator 1 ==                                                
                                                                                                           
 ╔═════════════════════════════════════╗                                                                 
 ║            Power Info               ║                                                                 
 ║                                     ║  
 ║                                     ║  
 ║                                     ║  
 ║                                     ║  
 ║                                     ║  
 ║                                     ║  
 ║                                     ║  
 ║                                     ║  
 ║                                     ║  
 ║                                     ║  
 ╚═════════════════════════════════════╝  
                                          
                                                                                                         
                                                                                                         
]] 

    -- Split the message into lines
    for i, line in ipairs(splitMessageIntoLines(message)) do
        -- Display each line using ShowMsg function
        ShowMsg(1, i, line)
    end
end

-- Helper function to split the message into lines
function splitMessageIntoLines(message)
    local lines = {}
    for line in message:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    return lines
end

