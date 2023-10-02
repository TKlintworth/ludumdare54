extends "res://Scripts/Enemy.gd"

var player
# Called when the node enters the scene tree for the first time.
func _ready():
	level_manager = self.get_parent().get_parent().get_node("LevelManager")
	player = self.get_parent().get_parent().get_node("Player")
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
