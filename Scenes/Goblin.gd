extends "res://Scripts/Enemy.gd"

const lunge_distance = 100
const lunge_cooldown = 2
var is_can_lunge
var curr_lunge_cooldown
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	level_manager = self.get_parent().get_parent().get_node("LevelManager")
	player = self.get_parent().get_parent().get_node("Player")
	is_can_lunge = true
	curr_lunge_cooldown = 0
	current_health = MAX_HEALTH
	current_state = State.STATE_IDLE
	MAX_Y = get_viewport().content_scale_size[1]
	MAX_X = get_viewport().content_scale_size[0]
	is_ready_to_attack = true
	level_manager = self.get_parent().get_parent().get_node("LevelManager")
	print("Current Health Goblin:", current_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(level_manager.get_is_active()):
		
		curr_lunge_cooldown += delta
		if curr_lunge_cooldown >= lunge_cooldown:
			is_can_lunge = true
			
		if (player.position - self.position).length() < lunge_distance and is_can_lunge:
			lunge()
			is_can_lunge = false
			curr_lunge_cooldown = 0
			
		else:
			
			var new_position = position + (player.position - self.position).normalized() * SPEED / 2 * delta
			distance = distance + (new_position - position).length()
			#print(distance)
			
			new_position[0] = max(MIN_X, new_position[0])
			new_position[0] = min(MAX_X, new_position[0])
			new_position[1] = max(MIN_Y, new_position[1])
			new_position[1] = min(MAX_Y, new_position[1])
			
			#$AnimatedSprite2D.animation = "walk"
			#$AnimatedSprite2D.play()
			position = new_position
	
func lunge():
	$AnimatedSprite2D.animation = "attack"
	$AnimatedSprite2D.play()
	await $AnimatedSprite2D.animation_finished

func _on_animated_sprite_2d_animation_finished():
	pass
	#$AnimatableBody2D.animation = "walk"
	#$AnimatableBody2D.play()
