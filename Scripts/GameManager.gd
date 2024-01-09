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
@export var player_max_lives = 10

var ui : Node = null
var current_level_index = 0
var player_score = 0
var winlose = ""
var score_multiplier = 1
var player_current_lives
var player_current_health = 0
# Map different creatures to different scores
var enemy_score_map = {
	"Skeleton": 50,
	"Pumpkin": 50,
	"Goblin": 100
}

signal player_current_lives_changed
signal player_current_health_changed
signal current_level_changed
signal player_score_changed
signal multiplier_changed

func level_complete():
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
	current_level_changed.emit()
	current_level_index = index
	

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Bandaid to skip the first few seconds of silence in the audio clip
	MusicPlayer.play(4.5)
	init_game()

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
func enemy_died():
	update_score(50)

### Signals
func _on_player_died():
	print("player died in game manager")
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
