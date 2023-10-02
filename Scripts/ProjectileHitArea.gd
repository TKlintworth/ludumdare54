extends Area2D

func _on_area_entered(area):
	print("collide")


func _on_body_entered(body):
	print("my body is ready")
	print(body)
	print(body.name)
	#print(body.get_collider_rid())


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("body shape entered")
	print(body_rid)
	print(body.name)
	if(body.name == "tile24"):
		print(body.get_coords_for_body_rid(body_rid))
		get_parent().queue_free()
