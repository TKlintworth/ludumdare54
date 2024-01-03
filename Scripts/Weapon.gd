extends AnimatedSprite2D

@export var ProjectileScene : PackedScene
@export var LevelManager : Node

var shoot_point
var player
var proj_speed
var is_ready_to_shoot
var is_charge_started
var charge_start_time
var able_to_shoot = false

const MIN_DAMAGE = 50
const MAX_DAMAGE = 150

const MIN_PROJ_SPEED = 100
const MAX_PROJ_SPEED = 500

const MAX_CHARGE_TIME = 3
const SHOOT_COOLDOWN = 1
var cooldown

# Called when the node enters the scene tree for the first time.
func _ready():
	shoot_point = get_node("ShootPoint")
	player = get_parent()
	is_ready_to_shoot = true
	is_charge_started = false
	cooldown = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(LevelManager.get_is_active() and able_to_shoot):
		
		cooldown += delta
		if cooldown >= SHOOT_COOLDOWN:
			is_ready_to_shoot = true
		
		if(Input.is_action_just_pressed("left_click") and is_ready_to_shoot):
			charge_start_time = Time.get_unix_time_from_system()
			is_charge_started = true
			is_ready_to_shoot = false
		
		if(Input.is_action_just_released("left_click") and is_charge_started):
			cooldown = 0
			is_charge_started = false
			var time_diff = Time.get_unix_time_from_system() - charge_start_time;
			
			var frac = time_diff / MAX_CHARGE_TIME
			
			var p_speed = MIN_PROJ_SPEED + frac * (MAX_PROJ_SPEED - MIN_PROJ_SPEED)
			var p_dmg = MIN_DAMAGE + frac * (MAX_DAMAGE - MIN_DAMAGE)
			
			print("SPEED:", p_speed)
			print("DMG: ", p_dmg)
			
			var global_mouse_pos = get_global_mouse_position()
			var player_pos = player.global_position
			var proj_direction = (global_mouse_pos - shoot_point.global_position).normalized()
			spawn_projectile(proj_direction, p_speed, p_dmg)
			
		

func spawn_projectile(dir, spd, dmg):
	$AudioStreamPlayer.play()
	var proj = ProjectileScene.instantiate()
	print(shoot_point.global_position)
	proj.position = shoot_point.global_position
	proj.create_projectile(dir, spd, dmg)
	get_tree().root.add_child(proj)

func fire():
	pass


