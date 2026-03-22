-- Function to display the message
function ShowReportTemplate()
    local message = [[
                                          == Uranium Recycling Plant ==                                                
                                                                                                           
 ╔═════════════════════════════════════╗                                                                 
 ║            Power Info               ║    Blender 1 Input               Blender 1 Ouput
 ║                                     ║  
 ║                                     ║   SulfAcid    :             WaterTank     : 
 ║                                     ║   NitricAcid  :             NonFisUranium :
 ║                                     ║   UraniumWaste:
 ║                                     ║   Silicon     :
 ║                                     ║  ══════════════════════════════════════════════════════════════════════════
 ║                                     ║    Arc Reactor Input             Arc Reactor Output       Status 
 ║                                     ║  
 ║                                     ║  UraniumWaste :             Plut. Pallete:    
 ║ Fuel Rod Finished:                  ║  NonFisUranium:             (OFF < 100 ON > 250)
 ╚═════════════════════════════════════╝  ══════════════════════════════════════════════════════════════════════════
                                            Assembler
										
                                          Concrete     :
                                          Plut.Pallette:   
                                          ══════════════════════════════════════════════════════════════════════════
                                          Manufacturer1                         Manufacturer2
										  										  
                                          ElectroRod   :                        ElectroRod   : 
                                          SteelBeam    :                        SteelBeam    :
                                          HeatSink     :                        HeatSink     :
                                          EncasedPlut  :                        EncasedPlut  :  										 
                                          St:                                   St: 
                                                                                                         
                                                                                                         
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

