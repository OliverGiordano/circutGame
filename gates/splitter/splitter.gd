extends gate


func logic():
	if $inputConnector.isPowered:
		$outputConnector.isPowered = true
		$outputConnector2.isPowered = true
	else:
		$outputConnector.isPowered = false
		$outputConnector2.isPowered = false#add spawn
