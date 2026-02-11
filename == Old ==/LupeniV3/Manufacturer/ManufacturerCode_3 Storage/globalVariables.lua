whatAreWeProducing = ""
showInfoOnScreen = false
refreshScreen = true
timeOut = 0
debugSwitch.state  = true

ingredients = man1:getRecipe():getIngredients()
bomMatrix = {}
containerInvs = {}

MachineStatus = "Off"	 -- used to send a general status to server

ScreenTimeoutSeconds = 20