extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/LivesTexture/LivesLabel.text = str(GameManager.player_current_lives)
	GameManager.player_current_lives_changed.connect(_player_current_lives_changed)
	GameManager.player_current_health_changed.connect(_player_current_health_changed)
	GameManager.current_level_changed.connect(_current_level_changed)
	GameManager.player_score_changed.connect(_player_score_changed)
	$MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/ScoreLabel.text = "Score: " + str(GameManager.player_score) + " (" + str(GameManager.score_multiplier) + "x)"
	$MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/TextureProgressBar.value = GameManager.player_current_health
	$MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/LevelLabel.text = "Level " + str(GameManager.current_level_index) + " / " + str(len(GameManager.scenes)-1)

func _player_current_lives_changed():
	$MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/LivesTexture/LivesLabel.text = str(GameManager.player_current_lives)

func _player_current_health_changed():
	print("health changed")
	$MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/TextureProgressBar.value = GameManager.player_current_health

func _current_level_changed():
	$MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/LevelLabel.text = "Level " + str(GameManager.current_level_index) + " / " + str(len(GameManager.scenes)-1)

func _player_score_changed():
	$MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/ScoreLabel.text = "Score: " + str(GameManager.player_score) + " (" + str(GameManager.score_multiplier) + "x)"
