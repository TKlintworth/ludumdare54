extends Control

signal start_button_pressed
signal start_button_focus_enter
signal start_button_focus_exit

# Called when the node enters the scene tree for the first time.
func _ready():
	print("level ui ")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_tiles_remaining_label_text(text):
	print(text)
	$CenterContainer/VBoxContainer/TilesRemainingLabel.text = str(text) + " Tiles Remaining"

func set_multiplier_text(text):
	print(text)
	$CenterContainer/VBoxContainer/MultiplierText.text = str(text) + "x score multiplier"


func _on_start_button_button_up():
	#$AudioStreamPlayer.play()
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
