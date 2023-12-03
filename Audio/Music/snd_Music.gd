extends AudioStreamPlayer

var stopped = false
var last_position

func _on_player_playerdeath():
	stopped = true
	playing = false

func _on_player_playervictory():
	stopped = true
	playing = false

func _on_finished():
	if not stopped:
		play()

func pause_audio():
	stream_paused = true

func unpause_audio():
	stream_paused = false
