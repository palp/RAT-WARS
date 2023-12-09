extends Control

@onready var options_menu = get_node("%options_menu")

func _on_options_pressed():
	options_menu.visible = !options_menu.visible

func _on_main_menu_pressed():
	if options_menu.visible:
		options_menu.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://World/launch.tscn")
	


func _on_options_menu_hidden():
	UserSettings.save_volumes(["Master", "Music", "SFX"])
