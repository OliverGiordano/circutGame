extends gate

var orGateOffTexture = ImageTexture.create_from_image(Image.load_from_file("res://textures/offOr.svg"))
var orGateTexture = ImageTexture.create_from_image(Image.load_from_file("res://textures/onOr.svg"))
func logic():
	if $inputConnector.isPowered || $inputConnector2.isPowered:
		$outputConnector.isPowered = true
		$Sprite2D.texture = orGateTexture
	elif !$inputConnector.isPowered && !$inputConnector2.isPowered:
		$outputConnector.isPowered = false
		$Sprite2D.texture = orGateOffTexture

