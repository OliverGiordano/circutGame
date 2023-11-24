extends RigidBody2D

@onready var connectedTo = null
@onready var posI = self.global_position
@onready var posCI = null
@onready var isPowered = false


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() && Globals.currentlySelected == null:
			Globals.currentlySelected = self
			if connectedTo != null:
				connectedTo.clearLines()
				clearLines()
				connectedTo.isPowered = false
				connectedTo.connectedTo = null
				connectedTo = null
			drawLineToCursor()
		elif event.is_pressed() && Globals.currentlySelected.get_parent() == self.get_parent():
			failConnection()
		elif event.is_pressed() && Globals.currentlySelected.is_in_group("output"):
			failConnection()
		elif event.is_pressed() && connectedTo != null:
			connectedTo.clearLines()
			connectedTo.isPowered = false
			connectedTo.connectedTo = null
			connectedTo = Globals.currentlySelected
			connectedTo.connectedTo = self
			connectedTo.clearLines()
			Globals.currentlySelected = null
		elif event.is_pressed() && Globals.currentlySelected != null && Globals.currentlySelected != self:
			Globals.currentlySelected.clearLines()
			Globals.currentlySelected.connectedTo = self
			connectedTo = Globals.currentlySelected
			posCI = connectedTo.global_position
			Globals.currentlySelected = null
			drawLine(connectedTo)
			
func failConnection():
	Globals.currentlySelected.clearLines()
	Globals.currentlySelected = self
	drawLineToCursor()

func drawLine(nextItem):
	$Line2D.clear_points()
	$Line2D.add_point(to_local(self.global_position))
	$Line2D.add_point(to_local(nextItem.global_position))

func drawLineToCursor():
	$Line2D.clear_points()
	$Line2D.add_point(to_local(self.global_position))
	$Line2D.add_point(get_local_mouse_position())

func clearLines():
	$Line2D.clear_points()

func _process(_delta):
	if !isPowered && $Line2D != null:
		$Line2D.default_color = Color("de1e39")
	elif isPowered && $Line2D != null:
		$Line2D.default_color = Color("249b42")
	if Globals.currentlySelected == self:
		drawLineToCursor()
	if connectedTo != null:
		if self.global_position != posI || connectedTo.global_position != posCI:
			drawLine(connectedTo)
			posI = self.global_position
			posCI = connectedTo.global_position
		if !isPowered:
			connectedTo.isPowered = false
		elif isPowered:
			connectedTo.isPowered = true
