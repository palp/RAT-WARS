extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if not UserSettings.config.get_value("cutscene", "opening_played", false):		
		get_node("%main_menu").play_cutscene("opening")		
		UserSettings.config.set_value("cutscene", "opening_played]", true)
		UserSettings.save_config()
