extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/HBoxContainer/VBoxContainer/LivesTexture/LivesLabel.text = str(GameManager.player_current_lives)
	GameManager.player_current_lives_changed.connect(_player_current_lives_changed)
	GameManager.player_current_health_changed.connect(_player_current_health_changed)
	$MarginContainer/HBoxContainer/VBoxContainer/TextureProgressBar.value = GameManager.player_current_health

func _player_current_lives_changed():
	$MarginContainer/HBoxContainer/VBoxContainer/LivesTexture/LivesLabel.text = str(GameManager.player_current_lives)

func _player_current_health_changed():
	print("health changed")
	$MarginContainer/HBoxContainer/VBoxContainer/TextureProgressBar.value = GameManager.player_current_health
