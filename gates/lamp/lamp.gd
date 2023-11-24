extends gate

func logic():
	if $inputConnector.isPowered:
		self.modulate = Color("249b42")
	if !$inputConnector.isPowered:
		self.modulate = Color("de1e39")


