extends AudioStreamPlayer

var stopped = false

func _on_player_playerdeath():
	stopped = true
	playing = false

func _on_player_playervictory():
	stopped = true
	playing = false

func _on_finished():
	if not stopped:
		play()
