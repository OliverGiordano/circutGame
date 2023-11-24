extends Control


func _on_button_pressed():
	Globals.delete.emit(self.get_parent())
