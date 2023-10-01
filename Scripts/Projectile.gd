extends Node2D

var dir 
var speed
var is_fired = false
var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func create_projectile(direction, s):
	dir = direction
	speed = s
	print("create projectile")
	is_fired = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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

func _on_hit_area_area_entered(area):
	print("projectile hit area entered by: ", area)
	#print(area.get_parent().is_in_group("tag_player"))
	#if !(area.get_parent().is_in_group("tag_projectile") or area.get_parent().is_in_group("tag_player")):
	#	queue_free()

func get_damage():
	return damage


func _on_hit_area_body_entered(body):
	pass # Replace with function body.
