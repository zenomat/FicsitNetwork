-- Function to display the message
function ShowReportTemplate()
    local message = [[
                             		== Battery Production ==
																										
     ┌─────────────┐   ┌─────────────┐   ┌─────────────┐                                          
     │ Sulfur      │   │1 Sulf.Acid  │   │ Sulf.Acid   │                                          
     │             ├──►├─────────────┤   │             │   ┌─────────────┐   ┌─────────────┐      
     │             │   │             ├──►│             │──►│ 2.Battery   │   │ Battery     │      
     └─────────────┘   │  Refinery   │   └─────────────┘   ├─────────────┤   │             │      
     ┌─────────────┐   │             │   ┌─────────────┐   │Blender1 x 3 ┼──►│             │      
     │ Water Tank  ├──►│             │   │ Alum Casing │   │             │   └─────────────┘      
     │             │   │             │   │             ├──►│             │                        
     │             │   └─────────────┘   │             │   │Blender1 x 3 │   ┌─────────────┐      
     └─────────────┘   ┌─────────────┐   └─────────────┘   │             ├──►│ WaterTank   │      
                       │1a.Alum.Sol  │   ┌─────────────┐   │             │   │ AutoFlush   │      
                       ├─────────────┤   │ Alum. Sol   │   └─────────────┘   │             │      
                       │             ├──►│             │      ▲              └─────────────┘      
                       │  Refinery   │   │             │──────┘                                          
                       │             │   └─────────────┘                                          
                       │             │
                       └─────────────┘
                                                                             ┌─────────────┐  
                                                                             │ DronePort   │ 
                                                                             │             │
                                                                             │             │																			 
                                                                             └─────────────┘																			 
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



