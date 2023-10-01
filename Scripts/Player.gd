extends CharacterBody2D


@export var SPEED = 250
@export var MAX_HEALTH = 100
var CURRENT_HEALTH
var level_manager
signal player_died

func _ready():
	CURRENT_HEALTH = MAX_HEALTH
	GameManager.register_player(self)
	level_manager = get_parent().get_node("LevelManager")

func _physics_process(delta):
	if(level_manager.get_is_active()):
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction_x = Input.get_axis("left", "right")
		var direction_y = Input.get_axis("up", "down")
		
		var dir = Vector2(direction_x, direction_y).normalized()

		velocity = dir * SPEED

		move_and_slide()

func _process(delta):
	if(level_manager.get_is_active()):
		if Input.is_action_just_pressed("ui_up"):
			CURRENT_HEALTH -= 10
			print(CURRENT_HEALTH)
		if (CURRENT_HEALTH <= 0):
			player_died.emit()
			queue_free()
