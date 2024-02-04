extends "res://Scripts/Projectile.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!get_viewport().get_visible_rect().has_point(position)):
		print("get rid of projectile")
		queue_free()
	if(is_fired):
		#position.x += (dir * speed * delta).x
		#position.y += (dir * speed * delta).y
		var new_position = position + dir * speed * delta
		var space_state = get_world_2d().direct_space_state
		var ray_params = PhysicsRayQueryParameters2D.new()
		ray_params.from = position
		ray_params.to = new_position
		ray_params.collision_mask = 1 | 2 | 4  # match with the Area2D collision mask
		ray_params.exclude = [self]
		ray_params.collide_with_areas = true  # Important to detect collisions with Area2D

		var result = space_state.intersect_ray(ray_params)

		if result.size() > 0:
			pass
			#print("Collided with: ", result["collider"])
			# Handle collision logic here. Perhaps queue_free() to destroy the projectile.
		else:
			pass
		position = new_position
