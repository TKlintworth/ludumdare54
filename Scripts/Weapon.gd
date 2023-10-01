extends AnimatedSprite2D

@export var ProjectileScene : PackedScene
@export var LevelManager : Node

var shoot_point
var player
var proj_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	shoot_point = get_node("ShootPoint")
	player = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(LevelManager.get_is_active()):
		if(Input.is_action_just_released("left_click")):
			var global_mouse_pos = get_global_mouse_position()
			var player_pos = player.global_position
			var proj_direction = (global_mouse_pos - shoot_point.global_position).normalized()
			spawn_projectile(proj_direction)
		

func spawn_projectile(dir):
	var proj = ProjectileScene.instantiate()
	print(shoot_point.global_position)
	proj.position = shoot_point.global_position
	proj.create_projectile(dir, 200)
	get_tree().root.add_child(proj)

func fire():
	pass


