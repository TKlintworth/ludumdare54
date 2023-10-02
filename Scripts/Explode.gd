# Idle.gd
extends State
var anim
var effective_range = 25
var damage = 200
var is_anim_done = false

# Upon entering the state, we set the Player node's velocity to zero.
func enter(_msg := {}) -> void:
	# We must declare all the properties we access through `owner` in the `Player.gd` script.
	#owner.velocity = Vector2.ZERO
	anim = state_machine.me.get_node("AnimatedSprite2D")
	anim.play("explode")

func update(delta: float) -> void:
	print("in update")
	if is_anim_done:
		print("done")
		if(state_machine.player.position - state_machine.me.position).length() <= effective_range:
			state_machine.player.take_damage(damage)
		state_machine.me.queue_free()

func _on_animated_sprite_2d_animation_finished():
	print("test")
	is_anim_done = true
