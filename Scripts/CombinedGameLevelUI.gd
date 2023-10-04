extends Control

#var Level_UI = preload("res://Scenes/GameUI.tscn").instantiate()
#var Game_UI = preload("res://Scenes/LevelUI.tscn").instantiate()
@onready var Game_UI = $MarginContainer/GameUI
@onready var Level_UI = $MarginContainer/LevelUI

func _ready():
	if($MarginContainer/GameUI):
		print("CombinedGameLevelUI has a GameUI node")
	if($MarginContainer/LevelUI):
		print("CombinedGameLevelUI has a LevelUI node")
	if($MarginContainer/GameUI.ScoreLabel):
		print("CombinedGameLevelUI GameUI has a ScoreLabel")
		$MarginContainer/GameUI.test()
	else:
		print("CombinedGameLevelUI GameUI does not have a ScoreLabel")

#func hide_level_UI():
#	Level_UI.hide()

#func show_level_UI():
#	Level_UI.show()
	
#func show_game_UI():
#	Game_UI.show()

#func hide_game_UI():
#	Game_UI.hide()
