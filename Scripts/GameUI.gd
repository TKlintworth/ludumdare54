extends Control

@export var LivesLabel : Control
@export var ScoreLabel : Control
@export var HealthBar : Control
@export var LevelLabel : Control

# Called when the node enters the scene tree for the first time.
func _ready():
	LivesLabel = $HBoxContainer/VBoxContainer/TextureProgressBar

func _player_current_lives_changed():
	LivesLabel.text = str(GameManager.player_current_lives)

func test():
	print("Inside of GameUI")

func _player_current_health_changed():
	print("health changed")
	HealthBar.value = GameManager.player_current_health

func _current_level_changed():
	LevelLabel.text = "Level " + str(GameManager.current_level_index) + " / " + str(len(GameManager.scenes)-1)
	LivesLabel.text = str(GameManager.player_current_lives)
	GameManager.player_current_lives_changed.connect(_player_current_lives_changed)
	GameManager.player_current_health_changed.connect(_player_current_health_changed)
	GameManager.current_level_changed.connect(_current_level_changed)
	GameManager.player_score_changed.connect(_player_score_changed)
	ScoreLabel.text = "Score: " + str(GameManager.player_score) + " (" + str(GameManager.score_multiplier) + "x)"
	print(GameManager.player_current_lives)
	print(GameManager.player_current_health)
	HealthBar.value = GameManager.player_current_health

func _player_score_changed():
	ScoreLabel.text = "Score: " + str(GameManager.player_score) + " (" + str(GameManager.score_multiplier) + "x)"
