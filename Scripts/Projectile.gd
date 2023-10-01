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
		position.x += (dir * speed * delta).x
		position.y += (dir * speed * delta).y

func _on_hit_area_area_entered(area):
	print("projectile hit area entered by: ", area)
	print(area.get_parent().is_in_group("tag_player"))
	if !(area.get_parent().is_in_group("tag_projectile") or area.get_parent().is_in_group("tag_player")):
		queue_free()

func get_damage():
	return damage
