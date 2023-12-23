extends Control

@onready var options_menu = get_node("%options_menu")
@onready var bonus_button = get_node("%bonus_button")
@onready var unlock_input = get_node("%unlock_input")
@onready var unlock_button = get_node("%unlock_button")
@onready var leaderboard = get_node("%leaderboard")
@onready var video_player = get_node("%VideoStreamPlayer")
@onready var rat_loop = preload("res://Video/big_rat_loop.ogv")
@onready var cutscenes_container = get_node("%cutscenes_container")
@onready var cutscene_scene = preload('res://CutsceneData/CutsceneNode/cutscene.tscn')

var in_loop = false

var bonus_disabled = false

signal video_started
signal video_stopped
	
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Player/player_select.tscn")

func close_submenus():
	options_menu.visible = false
	if not bonus_disabled:
		unlock_input.visible = false
		unlock_button.visible = false
	leaderboard.visible = false
	cutscenes_container.visible = false

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
	if in_loop:
		BackgroundMusic.audio_player.stream_paused = false
		get_tree().paused = false
		video_player.visible = false
	else:
		in_loop = true
		video_player.stream = rat_loop
		video_player.play()

func _on_credits_button_pressed():
	BackgroundMusic.audio_player.stream_paused = true
	video_player.visible = true
	get_tree().paused = true
	video_player.play()


func _on_video_stream_player_gui_input(_event):
	if Input.is_action_just_pressed("click") and video_player.stream_position > 5:
		BackgroundMusic.audio_player.stream_paused = false
		get_tree().paused = false
		# Make sure we end playback regardless of if we're in the loop
		in_loop = true
		video_player.stop()


func _on_options_menu_hidden():
	print_debug("Saving")
	UserSettings.save_volumes(["Master", "Music", "SFX"])


func _on_cutscenes_button_pressed():
	if cutscenes_container.visible:
		close_submenus()
	else:
		close_submenus()
		cutscenes_container.visible = true
		
func play_cutscene(name):
	BackgroundMusic.audio_player.stream_paused = true
	get_tree().paused = true	
	var cutscene_player = cutscene_scene.instantiate()
	cutscene_player.connect("tree_exited", _on_cutscene_ended)
	cutscene_player.scene_title = name	
	add_child(cutscene_player)

func _on_cutscene_ended():	
	BackgroundMusic.audio_player.stream_paused = false
	get_tree().paused = false	
	pass
