extends Node

@export var scenes = [
	"res://Scenes/main_menu.tscn",
	"res://Scenes/level1.tscn",
	"res://Scenes/level2.tscn",
	"res://Scenes/level3.tscn",
	"res://Scenes/level4.tscn",
	"res://Scenes/level5.tscn",
	"res://Scenes/level6.tscn",
	"res://Scenes/level7.tscn",
	"res://Scenes/level8.tscn",
	"res://Scenes/level9.tscn",
	"res://Scenes/level10.tscn",
]
@export var game_over_scene = "res://Scenes/GameEndUI.tscn"
@export var leaderboard_scene = "res://addons/silent_wolf/Scores/Leaderboard.tscn"
@export var skeleton_death_effect = preload("res://Scenes/SkeleDeathParticles.tscn")
@export var player_max_lives = 3
@export var shakeStrength: float = 5.0
@export var shakeFade: float = 5.0

@onready var damage_number_2d_template = preload("res://Scenes/damage_number_2d.tscn")

var ui : Node = null
var game_UI
var current_level_index = 1
var player_score = 0
var winlose = ""
var score_multiplier = 1
var player_current_lives
var player_current_position
var player_current_health = 0
# Map different creatures to different scores
var enemy_score_map = {
	"Skeleton": 50,
	"Pumpkin": 50,
	"Goblin": 100
}
var camera 
var camera_offset
var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var shake_fade: float = 0.0
var damage_number_2d_pool:Array[DamageNumber2D] = []
var damage_label_height = 10
var damage_label_spread = 10

signal player_current_lives_changed
signal player_current_health_changed
signal current_level_changed
signal player_score_changed
signal multiplier_changed

func get_damage_number() -> DamageNumber2D:
	print("get damage number")
	if damage_number_2d_pool.size() > 0:
		return damage_number_2d_pool.pop_front()
	else:
		var new_damage_number = damage_number_2d_template.instantiate()
		print("new damage number: ", new_damage_number)
		new_damage_number.tree_exited.connect(
			func():damage_number_2d_pool.append(new_damage_number))
		return new_damage_number

func spawn_damage_number(value:float, spawn_pos:Vector2):
	print("spawn pos: ", spawn_pos)
	var damage_number = get_damage_number()
	#damage_number.position = spawn_pos
	print("damage number: ", damage_number)
	print("damage number position, parent", damage_number.position, " ", damage_number.get_parent())
	var val = str(round(value))
	var pos = spawn_pos
	#add_child(damage_number, true)
	get_tree().root.add_child(damage_number)
	damage_number.set_values_and_animate(val, pos, damage_label_height, damage_label_spread)

func apply_shake(strength=false, fade=false):
	if(!strength):
		shake_strength = shakeStrength
	else:
		shake_strength = strength
	if(!fade):
		shake_fade = shakeFade
	else:
		shake_fade = fade

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func get_active_camera() -> Camera2D:
	return GlobalCamera

func level_complete():
	AudioManager.play("level_complete")
	ui.Level_UI.show()
	ui.Level_UI.level_complete()

func change_level(index):
	# TODO: Add some transition and then show the paused / tile selection screen again
	# Create a new timer and connect the timeout signal to the change_scene function
	# Then start the timer
	
	print("change level: ", index)
	await get_tree().create_timer(1.0).timeout
	print("end change level")
	_transition_to_scene(index)

func _transition_to_scene(index):
	print("transition to scene")
	if(index == 1):
		print("transition to level 1")
		load_ui()
	if(index >= len(scenes)):
		winlose = "win"
		get_tree().change_scene_to_file(game_over_scene)
	else:
		get_tree().change_scene_to_file(scenes[index])
	# TODO: Clean this up
	ui.Level_UI.show()
	ui.Level_UI.show_start_ui()
	current_level_index = index
	current_level_changed.emit()

func _physics_process(delta):
	if(shake_strength > 0):
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		camera.offset = camera_offset + random_offset() * shake_strength
	else:
		camera.offset = camera_offset

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Bandaid to skip the first few seconds of silence in the audio clip
	#MusicPlayer.play(4.5)
	init_game()
	camera = GlobalCamera
	camera_offset = camera.offset

