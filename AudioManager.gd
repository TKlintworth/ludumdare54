extends Node

var num_players = 8
var bus = "Master"

var available = []  # The available players.
var queue = []  # The queue of sounds to play.

# Dictionary to hold audio files
var audio_files = {
	"level_complete": preload("res://assets/sounds/level_complete.wav"),
	"player_death_sound": preload("res://assets/sounds/player_death_sound.wav"),
	"player_hurt": preload("res://assets/sounds/playerHurt.wav"),
	"select_tile": preload("res://assets/sounds/select_tile.wav"),
	"deselect_tile": preload("res://assets/sounds/deselect_tile.wav"),
	#"button_hover": preload(""),
	"button_click": preload("res://assets/sounds/button_click.wav"),
	"pickup1": preload("res://assets/sounds/pickup1.wav")
}

func _ready():
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = bus  

func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)

func play(sound_path):
	if(sound_path in audio_files):
		queue.append(audio_files[sound_path])

func _process(delta):
	# Play a queued sound if any players are available.
	if not queue.is_empty() and not available.is_empty():
		var sound = queue.pop_front() # Ensure the sound file is loaded properly
		if sound:
			available[0].stream = sound
			available[0].play()
			available.pop_front()
