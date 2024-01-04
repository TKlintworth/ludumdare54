extends Control

signal start_button_pressed
signal start_button_focus_enter
signal start_button_focus_exit

var label_node
var multiplier_node
var start_button
var select_node
var level_complete_mode = false
var ui_mode = true
# Called when the node enters the scene tree for the first time.
func _ready():
	print("level ui")
	label_node = get_node("CenterContainer/VBoxContainer/TilesRemainingLabel")
	multiplier_node = $CenterContainer/VBoxContainer/MultiplierText
	start_button = $CenterContainer/VBoxContainer/StartButton
	select_node = $CenterContainer/VBoxContainer/SelectTilesLabel
	
	GameManager.multiplier_changed.connect(_multiplier_changed)
	
func level_complete():
	###
	# Set UI to 
	# Level Complete
	# 	Next Level
	###
	print("level complete level UI")
	ui_mode = true
	level_complete_mode = true
	if(label_node and select_node and start_button and multiplier_node):
		label_node.hide()
		select_node.text = "Level Complete"
		#TODO: replace with score per level variable
		#label_node.text = "+ " + "100 points"
		#select_node.text = "Level Complete"
		start_button.text = "Next Level"
		multiplier_node.hide()

func show_start_ui():
	print("level start level UI")
	level_complete_mode = false
	ui_mode = true
	if(label_node and select_node and start_button and multiplier_node):
		print("show stuff in level ui")
		label_node.show()
		select_node.text = "Select Active Tiles"
		start_button.text = "Start"
		multiplier_node.show()
	
func set_tiles_remaining_label_text(text):
	print("set tiles remaining: ", text)
	if label_node:
		label_node.text = str(text) + " Tiles Remaining"
	else:
		print("Label node not found")

func set_multiplier_text(text):
	print(text)
	multiplier_node.text = str(text) + "x score multiplier"

func _on_start_button_button_up():
	print("start button pressed on levelui")
	ui_mode = false
	start_button_pressed.emit()

func _on_start_button_focus_entered():
	print("foxued")
	start_button_focus_enter.emit()

func _on_start_button_focus_exited():
	start_button_focus_exit.emit()

func _on_start_button_mouse_entered():
	print("entered")
	start_button_focus_enter.emit()

func _on_start_button_mouse_exited():
	print("exited")
	start_button_focus_exit.emit()

func _multiplier_changed():
	multiplier_node.text = str(GameManager.score_multiplier) + "x score multiplier"
