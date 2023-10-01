extends Node


@export var scenes = [
	"res://Scenes/main_menu.tscn",
	"res://Scenes/level1.tscn",
	"res://Scenes/level2.tscn"
]

var current_level_index = 0

func change_level(index):
	get_tree().change_scene_to_file(scenes[index])
	current_level_index = index
	
func _ready():
	pass

func register_player(p):
	p.player_died.connect(_on_player_died)
	
### Signals
func _on_player_died():
	print("player died in game manager")
	
