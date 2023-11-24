extends Node2D

var attachPoints = []
var online = false
var powered = false
var endOneCoord = []
var endTwoCoord = []
@onready var inputConnector = preload("res://inputConnector/inputConnector.tscn")
@onready var outputConnector = preload("res://outputConnector/outputConnector.tscn")

func _ready():
	$uiPopOut.hide()
	endOneCoord.append($end1.position)
	endTwoCoord.append($end2.position)
	moveConnector()
	updateCollision()
	drawLine()

func _process(_delta):
	endOneCoord.append($end1.position)
	endTwoCoord.append($end2.position)
	if endOneCoord[1] != endOneCoord[0] || endTwoCoord[1] != endTwoCoord[0]:
		moveConnector()
		updateCollision()
		drawLine()
	endOneCoord.remove_at(0)
	endTwoCoord.remove_at(0)
	deleteFree()
	updatePower()
	

func showHidePop(node):
	if $uiPopOut.visible:
		$uiPopOut.hide()
	else:
		$uiPopOut.position = node.position
		$uiPopOut.show()

func updatePower():
	powered = false
	for child in get_children():
		if child.is_in_group("input"):
			if child.isPowered:
				powered = true
	for child in get_children():
		if child.is_in_group("output"):
			child.isPowered = powered
			
	if powered:
		$Line2D.default_color = Color("249b42")
	else:
		$Line2D.default_color = Color("de1e39")

func drawLine():
	var p1 = $end1.position
	var p2 = $end2.position
	$Line2D.clear_points()
	$Line2D.add_point(p1)
	$Line2D.add_point(p2)

func updateCollision():
	$Line2D/StaticBody2D/CollisionShape2D.position = ($end1.position + $end2.position) / 2
	$Line2D/StaticBody2D/CollisionShape2D.rotation = $end1.position.direction_to($end2.position).angle()
	var length = $end1.position.distance_to($end2.position)
	$Line2D/StaticBody2D/CollisionShape2D.shape.size = Vector2(length, 10)

func _input(event : InputEvent):
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == MOUSE_BUTTON_LEFT && Globals.currentlySelected != null && online:
			var connector = null
			if Globals.currentlySelected.is_in_group("output"):
				connector = inputConnector.instantiate()
			elif Globals.currentlySelected.is_in_group("input"):
				connector = outputConnector.instantiate()
			self.add_child(connector)
			placeConnector(connector)
			connector.connectedTo = Globals.currentlySelected
			Globals.currentlySelected.connectedTo = connector
			Globals.currentlySelected = null

func placeConnector(connector):
	connector.position = to_local(self.get_global_mouse_position())
	var lnLine = $end1.position.distance_to($end2.position)
	var lnToPoint = $end1.position.distance_to(connector.position)
	var percentOfLine = lnToPoint/lnLine 
	attachPoints.append([connector, percentOfLine])
	
func moveConnector():
	for i in attachPoints:
		var lenX = abs($end1.position.x - $end2.position.x)
		var lenY = abs($end1.position.y - $end2.position.y)
		lenX *= i[1]
		lenY *= i[1]
		if $end1.position.x <= $end2.position.x:
			i[0].position.x = $end1.position.x + lenX
		else:
			i[0].position.x = $end1.position.x - lenX
		if $end1.position.y <= $end2.position.y:
			i[0].position.y = $end1.position.y + lenY
		else:
			i[0].position.y = $end1.position.y - lenY

func deleteFree():
	var index = 0
	for i in attachPoints:
		if i[0].connectedTo == null:
			i[0].queue_free()
			attachPoints.remove_at(index)
			index -= 1
		index += 1
	for i in attachPoints:
		if i[0].connectedTo == null:
			i[0].queue_free()
			attachPoints.remove_at(index)
			index -= 1
		index += 1


func _on_static_body_2d_mouse_entered():
	online = true


func _on_static_body_2d_mouse_exited():
	online = false
