extends Node

@export var scenes = [
	"res://Scenes/main_menu.tscn",
	"res://Scenes/level1.tscn",
	"res://Scenes/level2.tscn"
]

@export var leaderboard_scene = "res://addons/silent_wolf/Scores/Leaderboard.tscn"

var current_level_index = 0
var player_score = 10
var player_name = "default"

func change_level(index):
	# TODO: Add some transition and then show the paused / tile selection screen again
	get_tree().change_scene_to_file(scenes[index])
	current_level_index = index
	
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	init_game()

func _input(event):
	if(Input.is_action_just_pressed("pause")):
		pause_button_pressed()

func pause_button_pressed():
	print("pause toggle")
	get_tree().paused = not get_tree().paused
	if(get_tree().paused):
		PauseMenu.visible = true
	else:
		PauseMenu.visible = false

func register_player(p):
	p.player_died.connect(_on_player_died)
	
### Signals
func _on_player_died():
	print("player died in game manager")
	end_game()

func get_scores():
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(200).sw_get_scores_complete
	print("Scores: " + str(sw_result.scores))
	return sw_result.scores

func end_game():
	# SilentWolf.Scores.save_score(player_name, player_score)
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
	
