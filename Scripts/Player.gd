extends CharacterBody2D


@export var SPEED = 125
@export var MAX_HEALTH = 100
#@export var MAX_LIVES = 10
@onready var weapon = get_node("Weapon")

var CURRENT_HEALTH
#var CURRENT_LIVES
var level_manager

signal player_died
signal player_damage

func get_active_camera() -> Camera2D:
	return GlobalCamera

func _ready():
	CURRENT_HEALTH = MAX_HEALTH
	#CURRENT_LIVES = MAX_LIVES
	GameManager.register_player(self)
	level_manager = get_parent().get_node("LevelManager")

func _physics_process(delta):
	if(level_manager.get_is_active()):
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction_x = Input.get_axis("left", "right")
		var direction_y = Input.get_axis("up", "down")
		
		var dir = Vector2(direction_x, direction_y).normalized()
		
		# TODO: 
		# When we look to the left we need to make sure we still shoot from that direction
		# Make sure Weapon moves to the correct spot
		velocity = dir * SPEED
		var abs_vel = Vector2(abs(velocity.x), abs(velocity.y))
		if(dir.x < 0):
			if(abs_vel.x > 0):
				flip_horizontally("left")
		elif(dir.x > 0):
			flip_horizontally("right")
		if(abs_vel > Vector2(0,0)):
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("idle")
		GameManager.player_current_position = position
		move_and_slide()

func flip_horizontally(direction):
	if(direction == "left"):
		$AnimatedSprite2D.flip_h = true
		weapon.flip_h = true
		weapon.position = Vector2(-9,6)
	else:
		$AnimatedSprite2D.flip_h = false
		weapon.flip_h = false
		weapon.position = Vector2(10, 6)

func _process(delta):
	if(level_manager.get_is_active()):
		if Input.is_action_just_pressed("ui_up"):
			CURRENT_HEALTH -= 10
			player_damage.emit(CURRENT_HEALTH)
			print(CURRENT_HEALTH)
		if (CURRENT_HEALTH <= 0):
			player_died.emit()
			queue_free()

func take_damage(dmg):
	$AudioStreamPlayer.play()
	CURRENT_HEALTH -= dmg
	player_damage.emit(CURRENT_HEALTH)
	$AnimatedSprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color.WHITE

func _on_hit_area_entered(area):
	if(area.get_parent().is_in_group("tag_pickup")):
		area.get_parent().pick_up()
