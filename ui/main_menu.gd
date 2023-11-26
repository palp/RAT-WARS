extends Control

@onready var options_menu = get_node("%options_menu")

func _on_play_pressed():
	get_tree().change_scene_to_file("res://level_placeholder.tscn")

func _on_options_pressed():
	options_menu.visible = !options_menu.visible
