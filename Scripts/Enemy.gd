extends Area2D

@export var MAX_HEALTH: float = 100
var current_health
signal enemy_died

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = MAX_HEALTH

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):		
	
	if current_health <= 0:
		enemy_died.emit()
		queue_free()

func _on_area_entered(area):
	print("enemy area enetered by: ", area)
	var node = area.get_parent()
	
	current_health -= node.get_damage()
