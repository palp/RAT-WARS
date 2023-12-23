extends Control

@onready var virtual_joystick_mode:ItemList = get_node("%virtual_joystick_mode")
@onready var click_to_move_button = get_node("%click_to_move_button")
@onready var joystick_pos_slider = get_node("%joystick_pos_slider")
@onready var joystick_scale_slider = get_node("%joystick_scale_slider")
@onready var player:Player = get_tree().get_first_node_in_group("player")
@onready var track_options = get_node("%track_select_button")

# Called when the node enters the scene tree for the first time.
func _ready():
	click_to_move_button.button_pressed = UserSettings.config.get_value("control", "click_to_move", true)
	var mode = UserSettings.config.get_value("control", "virtual_joystick", "auto")
	virtual_joystick_mode.select(0)			
	if mode == "always":
		virtual_joystick_mode.select(1)
	elif mode == "never":
		virtual_joystick_mode.select(2)
	joystick_pos_slider.value = UserSettings.config.get_value("control", "virtual_joystick_position_x", 100)
	joystick_scale_slider.value = UserSettings.config.get_value("control", "virtual_joystick_scale", 1.0)	
	load_tracks()
	
func load_tracks():
	track_options.clear()
	var track_ix = 0
	for track in BackgroundMusic.tracks:
		track_options.add_item(track["name"], track_ix)
		track_ix += 1
	track_options.selected = BackgroundMusic.current_track_index

func _on_click_to_move_button_toggled(toggled_on):
	UserSettings.config.set_value("control", "click_to_move", toggled_on)
	player.disable_pathing = !toggled_on


func _on_virtual_joystick_mode_item_selected(index):	
	var mode = "auto"
	if index == 1:
		mode = "always"
	elif index == 2:
		mode = "never"
	UserSettings.config.set_value("control", "virtual_joystick", mode)
	player.configure_virtual_joystick()


func _on_joystick_pos_slider_value_changed(value):
	UserSettings.config.set_value("control", "virtual_joystick_position_x", value)
	player.configure_virtual_joystick()


func _on_joystick_scale_slider_value_changed(value):
	UserSettings.config.set_value("control", "virtual_joystick_scale", value)
	player.configure_virtual_joystick()


func _on_track_select_button_item_selected(index):
	BackgroundMusic.select_track(index)
