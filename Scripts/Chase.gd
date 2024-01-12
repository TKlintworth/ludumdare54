
# Idle.gd
extends State

var player
var velocity
var steering_power = .1
var explode_distance = 25

const moveable_directions = [
	Vector2(1, 0),
	Vector2(-1, 0),
	Vector2(0, 1),
	Vector2(0, -1)
]

# Upon entering the state, we set the Player node's velocity to zero.
func enter(_msg := {}) -> void:
	# We must declare all the properties we access through `owner` in the `Player.gd` script.
	velocity = Vector2.ZERO
	player = state_machine.player

	var anim = state_machine.me.get_node("AnimatedSprite2D")
	anim.play("default")

func update(delta: float) -> void:
	
	# implement chase logic
	var dir_with_mag = player.position - state_machine.me.position
	
	if dir_with_mag.length() <= explode_distance:
		state_machine.transition_to("Explode")
	
	var dir = dir_with_mag.normalized()
	var direction_interest = []
	var danger = []
	for item in moveable_directions:
		#print("RAYCAST RETURN: ", state_machine.me.raycast_in_dir(item, 20))
		direction_interest.append(item.dot(dir))
		#print("ITEM: ", item)
		if(state_machine.me.raycast_in_dir(item, 20)):
			danger.append(5)
		else:
			danger.append(0)
	print(danger)
	
	# get max index
	var c_max = direction_interest[0]
	var max_idx = 0
	var c_idx = 1
	
	while c_idx < len(direction_interest):
		if direction_interest[c_idx] > c_max:
			c_max = direction_interest[c_idx]
			max_idx = c_idx
		c_idx += 1
	
	var steering_force = moveable_directions[max_idx] - velocity.normalized()
	velocity += (steering_force * steering_power)
	state_machine.me.position += velocity * delta * 200
	
	
	
	
	
	
