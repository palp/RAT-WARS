extends AudioStreamPlayer


func _on_player_playerdeath():
	playing = false


func _on_finished():
	play()
