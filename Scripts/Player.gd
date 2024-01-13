extends CharacterBody2D


@export var SPEED = 125
@export var MAX_HEALTH = 100
#@export var MAX_LIVES = 10
var CURRENT_HEALTH
#var CURRENT_LIVES
var level_manager
signal player_died
signal player_damage

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
		if(abs(velocity.x) > 0 and dir.x < 0):
			print("velocity: ", velocity)
		#if(dir.x < 0):
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
		if(velocity > Vector2(0,0)):
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("idle")

		move_and_slide()

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
