extends gate


var timeDelay = 0.2
var tempTimer = .1
var syncTimeHit = false
func _ready(): 
	Globals.connect("timerTimeUp", _on_timer_time_up)
	Globals.connect("delete", checkDeleteSafely)
	$uiPopOut.hide()
func _on_timer_time_up(syncUp):#fbozo we are pulsing 2 times so it switches back and forth each time so it no working fix soon
	if syncTimeHit || syncUp:
		syncTimeHit = true
	else:
		return
	tempTimer += .1
	if tempTimer <= timeDelay:
		return
	tempTimer = .1
	$outputConnector.isPowered = !$outputConnector.isPowered


func _on_h_slider_value_changed(value):
	timeDelay = value
	syncTimeHit = false
	tempTimer = .1
	var fstring = 'Time delay: {value} (seconds)'.format({"value": value})
	$uiPopOut/Panel/ScrollContainer/VBoxContainer/RichTextLabel.text = fstring
