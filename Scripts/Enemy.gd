extends Area2D

@export var MAX_HEALTH: float = 100
var current_health
signal enemy_died

const MIN_ACTION_FREQ = 2
const SPEED = 200

var time_since_last_action = 0
var dodge_dir

enum State {STATE_IDLE, STATE_ATTACK, STATE_DODGE, STATE_DYING}
var current_state

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = MAX_HEALTH
	current_state = State.STATE_IDLE
	
func attack():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):		
	if time_since_last_action < MIN_ACTION_FREQ:
		time_since_last_action += delta
		
	if current_state == State.STATE_DODGE:
		var new_position = position + dodge_dir * SPEED * delta
		position = new_position
		
	if current_health <= 0:
		enemy_died.emit()
		queue_free()

func _on_area_entered(area):
	if(area.get_parent().is_in_group("tag_projectile")):
		var node = area.get_parent()
		current_health -= node.get_damage()
		node.queue_free()


func _on_dodge_detect_area_entered(area):
	
	if area.get_parent().is_in_group("tag_projectile"):
		if randi_range(0, 2) == 0:
			dodge(area)
			
	
func dodge(a):
	var n = a.get_parent()
	var p_to_e = (self.position - n.position).normalized()
	
	if randi_range(0, 1):
		dodge_dir = Vector2(-p_to_e[1], p_to_e[0])
	else:
		dodge_dir = Vector2(p_to_e[1], -p_to_e[0])
		
	current_state = State.STATE_DODGE
	
	
	

