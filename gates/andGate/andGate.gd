extends gate

var andGateOffTexture = ImageTexture.create_from_image(Image.load_from_file("res://textures/offAnd.svg"))
var andGateTexture = ImageTexture.create_from_image(Image.load_from_file("res://textures/onAnd.svg"))
func logic():
	if $inputConnector.isPowered && $inputConnector2.isPowered:
		$outputConnector.isPowered = true
		$Sprite2D.texture = andGateTexture
	elif !$inputConnector.isPowered || !$inputConnector2.isPowered:
		$outputConnector.isPowered = false
		$Sprite2D.texture = andGateOffTexture
