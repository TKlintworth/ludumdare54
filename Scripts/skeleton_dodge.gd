
# Idle.gd
extends State

var player
var dodge_dir
var distance
const SPEED = 150
const dodge_distance = 50
const tile_size = 24

var MAX_Y = 600
var MIN_Y = tile_size
var MAX_X = 1100
var MIN_X = tile_size

const moveable_directions = [
	Vector2(1, 0),
	Vector2(-1, 0),
	Vector2(0, 1),
	Vector2(0, -1)
]

# Upon entering the state, we set the Player node's velocity to zero.
func enter(_msg := {}) -> void:
	# We must declare all the properties we access through `owner` in the `Player.gd` script.
	#velocity = Vector2.ZERO
	
	player = state_machine.player
	print(state_machine.me.position)
	
	var p_to_e = (state_machine.me.position - _msg["a"].get_parent().position).normalized()
	
	if randi_range(0, 1):
		dodge_dir = Vector2(-p_to_e[1], p_to_e[0])
	else:
		dodge_dir = Vector2(p_to_e[1], -p_to_e[0])
	
	distance = 0
	print("content_scale_size: ", get_viewport().content_scale_size)
	MAX_Y = get_viewport().content_scale_size[1] - tile_size
	MAX_X = get_viewport().content_scale_size[0] - tile_size
	
	var anim = state_machine.me.get_node("AnimatedSprite2D")
	anim.play("walk")
	

func update(delta: float) -> void:
	
	var new_position = state_machine.me.position + dodge_dir * SPEED * delta
	distance = distance + (new_position - state_machine.me.position).length()
	#print(distance)
	
	new_position[0] = max(MIN_X, new_position[0])
	new_position[0] = min(MAX_X, new_position[0])
	new_position[1] = max(MIN_Y, new_position[1])
	new_position[1] = min(MAX_Y, new_position[1])
	
	state_machine.me.position = new_position
	if distance >= dodge_distance:
		state_machine.transition_to("Idle")




func _on_dodge_detect_area_entered(area):
	pass # Replace with function body.
