local disk_uuid

-- Shorten name
fs = filesystem
-- Initialize /dev
if fs.initFileSystem("/dev") == false then
    computer.panic("Cannot initialize /dev")
end
-- List all the drives
for _, drive in pairs(fs.childs("/dev")) do
    print("UUID: " .. drive)
    disk_uuid = drive
end


fs.mount("/dev/C4AFD95E4A80323616879BB804D10014", "/")

program = fs.open("//print.lua", r)

fs.doFile("//print.lua")

while true do
	printMsg()
end

--file location:
--c:\Users\zeno\AppData\Local\FactoryGame\Saved\SaveGames\Computers\35731B934C08C752A5E7E8AD93B82979\print.lua 

--file content:

function printMsg()
	print("lua from drive")
	print("pula verde pe campii")
end
