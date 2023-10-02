extends Area2D

@export var MAX_HEALTH: float = 10
var current_health
signal enemy_died

func _ready():
	print("skelly")
	current_health = MAX_HEALTH
	
func _process(delta):
	if current_health <= 0:
		enemy_died.emit()
		queue_free()

func _on_area_entered(area):
	if !area.get_parent().is_in_group("tag_enemy_projectile"):
		if(area.get_parent().is_in_group("tag_projectile")):
			var node = area.get_parent()
			print("node:", node)
			print("current health:", current_health)
			current_health -= node.get_damage()
			node.queue_free()
