
function SensorActive(sensor)
	return (sensor:getPrefabSignData():getTextElement("Name") == "FIXIT PROXIMITY SENSOR - ON")		
end
