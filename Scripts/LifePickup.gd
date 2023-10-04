extends Sprite2D

var tween
@export var life_value : int = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	tween = get_tree().create_tween()
	# Tweening sprite's scale from 1 to 1.5 and back to 1
	tween.tween_property(self, "scale", Vector2(1, 1), 2).set_delay(0.5)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 1).set_delay(0.5)
	# Setting the tween to loop infinitely
	tween.set_loops()
	# Start the Tween
	#tween.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pick_up():
	$AudioStreamPlayer.play()
	GameManager.update_lives(life_value)
	queue_free()
