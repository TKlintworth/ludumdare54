extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_resume_button_button_up():
	GameManager.pause_button_pressed()


func _on_quit_button_button_up():
	GameManager.quit()
