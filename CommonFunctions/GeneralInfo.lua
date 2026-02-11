function LocalTime()
  local hour = string.format("%02d", math.floor((computer.time()/60/60) % 24))
  local minute = string.format("%02d", math.floor((computer.time()/60) % 60))
  return hour .. ":" .. minute
end