extends Control

var player_score_position
var player_name
var player_winlose 
var submit_button_active = true
# Called when the node enters the scene tree for the first time.
func _ready():
	player_score_position = await GameManager.get_player_score_position()
	print(player_score_position)
	player_winlose = GameManager.winlose
	if(player_winlose == "win"):
		$CenterContainer/VBoxContainer/WinLoseLabel.text = "You won! :)"
	else:
		$CenterContainer/VBoxContainer/WinLoseLabel.text = "You lose! :("
	$CenterContainer/VBoxContainer/ScoreLabel.text = "Your score: " + str(GameManager.player_score)
	$CenterContainer/VBoxContainer/SubmitScoreButton.disabled = submit_button_active
	$CenterContainer/VBoxContainer/LeaderboardPosLabel.text = "Leaderboard position: " + str(player_score_position)

func _on_submit_score_button_button_up():
	# Submit the users score to the database
	GameManager.save_high_score(player_name)


func _on_name_entry_box_text_changed(new_text):
	print("new text: ", new_text)
	print(new_text.length())
	player_name = new_text
	if(new_text.length() > 0):
		submit_button_active = true
	else:
		submit_button_active = false
	$CenterContainer/VBoxContainer/SubmitScoreButton.disabled = not submit_button_active
