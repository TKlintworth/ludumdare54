# Idle.gd
extends State

var attack_cooldown = 2
var curr_attack_cooldown
var can_attack

# Upon entering the state, we set the Player node's velocity to zero.
func enter(_msg := {}) -> void:
	# We must declare all the properties we access through `owner` in the `Player.gd` script.
	#owner.velocity = Vector2.ZERO
	var anim = state_machine.me.get_node("AnimatedSprite2D")
	anim.play("idle")
	curr_attack_cooldown = 0
	can_attack = false

func update(delta: float) -> void:

	curr_attack_cooldown += delta
	if curr_attack_cooldown >= attack_cooldown:
		can_attack = true
		
	if can_attack:
		if randi_range(0, 4) == 0:
			state_machine.transition_to("Attack")





