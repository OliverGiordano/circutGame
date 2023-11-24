extends gate


var powered = false
func logic():
	$outputConnector.isPowered = powered
		
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			clicked.emit(self)
			powered = !powered
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
		$uiPopOut.visible = !$uiPopOut.visible


