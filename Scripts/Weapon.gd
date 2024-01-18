extends AnimatedSprite2D

@export var ProjectileScene : PackedScene
@export var LevelManager : Node

@onready var ChargeBar = $ChargeBar
@onready var ChargeKnob = $ChargeBar/ChargeKnob

var shoot_point
var player
var proj_speed
var is_ready_to_shoot
var is_charge_started
var charge_start_time

const MIN_DAMAGE = 50
const MAX_DAMAGE = 150

const MIN_PROJ_SPEED = 100
const MAX_PROJ_SPEED = 500

const MAX_CHARGE_TIME = 3
const SHOOT_COOLDOWN = 1
const MAX_OFFSET_PIXELS = 9
var cooldown
var current_charge_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	shoot_point = get_node("ShootPoint")
	player = get_parent()
	is_ready_to_shoot = true
	is_charge_started = false
	cooldown = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ChargeBar.visible = true if is_charge_started else false
	if(LevelManager.get_is_active() and !LevelManager.get_levelui_ui_mode()):

		# Handle charge start
		if Input.is_action_just_pressed("left_click") and is_ready_to_shoot:
			is_charge_started = true
			is_ready_to_shoot = false
			current_charge_time = 0  # Initialize or reset the charge time
			ChargeKnob.set_offset(Vector2(0, 0))  # Initialize the ChargeKnob's offset

		# Update charge if it has started
		if is_charge_started:
			current_charge_time += delta
			# Ensure charge time doesn't exceed maximum
			current_charge_time = min(current_charge_time, MAX_CHARGE_TIME)
			# Calculate fraction of the MAX_CHARGE_TIME that has passed
			var frac = current_charge_time / MAX_CHARGE_TIME
			# Calculate new offset for ChargeKnob based on the fraction of MAX_CHARGE_TIME
			var new_offset_x = frac * MAX_OFFSET_PIXELS
			ChargeKnob.offset = ChargeKnob.offset.lerp(Vector2(new_offset_x, 0), delta * 2)
			# lerp the ChargeKnob's offset to the new offset
			#ChargeKnob.set_offset(Vector2(new_offset_x, 0))

		# Handle charge release and fire
		if Input.is_action_just_released("left_click") and is_charge_started:
			# ChargeKnob returns to initial position
			ChargeKnob.set_offset(Vector2(0, 0))
			# Calculate time difference and fractional charge for determining projectile speed and damage
			var frac = current_charge_time / MAX_CHARGE_TIME
			print("frac:", frac)
			var p_speed = MIN_PROJ_SPEED + frac * (MAX_PROJ_SPEED - MIN_PROJ_SPEED)
			print("p_speed:", p_speed)
			var p_dmg = MIN_DAMAGE + frac * (MAX_DAMAGE - MIN_DAMAGE)
			print("p_dmg:", p_dmg)
			# Reset charge related variables
			is_charge_started = false
			
			cooldown = 0
			# Determine projectile direction and spawn it
			var global_mouse_pos = get_global_mouse_position()
			var proj_direction = (global_mouse_pos - shoot_point.global_position).normalized()
			spawn_projectile(proj_direction, p_speed, p_dmg)

		# Handle shoot cooldown
		cooldown += delta
		if cooldown >= SHOOT_COOLDOWN:
			is_ready_to_shoot = true


func spawn_projectile(dir, spd, dmg):
	$AudioStreamPlayer.play()
	var proj = ProjectileScene.instantiate()
	print(shoot_point.global_position)
	proj.position = shoot_point.global_position
	proj.create_projectile(dir, spd, dmg)
	get_tree().root.add_child(proj)

func fire():
	pass


