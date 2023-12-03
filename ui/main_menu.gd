extends Control

@onready var options_menu = get_node("%options_menu")
@onready var bonus_button = get_node("%bonus_button")
@onready var unlock_input = get_node("%unlock_input")
@onready var unlock_button = get_node("%unlock_button")
@onready var leaderboard = get_node("%leaderboard")
@onready var video_player = get_node("%VideoStreamPlayer")

signal video_started
signal video_stopped

func _on_play_pressed():
	get_tree().change_scene_to_file("res://level_placeholder.tscn")

func close_submenus():
	options_menu.visible = false
	unlock_input.visible = false
	unlock_button.visible = false
	leaderboard.visible = false

func _on_options_pressed():
	if options_menu.visible:
		close_submenus()
	else:
		close_submenus()
		options_menu.visible = true

func _on_bonus_button_pressed():
	if unlock_input.visible:
		close_submenus()
	else:
		close_submenus()
		unlock_input.visible = true
		unlock_button.visible = true


func _on_unlock_button_pressed():
	Unlocks.unlock(unlock_input.text.to_upper())
	unlock_input.text = ""
	close_submenus()


func _on_scores_button_pressed():
	if leaderboard.visible:
		close_submenus()
	else:
		close_submenus()
		leaderboard.visible = true


func _on_video_stream_player_finished():
	emit_signal("video_stopped")
	get_tree().paused = false
	video_player.visible = false

func _on_credits_button_pressed():
	emit_signal("video_started")
	video_player.visible = true
	get_tree().paused = true
	video_player.play()


func _on_video_stream_player_gui_input(event):
	if Input.is_action_just_pressed("click") and video_player.stream_position > 5:
		get_tree().paused = false
		video_player.stop()
