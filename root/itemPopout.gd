extends Control

signal createItem(itemName)


func _ready():
	for button in get_tree().get_nodes_in_group("button"):
		button.button_up.connect(dropItem)
		
func dropItem():
	Globals.dropInit.emit()

func _on_or_button_down():
	createItem.emit("or")
func _on_and_button_down():
	createItem.emit("and")
func _on_not_button_down():
	createItem.emit("not")
func _on_switch_button_down():
	createItem.emit("switch")
func _on_power_button_down():
	createItem.emit("powerOut")
func _on_lamp_button_down():
	createItem.emit("lamp")
func _on_clock_button_down():
	createItem.emit("clock")
func _on_splitter_button_down():
	createItem.emit("splitter")
func _on_wire_connector_button_down():
	createItem.emit("wireConnector")
