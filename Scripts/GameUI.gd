extends Control

var LivesLabel
var ScoreLabel
var HealthBar
var LevelLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	LivesLabel = $HBoxContainer/VBoxContainer/LivesTexture/LivesLabel
	ScoreLabel = $HBoxContainer/VBoxContainer2/ScoreLabel
	HealthBar = $HBoxContainer/VBoxContainer/TextureProgressBar
	LevelLabel = $HBoxContainer/VBoxContainer2/LevelLabel
	
	GameManager.player_current_lives_changed.connect(_player_current_lives_changed)
	GameManager.player_current_health_changed.connect(_player_current_health_changed)
	GameManager.current_level_changed.connect(_current_level_changed)
	GameManager.player_score_changed.connect(_player_score_changed)
	GameManager.multiplier_changed.connect(_multiplier_changed)

func init():
	HealthBar.value = GameManager.player_current_health

func _player_current_lives_changed():
	LivesLabel.text = str(GameManager.player_current_lives)

func _player_current_health_changed():
	print("health changed")
	HealthBar.value = GameManager.player_current_health

func set_level_label_text(t):
	LevelLabel.text = str(t)

func set_lives_label_text(t):
	LivesLabel.text = str(t)

func set_score_label_text(t):
	ScoreLabel.text = str(t)

func set_health_bar_value(val):
	HealthBar.value = val

func _current_level_changed():
	LevelLabel.text = "Level " + str(GameManager.current_level_index) + " / " + str(len(GameManager.scenes)-1)
	LivesLabel.text = str(GameManager.player_current_lives)
	ScoreLabel.text = "Score: " + str(GameManager.player_score) + " (" + str(GameManager.score_multiplier) + "x)"
	HealthBar.value = GameManager.player_current_health

func _player_score_changed():
	ScoreLabel.text = "Score: " + str(GameManager.player_score) + " (" + str(GameManager.score_multiplier) + "x)"

func _multiplier_changed():
	ScoreLabel.text = "Score: " + str(GameManager.player_score) + " (" + str(GameManager.score_multiplier) + "x)"	
