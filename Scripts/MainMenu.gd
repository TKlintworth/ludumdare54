extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_up():
	# Tell GameManager we want to load the first scene
	print("Button pressed")
	AudioManager.play("button_click")
	GameManager.change_level(1)


func _on_quit_button_up():
	GameManager.quit()
