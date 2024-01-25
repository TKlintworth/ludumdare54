extends Area2D

@export var ProjectileScene : PackedScene
@export var MAX_HEALTH: float = 10
var current_health
signal enemy_died (enemy)

const MIN_ACTION_FREQ = 2
const SPEED = 150
const dodge_distance = 100

var time_since_last_action = 0
var dodge_dir

enum State {STATE_IDLE, STATE_ATTACK, STATE_DODGE, STATE_DYING}
var current_state
var distance = 0
var is_ready_to_attack

var MAX_Y = 600
var MIN_Y = 0
var MAX_X = 1100
var MIN_X = 0
var animation_playing = false

var level_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = MAX_HEALTH
	print("current health:", current_health)
	current_state = State.STATE_IDLE
	MAX_Y = get_viewport().content_scale_size[1]
	MAX_X = get_viewport().content_scale_size[0]
	is_ready_to_attack = true
	level_manager = self.get_parent().get_parent().get_node("LevelManager")

func attack(dir, spd, dmg):
	print("attack called")
	var proj = ProjectileScene.instantiate()
	proj.position = position
	#proj.rotation_degrees = 45.0
	proj.create_projectile(dir, spd, dmg)
	get_tree().root.add_child(proj)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):		
	
	if(level_manager.get_is_active()):
		if time_since_last_action < MIN_ACTION_FREQ:
			time_since_last_action += delta
		else:
			is_ready_to_attack = true
			
		if current_state == State.STATE_DODGE:
			var new_position = position + dodge_dir * SPEED * delta
			distance = distance + (new_position - position).length()
			#print(distance)
			
			new_position[0] = max(MIN_X, new_position[0])
			new_position[0] = min(MAX_X, new_position[0])
			new_position[1] = max(MIN_Y, new_position[1])
			new_position[1] = min(MAX_Y, new_position[1])
			
			position = new_position
			if distance >= dodge_distance:
				current_state = State.STATE_IDLE
		
		else:
			if randi_range(0, 3) == 1 and is_ready_to_attack:
				is_ready_to_attack = false
				time_since_last_action = 0
				attack(Vector2(-1, 0), 250, 1)
		
		

func _on_area_entered(area):
	if !area.get_parent().is_in_group("tag_enemy_projectile"):
		if(area.get_parent().is_in_group("tag_projectile")):
			var node = area.get_parent()
			print("node:", node)
			print("current health:", current_health)
			#current_health -= node.get_damage()
			take_damage(node.get_damage())
			node.queue_free()

func take_damage(damage):
	current_health -= damage
	print("Enemy taking damage")
	$AnimatedSprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color.WHITE
	if current_health <= 0:
		enemy_died.emit(self)
		queue_free()

func raycast_in_dir(to, dist):
	var space_state = get_world_2d().direct_space_state
	var v = (position + to).normalized() * dist
	
	var query = PhysicsRayQueryParameters2D.create(position, v, collision_mask)
	query.collide_with_areas = false
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	return result
	
func dodge(a):
	var n = a.get_parent()
	var p_to_e = (self.position - n.position).normalized()
	
	if randi_range(0, 1):
		dodge_dir = Vector2(-p_to_e[1], p_to_e[0])
	else:
		dodge_dir = Vector2(p_to_e[1], -p_to_e[0])
	
	distance = 0
	current_state = State.STATE_DODGE
	
	
func _on_animated_sprite_2d_animation_finished():
	animation_playing = false

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("body shape entered")
	print(body_rid)
	print(body.name)
	if(body.name == "tile24"):
		print(body.get_coords_for_body_rid(body_rid))
		queue_free()
