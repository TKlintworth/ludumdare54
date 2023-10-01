extends Control

signal start_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_tiles_remaining_label_text(text):
	print(text)
	$CenterContainer/VBoxContainer/TilesRemainingLabel.text = str(text) + " Tiles Remaining"


func _on_start_button_button_up():
	start_button_pressed.emit()
