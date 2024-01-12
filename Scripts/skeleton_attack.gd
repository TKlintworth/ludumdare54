# Idle.gd
extends State
var anim
var is_anim_done = false

@export var ProjectileScene : PackedScene

# Upon entering the state, we set the Player node's velocity to zero.
func enter(_msg := {}) -> void:
	# What do once entered "Attack" state follows
	
	# We must declare all the properties we access through `owner` in the `Player.gd` script.
	#owner.velocity = Vector2.ZERO
	
	var anim = state_machine.me.get_node("AnimatedSprite2D")
	anim.play("attack")
	var proj = ProjectileScene.instantiate()
	proj.position = state_machine.me.position
	
	#TODO: this is trying to be called when the player has already been deleted
	var dir = (state_machine.player.position - state_machine.me.position).normalized()
	
	# Come back and rotate the projectile
	proj.create_projectile(dir, 250, 1)
	get_tree().root.add_child(proj)
	
	state_machine.transition_to("Idle")

func update(delta: float) -> void:
	print("in update")
	if is_anim_done:
		print("done")
		state_machine.transition_to("Idle")
		#state_machine.me.queue_free()

func _on_animated_sprite_2d_animation_finished():
	print("test")
	is_anim_done = true
