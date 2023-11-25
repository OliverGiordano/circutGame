extends Node

signal clicked
signal dropInit

var held_object = null
var panHeld = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.dropInit.connect(dropHeldInitial)
	for node in get_tree().get_nodes_in_group("pickable"):
		node.clicked.connect(_on_pickable_clicked)
	timerClock(0)
	
func timerClock(timeCountUp):
	await get_tree().create_timer(.1).timeout
	if floor(timeCountUp) == 1:
		Globals.timerTimeUp.emit(true)
		timeCountUp = 0
	else:
		Globals.timerTimeUp.emit(false)
		timeCountUp += .1
	timerClock(timeCountUp)


func _on_pickable_clicked(object):
	if !held_object:
		object.pickup()
		held_object = object
	elif held_object != null:
		held_object.drop()
		held_object = null
		
func dropHeldInitial():
	if held_object != null:
		held_object.drop()
		held_object = null

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !event.pressed:
			pass
		if held_object and !event.pressed:
			held_object.drop()
			held_object = null
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT and Globals.currentlySelected != null:
		Globals.currentlySelected.clearLines()
		Globals.currentlySelected.isPowered = false
		Globals.currentlySelected = null
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_WHEEL_UP && $Camera2D.scale.x < 1.3:
		var tween = get_tree().create_tween()
		tween.tween_property($Camera2D, "zoom", $Camera2D.zoom + Vector2(.2, .2), .2).set_trans(Tween.TRANS_LINEAR)
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_WHEEL_DOWN && sqrt($Camera2D.zoom.x**2-.1) > .7:#if we go to 0 or less the camera flips upside down
		var tween = get_tree().create_tween()
		tween.tween_property($Camera2D, "zoom", $Camera2D.zoom + Vector2(-.2, -.2), .2).set_trans(Tween.TRANS_LINEAR)
	
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_MIDDLE:
		panHeld = !panHeld
		
	if event is InputEventMouseMotion && panHeld:
		#if $Camera2D.position.x < 10000 && $Camera2D.position.x > -10000 && $Camera2D.position.y < 10000 && $Camera2D.position.y > -10000:
		$Camera2D.position += -event.velocity/200 * $Camera2D.scale
	if $Camera2D.position.x < $Camera2D.limit_left:
		$Camera2D.position.x = $Camera2D.limit_left
	if $Camera2D.position.y < $Camera2D.limit_top:
		$Camera2D.position.y = $Camera2D.limit_top
	if $Camera2D.position.x > $Camera2D.limit_right:
		$Camera2D.position.x = $Camera2D.limit_right
	if $Camera2D.position.y > $Camera2D.limit_bottom:
		$Camera2D.position.y = $Camera2D.limit_bottom


@onready var orGate = preload("res://gates/orGate/orGate.tscn")
@onready var andGate = preload("res://gates/andGate/andGate.tscn")
@onready var notGate = preload("res://gates/notGate/notGate.tscn")
@onready var switch = preload("res://gates/switch/switch.tscn")
@onready var powerOut = preload("res://gates/powerout/powerOut.tscn")
@onready var lamp = preload("res://gates/lamp/lamp.tscn")
@onready var clock = preload("res://gates/clock/clock.tscn")
@onready var splitter = preload("res://gates/splitter/splitter.tscn")
@onready var wireConnector = preload("res://gates/wireConnector/wireConnector.tscn")

func _on_item_popout_create_item(item):
	var n = null
	match item:
		"or":
			n = orGate.instantiate()
		"and":
			n = andGate.instantiate()
		"not":
			n = notGate.instantiate()
		"switch":
			n = switch.instantiate()
		"powerOut":
			n = powerOut.instantiate()
		"lamp":
			n = lamp.instantiate()
		"clock":
			n = clock.instantiate()
		"splitter":
			n = splitter.instantiate()
		"wireConnector":
			n = wireConnector.instantiate()
		_:
			return
	makeChild(n)


func makeChild(child):
	add_child(child)
	child.clicked.connect(_on_pickable_clicked)
	for c in child.get_children():
		if c.is_in_group("pickable"):
			c.clicked.connect(_on_pickable_clicked)
	child.held = true
	held_object = child
	child.pickup()
