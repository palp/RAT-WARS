extends Control

@onready var options_menu = get_node("%options_menu")
@onready var bonus_button = get_node("%bonus_button")
@onready var unlock_input = get_node("%unlock_input")
@onready var unlock_button = get_node("%unlock_button")
@onready var leaderboard = get_node("%leaderboard")

func _on_play_pressed():
	get_tree().change_scene_to_file("res://level_placeholder.tscn")

func _on_options_pressed():
	options_menu.visible = !options_menu.visible


func _on_bonus_button_pressed():
	unlock_input.visible = !unlock_input.visible
	unlock_button.visible = unlock_input.visible


func _on_unlock_button_pressed():	
	Unlocks.unlock(unlock_input.text.to_upper())
	unlock_input.text = ""
	unlock_input.visible = false
	unlock_button.visible = false


func _on_scores_button_pressed():
	leaderboard.visible = !leaderboard.visible
