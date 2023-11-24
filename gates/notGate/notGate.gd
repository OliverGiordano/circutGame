extends gate

func logic():
	if !$inputConnector.isPowered || $inputConnector == null:
		$outputConnector.isPowered = true
	elif $inputConnector.isPowered:
		$outputConnector.isPowered = false