func _input(event):
	if(Input.is_action_just_pressed("pause")):
		pause_button_pressed()
	if(Input.is_action_just_pressed("ui_right")):
		change_level(2)
		
func load_ui():
	if ui == null:
		var ui_scene = preload("res://Scenes/CombinedGameLevelUI.tscn")
		ui = ui_scene.instantiate()
		ui.z_index = 5
		get_tree().root.add_child(ui)
		if(ui):
			print("ui loaded")
		else:
			print("ui not loaded")
	#else:
	#	ui.show()
		#ui.Game_UI.init()
		#ui.Level_UI.set_tiles_remaining_label_text(50)
		
func unload_ui():
	if ui != null:
		ui.queue_free()
		ui = null

func pause_button_pressed():
	print("pause toggle")
	get_tree().paused = not get_tree().paused
	if(get_tree().paused):
		PauseMenu.visible = true
	else:
		PauseMenu.visible = false

func register_player(p):
	player_current_health = p.CURRENT_HEALTH
	player_current_health_changed.emit()
	p.player_died.connect(_on_player_died)
	p.player_damage.connect(_on_player_damage)

#add type with unique score
func enemy_died(enemyPos):
	print("Enemy Position: ", enemyPos)
	# if the enemy is a skeleon, spawn and play the death particle effect
	var particle_effect_instance = skeleton_death_effect.instantiate()
	particle_effect_instance.position = enemyPos
	particle_effect_instance.emitting = true
	get_tree().root.add_child(particle_effect_instance)
	#particle_effect_instance.position = 
	apply_shake(2, 1)
	update_score(50)

### Signals
func _on_player_died():
	# TODO: Clean up projectiles and stop enemies from moving
	print("player died in game manager")
	AudioManager.play("player_death_sound")
	# If player has lives left, re load the current level
	if(player_current_lives > 0):
		change_level(current_level_index)
		player_current_lives -= 1
		player_current_lives_changed.emit()
	# Else, end the game
	else:
		lose_game()

func _on_player_damage(h):
	print("player damage in game manager")
	player_current_health = h
	print("player current health:",h)
	player_current_health_changed.emit()
	game_UI.flash_screen()
	apply_shake()

func get_all_scores():
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(200).sw_get_scores_complete
	print("Scores: " + str(sw_result.scores))
	return sw_result.scores

func get_player_score_position():
	# A score_value, meaning just any numeric value, e.g.: SilentWolf.Scores.get_score_position(116)
	var sw_result = await SilentWolf.Scores.get_score_position(player_score).sw_get_position_complete
	var position = sw_result.position
	#print(SilentWolf.Scores.get_score_position(player_score))
	#get_tree().root.add_child(SilentWolf.Scores.get_score_position(player_score))
	return position

func lose_game():
	winlose = "lose"
	get_tree().change_scene_to_file(game_over_scene)

func save_high_score(player_name):
	var sw_result: Dictionary = await SilentWolf.Scores.save_score(player_name, player_score).sw_save_score_complete
	print("Score persisted successfully: " + str(sw_result.score_id))
	get_tree().change_scene_to_file(leaderboard_scene)

func quit():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # default behavior
	
func init_game():
	var secrets_file = "res://secrets.json"
	var json_as_text = FileAccess.get_file_as_string(secrets_file)
	var json_as_dict = JSON.parse_string(json_as_text)
	# Configure SilentWolf Leaderboard addon
	SilentWolf.configure({
		"api_key": json_as_dict["API_KEY"],
		"game_id": json_as_dict["GAME_ID"],
		"log_level": 1
	  })
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/MainPage.tscn"
	})
	player_current_lives = player_max_lives
	print(player_current_lives)
	
func update_score(s, multi=true):
	print("score multi:", score_multiplier)
	print("score val:", s)
	if(multi):
		player_score += float(score_multiplier) * int(s)
	else:
		player_score += int(s)
	player_score_changed.emit()

func update_lives(l):
	player_current_lives += 1
	player_current_lives_changed.emit()

func update_player_health(h):
	player_current_health += h
	player_current_health_changed.emit()

func update_score_multiplier(m):
	score_multiplier = m
	multiplier_changed.emit()

func get_player_position():
	return player_current_position
