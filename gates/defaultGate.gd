class_name gate extends RigidBody2D

signal clicked

var held = false
var dropShadow = null
func _process(_delta):
	if held:
		global_transform.origin = get_global_mouse_position()
	logic()

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			clicked.emit(self)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
		$uiPopOut.visible = !$uiPopOut.visible
			
		
func _ready():
	Globals.connect("delete", checkDeleteSafely)
	$uiPopOut.hide()

func checkDeleteSafely(node):
	if node == self:
		deleteSafely()

func deleteSafely():
	for child in self.get_children():
		if child.is_in_group("input") || child.is_in_group("output"):
			if child.connectedTo != null:
				child.connectedTo.connectedTo = null
				child.connectedTo.isPowered = false
				child.connectedTo.clearLines()
				child.connectedTo = null
	self.queue_free()

func pickup():
	#if held:
	#	self.scale = Vector2(1.1, 1.1)
	#	return
	held = true
	self.scale = Vector2(1.1, 1.1)
	self.z_index = 3
	#self.scale = Vector2(1, 1)
	dropShadow = $Sprite2D.duplicate() #potential dropshadows
	self.add_child(dropShadow)
	dropShadow.z_index = -2
	dropShadow.modulate = Color(0,0,0, .5)
	dropShadow.position += Vector2(10, 10)

func drop():
	if held:
		self.scale = Vector2(1, 1)
		held = false
		if dropShadow != null:
			self.z_index = 0
			self.dropShadow.queue_free()
			dropShadow = null
	

func logic():
	pass
