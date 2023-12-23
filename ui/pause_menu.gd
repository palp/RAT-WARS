extends Control

@onready var options_menu = get_node("%options_menu")
@onready var track_select_panel = get_node("%track_select_panel")
@onready var track_options = get_node("%track_select_button")

func _ready():
	track_options.clear()
	var track_ix = 0
	for track in BackgroundMusic.tracks:
		track_options.add_item(track["name"], track_ix)
		track_ix += 1
	track_options.selected = BackgroundMusic.current_track_index


func _on_options_pressed():
	track_select_panel.visible = false
	options_menu.visible = !options_menu.visible

func _on_main_menu_pressed():
	options_menu.visible = false
	track_select_panel.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://World/launch.tscn")
	


func _on_options_menu_hidden():
	UserSettings.save_volumes(["Master", "Music", "SFX"])


func _on_track_select_button_item_selected(index):
	BackgroundMusic.select_track(index)


func _on_music_select_button_pressed():
	options_menu.visible = false
	track_select_panel.visible = !track_select_panel.visible
