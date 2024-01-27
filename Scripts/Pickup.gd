extends Sprite2D

var tween
@export var score_value : int = 25
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#tween = get_tree().create_tween()
	# Tweening sprite's scale from 1 to 1.5 and back to 1
	#tween.tween_property(self, "scale", Vector2(1, 1), 2)
	#tween.tween_property(self, "scale", Vector2(-1, -1), 2).as_relative() # .set_delay(0.5)
	# Setting the tween to loop infinitely
	# Start the Tween
	#tween.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pick_up():
	print("Picked up")
	AudioManager.play("pickup1")
	GameManager.update_score(score_value)
	queue_free()
